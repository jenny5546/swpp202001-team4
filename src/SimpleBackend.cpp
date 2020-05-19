#include "SimpleBackend.h"
#include "Team4Passes.h"


// Return sizeof(T) in bytes.
unsigned getAccessSize(Type *T) {
  if (isa<PointerType>(T))
    return 8;
  else if (isa<IntegerType>(T)) {
    return T->getIntegerBitWidth() == 1 ? 1 : (T->getIntegerBitWidth() / 8);
  } else if (isa<ArrayType>(T)) {
    return getAccessSize(T->getArrayElementType()) * T->getArrayNumElements();
  }
  assert(false && "Unsupported access size type!");
}


// A simple namer. :)
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


PreservedAnalyses SimpleBackend::run(Module &M, ModuleAnalysisManager &FAM) {
  if (verifyModule(M, &errs(), nullptr))
    exit(1);

  // First, name all instructions / arguments / etc.
  InstNamer Namer;
  Namer.visit(M);

  // Second, convert known constant expressions to instructions.
  ConstExprToInsts CEI;
  CEI.visit(M);

  // Third, depromote registers to alloca & canonicalize iN types into i64.
  DepromoteRegisters Deprom;
  Deprom.visitModule(M);

  if (verifyModule(M, &errs(), nullptr)) {
    errs() << "BUG: DepromoteRegisters created an ill-formed module!\n";
    errs() << M;
    exit(1);
  }

  // For debugging, this will print the depromoted module.
  if (printDepromotedModule)
    Deprom.dumpToStdOut();

  // Now, let's emit assembly!
  error_code EC;
  raw_ostream *os =
    outputFile == "-" ? &outs() : new raw_fd_ostream(outputFile, EC);

  if (EC) {
    errs() << "Cannot open file: " << outputFile << "\n";
    exit(1);
  }

  AssemblyEmitter Emitter(os);
  Emitter.run(Deprom.getDepromotedModule());

  if (os != &outs()) delete os;

  return PreservedAnalyses::all();
}