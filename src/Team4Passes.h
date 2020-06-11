#ifndef TEAM4PASSES_H
#define TEAM4PASSES_H

#include "llvm/ADT/SmallVector.h"
#include "llvm/Analysis/AliasAnalysis.h"
#include "llvm/Analysis/BasicAliasAnalysis.h"
#include "llvm/Analysis/MemoryBuiltins.h"
#include "llvm/Analysis/OptimizationRemarkEmitter.h"
#include "llvm/Analysis/OrderedInstructions.h"
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
#include "llvm/Transforms/Scalar/GVN.h"
#include "llvm/Transforms/Scalar/LICM.h"
#include "llvm/Transforms/Scalar/LoopDeletion.h"
#include "llvm/Transforms/Scalar/LoopInstSimplify.h"
#include "llvm/Transforms/Scalar/LoopSimplifyCFG.h"
#include "llvm/Transforms/Scalar/LoopUnrollPass.h"
#include "llvm/Transforms/Scalar/SimplifyCFG.h"
#include "llvm/Transforms/Utils/BasicBlockUtils.h"
#include "llvm/Transforms/Utils/CodeExtractor.h"
#include "llvm/Transforms/Utils/Cloning.h"
#include "llvm/Transforms/Utils/ModuleUtils.h"
#include "llvm/Support/Casting.h"
#include "llvm/IR/Use.h"
#include "llvm/IR/Value.h"

#include <algorithm>
#include <memory>
#include <string>
#include <sstream>
#include <vector>
#include <regex>
#include <set>

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
    bool isOutlinedArgs(const BasicBlock *Block, Value *V);
    unsigned countOutlinedArgs(BasicBlock *Block, vector<Value *> funcArgs);
    PreservedAnalyses run(Module &M, ModuleAnalysisManager &MAM);
};

class FunctionInlinePass : public llvm::PassInfoMixin<FunctionInlinePass> {
public:
    unsigned countInsts(const Function &F);
    unsigned countRegs(const Function &F);
    PreservedAnalyses run(Module &M, ModuleAnalysisManager &MAM);
};

class ArithmeticPass : public llvm::PassInfoMixin<ArithmeticPass> {
public:
  PreservedAnalyses run(Function &F, FunctionAnalysisManager &FAM);
};

class LICMGVLoadPass : public llvm::PassInfoMixin<LICMGVLoadPass> {
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
  unsigned TempRegCnt;

  /* data for building depromoted module */
  map<Function *, Function *> FuncMap;
  map<GlobalVariable *, Constant *> GVMap; // Global var to 'inttoptr i'
  vector<pair<uint64_t, uint64_t>> GVLocs; // (Global var addr, size) info
  map<Argument *, Argument *> ArgMap;
  map<BasicBlock *, BasicBlock *> BBMap;
  vector<BasicBlock *> BasicBlockBFS;        // BFS-Ordered Basic Blocks
  map<Instruction *, Value *> InstMap;       // original instruction to depromoted value
  map<Instruction *, unsigned> RegToRegMap;  // permanent register user to register number
  map<Instruction *, AllocaInst *> RegToAllocaMap;
  vector<pair<Instruction *, pair<Value *, unsigned>>> TempRegUsers; // temporary users
  vector<StoreInst *> Evictions;

  void raiseError(Instruction &I);

  /* type-related routines */
  Type *SrcToTgtType(Type *SrcTy);
  void checkSrcType(Type *T);
  void checkTgtType(Type *T);

  /* assembly allocation and management */
  string assemblyRegisterName(unsigned registerId);
  string retrieveAssemblyRegister(Instruction *I, vector<Value*> *Ops = nullptr);
  Value *emitLoadFromSrcRegister(Instruction *I, unsigned targetRegisterId);
  void emitStoreToSrcRegister(Value *V, Instruction *I);

  /* helper functions for instruction tracking */
  void saveInst(Value *Res, Instruction *I);
  void saveTempInst(Instruction *OldI, Value *Res);
  void evictTempInst(Instruction *I);
  bool getBlockBFS(BasicBlock *StartBB, vector<BasicBlock *> &BasicBlockBFS);
  Value *translateSrcOperandToTgt(Value *V, unsigned OperandId);

  /* after-depromotion clean-up functions */
  void resolveRegDependency();
  void removeExtraMemoryInsts();
  void replaceDuplicateLoads();
  void cleanRedundantCasts();

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