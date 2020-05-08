#ifndef TEAM4PASSES_H
#define TEAM4PASSES_H

#include "llvm/IR/PassManager.h"
#include "llvm/Passes/PassBuilder.h"
#include "llvm/Passes/PassPlugin.h"
#include "llvm/Support/raw_ostream.h"
#include "llvm/IR/PatternMatch.h"
#include <string>

using namespace std;
using namespace llvm;
using namespace llvm::PatternMatch;

/* add following lines
class DoSomethingPass : public llvm::PassInfoMixin<DoSomethingPass> {
public:
    PreservedAnalyses run(Function &F, FunctionAnalysisManager &FAM);
};
*/

#endif