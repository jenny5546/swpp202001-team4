#include "SimpleBackend.h"
#include "Team4Passes.h"


void DepromoteRegisters::raiseError(Instruction &I) {
  errs() << "DepromoteRegisters: Unsupported Instruction: " << I << "\n";
  abort();
}

Type *DepromoteRegisters::SrcToTgtType(Type *SrcTy) {
  if (SrcTy->isIntegerTy())
    // All integer registers are zero-extended to 64 bit registers.
    return I64Ty;
  assert(isa<PointerType>(SrcTy));
  // Pointers are also 64 bit registers, but let's keep type.
  // Assembler will take care of it.
  return SrcTy;
}

void DepromoteRegisters::checkSrcType(Type *T) {
  if (T->isIntegerTy()) {
    unsigned bw = T->getIntegerBitWidth();
    assert(bw == 1 || bw == 8 || bw == 16 || bw == 32 || bw == 64);
  } else if (T->isArrayTy()) {
    return checkSrcType(T->getArrayElementType());
  } else {
    assert(isa<PointerType>(T) || isa<ArrayType>(T));
  }
}

void DepromoteRegisters::checkTgtType(Type *T) {
  if (T->isIntegerTy()) {
    // Only 64-bit values or registers are available after depromotion.
    assert(T->getIntegerBitWidth() == 64);
  } else {
    assert(isa<PointerType>(T));
  }
}

string DepromoteRegisters::assemblyRegisterName(unsigned registerId) {
  assert(1 <= registerId && registerId <= 16);
  return "__r" + to_string(registerId) + "__";
}

string DepromoteRegisters::retrieveAssemblyRegister(Instruction *I) {
  /* get register name for given instruction; evict a used register if necessary */
  unsigned registerId;

  if (I == nullptr || (RegToAllocaMap.count(I) || !RegToRegMap.count(I))) {
    /* retrieve temporary register, and assign new if none */
    for (unsigned i = 0; i < TempRegCnt; i++) {
      if (TempRegUsers[i].first != nullptr) 
        continue;
      TempRegUsers[i].first = I;
      TempRegUsers[i].second.first = nullptr;
      return assemblyRegisterName(TempRegUsers[i].second.second);
    }

    emitStoreToSrcRegister(TempRegUsers[0].second.first, TempRegUsers[0].first);
    registerId = TempRegUsers[0].second.second;
    TempRegUsers.erase(TempRegUsers.begin());
    TempRegUsers.push_back(make_pair(I, make_pair(nullptr, registerId)));
  } else {
    /* retrieve permanent register */
    registerId = RegToRegMap[I];
  }

  assert(1 <= registerId && registerId <= 16);
  return assemblyRegisterName(registerId);
}

Value *DepromoteRegisters::emitLoadFromSrcRegister(Instruction *I, unsigned targetRegisterId) {
  assert(RegToAllocaMap.count(I));
  assert(1 <= targetRegisterId && targetRegisterId <= 16 &&
         "r1 ~ r16 are available only!");

  /* retrieve temporary register if being used */
  for (unsigned i = 0; i < TempRegCnt; i++) {
    if (TempRegUsers[i].first == I)
        return TempRegUsers[i].second.first;
  }

  auto *TgtVal = Builder->CreateLoad(RegToAllocaMap[I], retrieveAssemblyRegister(I));
  checkTgtType(TgtVal->getType());
  saveTempInst(I, TgtVal);
  return TgtVal;
}

void DepromoteRegisters::emitStoreToSrcRegister(Value *V, Instruction *I) {
  assert(RegToAllocaMap.count(I));
  checkTgtType(V->getType());
  if (auto *I = dyn_cast<Instruction>(V))
    if (I->hasName())
      assert(I->getName().startswith("__r"));
  Builder->CreateStore(V, RegToAllocaMap[I]);
}

void DepromoteRegisters::saveInst(Value *Res, Instruction *I) {
  /* save instruction mapping */
  InstMap[I] = Res;
  if (RegToAllocaMap.count(I)) 
    ValToAllocaMap[Res] = RegToAllocaMap[I];
  saveTempInst(I, Res);
}

void DepromoteRegisters::saveTempInst(Instruction *OldI, Value *Res) {
  for (unsigned i = 0; i < TempRegCnt; i++) {
    if (TempRegUsers[i].first == OldI) {
      TempRegUsers[i].second.first = Res;
      return;
    }
  }
}

void DepromoteRegisters::evictTempInst(Instruction *I) {
  /* evict from temporary register user list */
  for (unsigned i = 0; i < TempRegCnt; i++) {
    if (TempRegUsers[i].first != I) 
        continue;
    unsigned registerId = TempRegUsers[i].second.second;
    TempRegUsers.erase(TempRegUsers.begin() + i);
    TempRegUsers.push_back(make_pair(nullptr, make_pair(nullptr, registerId)));
    return;
  }
}

