#include "Team4Passes.h"

/*******************************************
 *          Function Outlining Pass
  
 * If a function uses more than 14 registers, 
 * break the block, making sure that the pred
 * block post dominates the succ block, and 
 * replace it into a function call.

********************************************/ 
PreservedAnalyses FunctionOutlinePass::run(Module &M, ModuleAnalysisManager &MAM) {

    /* [Most Simple Case] If a single function with only an entry block uses more than 13 registers, 
    just break into another function. No need to check for post dominance relations */

    for (auto &F : M){
        unsigned countBB = 0;

        for (auto &BB : F){
            countBB++;
        }
        // unsigned countBB = F.size();
        // outs()<<"number of basic blocks" << F.getName() << countBB<<"\n";
        for (auto &BB : F ){

            // outs()<<"Start of Block\n";
            vector<Instruction *> unOutlinedInsts;
            vector<Instruction *> outlinedInsts;
            vector<Value *> dependentRegs;
            bool outLined = false;
            int regs = 0;
            Instruction *pointToInsert; 

            /*  1. Iterate through Basic Block, push instructions to outline, 
            only if the basic block uses more than 14 resistors. */
            for (auto &I : BB){

                /* Registers have names %x = (some instruction).
                Keep track of the number of regs.*/

                if (I.hasName()){ // Regs with name in characters
                    regs ++;   
                }
                if (!I.hasName() && !I.getType()->isVoidTy()){ // Regs that have names like %0, %1.. rename them.
                    I.setName("temp");
                    regs ++;
                }

                if (regs<=13){ // If number of registers exceed 13 in one block, split.
                    unOutlinedInsts.push_back(&I); 
                    
                }
                if (regs ==14){
                    pointToInsert = &I;
                }
                if (regs > 13 && !I.isTerminator()){ // Push back outlined insts to a vector 
                    outLined = true;
                    outlinedInsts.push_back(&I);
                } 

            }

            /*  2. If outline_signal is true, push dependent registers to use as function args */

            if (outLined && countBB==1){

                BasicBlock *succ = BB.splitBasicBlock(pointToInsert, "outline");
                BB.getTerminator()->eraseFromParent();
                IRBuilder<> builder(&BB);
                builder.CreateBr(succ);
                
                CodeExtractorAnalysisCache CEAC(F);
                Function *OutlineF = CodeExtractor(succ).extractCodeRegion(CEAC);

                /* 1. Outline function uses regs from the previous insts. (Dependent!) */
                // for(auto ai = F.arg_begin(), ae = F.arg_end(); ai != ae; ++ai){
                //     if (hasUser(dyn_cast<Value>(ai),outlinedInsts)){
                //         dependentRegs.push_back(ai);
                //     }
                // }
                // /* 2. Outline function uses the func parameters. (Dependent!) */
                // for (auto i : unOutlinedInsts){
                //     if (hasUser(i,outlinedInsts)){
                //         // outs()<<"instr with user"<<i->getName()<<"\n";
                //         dependentRegs.push_back(i);
                //     }
                // }
                /*  3. Create the new outlined function  */
                // vector<Type*> ArgTypes;

                // // Get argument types from the 'dependentRegs'

                // for (auto &r : dependentRegs){
                //     ArgTypes.push_back(r->getType());
                // }
                // FunctionType *FTy = FunctionType::get(F.getFunctionType()->getReturnType(),
                //                         ArgTypes, F.getFunctionType()->isVarArg());

                // string FunctionName = "OUTLINED_FUNCTION";
                // Function *OutlinedF = Function::Create(FTy, F.getLinkage(), F.getAddressSpace(),
                //                         FunctionName, F.getParent());
                
                // Function::arg_iterator args = OutlinedF->arg_begin();

                // for (auto &r : dependentRegs){
                //     args->setName(r->getName());
                //     &*args++; // FIXME: This results in warning: expression result unused [-Wunused-value] 
                // }
                
                /*  4. Now, copy the 'need-to-outline' instructions to the outlined function  */

                // BasicBlock* EntryBlock = BasicBlock::Create(M.getContext(), "entry", OutlinedF);
                // IRBuilder<> builder(EntryBlock);
                // // builder.SetInsertPoint(EntryBlock);
                // builder.CreateRet(0);
                // // verifyFunction(*OutlinedF);
                // // M.dump();
                
                // for (auto &I : outlinedInsts){
                //     Instruction* inst = I->clone();
                //     inst->setName(I->getName());
                //     // outs()<<"cloned instruction: "<<inst->getOperand(0)->getName()<<"\n";
                //     inst->dropAllReferences();
                //     inst->setDebugLoc(DebugLoc());
                //     builder.Insert(inst);
                // }

                /* 5. Add an instruction to call the outlined function */
                // Constant* hook = M.getOrInsertFunction(OutlinedF, FTy);
                //* Print for debugging purposes *// 
                // for (auto &I : outlinedInsts){
                //     outs()<<"outlined instructions"<< I->getName()<<"\n";
                // }
                // for (auto &r : dependentRegs){
                //     outs()<<"depndent registers"<< r->getName()<<"\n";
                // }
                // for(auto ai = OutlinedF->arg_begin(), ae = OutlinedF->arg_end(); ai != ae; ++ai){
                //     outs()<<"copy arguments:"<< ai->getName()<<"\n";
                // }
            }

            // M.getFunctionList().push_back(OutlinedF);
            // outs()<<"size of vec: "<<dependentRegs.size()<<"\n";
            // for (auto &i : outlinedInsts){
            //     outs()<<"Outlined Instructions: "<<i->getName()<<"\n";
            // }

        }
        vector <Instruction*> toErase;
        for (auto &BB : F ){
            for (auto &I: BB){
                if (auto *CI = dyn_cast<CallInst>(&I)){
                    Function *calledfunc = CI->getCalledFunction();
                    bool found = false;
                    // outs() << *CI << "\n";
                    
                    if (calledfunc->isIntrinsic()){
                        toErase.push_back(&I);
                    }

                }
            }
        }
        for (auto I : toErase){
            I->eraseFromParent();
        }        
    }
    return PreservedAnalyses::all();
}


