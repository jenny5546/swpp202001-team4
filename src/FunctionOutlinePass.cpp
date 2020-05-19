#include "Team4Passes.h"

/*******************************************
 *          Function Outlining Pass
  
 * If a basic block uses more than 14 registers, 
 * break the block, making sure that the pred
 * block post dominates the succ block, and 
 * replace it into a function call.

********************************************/ 
PreservedAnalyses FunctionOutlinePass::run(Module &M, ModuleAnalysisManager &MAM) {

    /* 
        If a block in a function uses more than 13 registers, 
        just break it into half, outlining it to another function. 
    */

    for (auto &F : M) {

        for (auto &BB : F ) {

            bool outLined = false;
            int regsInBlock = 0;
            Instruction *pointToInsert; 
            vector<Value *> valuesToPreserve;

            for (auto *itr = F.arg_begin(), *end = F.arg_end(); itr != end; ++itr)
                valuesToPreserve.push_back(&*itr);

            for (auto &I : BB){

                /* 
                    Registers have names %x = (some instruction).
                    Keep track of the number of regs.
                */

                //  Count regs with name in characters & regs that have names like %0, %1...
                if (I.hasName() || !I.hasName() && !I.getType()->isVoidTy()) { 
                    regsInBlock ++;   
                }
                if (regsInBlock <= 13){
                    valuesToPreserve.push_back(&I);
                }
                if (regsInBlock ==14){
                    pointToInsert = &I;
                }
                if (regsInBlock > 13 && !I.isTerminator()){ 
                    outLined = true;
                } 

            }

            if (outLined){

                BasicBlock *succ = BB.splitBasicBlock(pointToInsert, "outline");

                unsigned useCnt = 0;
                for (auto *v : valuesToPreserve)
                    if (v->isUsedInBasicBlock(succ))
                        useCnt++;
                if (useCnt > 16)
                    break;

                BB.getTerminator()->eraseFromParent();
                IRBuilder<> builder(&BB);
                builder.CreateBr(succ);
                
                CodeExtractorAnalysisCache CEAC(F);
                Function *OutlineF = CodeExtractor(succ).extractCodeRegion(CEAC);

            } else break;

            /* 
                Erase the llvm.lifetime.start, llvm.lifetime.end global function calls manually 
                by pushing them into a vector and erasing them at the end.
            */

            vector <Instruction*> toErase;
            for (auto &BB : F ){
                for (auto &I: BB){
                    if (auto *CI = dyn_cast<CallInst>(&I)){
                        Function *calledfunc = CI->getCalledFunction();
                        bool found = false;
                        
                        /* 
                            Functions that start with 'llvm.' are intrinsic 
                            these functions also do not have instructions so check for these two conditions
                        */
                        if (calledfunc->isIntrinsic() && calledfunc->getInstructionCount()==0){
                            toErase.push_back(&I);
                        }

                    }
                }
            }

            for (auto I : toErase){
                I->eraseFromParent();
            }        
        }
    }
    return PreservedAnalyses::all();
}