void DepromoteRegisters::getBlockBFS(BasicBlock *StartBB, vector<BasicBlock *> &BasicBlockBFS) {
  /* get blocks in logical BFS order, from StartBB */
  BasicBlockBFS.clear();
  vector<BasicBlock *> BlockQueue;
  BlockQueue.push_back(StartBB);

  while (!BlockQueue.empty()) {
    BasicBlock *BB = BlockQueue.front();
    BlockQueue.erase(BlockQueue.begin());

    if (find(BasicBlockBFS.begin(), BasicBlockBFS.end(), BB) != BasicBlockBFS.end()) 
        continue;

    BasicBlockBFS.push_back(BB);
    for (unsigned i = 0, cnt = BB->getTerminator()->getNumSuccessors(); i < cnt; i++)
      BlockQueue.push_back(BB->getTerminator()->getSuccessor(i));
  }
}

// Encode the value of V.
// If V is an argument, return the corresponding argN argument.
// If V is a constant, just return it.
// If V is an instruction, it emits load from the temporary alloca.
Value *DepromoteRegisters::translateSrcOperandToTgt(Value *V, unsigned OperandId) {
  checkSrcType(V->getType());

  if (auto *ZI = dyn_cast<ZExtInst>(V))
    V = ZI->getOperand(0);

  if (auto *A = dyn_cast<Argument>(V)) {
    // Nothing to emit.
    // Returns one of "arg1", "arg2", ...
    assert(ArgMap.count(A));
    return ArgMap[A];

  } else if (auto *CI = dyn_cast<ConstantInt>(V)) {
    return ConstantInt::get(I64Ty, CI->getZExtValue());

  } else if (isa<ConstantPointerNull>(V)) {
    return V;

  } else if (isa<UndefValue>(V)) {
    return UndefValue::get(I64Ty);

  } else if (auto *GV = dyn_cast<GlobalVariable>(V)) {
    assert(GVMap.count(GV));
    return GVMap[GV];

  } else if (auto *I = dyn_cast<Instruction>(V)) {
    if (RegToAllocaMap.count(I) || !RegToRegMap.count(I)) {
      auto *Res = emitLoadFromSrcRegister(I, OperandId);
      if (dyn_cast<PHINode>(I)) 
        ValToAllocaMap[Res] = RegToAllocaMap[I];
      return Res;
    } else {
      return InstMap[I];
    }

  } else {
    assert(false && "Unknown instruction type!");
  }
}

void DepromoteRegisters::resolveRegDependency() {
  /* resolve dependency issues by adding load/store insts where dependency could occur */
  vector <pair<Instruction *, pair<Instruction *, Instruction *>>> LoadToAdd;
  vector<pair<Instruction *, Instruction *>> StoreToAdd;

  for (auto *BB : BasicBlockBFS) {
    for (auto &I: *BBMap[BB]) {
      if (auto *SI = dyn_cast<StoreInst>(&I)) {
        /* store to XX_slot register indicate eviction from reg, hence start checking */
        auto *Op = SI->getValueOperand();
        auto *OpI = dyn_cast<Instruction>(Op);

        if ((!SI->getPointerOperand()->getName().endswith("_slot") &&
             !SI->getPointerOperand()->getName().endswith("_phi")) || !OpI)
            continue;

        unsigned isStored = 0;
        for (auto itr = Op->use_begin(), end = Op->use_end(); itr != end; ++itr) {
          Instruction *UsrI = dyn_cast<Instruction>((*itr).getUser());
          if (!UsrI || UsrI == SI) 
            continue;

          vector<BasicBlock *> Reachables;
          getBlockBFS(SI->getParent(), Reachables);

          for (BasicBlock *Reachable : Reachables) {
            if (Reachable != UsrI->getParent())
                continue;

            for (auto &UserBBInst : *Reachable) {
              Instruction *PtyOp = ValToAllocaMap[Op];
              if (&UserBBInst == OpI) 
                break;
              if (&UserBBInst != UsrI || !PtyOp)
                continue;

              /* user instruction is reachable after eviction */
              if (!isStored && !dyn_cast<LoadInst>(OpI)) {
                StoreToAdd.push_back(make_pair(OpI, PtyOp));
                isStored = 1;
              }

              LoadToAdd.push_back(make_pair(PtyOp, make_pair(OpI, UsrI)));
              break;
            }
            break;
          }

        }
      }
    }
  }

  for (auto entry : StoreToAdd) 
    (new StoreInst(entry.first, entry.second))->insertAfter(entry.first);
  for (auto entry: LoadToAdd) 
    (new LoadInst(entry.first, entry.second.first->getName()))->insertBefore(entry.second.second);
}

