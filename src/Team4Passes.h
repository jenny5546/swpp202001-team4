#ifndef TEAM4PASSES_H
#define TEAM4PASSES_H

#include "llvm/IR/PassManager.h"
#include "llvm/Passes/PassBuilder.h"
#include "llvm/Passes/PassPlugin.h"
#include "llvm/Support/raw_ostream.h"
#include "llvm/IR/PatternMatch.h"
#include <string>

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

#endif