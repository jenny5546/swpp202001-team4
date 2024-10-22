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

string DepromoteRegisters::retrieveAssemblyRegister(Instruction *I, vector<Value*> *Ops) {
  /* get register name for given instruction; evict a used register if necessary */
  unsigned registerId;

  if (I == nullptr || (RegToAllocaMap.count(I) || !RegToRegMap.count(I))) {
    if (Ops != nullptr) { /* attempt to use register name of operand */
      for (auto *OpVal : *Ops) {
        if (!isa<Instruction>(OpVal) || !OpVal->hasOneUse() || // must be an instruction that is only used here
             dyn_cast<Instruction>(OpVal)->getParent() != I->getParent()) // operand must be in same block for dependence safety
          continue;
        for (unsigned i = 0; i < TempRegCnt; i++) { // if only used once, search for its register ID
            if (TempRegUsers[i].first != OpVal) continue;
            registerId = TempRegUsers[i].second.second; // evict without store, and give register to current inst
            TempRegUsers.erase(TempRegUsers.begin() + i);
            TempRegUsers.push_back(make_pair(I, make_pair(nullptr, registerId)));
            return assemblyRegisterName(registerId);
        }
      }
      delete Ops; // Ops are passed with "new"; they are no longer needed after this
    }
    /* retrieve temporary register, and assign new if none */
    for (unsigned i = 0; i < TempRegCnt; i++) {
      if (TempRegUsers[i].first != nullptr) 
        continue;
      registerId = TempRegUsers[i].second.second;
      TempRegUsers.erase(TempRegUsers.begin() + i); // push the register to the end to indicate recent usage (LRU)
      TempRegUsers.push_back(make_pair(I, make_pair(nullptr, registerId)));
      return assemblyRegisterName(registerId);
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
    if (TempRegUsers[i].first == I) {
      auto Res = TempRegUsers[i].second.first; // push the register to the end to indicate recent usage (LRU)
      TempRegUsers.push_back(make_pair(TempRegUsers[i].first, 
          make_pair(TempRegUsers[i].second.first, TempRegUsers[i].second.second)));
      TempRegUsers.erase(TempRegUsers.begin() + i);
      return Res;
    }
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
  Evictions.push_back(Builder->CreateStore(V, RegToAllocaMap[I])); // add to list of evictions, to differentiate from normal stores
}

void DepromoteRegisters::saveInst(Value *Res, Instruction *I) {
  /* save instruction mapping */
  InstMap[I] = Res;
  if (isa<Constant>(Res)) // if the value turns out to be a constant, it should not reside in register
    evictTempInst(I);
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

bool DepromoteRegisters::getBlockBFS(BasicBlock *StartBB, vector<BasicBlock *> &BasicBlockBFS) {
  /* get blocks in logical BFS order, from StartBB */
  /* additionally, return true if StartBB is in a loop */
  BasicBlockBFS.clear();
  vector<BasicBlock *> BlockQueue;
  BlockQueue.push_back(StartBB);
  bool isLoop = false;

  while (!BlockQueue.empty()) {
    BasicBlock *BB = BlockQueue.front();
    BlockQueue.erase(BlockQueue.begin());

    if (find(BasicBlockBFS.begin(), BasicBlockBFS.end(), BB) != BasicBlockBFS.end()) 
    {
        if (StartBB == BB) isLoop = true; // if StartBB is found again, then it is in loop
        continue;
    }

    BasicBlockBFS.push_back(BB);
    for (unsigned i = 0, cnt = BB->getTerminator()->getNumSuccessors(); i < cnt; i++)
      BlockQueue.push_back(BB->getTerminator()->getSuccessor(i));
  }
  return isLoop;
}

// Encode the value of V.
// If V is an argument, return the corresponding argN argument.
// If V is a constant, just return it.
// If V is an instruction, it emits load from the temporary alloca.
Value *DepromoteRegisters::translateSrcOperandToTgt(Value *V, unsigned OperandId) {
  checkSrcType(V->getType());

  while (auto *ZI = dyn_cast<ZExtInst>(V)) // keep receiving operand until non-zext value
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
    if (V->getType()->isIntegerTy())
      return ConstantInt::get(I64Ty, 0);
    else if (V->getType()->isPointerTy())
      return ConstantPointerNull::get(dyn_cast<PointerType>(V->getType()));
    else
      return UndefValue::get(I64Ty);

  } else if (auto *GV = dyn_cast<GlobalVariable>(V)) {
    assert(GVMap.count(GV));
    return GVMap[GV];

  } else if (auto *I = dyn_cast<Instruction>(V)) {
    if (isa<Constant>(InstMap[I]) || (!RegToAllocaMap.count(I) && RegToRegMap.count(I)))
      return InstMap[I];
    else {
      auto *Res = emitLoadFromSrcRegister(I, OperandId);
      saveInst(Res, I); // after retrieved, must put reg value info to TempRegUsers
      return Res;
    }

  } else {
    assert(false && "Unknown instruction type!");
  }
}

void DepromoteRegisters::resolveRegDependency() {
  /* resolve dependency issues by adding load/store insts where dependency could occur */
  vector <pair<Instruction *, pair<Instruction *, Instruction *>>> LoadToAdd;
  vector<pair<Instruction *, Instruction *>> StoreToAdd;

  for (auto *SI : Evictions) {
    /* iterate through list of register evictions */
    auto *Op = SI->getValueOperand();
    auto *OpI = dyn_cast<Instruction>(Op);
    auto *PtyOp = SI->getPointerOperand();
    vector<pair<Instruction *, Instruction *>> InstsToResolve;

    if (!isa<PHINode>(Op) && !(isa<LoadInst>(Op) && dyn_cast<LoadInst>(Op)->getPointerOperand() == PtyOp))
      StoreToAdd.push_back(make_pair(OpI, dyn_cast<AllocaInst>(PtyOp))); // add store after original instruction

    for (auto itr = Op->use_begin(), end = Op->use_end(); itr != end; ++itr) // get all usages
      InstsToResolve.push_back(make_pair(dyn_cast<Instruction>((*itr).getUser()), OpI));

    for (auto itr = PtyOp->use_begin(), end = PtyOp->use_end(); itr != end; ++itr) // get all usages after loading back from stack
      if (auto *LI = dyn_cast<LoadInst>((*itr).getUser()))
        for (auto itr2 = LI->use_begin(), end2 = LI->use_end(); itr2 != end2; ++itr2)
          InstsToResolve.push_back(make_pair(dyn_cast<Instruction>((*itr2).getUser()), LI));

    for (auto entry : InstsToResolve) { // iterate through usages, and add loads before every usage in separate blocks
      Instruction *UsrI = entry.first;
      Instruction *OpI = dyn_cast<Instruction>(entry.second);

      if (!UsrI || UsrI == SI || UsrI->getParent() == OpI->getParent())
        continue;

      LoadToAdd.push_back(make_pair(dyn_cast<Instruction>(PtyOp), make_pair(OpI, UsrI)));
    }
  }

  for (auto entry : StoreToAdd) 
    (new StoreInst(entry.first, entry.second))->insertAfter(entry.first);
  for (auto entry: LoadToAdd) { // since only "__rx__" part matter, and after this it goes to emitter, just copy name
    auto *Res = new LoadInst(entry.first, entry.second.first->getName());
    Res->insertBefore(entry.second.second); 
    for (unsigned i = 0, n = entry.second.second->getNumOperands(); i < n; i++)
      if (entry.second.second->getOperand(i) == entry.second.first)
        entry.second.second->setOperand(i, Res); // this is for passing use_empty()
  }
  for (auto entry : Evictions) // eviction stores are no longer needed
    entry->eraseFromParent();
}

void DepromoteRegisters::removeExtraMemoryInsts() {       // remove unnecessary memory operations
  OrderedInstructions OI(new DominatorTree(*FuncToEmit)); // introduced from resolving dependencies
  std::set<Instruction *> InstsToRemove;

  for (auto *BB : BasicBlockBFS) { // go through every instruction, looking for alloca/load/store
    LoadInst *PrevLI = nullptr;

    for (auto &I : *BBMap[BB]) {
      if (I.hasName() && I.use_empty() && (isa<AllocaInst>(&I) || isa<LoadInst>(&I))) {
        InstsToRemove.insert(&I); // remove alloca/load that is not used

      } else if (auto *LI = dyn_cast<LoadInst>(&I)) {
        auto *SIOP = dyn_cast<StoreInst>(I.use_begin()->getUser());
        if (I.hasOneUse() && SIOP && SIOP->getPointerOperand() == LI->getPointerOperand()) {
          // load and store without usage
          InstsToRemove.insert(dyn_cast<Instruction>(SIOP)); // remove store first (must erase use first!)
          // load will be removed by use_empty() condition on next recursive call

        } else {
          // consecutive double loads
          if (PrevLI != nullptr && PrevLI->getPointerOperand() == LI->getPointerOperand() &&
            PrevLI->getName().str().substr(0, 6) == LI->getName().str().substr(0, 6))
              PrevLI->replaceAllUsesWith(LI);
          
          PrevLI = LI;
          continue;
        }
        
      } else if (auto *SI = dyn_cast<StoreInst>(&I)) {
        auto *PtyOp = SI->getPointerOperand();
        if (!PtyOp->getName().endswith("_slot") || !isa<Instruction>(SI->getValueOperand())) {
          PrevLI = nullptr; // reset PrevLI since this continues to next iteration
          continue;  // only consider store to stack created by depromotion
        }

        vector<BasicBlock *> Reachables;
        getBlockBFS(SI->getParent(), Reachables);

        InstsToRemove.insert(&I); // if no reachable load after store, remove the store

        for (auto itr = PtyOp->use_begin(), end = PtyOp->use_end(); itr != end; ++itr) {
          LoadInst *UsrI = dyn_cast<LoadInst>(itr->getUser()); 

          if (UsrI && find(Reachables.begin(), Reachables.end(), UsrI->getParent()) != Reachables.end() &&
              !((UsrI->getParent() == SI->getParent() && !OI.dfsBefore(SI, UsrI))))
            InstsToRemove.erase(&I); // if there is reachable load after store, then store is needed
        }
      }
      PrevLI = nullptr;
    }
  }
  for (auto *I : InstsToRemove)
    I->eraseFromParent();
  if (!InstsToRemove.empty())
    removeExtraMemoryInsts();
}

void DepromoteRegisters::replaceDuplicateLoads() {
  /* search for duplicate loads, and replace it if possible */
  std::set<Instruction *> InstsToRemove;
  for (auto *BB : BasicBlockBFS) { // go through every instruction, looking for load instructions
    for (auto &I : *BBMap[BB]) {
      if (auto *LI = dyn_cast<LoadInst>(&I)) {
        auto *PtyOp = LI->getPointerOperand();

        // must be a load from stack, allocated during depromotion
        if (!(PtyOp->getName().endswith("_slot") || 
              PtyOp->getName().endswith("_phi")) || 
             !isa<AllocaInst>(PtyOp))
          continue;
        
        // search for possible replacements
        Instruction *RI = nullptr;
        for (auto &I : *LI->getParent()) {
          if (&I == LI) {
            if (RI) { // replacement was found, replace original load
              I.replaceAllUsesWith(RI);
              InstsToRemove.insert(&I);
            }
            break;
          }
          auto *newLI = dyn_cast<LoadInst>(&I);
          if (newLI && newLI->getPointerOperand() == PtyOp &&
              I.getName().str().substr(0, 6) == LI->getName().str().substr(0, 6)) {
            if (!RI) RI = &I; // a replacement is found
          } else if (RI && RI->getName().str().substr(0, 6) == I.getName().str().substr(0, 6) &&
                   I.getName().str().find("after_trunc__") == string::npos) {
            RI = nullptr; // previously found replacement is not valid
          }
        }
      }
    }
  }
  for (auto *I : InstsToRemove)
    I->eraseFromParent();
}

void DepromoteRegisters::cleanRedundantCasts() {
  for (auto *BB : BasicBlockBFS) { // go through every cast instruction
    for (auto &I: *BBMap[BB]) {
      if (auto *CI = dyn_cast<CastInst>(&I)) {
        auto *Op = CI->getOperand(0);
        if (!dyn_cast<Instruction>(Op) || CI->getNumUses() != 1 ||
            Op->getName().str().find("arg") != string::npos ||
            Op->getName().str().find("before_zext__") != string::npos ||
            CI->getName().str().find("after_trunc__") != string::npos)
          continue;
        // if CI is only used once in the next/next-next inst, then it can use Op name
        for (auto itr = CI->getParent()->begin(), end = CI->getParent()->end();; ++itr) {
          if (&*itr != CI) 
            continue;
          ++itr;
          if (itr == end)
            break;
          if (&*itr == CI->use_begin()->getUser())
            CI->setName(assemblyRegisterName(stoi(Op->getName().str().substr(3, 2))));
          if (itr->hasName() && itr->getName().str().substr(3, 2) == Op->getName().str().substr(3, 2))
            break;
          ++itr;
          if (itr != end && &*itr == CI->use_begin()->getUser())
              CI->setName(assemblyRegisterName(stoi(Op->getName().str().substr(3, 2))));
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
  Evictions.clear();

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
  TempRegCnt = 4; // minimum required number
  unsigned instCnt = 0; // total number of registers
  for (auto &BB: F) {
    for (auto &I: BB) {
      if (auto *CI = dyn_cast<CallInst>(&I)) {
        unsigned argCnt = 0;
        for (auto I = CI->arg_begin(), E = CI->arg_end(); I != E; ++I) 
            argCnt++;
        if (CI->hasName()) // the instruction itself must have register ID as well
            argCnt++;
        if (argCnt > TempRegCnt) // store max # of arguments needed for a call
            TempRegCnt = argCnt;
      }
      if (I.hasName()) // count total number of named IR registers
        instCnt++;
    }
  }

  if ((instCnt <= 12) && (TempRegCnt <= 16 - instCnt)) 
    TempRegCnt = 16 - instCnt; // all values are permanent register users
  else if (TempRegCnt < 8) 
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

  /* resolve dependency issues, and clean-up unnecessarily created instructions */
  resolveRegDependency();
  removeExtraMemoryInsts(); 
  replaceDuplicateLoads();
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
        if (!I.hasName() || dyn_cast<CastInst>(&I)) // casts are usually for one-time use; make it temporary
            continue;

        auto SingleInstCount = make_pair(0, &I);
        for (auto itr = (I).use_begin(), end = (I).use_end(); itr != end; ++itr) {
            if (auto *UserI = dyn_cast<Instruction>((*itr).getUser())) {
                SingleInstCount.first++;
                if (getBlockBFS(UserI->getParent(), *(new vector<BasicBlock *>))) 
                  SingleInstCount.first += 2; // give more priority if it is used within loop
                if (isa<PHINode>(&I)) SingleInstCount.first += 10; // give a lot of priority if instruction is phi value
            }
        }
        for (int i = 0; i <= InstCount.size(); i++) {
          if (i == InstCount.size() || InstCount[i].first < SingleInstCount.first) {
            InstCount.insert(InstCount.begin() + i, SingleInstCount);
            break;
          }
        }
      }
    }

    /* if phi uses constant, or is dependent on other phi on same block, must be put on stack */
    for (unsigned i = 0, flag = 0, sz = InstCount.size(); i < sz; i++, flag = 0, sz = InstCount.size()) {
      if (auto *phi = dyn_cast<PHINode>(InstCount[i].second)) {
        for (unsigned j = 0, end = phi->getNumIncomingValues(); j < end; j++)
          if (isa<Constant>(phi->getIncomingValue(j))) flag = 1; // LLVM IR does not allow assigning constant to register, so delete
        for (auto itr = phi->use_begin(), end = phi->use_end(); itr != end; ++itr) {
          auto *UsrI = dyn_cast<Instruction>(itr->getUser());
          if (isa<PHINode>(UsrI) && UsrI->getParent() == phi->getParent())
            for (unsigned j = 0; j < sz; j++)
              if (InstCount[j].second == UsrI) flag = 1; // there is another phi, that is used by this phi, on permanent candidates
        }
      }
      if (flag) InstCount.erase(InstCount.begin() + i--); // deletion has to be done within iteration so that only either of dependent phis are deleted
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

        RegToAllocaMap[&*I] =
          IB.CreateAlloca(SrcToTgtType(Ty), nullptr, I->getName() + "_slot");
        if (dyn_cast<PHINode>(I)) // phis will be handled differently later when removing extra load/stores
          RegToAllocaMap[&*I]->setName(RegToAllocaMap[&*I]->getName() + "_phi");
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
  if (isa<UnreachableInst>(&I) && I.getParent()->getTerminator() == &I) // unreachable instructions are changed to br
    Builder->CreateBr(BBMap[&I.getParent()->getParent()->getEntryBlock()]);
  else
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
    string Reg = retrieveAssemblyRegister(&LI, new vector<Value *>{LI.getPointerOperand()});
    string RegBeforeZext = Reg + "before_zext__";
    LoadedVal = Builder->CreateLoad(TgtPtrOp, RegBeforeZext);
    LoadedVal = Builder->CreateZExt(LoadedVal, I64Ty, Reg);
  } else {
    LoadedVal = Builder->CreateLoad(TgtPtrOp, retrieveAssemblyRegister(&LI, new vector<Value *>{LI.getPointerOperand()}));
  }
  checkTgtType(LoadedVal->getType());
  saveInst(LoadedVal, &LI);
}

void DepromoteRegisters::visitStoreInst(StoreInst &SI) {
  if (isa<UndefValue>(SI.getValueOperand()) || isa<UndefValue>(SI.getPointerOperand()))
    return; // ignore undef created by GVN
  auto *Ty = SI.getValueOperand()->getType();
  checkSrcType(Ty);
  
  auto *TgtValOp = translateSrcOperandToTgt(SI.getValueOperand(), 1);
  checkTgtType(TgtValOp->getType());
  if (TgtValOp->getType() != Ty) {
    // 64bit -> Ty bit trunc is needed.
    // after_trunc__ will be recognized by the assembler & merged with 64-bit
    // store into a smaller store.
    string R0Trunc = assemblyRegisterName(1) + "after_trunc__"; // this is ignored by emitter; just use r1
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
  
  auto *Op1 = translateSrcOperandToTgt(BO.getOperand(0), 1);
  auto *Op2 = translateSrcOperandToTgt(BO.getOperand(1), 2);
  auto *Op1Trunc = Builder->CreateTruncOrBitCast(Op1, Ty,
                      assemblyRegisterName(1) + "after_trunc__"); // this is ignored by emitter; just use r1
  auto *Op2Trunc = Builder->CreateTruncOrBitCast(Op2, Ty,
                      assemblyRegisterName(2) + "after_trunc__"); // same as above
  
  Value *Res = nullptr;
  if (BO.getType() != I64Ty) {
    string RegName = retrieveAssemblyRegister(&BO, new vector<Value *>{BO.getOperand(0), BO.getOperand(1)});
    Res = Builder->CreateBinOp(BO.getOpcode(), Op1Trunc, Op2Trunc,
                               RegName + "before_zext__");
    Res = Builder->CreateZExt(Res, I64Ty, RegName);
  } else {
    Res = Builder->CreateBinOp(BO.getOpcode(), Op1Trunc, Op2Trunc,
          retrieveAssemblyRegister(&BO, new vector<Value *>{BO.getOperand(0), BO.getOperand(1)}));
  }
  saveInst(Res, &BO);
}

void DepromoteRegisters::visitICmpInst(ICmpInst &II) {
  auto *OpTy = II.getOperand(0)->getType();
  checkSrcType(II.getType());
  checkSrcType(OpTy);
  
  auto *Op1 = translateSrcOperandToTgt(II.getOperand(0), 1);
  auto *Op2 = translateSrcOperandToTgt(II.getOperand(1), 2);
  auto *Op1Trunc = Builder->CreateTruncOrBitCast(Op1, OpTy,
                    assemblyRegisterName(1) + "after_trunc__"); // ignored by emitter
  auto *Op2Trunc = Builder->CreateTruncOrBitCast(Op2, OpTy,
                    assemblyRegisterName(2) + "after_trunc__"); // same as above
  
  // i1 -> i64 zext
  auto Reg = retrieveAssemblyRegister(&II, new vector<Value *>{II.getOperand(0), II.getOperand(1)});
  string Reg_before_zext = Reg + "before_zext__";
  auto *Res = Builder->CreateZExt(
      Builder->CreateICmp(II.getPredicate(), Op1Trunc, Op2Trunc,
      Reg_before_zext), I64Ty, Reg);
  saveInst(Res, &II);
}

void DepromoteRegisters::visitSelectInst(SelectInst &SI) {
  auto *Ty = SI.getType();
  auto *OpCond = translateSrcOperandToTgt(SI.getOperand(0), 1);
  assert(OpCond->getType() == I64Ty);
  // i64 -> i1 trunc
  string R1Trunc = assemblyRegisterName(1) + "after_trunc__"; // ignored by emitter
  OpCond = Builder->CreateTrunc(OpCond, I1Ty, R1Trunc);
  
  auto *OpLeft = translateSrcOperandToTgt(SI.getOperand(1), 2);
  auto *OpRight = translateSrcOperandToTgt(SI.getOperand(2), 3);
  auto *Res = Builder->CreateSelect(OpCond, OpLeft, OpRight, 
    retrieveAssemblyRegister(&SI, new vector<Value *>{SI.getOperand(0), SI.getOperand(1), SI.getOperand(2)}));
  saveInst(Res, &SI);
}

void DepromoteRegisters::visitGetElementPtrInst(GetElementPtrInst &GEPI) {
  // Make it look like 'gep i8* ptr, i'
  auto *PtrOp = translateSrcOperandToTgt(GEPI.getPointerOperand(), 1);
  auto RegName = retrieveAssemblyRegister(&GEPI, new vector<Value *>{GEPI.getPointerOperand()});
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
          isa<Constant>(IdxValue) ? "" : retrieveAssemblyRegister(nullptr)); // if constant, LLVM will not create any inst
    }

    bool isZero = false;
    if (auto *CI = dyn_cast<ConstantInt>(IdxValue))
      isZero = CI->getZExtValue() == 0;

    if (!isZero) {
      PtrI8Op = Builder->CreateGEP(PtrI8Op, IdxValue, RegName);
    }

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
void DepromoteRegisters::visitBitCastInst(BitCastInst &BCI) {
  auto *Op = translateSrcOperandToTgt(BCI.getOperand(0), 1);
  auto *CastedOp = Builder->CreateBitCast(Op, BCI.getType(),
            retrieveAssemblyRegister(&BCI));
  saveInst(CastedOp, &BCI);
}

void DepromoteRegisters::visitSExtInst(SExtInst &SI) {
  // Get the sign bit.
  uint64_t bw = SI.getOperand(0)->getType()->getIntegerBitWidth();
  auto *Op = translateSrcOperandToTgt(SI.getOperand(0), 1);
  auto RegName = retrieveAssemblyRegister(&SI); // do not try to use Ops name, since its name is needed below
  auto *AndVal =
    Builder->CreateBinOp(Instruction::UDiv, Op, ConstantInt::get(I64Ty, 1llu << (bw - 1)), RegName);
  unsigned long long mask = 0llu;
  if (isa<IntegerType>(SI.getDestTy())) {
    for (unsigned i = 0, end = SI.getDestTy()->getIntegerBitWidth() - bw; i < end; i++) {
      mask += 1llu;
      mask <<= 1;
    }
    mask += 1llu;
    for (unsigned i = 0, end = bw - 1; i < end; i++)
      mask <<= 1;
  } else
    mask -= (1llu << (bw - 1));
  auto *NegVal =
    Builder->CreateBinOp(Instruction::Mul, AndVal, ConstantInt::get(I64Ty, mask), RegName);
  auto *ResVal =
    Builder->CreateOr(NegVal, Op, RegName);
  saveInst(ResVal, &SI);
}

void DepromoteRegisters::visitZExtInst(ZExtInst &ZI) {
  // Everything is zero-extended by default.
}

void DepromoteRegisters::visitTruncInst(TruncInst &TI) {
  auto *Op = translateSrcOperandToTgt(TI.getOperand(0), 1);
  auto RegName = retrieveAssemblyRegister(&TI, new vector<Value *>{TI.getOperand(0)});
  uint64_t Mask = (1llu << (TI.getDestTy()->getIntegerBitWidth())) - 1;
  Value *Res = Builder->CreateBinOp(Instruction::URem, Op, ConstantInt::get(I64Ty, Mask + 1), RegName); // UREM is faster than AND
  saveInst(Res, &TI);
}

void DepromoteRegisters::visitPtrToIntInst(PtrToIntInst &PI) {
  auto *Op = translateSrcOperandToTgt(PI.getOperand(0), 1);
  auto *Res = Builder->CreatePtrToInt(Op, I64Ty, retrieveAssemblyRegister(&PI, new vector<Value *>{PI.getOperand(0)}));
  saveInst(Res, &PI);
}

void DepromoteRegisters::visitIntToPtrInst(IntToPtrInst &II) {
  auto *Op = translateSrcOperandToTgt(II.getOperand(0), 1);
  auto *Res = Builder->CreateIntToPtr(Op, II.getType(), retrieveAssemblyRegister(&II, new vector<Value *>{II.getOperand(0)}));
  saveInst(Res, &II);
}

// ---- Call ----
void DepromoteRegisters::visitCallInst(CallInst &CI) {
  auto *CalledF = CI.getCalledFunction();
  if (CalledF->isIntrinsic() && CalledF->getInstructionCount() == 0 && CalledF->getReturnType()->isVoidTy())
    return; // ignore LLVM instrinsic void functions
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
    string regname = assemblyRegisterName(1) + "to_i1__"; // ignored by emitter; just use r1
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
  vector<PHINode *> StoreToMake;
  vector<PHINode *> RegCopyToMake;
  for (auto &PHI : Succ->phis()) {
    auto *V =
      translateSrcOperandToTgt(PHI.getIncomingValueForBlock(BBFrom), 1);
    checkTgtType(V->getType());
    assert(!isa<Instruction>(V) || !V->hasName() ||
           V->getName().startswith("__r"));
    if (RegToAllocaMap.count(&PHI)) StoreToMake.push_back(&PHI);
    else RegCopyToMake.push_back(&PHI); // store to stack must be done first to avoid dependency issue
  }
  for (auto *PHI: StoreToMake)
    Builder->CreateStore(
        translateSrcOperandToTgt(
            PHI->getIncomingValueForBlock(BBFrom), 1), RegToAllocaMap[PHI]);
  for (auto *PHI: RegCopyToMake) {
      auto *V = translateSrcOperandToTgt(PHI->getIncomingValueForBlock(BBFrom), 1);
      auto RegName = retrieveAssemblyRegister(PHI);
      if (V->getType()->isIntegerTy()) { // these are ignored by emitter and will be merged
        Value *tempVal= Builder->CreateIntToPtr(V, I8PtrTy, RegName);
        InstMap[PHI] = Builder->CreatePtrToInt(tempVal, V->getType(), RegName);
      } else {
        Value *tempVal= Builder->CreatePtrToInt(V, I64Ty, RegName);
        InstMap[PHI] = Builder->CreateIntToPtr(tempVal, V->getType(), RegName);
      }
  }
}

// ---- Phi ----
void DepromoteRegisters::visitPHINode(PHINode &PN) {
  if (!RegToAllocaMap.count(&PN)) return; // create load on original phi if it is temporary register user
  saveInst(Builder->CreateLoad(RegToAllocaMap[&PN], retrieveAssemblyRegister(&PN)), &PN);
}

// ---- For Debugging -----
void DepromoteRegisters::dumpToStdOut() {
  outs() << *ModuleToEmit;
}