void DepromoteRegisters::removeExtraMemoryInsts() {
  /* remove unnecessary memory operations introduced from resolving dependencies */
  vector <Instruction *> InstsToRemove;

  for (auto *BB : BasicBlockBFS) {
    LoadInst *PrevLI = nullptr;
    for (auto &I: *BBMap[BB]) {
      if (I.hasName() && I.use_empty() && dyn_cast<AllocaInst>(&I)) {
        InstsToRemove.push_back(&I);
      } else if (auto *LI = dyn_cast<LoadInst>(&I)) {
        if (PrevLI != nullptr &&
            PrevLI->getPointerOperand() == LI->getPointerOperand() &&
            PrevLI->getPointerOperandType() == LI->getPointerOperandType() &&
            PrevLI->getName().str().substr(0, 6) == LI->getName().str().substr(0, 6)) {
          InstsToRemove.push_back(&I);
          LI->replaceAllUsesWith(PrevLI);
          continue;
        }
        PrevLI = LI;
        continue;
      } else if (auto *SI = dyn_cast<StoreInst>(&I)) {
        auto *Op = SI->getValueOperand();
        auto *OpI = dyn_cast<Instruction>(Op);
        if (!SI->getPointerOperand()->getName().endswith("_slot") || !OpI) 
          continue;
        Value *PtyOp = ValToAllocaMap[Op];

        vector<BasicBlock *> Reachables;
        getBlockBFS(SI->getParent(), Reachables);

        int isSelfChecked = 0, shouldRemove = 1;
        for (BasicBlock *Reachable : Reachables) {
          if (!shouldRemove)
            break;
          for (auto &RI : *Reachable) {
            if (Reachable == SI->getParent() && !isSelfChecked) {
              if (&RI == SI)
                isSelfChecked = 1;
              continue;
            }
            if (auto *LI = dyn_cast<LoadInst>(&RI)) {
              if (LI->getPointerOperand() == PtyOp) {
                  shouldRemove = 0;
                  break;
              }
            }
          }
        }

        if (shouldRemove)
          InstsToRemove.push_back(&I);
      }
      PrevLI = nullptr;
    }
  }

  for (auto *I : InstsToRemove) {
    I->removeFromParent();
    I->deleteValue();
  }
}

void DepromoteRegisters::cleanRedundantCasts() {
  
  for (auto *BB : BasicBlockBFS) {
    for (auto &I: *BBMap[BB]) {
      if (auto *CI = dyn_cast<CastInst>(&I)) {
        auto *Op = CI->getOperand(0);

        if (!dyn_cast<Instruction>(Op) ||
            Op->getName().str().find("before_zext__") != string::npos ||
            CI->getName().str().find("after_trunc__") != string::npos ||
            Op->getName().str().find("arg") != string::npos)
          continue;
        
        unsigned usageCnt = 0;
        Instruction *UserI;
        for (auto itr = CI->use_begin(), end = CI->use_end(); itr != end; ++itr) {
          if (dyn_cast<CastInst>(itr->getUser()) == CI)
            continue;
          usageCnt++;
          UserI = dyn_cast<Instruction>(itr->getUser());
        }

        if (usageCnt > 1)
          continue;
        
        int shouldCheck = 0;
        for (auto &I: *CI->getParent()) {
          if (&I == CI)
            shouldCheck = 1;
          else if (shouldCheck && (&I == UserI)) {
       //     outs() << "Case made for \n";
       //     outs() << *CI << "\n";
       //     outs() << *UserI << "\n";
            CI->setName(assemblyRegisterName(stoi(Op->getName().str().substr(3, 6))));
          }
          else if (shouldCheck == 1)
            shouldCheck++;
          else if (shouldCheck > 1)
            break;
        }
      }
    }
  }
}

Module *DepromoteRegisters::getDepromotedModule() const {
    return ModuleToEmit.get(); 
}

void DepromoteRegisters::visitModule(Module &M) {
  Context = &M.getContext();
  ModuleToEmit = unique_ptr<Module>(new Module("DepromotedModule", *Context));
  I64Ty = IntegerType::getInt64Ty(*Context);
  I1Ty = IntegerType::getInt1Ty(*Context);
  I8PtrTy = PointerType::getInt8PtrTy(*Context);
  ModuleToEmit->setDataLayout(M.getDataLayout());

  uint64_t GVOffset = 20480;
  FunctionType *MallocTy = nullptr;
  for (auto &G : M.global_objects()) {
    if (auto *F = dyn_cast<Function>(&G)) {
      SmallVector<Type *, 16> FuncArgTys;

      // Map arguments to arg1, arg2, .. registers.
      for (auto I = F->arg_begin(), E = F->arg_end(); I != E; ++I) {
        Argument *A = &*I;
        checkSrcType(A->getType());
        FuncArgTys.push_back(SrcToTgtType(A->getType()));
      }

      // A function returns either i64 or a pointer.
      auto *RetTy = F->getReturnType()->isVoidTy() ? I64Ty :
                      SrcToTgtType(F->getReturnType());
      FunctionType *FTy = FunctionType::get(RetTy, FuncArgTys, false);
      FuncMap[F] = Function::Create(FTy, Function::ExternalLinkage,
                                    F->getName(), *ModuleToEmit);

      if (F->getName() == "malloc") {
        assert(FuncArgTys.size() == 1 && FuncArgTys[0] == I64Ty &&
               "malloc has one argument");
        assert(RetTy->isPointerTy() && "malloc should return pointer");
        MallocTy = dyn_cast<FunctionType>(F->getValueType());
        MallocFn = FuncMap[F];
      }

    } else {
      GlobalVariable *GVSrc = dyn_cast<GlobalVariable>(&G);
      assert(GVSrc &&
             "A global object is neither function nor global variable");
      
      unsigned sz = (getAccessSize(GVSrc->getValueType()) + 7) / 8 * 8;
      auto *CI = ConstantInt::get(I64Ty, GVOffset);
      GVMap[GVSrc] = ConstantExpr::getIntToPtr(CI, GVSrc->getType());
      GVLocs.emplace_back(GVOffset, sz);

      GVOffset += sz;
    }
  }

  if (!MallocFn) {
    MallocTy = FunctionType::get(I8PtrTy, {I64Ty}, false);
    MallocFn = Function::Create(MallocTy, Function::ExternalLinkage,
                                "malloc", *ModuleToEmit);
  }

  /* imitate original visitor pattern manually */
  for (Function &F : M)
    visitFunction(F);
}

