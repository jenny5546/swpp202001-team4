#ifndef TEAM4PASSES_H
#define TEAM4PASSES_H

#include "llvm/ADT/SmallVector.h"
#include "llvm/Analysis/MemoryBuiltins.h"
#include "llvm/Analysis/TargetFolder.h"
#include "llvm/Analysis/TargetLibraryInfo.h"
#include "llvm/Analysis/ValueTracking.h"
#include "llvm/IR/Constants.h"
#include "llvm/IR/DataLayout.h"
#include "llvm/IR/Function.h"
#include "llvm/IR/InstrTypes.h"
#include "llvm/IR/Instructions.h"
#include "llvm/IR/InstVisitor.h"
#include "llvm/IR/IRBuilder.h"
#include "llvm/IR/PassManager.h"
#include "llvm/IR/PatternMatch.h"
#include "llvm/IR/Verifier.h"
#include "llvm/Pass.h"
#include "llvm/Passes/PassBuilder.h"
#include "llvm/Passes/PassPlugin.h"
#include "llvm/Support/raw_ostream.h"
#include "llvm/Transforms/InstCombine/InstCombine.h"
#include "llvm/Transforms/IPO.h"
#include "llvm/Transforms/Scalar/DCE.h"
#include "llvm/Transforms/Scalar/SimplifyCFG.h"
#include "llvm/Transforms/Utils/BasicBlockUtils.h"
#include "llvm/Transforms/Utils/CodeExtractor.h"

#include <algorithm>
#include <memory>
#include <string>
#include <sstream>
#include <vector>

#include "llvm/Analysis/MemoryBuiltins.h"
#include "llvm/Analysis/TargetLibraryInfo.h"
#include "llvm/IR/DataLayout.h"
#include "llvm/Pass.h"
#include "llvm/Analysis/ValueTracking.h"
#include "llvm/IR/Constants.h"
#include <algorithm>

#include "llvm/Transforms/Scalar/GVN.h"

using namespace std;
using namespace llvm;
using namespace llvm::PatternMatch;

class Malloc2AllocPass : public llvm::PassInfoMixin<Malloc2AllocPass> {
public:
    void findPossibleMallocs(Function &F, vector<Instruction*> &PossibleMallocs, unsigned MaxSize);
    void findReplaceableMallocs(Function &F, FunctionAnalysisManager &FAM, vector<Instruction*> &PossibleMallocs, vector<Instruction*> &ReplaceableMallocs, vector<Instruction*> &RemovableFrees);
    void replaceMallocwithAlloc(Function &F, FunctionAnalysisManager &FAM, vector<Instruction*> &ReplaceableMallocs, vector<Instruction*> &RemovableFrees);
    PreservedAnalyses run(Function &F, FunctionAnalysisManager &FAM);
};

class Malloc2AllocinMainPass : public llvm::PassInfoMixin<Malloc2AllocinMainPass> {
public:
    PreservedAnalyses run(Module &M, ModuleAnalysisManager &MAM);
};

class FunctionOutlinePass : public llvm::PassInfoMixin<FunctionOutlinePass> {
public:
    PreservedAnalyses run(Module &M, ModuleAnalysisManager &MAM);
};

class ArithmeticPass : public llvm::PassInfoMixin<ArithmeticPass> {
public:
  PreservedAnalyses run(Function &F, FunctionAnalysisManager &FAM);
};

/* Converts an IR Module into a new IR Module that has registers demoted to stack */
class DepromoteRegisters : public InstVisitor<DepromoteRegisters> {
private:
  LLVMContext *Context;
  IntegerType *I64Ty;
  IntegerType *I1Ty;
  PointerType *I8PtrTy;

  unique_ptr<Module> ModuleToEmit;
  Function *FuncToEmit = nullptr;
  BasicBlock *BBToEmit = nullptr;
  unique_ptr<IRBuilder<TargetFolder>> Builder;
  Function *MallocFn = nullptr;
  Instruction *DummyInst;
  unsigned TempRegCnt;

  /* data for building depromoted module */
  map<Function *, Function *> FuncMap;
  map<GlobalVariable *, Constant *> GVMap; // Global var to 'inttoptr i'
  vector<pair<uint64_t, uint64_t>> GVLocs; // (Global var addr, size) info
  map<Argument *, Argument *> ArgMap;
  map<BasicBlock *, BasicBlock *> BBMap;
  vector<BasicBlock *> BasicBlockBFS;        // BFS-Ordered Basic Blocks
  map<Instruction *, Value *> InstMap;       // original instruction to depromoted value
  map<Value *, AllocaInst *> ValToAllocaMap; // depromoted value to reserved alloca slot
  map<Instruction *, unsigned> RegToRegMap;  // permanent register user to register number
  map<Instruction *, AllocaInst *> RegToAllocaMap;
  vector<pair<Instruction *, pair<Value *, unsigned>>> TempRegUsers; // temporary users

  void raiseError(Instruction &I);

  /* type-related routines */
  Type *SrcToTgtType(Type *SrcTy);
  void checkSrcType(Type *T);
  void checkTgtType(Type *T);

  /* assembly allocation and management */
  string assemblyRegisterName(unsigned registerId);
  string retrieveAssemblyRegister(Instruction *I);
  Value *emitLoadFromSrcRegister(Instruction *I, unsigned targetRegisterId);
  void emitStoreToSrcRegister(Value *V, Instruction *I);

  /* helper functions for instruction tracking */
  void saveInst(Value *Res, Instruction *I);
  void saveTempInst(Instruction *OldI, Value *Res);
  void evictTempInst(Instruction *I);
  void getBlockBFS(BasicBlock *StartBB, vector<BasicBlock *> &BasicBlockBFS);
  
  Value *translateSrcOperandToTgt(Value *V, unsigned OperandId);

  /* after-depromotion clean-up functions */
  void resolveRegDependency();

public:
  Module *getDepromotedModule() const;

  /* higher-level visit functions */
  void visitModule(Module &M);
  void visitFunction(Function &F);
  void visitBasicBlock(BasicBlock &BB);
  void visitInstruction(Instruction &I);

  /* memory operations */
  void visitAllocaInst(AllocaInst &I);
  void visitLoadInst(LoadInst &LI);
  void visitStoreInst(StoreInst &SI);

  /* arithmetic operations */
  void visitBinaryOperator(BinaryOperator &BO);
  void visitICmpInst(ICmpInst &II);
  void visitSelectInst(SelectInst &SI);
  void visitGetElementPtrInst(GetElementPtrInst &GEPI);

  /* casts */
  void visitBitCastInst(BitCastInst &BCI);
  void visitSExtInst(SExtInst &SI);
  void visitZExtInst(ZExtInst &ZI);
  void visitTruncInst(TruncInst &TI);
  void visitPtrToIntInst(PtrToIntInst &PI);
  void visitIntToPtrInst(IntToPtrInst &II);

  /* call */
  void visitCallInst(CallInst &CI);

  /* terminators */
  void visitReturnInst(ReturnInst &RI);
  void visitBranchInst(BranchInst &BI);
  void visitSwitchInst(SwitchInst &SI);
  void processPHIsInSuccessor(BasicBlock *Succ, BasicBlock *BBFrom);
  
  /* phi */
  void visitPHINode(PHINode &PN);

  /* for debugging */
  void dumpToStdOut();
};

#endif
