#include "llvm/AsmParser/Parser.h"
#include "llvm/IR/InstIterator.h"
#include "llvm/IR/IRBuilder.h"
#include "llvm/IR/Module.h"
#include "llvm/Passes/PassBuilder.h"
#include "llvm/Support/SourceMgr.h"
#include "gtest/gtest.h"
#include "SimpleBackend.h"
#include "Team4Passes.h"

using namespace llvm;
using namespace std;

/* Classes borrowed from SimpleBackend.cpp */
class InstNamer : public InstVisitor<InstNamer> {
public:
  void visitFunction(Function &F) {
    for (auto &Arg : F.args())
      if (!Arg.hasName())
        Arg.setName("arg");

    for (BasicBlock &BB : F) {
      if (!BB.hasName())
        BB.setName(&F.getEntryBlock() == &BB ? "entry" : "bb");

      for (Instruction &I : BB)
        if (!I.hasName() && !I.getType()->isVoidTy())
          I.setName("tmp");
    }
  }
};
class ConstExprToInsts : public InstVisitor<ConstExprToInsts> {
  Instruction *ConvertCEToInst(ConstantExpr *CE, Instruction *InsertBefore) {
    auto *NewI = CE->getAsInstruction();
    NewI->insertBefore(InsertBefore);
    NewI->setName("from_constexpr");
    visitInstruction(*NewI);
    return NewI;
  }
public:
  void visitInstruction(Instruction &I) {
    for (unsigned Idx = 0; Idx < I.getNumOperands(); ++Idx) {
      if (auto *CE = dyn_cast<ConstantExpr>(I.getOperand(Idx))) {
        I.setOperand(Idx, ConvertCEToInst(CE, &I));
      }
    }
  }
};

TEST(MainTest, CheckMain) {
  // Show that the assembler correctly emits 'start main 0' as well as 'end main'
  LLVMContext Context;
  unique_ptr<Module> M(new Module("MyTestModule", Context));
  auto *I64Ty = Type::getInt64Ty(Context);
  auto *TestFTy = FunctionType::get(I64Ty, {}, false);
  Function *TestF = Function::Create(TestFTy, Function::ExternalLinkage,
                                     "main", *M);

  BasicBlock *Entry = BasicBlock::Create(Context, "entry", TestF);
  IRBuilder<> EntryBuilder(Entry);
  EntryBuilder.CreateRet(ConstantInt::get(I64Ty, 0));

  string str;
  raw_string_ostream os(str);
  AssemblyEmitter(&os).run(M.get());

  str = os.str();
  // These strings should exist in the assembly!
  EXPECT_NE(str.find("start main 0:"), string::npos);
  EXPECT_NE(str.find("end main"), string::npos);
}

TEST(MemoryEfficiencyTest, ExtraAlloca1) {
  LLVMContext Context;
  SMDiagnostic Error;
  unique_ptr<Module> M = parseAssemblyFile("./filechecks/RegisterAllocationOpt-Test1.ll", Error, Context);
  ASSERT_TRUE(M);
  
  InstNamer Namer;
  Namer.visit(*M);
  ConstExprToInsts CEI;
  CEI.visit(*M);
  DepromoteRegisters Deprom;
  Deprom.visitModule(*M);
  Module *DM = Deprom.getDepromotedModule();

  for (auto &F : *DM) {
    for (auto &I : F) {
      if (isa<AllocaInst>(&I))
        ASSERT_TRUE(!I.use_empty());
    }
  }
}

TEST(MemoryEfficiencyTest, ExtraAlloca2) {
  LLVMContext Context;
  SMDiagnostic Error;
  unique_ptr<Module> M = parseAssemblyFile("./filechecks/RegisterAllocationOpt-Test2.ll", Error, Context);
  ASSERT_TRUE(M);
  
  InstNamer Namer;
  Namer.visit(*M);
  ConstExprToInsts CEI;
  CEI.visit(*M);
  DepromoteRegisters Deprom;
  Deprom.visitModule(*M);
  Module *DM = Deprom.getDepromotedModule();

  for (auto &F : *DM) {
    for (auto &I : F) {
      if (isa<AllocaInst>(&I))
        ASSERT_TRUE(!I.use_empty());
    }
  }
}