void DepromoteRegisters::visitFunction(Function &F) {
  assert(FuncMap.count(&F));
  FuncToEmit = FuncMap[&F];

  // Fill source argument -> target argument map.
  for (unsigned i = 0, e = F.arg_size(); i < e; ++i) {
    auto *Arg = FuncToEmit->getArg(i);
    Arg->setName("__arg" + to_string(i + 1) + "__");
    checkTgtType(Arg->getType());
    ArgMap[F.getArg(i)] = Arg;
  }

  /* nothing more to handle if no instructions */
  if (F.getInstructionCount() <= 0) 
    return;

  /* decide total number of temporary registers */
  TempRegCnt = 3; // minimum required number
  unsigned instCnt = 0; // total number of registers
  for (auto &BB: F) {
    for (auto &I: BB) {
      if (auto *CI = dyn_cast<CallInst>(&I)) {
        unsigned argCnt = 0;
        for (auto I = CI->arg_begin(), E = CI->arg_end(); I != E; ++I) 
            argCnt++;
        if (argCnt > TempRegCnt) // store max # of arguments needed for a call
            TempRegCnt = argCnt;
      }
      if (I.hasName()) // count total number of named IR registers
        instCnt++;
    }
  }

  //if ((instCnt <= 13) && (TempRegCnt <= 16 - instCnt)) 
  //  TempRegCnt = 16 - instCnt; // all values are permanent register users
  //else 
  if (TempRegCnt < 8) 
    TempRegCnt = 8;

  /* initialize temporary register user tracker */
  TempRegUsers.clear();
  for (unsigned i = 0; i < TempRegCnt; i++) 
    TempRegUsers.push_back(make_pair(nullptr, make_pair(nullptr, i + 1)));

  getBlockBFS(&F.getEntryBlock(), BasicBlockBFS);
  
  // Fill source BB -> target BB map.
  for (auto *BB : BasicBlockBFS) 
    BBMap[BB] = BasicBlock::Create(*Context, "." + BB->getName(), FuncToEmit);
  
  // visit all basic blocks in BFS order
  for (auto *BB : BasicBlockBFS) 
    visit(*BB); 

  /* resolve dependency issues introduced by temporary register system */
  resolveRegDependency();

  /* clean-up unnecessary instructions created during depromotion */
  removeExtraMemoryInsts();
  cleanRedundantCasts();
}

