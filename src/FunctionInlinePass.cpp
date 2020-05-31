#include "Team4Passes.h"

/*******************************************
 *          Function Inline Pass
  
 * If a function is worthy to inline, stuff 
 * it into a vector and inline them. 

********************************************/ 

unsigned FunctionInlinePass::countInsts(const Function &F) {
    unsigned count=0;
    for (auto &BB : F) {
        for (auto &I : BB){
            count++;
        }
    }
    return count;
}

unsigned FunctionInlinePass::countRegs(const Function &F) {
    unsigned count=0;
    for (auto &BB : F) {
        for (auto &I : BB){
            if (I.hasName() || !I.hasName() && !I.getType()->isVoidTy()) { 
                count++; 
            }
        }
    }
    return count;
}

PreservedAnalyses FunctionInlinePass::run(Module &M, ModuleAnalysisManager &MAM) {

    FunctionAnalysisManager &FAM = MAM.getResult<FunctionAnalysisManagerModuleProxy>(M).getManager();

    std::function<AssumptionCache &(Function &)> GetAssumptionCache =
        [&](Function &F) -> AssumptionCache & {
        return FAM.getResult<AssumptionAnalysis>(F);
    };

    InlineFunctionInfo IFI(/*cg=*/nullptr, &GetAssumptionCache);
    SmallVector<Function *, 16> InlinedFunctions;   
    bool Inlined = false;     

    SmallVector<Function *, 16> CalledFunctions;  

    for (auto &F : M) {
        for (auto &BB : F ) {
            for (auto &I : BB){
                if (auto *CI = dyn_cast<CallInst>(&I)){
                    Function *calledfunc = CI->getCalledFunction();
                    // if (instsInFunc(*calledfunc)<15)
                    if (countRegs(*calledfunc)<15 && countRegs(F)<15)
                        CalledFunctions.push_back(calledfunc);
                }
            }
        }
    }

    for (auto F : CalledFunctions) {

        SmallSetVector<CallSite, 16> Calls;

        // if (!F->isDeclaration()) {
        if (!F->isDeclaration() && isInlineViable(*F)) { // Is inline viable 하면 bitcount2 도 줄지만, 5는 늘어나
            Calls.clear();

            for (User *U : F->users())
                if (auto CS = CallSite(U))
                    if (CS.getCalledFunction() == F)
                        Calls.insert(CS);
            
            for (CallSite CS : Calls)
                Inlined |= InlineFunction(CS, IFI, /*CalleeAAR=*/nullptr, false);
            
            InlinedFunctions.push_back(F);
        }
    }

    // Remove any live functions.
    erase_if(InlinedFunctions, [&](Function *F) {
        F->removeDeadConstantUsers();
        return !F->isDefTriviallyDead();
    });

    // Delete the non-comdat ones from the module and also from our vector.
    auto NonComdatBegin = partition(
        InlinedFunctions, [&](Function *F) { return F->hasComdat(); });
    for (Function *F : make_range(NonComdatBegin, InlinedFunctions.end()))
        M.getFunctionList().erase(F);
    InlinedFunctions.erase(NonComdatBegin, InlinedFunctions.end());

    if (!InlinedFunctions.empty()) {
        // Now we just have the comdat functions. Filter out the ones whose comdats
        // are not actually dead.
        filterDeadComdatFunctions(M, InlinedFunctions);
        // The remaining functions are actually dead.
        for (Function *F : InlinedFunctions)
        M.getFunctionList().erase(F);
    }

    return Inlined ? PreservedAnalyses::none() : PreservedAnalyses::all();
}