#ifndef TEAM4PASSES_H
#define TEAM4PASSES_H

#include "llvm/IR/PassManager.h"
#include "llvm/Passes/PassBuilder.h"
#include "llvm/Passes/PassPlugin.h"
#include "llvm/Support/raw_ostream.h"
#include "llvm/IR/PatternMatch.h"
#include "llvm/Transforms/Utils/BasicBlockUtils.h"
#include "llvm/Transforms/InstCombine/InstCombine.h"
#include "llvm/IR/IRBuilder.h"
#include "llvm/Transforms/Scalar/SimplifyCFG.h"
#include <vector>
#include <string>
#include <algorithm>

using namespace std;
using namespace llvm;
using namespace llvm::PatternMatch;

/* add following lines
class DoSomethingPass : public llvm::PassInfoMixin<DoSomethingPass> {
public:
    PreservedAnalyses run(Function &F, FunctionAnalysisManager &FAM);
};
*/

class ArithmeticPass : public llvm::PassInfoMixin<ArithmeticPass> {
public:
  PreservedAnalyses run(Function &F, FunctionAnalysisManager &FAM);
};

#endif