void DepromoteRegisters::visitBasicBlock(BasicBlock &BB) {
  assert(BBMap.count(&BB));
  BBToEmit = BBMap[&BB];

  Function *SourceFunc = BB.getParent();
  if (&BB == &SourceFunc->getEntryBlock()) {
    
    /* sort by number of usages */
    vector<pair<unsigned, Instruction *>> InstCount;
    for (auto *BB : BasicBlockBFS) {
      for (auto &I : *BB) {
        if (!I.hasName() || dyn_cast<CastInst>(&I))//||  dyn_cast<PHINode>(&I))
            continue;

        if (auto *phi = dyn_cast<PHINode>(&I)) {
          int canBePermanent = 1;
          for (int i = 0, end = phi->getNumIncomingValues(); i < end; i++) {
            if (isa<Constant>(phi->getIncomingValue(i))) { //|| //!phi->getIncomingValue(i)->getType()->isIntegerTy()) {
              canBePermanent = 0;
              break;
            }
          }
          
          if (!canBePermanent) 
            continue;
        }

        auto SingleInstCount = make_pair(0, &I);
        for (auto itr = (I).use_begin(), end = (I).use_end(); itr != end; ++itr) {
            if (dyn_cast<Instruction>((*itr).getUser())) 
                SingleInstCount.first++;
        }

        InstCount.push_back(SingleInstCount);
      }
    }
    std::sort(InstCount.begin(), InstCount.end()); 
    reverse(InstCount.begin(), InstCount.end()); // descending order

    /* give phis more priority */
    for (unsigned i = 0, sz = InstCount.size(); i < sz; i++) {
      if (auto *phi = dyn_cast<PHINode>(InstCount[i].second)) {
        auto *PHIInst = InstCount[i].second;
        InstCount.erase(InstCount.begin() + i);
        InstCount.insert(InstCount.begin(), make_pair(0, PHIInst));


        for (auto itr = phi->use_begin(), end = phi->use_end(); itr != end; ++itr) {
          auto *UsrI = dyn_cast<Instruction>(itr->getUser());
            if (UsrI && isa<PHINode>(UsrI) && UsrI != PHIInst && UsrI->getParent() == PHIInst->getParent()) {
              for (unsigned j = 0; j < sz; j++) {
                if (InstCount[j].second == UsrI) {
                  InstCount.erase(InstCount.begin());
                }
                sz = InstCount.size();
              }
            }
        
        }
      }
      sz = InstCount.size();
    }
    
    /* assign permanent register users */
    for (unsigned i = 0, sz = InstCount.size(); i < 16 - TempRegCnt && i < sz; i++)
      RegToRegMap[InstCount[i].second] = i + TempRegCnt + 1; // r(T+1) ~ r16
    
    /* assign allocas for temporary users */
    IRBuilder<> IB(BBToEmit); 
    for (auto *BB : BasicBlockBFS) {
      for (auto &RI : *BB) {
        auto *I = &RI;
        if (!I->hasName() || dyn_cast<ZExtInst>(I)) 
            continue;

        auto *Ty = I->getType();
        checkSrcType(Ty);

        if (RegToRegMap.count(&*I)) // don't assign for permanent users
          continue;

        if (dyn_cast<PHINode>(I))
          RegToAllocaMap[&*I] =
            IB.CreateAlloca(SrcToTgtType(Ty), nullptr, I->getName() + "_phi");
        else
          RegToAllocaMap[&*I] =
            IB.CreateAlloca(SrcToTgtType(Ty), nullptr, I->getName() + "_slot");
      }
    }

    if (FuncToEmit->getName() == "main") {
      // Let's create a malloc for each global var.
      // This is dummy register.
      string Reg1 = retrieveAssemblyRegister(nullptr);
      for (auto &[_, Size] : GVLocs) {
        auto *ArgTy =
          dyn_cast<IntegerType>(MallocFn->getFunctionType()->getParamType(0));
        assert(ArgTy);
        IB.CreateCall(MallocFn, {ConstantInt::get(ArgTy, Size)}, Reg1);
      }
    }
  }

  Builder = make_unique<IRBuilder<TargetFolder>>(BBToEmit,
      TargetFolder(ModuleToEmit->getDataLayout()));
}

// Unsupported instruction goes here.
void DepromoteRegisters::visitInstruction(Instruction &I) {
  raiseError(I);
}

// ---- Memory operations ----
void DepromoteRegisters::visitAllocaInst(AllocaInst &I) {
  // NOTE: It is assumed that allocas are only in the entry block!
  assert(I.getParent() == &I.getFunction()->getEntryBlock() &&
         "Alloca is not in the entry block; this algorithm wouldn't work");
  
  checkSrcType(I.getAllocatedType());
  // This will be lowered to 'r1 = add sp, <offset>'
  auto *NewAllc = Builder->CreateAlloca(I.getAllocatedType(),
            I.getArraySize(), retrieveAssemblyRegister(&I));
  saveInst(NewAllc, &I);
}

void DepromoteRegisters::visitLoadInst(LoadInst &LI) {
  checkSrcType(LI.getType());
  auto *TgtPtrOp = translateSrcOperandToTgt(LI.getPointerOperand(), 1);
  auto *LoadedTy = TgtPtrOp->getType()->getPointerElementType();
  Value *LoadedVal = nullptr;
  
  if (LoadedTy->isIntegerTy() && LoadedTy->getIntegerBitWidth() < 64) {
    // Need to zext.
    // before_zext__ will be recognized by the assembler & merged with 64-bit
    // load to a smaller load.
    string Reg = retrieveAssemblyRegister(&LI);
    string RegBeforeZext = Reg + "before_zext__";
    LoadedVal = Builder->CreateLoad(TgtPtrOp, RegBeforeZext);
    LoadedVal = Builder->CreateZExt(LoadedVal, I64Ty, Reg);
  } else {
    LoadedVal = Builder->CreateLoad(TgtPtrOp, retrieveAssemblyRegister(&LI));
  }
  checkTgtType(LoadedVal->getType());
  saveInst(LoadedVal, &LI);
}

void DepromoteRegisters::visitStoreInst(StoreInst &SI) {
  auto *Ty = SI.getValueOperand()->getType();
  checkSrcType(Ty);
  
  auto *TgtValOp = translateSrcOperandToTgt(SI.getValueOperand(), 1);
  checkTgtType(TgtValOp->getType());
  if (TgtValOp->getType() != Ty) {
    // 64bit -> Ty bit trunc is needed.
    // after_trunc__ will be recognized by the assembler & merged with 64-bit
    // store into a smaller store.
    string R0Trunc = retrieveAssemblyRegister(nullptr) + "after_trunc__";
    assert(Ty->isIntegerTy() && TgtValOp->getType()->isIntegerTy());
    TgtValOp = Builder->CreateTrunc(TgtValOp, Ty, R0Trunc);
  }
  
  auto *TgtPtrOp = translateSrcOperandToTgt(SI.getPointerOperand(), 2);
  Builder->CreateStore(TgtValOp, TgtPtrOp);
}