TEST(MemoryEfficiencyTest, ExtraAlloca3) {
  LLVMContext Context;
  SMDiagnostic Error;
  unique_ptr<Module> M = parseAssemblyFile("./filechecks/RegisterAllocationOpt-Test3.ll", Error, Context);
  ASSERT_TRUE(M);
  
  InstNamer Namer;
  Namer.visit(*M);
  ConstExprToInsts CEI;
  CEI.visit(*M);
  DepromoteRegisters Deprom;
  Deprom.visitModule(*M);
  Module *DM = Deprom.getDepromotedModule();

  for (auto &F : *DM) {
    for (auto &I : F) {
      if (isa<AllocaInst>(&I))
        ASSERT_TRUE(!I.use_empty());
    }
  }
}

TEST(MemoryEfficiencyTest, ExtraLoad1) {
  LLVMContext Context;
  SMDiagnostic Error;
  unique_ptr<Module> M = parseAssemblyFile("./filechecks/RegisterAllocationOpt-Test1.ll", Error, Context);
  ASSERT_TRUE(M);
  
  InstNamer Namer;
  Namer.visit(*M);
  ConstExprToInsts CEI;
  CEI.visit(*M);
  DepromoteRegisters Deprom;
  Deprom.visitModule(*M);
  Module *DM = Deprom.getDepromotedModule();

  for (auto &F : *DM) {
    for (auto &BB : F) {
      bool isPrevLoad = false;
      LoadInst *PrevLoad = nullptr;
      for (auto &I : BB) {
        if (auto *LI = dyn_cast<LoadInst>(&I)) {
          if (isPrevLoad) {
            ASSERT_FALSE(!(PrevLoad->getPointerOperand() == LI->getPointerOperand() &&
              PrevLoad->getName().str().substr(0, 6) == LI->getName().str().substr(0, 6)));
          }
          isPrevLoad = true;
          PrevLoad = LI;
        } else {
          isPrevLoad = false;
          PrevLoad = nullptr;
        }
      }
    }
  }
}

TEST(MemoryEfficiencyTest, ExtraLoad2) {
  LLVMContext Context;
  SMDiagnostic Error;
  unique_ptr<Module> M = parseAssemblyFile("./filechecks/RegisterAllocationOpt-Test2.ll", Error, Context);
  ASSERT_TRUE(M);
  
  InstNamer Namer;
  Namer.visit(*M);
  ConstExprToInsts CEI;
  CEI.visit(*M);
  DepromoteRegisters Deprom;
  Deprom.visitModule(*M);
  Module *DM = Deprom.getDepromotedModule();

  for (auto &F : *DM) {
    for (auto &BB : F) {
      bool isPrevLoad = false;
      LoadInst *PrevLoad = nullptr;
      for (auto &I : BB) {
        if (auto *LI = dyn_cast<LoadInst>(&I)) {
          if (isPrevLoad) {
            ASSERT_FALSE(!(PrevLoad->getPointerOperand() == LI->getPointerOperand() &&
              PrevLoad->getName().str().substr(0, 6) == LI->getName().str().substr(0, 6)));
          }
          isPrevLoad = true;
          PrevLoad = LI;
        } else {
          isPrevLoad = false;
          PrevLoad = nullptr;
        }
      }
    }
  }
}

