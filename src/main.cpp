#include "SimpleBackend.h"
#include "Team4Passes.h"
#include "llvm/IR/PassManager.h"
#include "llvm/IRReader/IRReader.h"
#include "llvm/Passes/PassBuilder.h"
#include "llvm/Support/CommandLine.h"
#include "llvm/Support/PrettyStackTrace.h"
#include "llvm/Support/Signals.h"
#include "llvm/Support/SourceMgr.h"

#include <string>

using namespace std;
using namespace llvm;


static cl::OptionCategory optCategory("SWPP Compiler options");

static cl::opt<string> optInput(
    cl::Positional, cl::desc("<input bitcode file>"), cl::Required,
    cl::value_desc("filename"), cl::cat(optCategory));

static cl::opt<string> optOutput(
    "o", cl::desc("output assembly file"), cl::cat(optCategory), cl::Required,
    cl::init("a.s"));

static cl::opt<bool> optPrintDepromotedModule(
    "print-depromoted-module", cl::desc("print depromoted module"),
    cl::cat(optCategory), cl::init(false));

static llvm::ExitOnError ExitOnErr;


// adapted from llvm-dis.cpp
static unique_ptr<Module> openInputFile(LLVMContext &Context,
                                        string InputFilename) {
  auto MB = ExitOnErr(errorOrToExpected(MemoryBuffer::getFile(InputFilename)));
  SMDiagnostic Diag;
  auto M = getLazyIRModule(move(MB), Diag, Context, true);
  if (!M) {
    Diag.print("", errs(), false);
    return 0;
  }
  ExitOnErr(M->materializeAll());
  return M;
}

int main(int argc, char **argv) {
  sys::PrintStackTraceOnErrorSignal(argv[0]);
  PrettyStackTraceProgram X(argc, argv);
  EnableDebugBuffering = true;

  cl::ParseCommandLineOptions(argc, argv);

  LLVMContext Context;
  // Read the module
  auto M = openInputFile(Context, optInput);
  if (!M)
    return 1;

  LoopAnalysisManager LAM;
  FunctionAnalysisManager FAM;
  CGSCCAnalysisManager CGAM;
  ModuleAnalysisManager MAM;
  PassBuilder PB;

  // Register all the basic analyses with the managers.
  PB.registerModuleAnalyses(MAM);
  PB.registerCGSCCAnalyses(CGAM);
  PB.registerFunctionAnalyses(FAM);
  PB.registerLoopAnalyses(LAM);
  PB.crossRegisterProxies(LAM, FAM, CGAM, MAM);

  // Register all the passes
  LoopPassManager LPM1;
  LPM1.addPass(LoopInstSimplifyPass());
  LPM1.addPass(LoopSimplifyCFGPass());
  LPM1.addPass(LICMPass());
  
  LoopPassManager LPM2;
  LPM2.addPass(LoopDeletionPass());

  FunctionPassManager FPM1;
  FPM1.addPass(LICMGVLoadPass());

  FunctionPassManager FPM2;
  FPM2.addPass(SimplifyCFGPass());
  FPM2.addPass(RequireAnalysisPass<OptimizationRemarkEmitterAnalysis, Function>());
  FPM2.addPass(createFunctionToLoopPassAdaptor(std::move(LPM1)));
  FPM2.addPass(SimplifyCFGPass());
  FPM2.addPass(createFunctionToLoopPassAdaptor(std::move(LPM2)));
  FPM2.addPass(LoopUnrollPass());

  FPM2.addPass(SimplifyCFGPass());
  FPM2.addPass(GVN());
  FPM2.addPass(ArithmeticPass());
  FPM2.addPass(DCEPass());
  FPM2.addPass(Malloc2AllocPass());
  FPM2.addPass(SimplifyCFGPass());

  ModulePassManager MPM;
  MPM.addPass(createModuleToFunctionPassAdaptor(std::move(FPM1)));
  MPM.addPass(FunctionOutlinePass());
  MPM.addPass(FunctionInlinePass());
  MPM.addPass(createModuleToFunctionPassAdaptor(std::move(FPM2)));
  MPM.addPass(SimpleBackend(optOutput, optPrintDepromotedModule));

  // Run!
  MPM.run(*M, MAM);

  return 0;
}