// ---- Arithmetic operations ----
void DepromoteRegisters::visitBinaryOperator(BinaryOperator &BO) {
  auto *Ty = BO.getType();
  checkSrcType(Ty);
  
  switch(BO.getOpcode()) {
  case Instruction::UDiv:
  case Instruction::URem:
  case Instruction::Mul:
  case Instruction::Shl:
  case Instruction::LShr:
  case Instruction::And:
  case Instruction::Or:
  case Instruction::Xor:
  case Instruction::Add:
  case Instruction::Sub:
  case Instruction::SDiv:
  case Instruction::SRem:
  case Instruction::AShr:
    break;
  default: raiseError(BO); break;
  }
  
  auto RegName = retrieveAssemblyRegister(&BO);
  auto *Op1 = translateSrcOperandToTgt(BO.getOperand(0), 1);
  auto *Op2 = translateSrcOperandToTgt(BO.getOperand(1), 2);
  auto *Op1Trunc = Builder->CreateTruncOrBitCast(Op1, Ty,
                                RegName + "after_trunc__");
  auto *Op2Trunc = Builder->CreateTruncOrBitCast(Op2, Ty,
      retrieveAssemblyRegister(nullptr) + "after_trunc__");
  
  Value *Res = nullptr;
  if (BO.getType() != I64Ty) {
    Res = Builder->CreateBinOp(BO.getOpcode(), Op1Trunc, Op2Trunc,
                               RegName + "before_zext__");
    Res = Builder->CreateZExt(Res, I64Ty, RegName);
  } else {
    Res = Builder->CreateBinOp(BO.getOpcode(), Op1Trunc, Op2Trunc, RegName);
  }
  saveInst(Res, &BO);
}

void DepromoteRegisters::visitICmpInst(ICmpInst &II) {
  auto *OpTy = II.getOperand(0)->getType();
  checkSrcType(II.getType());
  checkSrcType(OpTy);
  
  auto RegName = retrieveAssemblyRegister(&II);
  auto *Op1 = translateSrcOperandToTgt(II.getOperand(0), 1);
  auto *Op2 = translateSrcOperandToTgt(II.getOperand(1), 2);
  auto *Op1Trunc = Builder->CreateTruncOrBitCast(Op1, OpTy,
                                RegName + "after_trunc__");
  auto *Op2Trunc = Builder->CreateTruncOrBitCast(Op2, OpTy,
      retrieveAssemblyRegister(nullptr) + "after_trunc__");
  
  // i1 -> i64 zext
  string Reg_before_zext = RegName + "before_zext__";
  auto *Res = Builder->CreateZExt(
      Builder->CreateICmp(II.getPredicate(), Op1Trunc, Op2Trunc,
      Reg_before_zext), I64Ty, RegName);
  saveInst(Res, &II);
}

void DepromoteRegisters::visitSelectInst(SelectInst &SI) {
  auto RegName = retrieveAssemblyRegister(&SI);
  auto *Ty = SI.getType();
  auto *OpCond = translateSrcOperandToTgt(SI.getOperand(0), 1);
  assert(OpCond->getType() == I64Ty);
  // i64 -> i1 trunc
  string R1Trunc = RegName + "after_trunc__";
  OpCond = Builder->CreateTrunc(OpCond, I1Ty, R1Trunc);
  
  auto *OpLeft = translateSrcOperandToTgt(SI.getOperand(1), 2);
  auto *OpRight = translateSrcOperandToTgt(SI.getOperand(2), 3);
  auto *Res = Builder->CreateSelect(OpCond, OpLeft, OpRight, RegName);
  saveInst(Res, &SI);
}

void DepromoteRegisters::visitGetElementPtrInst(GetElementPtrInst &GEPI) {
  // Make it look like 'gep i8* ptr, i'
  auto *PtrOp = translateSrcOperandToTgt(GEPI.getPointerOperand(), 1);
  auto RegName = retrieveAssemblyRegister(&GEPI);
  auto *PtrI8Op = Builder->CreateBitCast(PtrOp, I8PtrTy, RegName);
  unsigned Idx = 1;
  Type *CurrentPtrTy = GEPI.getPointerOperandType();
  
  while (Idx <= GEPI.getNumIndices()) {
    assert(GEPI.getOperand(Idx)->getType() == I64Ty &&
           "We only accept getelementptr with indices of 64 bits.");
    auto *IdxValue = translateSrcOperandToTgt(GEPI.getOperand(Idx), 2);
    
    auto *ElemTy = CurrentPtrTy->getPointerElementType();
    unsigned sz = getAccessSize(ElemTy);
    if (sz != 1) {
      assert(sz != 0);
      IdxValue = Builder->CreateMul(IdxValue, ConstantInt::get(I64Ty, sz),
                          retrieveAssemblyRegister(nullptr));
    }

    bool isZero = false;
    if (auto *CI = dyn_cast<ConstantInt>(IdxValue))
      isZero = CI->getZExtValue() == 0;

    if (!isZero)
      PtrI8Op = Builder->CreateGEP(PtrI8Op, IdxValue, RegName);

    if (!ElemTy->isArrayTy()) {
      CurrentPtrTy = nullptr;
      assert(Idx == GEPI.getNumIndices());
    } else
      CurrentPtrTy = PointerType::get(ElemTy->getArrayElementType(), 0);
    ++Idx;
  }

  PtrOp = Builder->CreateBitCast(PtrI8Op, GEPI.getType(), RegName);
  saveInst(PtrOp, &GEPI);
}

