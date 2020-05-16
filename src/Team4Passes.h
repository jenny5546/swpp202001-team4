#ifndef TEAM4PASSES_H
#define TEAM4PASSES_H

#include "llvm/Passes/PassBuilder.h"
#include "llvm/Passes/PassPlugin.h"
#include "llvm/IR/IRBuilder.h"
#include "llvm/IR/PatternMatch.h"
#include "llvm/IR/PassManager.h"
#include "llvm/IR/Function.h"
#include "llvm/Support/raw_ostream.h"
#include "llvm/Transforms/InstCombine/InstCombine.h"
#include "llvm/Transforms/IPO.h"
#include "llvm/Transforms/Scalar/SimplifyCFG.h"
#include "llvm/Transforms/Scalar/DCE.h"
#include "llvm/Transforms/Utils/BasicBlockUtils.h"
#include "llvm/Transforms/Utils/CodeExtractor.h"
#include "llvm/IR/IRBuilder.h"
#include <algorithm>
#include <string>
#include <vector>

#include "llvm/Analysis/MemoryBuiltins.h"
#include "llvm/Analysis/TargetLibraryInfo.h"
#include "llvm/IR/DataLayout.h"
#include "llvm/Pass.h"
#include "llvm/Analysis/ValueTracking.h"
#include "llvm/IR/Constants.h"
#include <algorithm>

using namespace std;
using namespace llvm;
using namespace llvm::PatternMatch;

class Malloc2AllocPass : public llvm::PassInfoMixin<Malloc2AllocPass> {
public:
    void findPossibleMallocs(Function &F, vector<Instruction*> &PossibleMallocs);
    void findReplaceableMallocs(Function &F, FunctionAnalysisManager &FAM, vector<Instruction*> &PossibleMallocs, vector<Instruction*> &ReplaceableMallocs, vector<Instruction*> &RemovableFrees);
    void replaceMallocwithAlloc(Function &F, FunctionAnalysisManager &FAM, vector<Instruction*> &ReplaceableMallocs, vector<Instruction*> &RemovableFrees);
    PreservedAnalyses run(Function &F, FunctionAnalysisManager &FAM);
};

class FunctionOutlinePass : public llvm::PassInfoMixin<FunctionOutlinePass> {
public:
    PreservedAnalyses run(Module &M, ModuleAnalysisManager &MAM);
};

class ArithmeticPass : public llvm::PassInfoMixin<ArithmeticPass> {
public:
  PreservedAnalyses run(Function &F, FunctionAnalysisManager &FAM);
};

#endif