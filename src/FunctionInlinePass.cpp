#include "Team4Passes.h"

/*******************************************
 *          Function Inline Pass
  
 * If a function is worthy to inline, stuff 
 * it into a vector and inline them. 

********************************************/ 

unsigned FunctionInlinePass::instsInFunc(const Function &F) {
    unsigned count=0;
    for (auto &BB : F) {
        for (auto &I : BB){
            count++;
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
                    if (instsInFunc(*calledfunc)<20 && instsInFunc(F)<20)
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

    return Inlined ? PreservedAnalyses::none() : PreservedAnalyses::all();
}