// ---- Casts ----
string DepromoteRegisters::retrieveCastInstRegister(CastInst *CI) {
  auto *Op = CI->getOperand(0);
  auto *OpI = dyn_cast<Instruction>(Op);

  if (!OpI) 
    return retrieveAssemblyRegister(CI);

  for (auto itr = Op->use_begin(), end = Op->use_end(); itr != end; ++itr) {
    auto *UserI = dyn_cast<Instruction>(itr->getUser());
    if (!UserI || UserI == CI || UserI == OpI)
      continue;
    return retrieveAssemblyRegister(CI);
  }

  for (unsigned i = 0; i < TempRegCnt; i++) {
      if (TempRegUsers[i].first != OpI) 
        continue;
      TempRegUsers[i].first = CI;
      TempRegUsers[i].second.first = nullptr;
      return assemblyRegisterName(TempRegUsers[i].second.second);
  }
  return retrieveAssemblyRegister(CI);
}

void DepromoteRegisters::visitBitCastInst(BitCastInst &BCI) {
  auto *Op = translateSrcOperandToTgt(BCI.getOperand(0), 1);
  auto *CastedOp = Builder->CreateBitCast(Op, BCI.getType(),
            retrieveCastInstRegister(&BCI));
  saveInst(CastedOp, &BCI);
}

void DepromoteRegisters::visitSExtInst(SExtInst &SI) {
  // Get the sign bit.
  uint64_t bw = SI.getOperand(0)->getType()->getIntegerBitWidth();
  auto *Op = translateSrcOperandToTgt(SI.getOperand(0), 1);
  auto RegName = retrieveAssemblyRegister(&SI);
  auto *AndVal =
    Builder->CreateBinOp(Instruction::UDiv, Op, 
      ConstantInt::get(I64Ty, 1llu << (bw - 1)), RegName);
    //Builder->CreateAnd(Op, (1llu << (bw - 1)), RegName);
  auto *NegVal =
    Builder->CreateBinOp(Instruction::Mul, AndVal, 
      ConstantInt::get(I64Ty, 0llu - (1llu << (bw - 1))), RegName);
    //Builder->CreateSub(ConstantInt::get(I64Ty, 0), AndVal, RegName);
  auto *ResVal =
    Builder->CreateOr(NegVal, Op, RegName);
  saveInst(ResVal, &SI);
}

void DepromoteRegisters::visitZExtInst(ZExtInst &ZI) {
  // Everything is zero-extended by default.
}

void DepromoteRegisters::visitTruncInst(TruncInst &TI) {
  auto *Op = translateSrcOperandToTgt(TI.getOperand(0), 1);
  uint64_t Mask = 1llu << (TI.getDestTy()->getIntegerBitWidth());
  Value *Res;
  if (Mask == 0)
    Res = Builder->CreateAnd(Op, Mask - 1, retrieveCastInstRegister(&TI));
  else 
    Res = Builder->CreateBinOp(Instruction::URem, Op, 
      ConstantInt::get(I64Ty, Mask), retrieveCastInstRegister(&TI));
  saveInst(Res, &TI);
}

void DepromoteRegisters::visitPtrToIntInst(PtrToIntInst &PI) {
  auto *Op = translateSrcOperandToTgt(PI.getOperand(0), 1);
  auto *Res = Builder->CreatePtrToInt(Op, I64Ty, retrieveCastInstRegister(&PI));
  saveInst(Res, &PI);
}

void DepromoteRegisters::visitIntToPtrInst(IntToPtrInst &II) {
  auto *Op = translateSrcOperandToTgt(II.getOperand(0), 1);
  auto *Res = Builder->CreateIntToPtr(Op, II.getType(), retrieveCastInstRegister(&II));
  saveInst(Res, &II);
}

// ---- Call ----
void DepromoteRegisters::visitCallInst(CallInst &CI) {
  auto *CalledF = CI.getCalledFunction();
  assert(FuncMap.count(CalledF));
  auto *CalledFInTgt = FuncMap[CalledF];
  
  SmallVector<Value *, 16> Args;
  unsigned Idx = 1;
  for (auto I = CI.arg_begin(), E = CI.arg_end(); I != E; ++I) {
    Args.emplace_back(translateSrcOperandToTgt(*I, Idx));
    ++Idx;
  }
  if (CI.hasName()) {
    Value *Res = Builder->CreateCall(CalledFInTgt, Args,
                  retrieveAssemblyRegister(&CI));
    saveInst(Res, &CI);
  } else {
    Builder->CreateCall(CalledFInTgt, Args);
  }
}

