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
    vector<tuple <Function *,BasicBlock &> > trace;

    for (auto &F : M) {
        for (auto &BB : F ) {
            for (auto &I : BB){
                if (auto *CI = dyn_cast<CallInst>(&I)){
                    Function *calledfunc = CI->getCalledFunction();

                    if (countRegs(*calledfunc)<15 && countRegs(F)<15){

                        CalledFunctions.push_back(calledfunc);
                        trace.push_back(tuple<Function *,BasicBlock &>(calledfunc, BB));

                    }
                }
            }
        }
    }

    for (auto T : trace) {

        Function *F = get<0>(T);
        BasicBlock &block = get<1>(T);
        // outs()<<"called function is "<<F->getName()<<"\n";

        SmallSetVector<CallSite, 16> Calls;
        // bool duplicate = false;
        unsigned occurences = 0;
        
        for(int i = 0;  i < trace.size(); i++){
            if (get<0>(trace[i])==F){
                occurences++;
            }       
        }

        if (!F->isDeclaration() && isInlineViable(*F)) { // Is inline viable 하면 bitcount2 도 줄지만, 5는 늘어나
            Calls.clear();

            for (User *U : F->users()) {

                if (auto CS = CallSite(U)) {
                    if (CS.getCalledFunction() == F) {
                        
                        Calls.insert(CS);
                        // outs()<<"inlined function "<<F->getName()<<"\n";
                    }
                }
            }
            for (CallSite CS : Calls){
                Inlined |= InlineFunction(CS, IFI, /*CalleeAAR=*/nullptr, false);
            }
            InlinedFunctions.push_back(F);
        }
    }


    // Remove any live functions.
    erase_if(InlinedFunctions, [&](Function *F) {
        F->removeDeadConstantUsers();
        return !F->isDefTriviallyDead();
    });

    // Delete the non-comdat ones from the module and also from our vector.
    auto NonComdatBegin = partition(InlinedFunctions,[&](Function *F) {
        return F->hasComdat(); 
    });
    for (Function *F : make_range(NonComdatBegin, InlinedFunctions.end())) {
        // M.getFunctionList().erase(F);
    }
    InlinedFunctions.erase(NonComdatBegin, InlinedFunctions.end());

    if (!InlinedFunctions.empty()) {
        filterDeadComdatFunctions(M, InlinedFunctions);
        for (Function *F : InlinedFunctions){
            // M.getFunctionList().erase(F);
        }
    }

    return Inlined ? PreservedAnalyses::none() : PreservedAnalyses::all();
}