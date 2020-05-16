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

using namespace std;
using namespace llvm;
using namespace llvm::PatternMatch;


class FunctionOutlinePass : public llvm::PassInfoMixin<FunctionOutlinePass> {
public:
    PreservedAnalyses run(Module &M, ModuleAnalysisManager &MAM);
};

class ArithmeticPass : public llvm::PassInfoMixin<ArithmeticPass> {
public:
  PreservedAnalyses run(Function &F, FunctionAnalysisManager &FAM);
};

#endif