// ---- Terminators ----
void DepromoteRegisters::visitReturnInst(ReturnInst &RI) {
  if (auto *RetVal = RI.getReturnValue())
    Builder->CreateRet(translateSrcOperandToTgt(RetVal, 1));
  else
    // To `ret i64 0`
    Builder->CreateRet(
      ConstantInt::get(IntegerType::getInt64Ty(*Context), 0));
}

void DepromoteRegisters::visitBranchInst(BranchInst &BI) {
  for (auto *Succ : BI.successors())
    processPHIsInSuccessor(Succ, BI.getParent());
  
  if (BI.isUnconditional()) {
    Builder->CreateBr(BBMap[BI.getSuccessor(0)]);
  } else {
    auto *CondOp = translateSrcOperandToTgt(BI.getCondition(), 1);
    // to_i1__ is recognized by assembler.
    string regname = retrieveAssemblyRegister(nullptr) + "to_i1__";
    auto *Condi1 = Builder->CreateICmpNE(CondOp, ConstantInt::get(I64Ty, 0),
                                         regname);
    Builder->CreateCondBr(Condi1, BBMap[BI.getSuccessor(0)],
                                  BBMap[BI.getSuccessor(1)]);
  }
}

void DepromoteRegisters::visitSwitchInst(SwitchInst &SI) {
  // Emit phi's values first!
  for (unsigned i = 0, e = SI.getNumSuccessors(); i != e; ++i)
    processPHIsInSuccessor(SI.getSuccessor(i), SI.getParent());
  
  auto *TgtCond = translateSrcOperandToTgt(SI.getCondition(), 1);
  vector<pair<ConstantInt *, BasicBlock *>> TgtCases;
  for (SwitchInst::CaseIt I = SI.case_begin(), E = SI.case_end();
       I != E; ++I) {
    auto *C = ConstantInt::get(I64Ty, I->getCaseValue()->getZExtValue());
    TgtCases.emplace_back(C, BBMap[I->getCaseSuccessor()]);
  }
  auto *TgtSI = Builder->CreateSwitch(TgtCond, BBMap[SI.getDefaultDest()],
                                      SI.getNumCases());
  for (auto [CaseVal, CaseDest] : TgtCases)
    TgtSI->addCase(CaseVal, CaseDest);
}

void DepromoteRegisters::processPHIsInSuccessor(BasicBlock *Succ, BasicBlock *BBFrom) {
  // PHIs can use each other:
  // ex)
  // loop:
  //   x = phi [0, entry] [y, loop] // y from the prev. iteration
  //   y = phi [1, entry] [x, loop] // x from the prev. iteration
  //   ...
  //   br label %loop
  //
  // hence, all loads are done prior to any store instruction
  vector<PHINode *> RegCopyToMake, StoreToMake;

 // outs() << Succ->getParent()->getName() << "\n\n";
  for (auto &PHI : Succ->phis()) {
    auto *V =
      translateSrcOperandToTgt(PHI.getIncomingValueForBlock(BBFrom), 1);
    checkTgtType(V->getType());
    assert(!isa<Instruction>(V) || !V->hasName() ||
           V->getName().startswith("__r"));
    if (RegToAllocaMap.count(&PHI)) {
      StoreToMake.push_back(&PHI);
      evictTempInst(&PHI);
    } else {
      assert(RegToRegMap.count(&PHI));
      assert(!isa<ConstantInt>(V));
      RegCopyToMake.push_back(&PHI);
      
    }
  }
  for (auto *PHI: StoreToMake)
    Builder->CreateStore(
        translateSrcOperandToTgt(
            PHI->getIncomingValueForBlock(BBFrom), 1), RegToAllocaMap[PHI]);

  for (auto *PHI: RegCopyToMake) {
      auto *V =
        translateSrcOperandToTgt(PHI->getIncomingValueForBlock(BBFrom), 1);
      auto RegName = retrieveAssemblyRegister(PHI);
      if (V->getType()->isIntegerTy()) {
        
        Value *tempVal= Builder->CreateIntToPtr(V, I8PtrTy, RegName);
   //     outs() << "Created " << *tempVal << "\n";
        InstMap[PHI] = Builder->CreatePtrToInt(tempVal, V->getType(), RegName);

      //  InstMap[&PHI] = Builder->CreateBinOp(Instruction::UDiv, V, ConstantInt::get(I64Ty, 1), RegName);
 //       outs() << "Created " << *InstMap[&PHI] << "\n";
      } else {



//  auto *Res = 

        Value *tempVal;
    //    if (V->getType() == I8PtrTy)
          tempVal= Builder->CreatePtrToInt(V, I64Ty, RegName);
   //     else
     //     tempVal = Builder->CreateBitCast(V, I8PtrTy, RegName);
  //      outs() << "Created " << *tempVal << "\n";
        InstMap[PHI] = Builder->CreateIntToPtr(tempVal, V->getType(), RegName);
  //      outs() << "Created " << *InstMap[&PHI] << "\n";
      }
  }
}

// ---- Phi ----
void DepromoteRegisters::visitPHINode(PHINode &PN) {
  // Do nothing! already processed by processPHIsInSuccessors().
}

// ---- For Debugging -----
void DepromoteRegisters::dumpToStdOut() {
  outs() << *ModuleToEmit;
}