TEST(MemoryEfficiencyTest, ExtraLoad3) {
  LLVMContext Context;
  SMDiagnostic Error;
  unique_ptr<Module> M = parseAssemblyFile("./filechecks/RegisterAllocationOpt-Test3.ll", Error, Context);
  ASSERT_TRUE(M);
  
  InstNamer Namer;
  Namer.visit(*M);
  ConstExprToInsts CEI;
  CEI.visit(*M);
  DepromoteRegisters Deprom;
  Deprom.visitModule(*M);
  Module *DM = Deprom.getDepromotedModule();

  for (auto &F : *DM) {
    for (auto &BB : F) {
      bool isPrevLoad = false;
      LoadInst *PrevLoad = nullptr;
      for (auto &I : BB) {
        if (auto *LI = dyn_cast<LoadInst>(&I)) {
          if (isPrevLoad) {
            ASSERT_FALSE(!(PrevLoad->getPointerOperand() == LI->getPointerOperand() &&
              PrevLoad->getName().str().substr(0, 6) == LI->getName().str().substr(0, 6)));
          }
          isPrevLoad = true;
          PrevLoad = LI;
        } else {
          isPrevLoad = false;
          PrevLoad = nullptr;
        }
      }
    }
  }
}

TEST(MemoryEfficiencyTest, ExtraStore1) {
  LLVMContext Context;
  SMDiagnostic Error;
  unique_ptr<Module> M = parseAssemblyFile("./filechecks/RegisterAllocationOpt-Test1.ll", Error, Context);
  ASSERT_TRUE(M);
  
  InstNamer Namer;
  Namer.visit(*M);
  ConstExprToInsts CEI;
  CEI.visit(*M);
  DepromoteRegisters Deprom;
  Deprom.visitModule(*M);
  Module *DM = Deprom.getDepromotedModule();

  for (auto &F : *DM) {
    for (auto &BB : F) {
      for (auto &I : BB) {
        if (auto *LI = dyn_cast<LoadInst>(&I)) {
          ASSERT_TRUE(!(I.hasOneUse() && isa<StoreInst>(I.use_begin()->getUser()) &&
              dyn_cast<StoreInst>(I.use_begin()->getUser())->getPointerOperand() == LI->getPointerOperand()));
        }
      }
    }
  }
}

TEST(MemoryEfficiencyTest, ExtraStore2) {
  LLVMContext Context;
  SMDiagnostic Error;
  unique_ptr<Module> M = parseAssemblyFile("./filechecks/RegisterAllocationOpt-Test2.ll", Error, Context);
  ASSERT_TRUE(M);
  
  InstNamer Namer;
  Namer.visit(*M);
  ConstExprToInsts CEI;
  CEI.visit(*M);
  DepromoteRegisters Deprom;
  Deprom.visitModule(*M);
  Module *DM = Deprom.getDepromotedModule();

  for (auto &F : *DM) {
    for (auto &BB : F) {
      for (auto &I : BB) {
        if (auto *LI = dyn_cast<LoadInst>(&I)) {
          ASSERT_TRUE(!(I.hasOneUse() && isa<StoreInst>(I.use_begin()->getUser()) &&
              dyn_cast<StoreInst>(I.use_begin()->getUser())->getPointerOperand() == LI->getPointerOperand()));
        }
      }
    }
  }
}

TEST(MemoryEfficiencyTest, ExtraStore3) {
  LLVMContext Context;
  SMDiagnostic Error;
  unique_ptr<Module> M = parseAssemblyFile("./filechecks/RegisterAllocationOpt-Test3.ll", Error, Context);
  ASSERT_TRUE(M);
  
  InstNamer Namer;
  Namer.visit(*M);
  ConstExprToInsts CEI;
  CEI.visit(*M);
  DepromoteRegisters Deprom;
  Deprom.visitModule(*M);
  Module *DM = Deprom.getDepromotedModule();

  for (auto &F : *DM) {
    for (auto &BB : F) {
      for (auto &I : BB) {
        if (auto *LI = dyn_cast<LoadInst>(&I)) {
          ASSERT_TRUE(!(I.hasOneUse() && isa<StoreInst>(I.use_begin()->getUser()) &&
              dyn_cast<StoreInst>(I.use_begin()->getUser())->getPointerOperand() == LI->getPointerOperand()));
        }
      }
    }
  }
}

int main(int argc, char **argv) {
  ::testing::InitGoogleTest(&argc, argv);
  return RUN_ALL_TESTS();
}