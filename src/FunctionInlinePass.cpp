#include "Team4Passes.h"

/*******************************************
 *          Function Inline Pass

 * If a function is small enough to inline, 
 * by small enough meaning that the inlined
 * function should use less than 14 registers,
 * after filtering these function calls, 
 * stuff it into a vector and inline them. 

********************************************/ 

unsigned FunctionInlinePass::countRegs(const Function &F) {
    unsigned count=0;
    for (auto &BB : F) {
        for (auto &I : BB){
            if (I.hasName() || (!I.hasName() && !I.getType()->isVoidTy())) { 
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

    InlineFunctionInfo IFI(nullptr, &GetAssumptionCache);
    
    SmallVector<Function *, 16> InlinedFunctions;   
    bool Inlined = false;    

    SmallVector<Function *, 16> CalledFunctions;  

    // Keep track of the function to inline & where it was called
    vector<tuple <Function *,BasicBlock &> > trace;

    for (auto &F : M) {
        for (auto &BB : F ) {
            for (auto &I : BB){
                if (auto *CI = dyn_cast<CallInst>(&I)){
                    Function *calledfunc = CI->getCalledFunction();

                    // Check if the calledfunc and the original function uses
                    // less than 15 registers-> optimal for inlining
                    if (countRegs(*calledfunc)<15){ 
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

        SmallSetVector<CallSite, 16> Calls;
        unsigned occurences = 0;
        
        // check if the inlined function is called more than once in the same block
        for(int i = 0;  i < trace.size(); i++){
            if (get<0>(trace[i])==F){
                occurences++;
            }       
        }

        if (!F->isDeclaration() && isInlineViable(*F)) { 
            Calls.clear();

            for (User *U : F->users()) {

                if (auto CS = CallSite(U)) {
                    if (CS.getCalledFunction() == F) {
                        
                        Calls.insert(CS);
                    }
                }
            }
            // Now inline all the should-be-inlined function 
            for (CallSite CS : Calls){
                Inlined |= InlineFunction(CS, IFI, nullptr, false);
            }
            bool isOutlinedFunction = false;

            // Don't erase Outlined Functions, even if it is inlined
            
            for (auto &BB: F->getBasicBlockList()){
                if (BB.getName() == "newFuncRoot"){ // Checking if it is an outlined func
                    isOutlinedFunction = true;
                    break;
                }
            }
            // Don't pushback previously outlined functions
            if (!isOutlinedFunction) {
                InlinedFunctions.push_back(F);
            }
        }
    }

    // Clean up the inlined functions

    erase_if(InlinedFunctions, [&](Function *F) {
        F->removeDeadConstantUsers();
        return !F->isDefTriviallyDead();
    });

    auto NonComdatBegin = partition(InlinedFunctions,[&](Function *F) {
        return F->hasComdat(); 
    });

    InlinedFunctions.erase(NonComdatBegin, InlinedFunctions.end());

    if (!InlinedFunctions.empty()) {
        filterDeadComdatFunctions(M, InlinedFunctions);
        for (Function *F : InlinedFunctions){
            M.getFunctionList().erase(F);
        }
    }

    return Inlined ? PreservedAnalyses::none() : PreservedAnalyses::all();
}