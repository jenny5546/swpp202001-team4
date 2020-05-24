#include "Team4Passes.h"

/*******************************************
 *          Function Outlining Pass
  
 * If a basic block uses more than 14 registers, 
 * break the block, making sure that the pred
 * block post dominates the succ block, and 
 * replace it into a function call.

********************************************/ 

bool FunctionOutlinePass::isOutlinedArgs(const BasicBlock *Block, Value *V) {
      
      if (isa<Argument>(V)) return true;
      if (Instruction *I = dyn_cast<Instruction>(V))
          if (I->getParent()->getName()!=Block->getName())
          return true;
      return false;

}
unsigned FunctionOutlinePass::countOutlinedArgs(BasicBlock *Block, vector<Value *> funcArgs) {
      
      unsigned countArgs=0;
      for (Instruction &II : *Block){    
          for (auto &OI : II.operands()){
              Value *V = OI;
              if (isOutlinedArgs(Block,V)) {
                  countArgs++;
              }
              if(find(funcArgs.begin(), funcArgs.end(), V) != funcArgs.end()){
                  countArgs++;
              }
          }
      }
      return countArgs;
}

PreservedAnalyses FunctionOutlinePass::run(Module &M, ModuleAnalysisManager &MAM) {

    for (auto &F : M) {

        SmallVector<BasicBlock *, 16> BBs;
        vector<Value *> funcArgs;

        // Get Function arguments and save them in a vector
        for (auto *itr = F.arg_begin(), *end = F.arg_end(); itr != end; ++itr)
            funcArgs.push_back(&*itr);
        unsigned regsInFunc = 0;
        unsigned numOfBlocks = 0;
        for (auto &BB : F) {
            numOfBlocks++;
        }
        for (auto &BB : F ) {
            bool splitBlockFlag = false;
            unsigned regsInBlock = 0;
            unsigned instInBlock = 0;
            unsigned totalInsts = 0;
            Instruction *pointToInsert;
            unsigned point;
            
            for (auto &I : BB){
                /* 
                    Registers have names %x = (some instruction).
                    Keep track of the number of regs.
                */
                totalInsts++;
                //  Count regs with name in characters & regs that have names like %0, %1...
                if (I.hasName() || !I.hasName() && !I.getType()->isVoidTy()) { 
                    regsInBlock ++; 
                    regsInFunc++;    
                }
                if (regsInBlock ==14){
                    pointToInsert = &I;
                    point= totalInsts;
                }
                if (regsInBlock > 13 && !I.isTerminator()){ 
                    splitBlockFlag = true;
                } 
            }
            /* [Case 1] Split a single big block into pieces */

            if (splitBlockFlag){

                BasicBlock *succ;
                unsigned countArgs=0;
                bool canSplit = false;
                outs()<<point<<"\n";
                succ = SplitBlock(&BB, pointToInsert); 
                countArgs = countOutlinedArgs(succ, funcArgs);
                
                /* Is unsafe to split, outlines to func args with more than 10 args */

                if (countArgs>=11){
                    outs()<<"count is "<<countArgs<<"\n";

                    while(totalInsts-point>3){

                        pointToInsert = pointToInsert->getNextNode();
                        MergeBlockIntoPredecessor(succ);
                        succ = SplitBlock(&BB, pointToInsert); 
                        countArgs = countOutlinedArgs(succ, funcArgs);
                        point++;
                        outs()<<"(inside loop) count is "<<countArgs<<"\n";
                        if (countArgs<11){
                            outs()<<"split\n";
                            canSplit= true;
                            break;
                        }
                    }
                    
                }
                /* Is safe to split */
                else{
                    canSplit= true;
                }
                if (canSplit){
                    CodeExtractorAnalysisCache CEAC(F);
                    Function *OutlineF = CodeExtractor(succ).extractCodeRegion(CEAC);
                    outs()<<"Splitting 완료\n";
                }
                else{
                    outs()<<"This block cannot be outlined\n";
                }
            }
            /* [Case 2] Split whole blocks if the function uses a lot of regs */
            if (regsInFunc > 13 && numOfBlocks>1 && regsInBlock>3 && !splitBlockFlag){ 
                BBs.push_back(&BB);
                if (const InvokeInst *II = dyn_cast<InvokeInst>(BB.getTerminator()))
                    BBs.push_back(II->getUnwindDest());
            }
        }
        for (auto BB : BBs){
            /* Is safe to split */
            if (countOutlinedArgs(BB, funcArgs)<=10){
                CodeExtractorAnalysisCache CEAC(F);
                CodeExtractor(BB).extractCodeRegion(CEAC);
            }
            /* Is unsafe to split, outlines to func args with more than 10 args */
            else {
                unsigned instsInBlock;
                unsigned splitPoint=1;
                Instruction *pointToInsert;
                unsigned countArgs=0;
                for (auto &I : *BB){
                    instsInBlock++;
                }
                // Get First instruction of the block
                for (auto &I : *BB){
                    pointToInsert = &I;
                    break;
                }
                BasicBlock *succ= SplitBlock(BB, pointToInsert); 
                countArgs = countOutlinedArgs(succ, funcArgs);
                bool canSplit = false;
                /* Find split the block to another block, so that 
                the outlined func does not exceed 10 func args */
                if (countArgs>=11){
                    outs()<<"count is "<<countArgs<<"\n";

                    while(instsInBlock-splitPoint>3){

                        pointToInsert = pointToInsert->getNextNode();
                        MergeBlockIntoPredecessor(succ);
                        succ = SplitBlock(BB, pointToInsert); 
                        countArgs = countOutlinedArgs(succ, funcArgs);
                        splitPoint++;
                        outs()<<"(inside loop) count is "<<countArgs<<"\n";
                        if (countArgs<11){
                            outs()<<"split\n";
                            canSplit= true;
                            break;
                        }
                    }
                    
                }
                else{
                    canSplit= true;
                }

                if (canSplit){
                    CodeExtractorAnalysisCache CEAC(F);
                    Function *OutlineF = CodeExtractor(succ).extractCodeRegion(CEAC);
                    outs()<<"Splitting 완료\n";
                }
                else{
                    outs()<<"This block cannot be outlined\n";
                }
            }
        }
        vector <Instruction*> callInstsToErase;
        /* 
            Erase the llvm.lifetime.start, llvm.lifetime.end global function calls manually 
            by pushing them into a vector and erasing them at the end.
        */
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
                        callInstsToErase.push_back(&I);
                    }
                }
            }
        }
        /* 
            Erase calls to functions that do nothing (funcs that ret 0 and terminate)
            This will reduce the costs of calling these useless functions.
        */
        for (auto &BB : F) {
            for (auto &I: BB){
                if (auto *CI = dyn_cast<CallInst>(&I)){
                    Function *calledfunc = CI->getCalledFunction();
                    bool isOutlinedFunc = false;
                    for (auto &b : *calledfunc){
                        if (b.getName()=="newFuncRoot"){
                            isOutlinedFunc = true;
                            break;
                        }
                    }
                    if (isOutlinedFunc && !CI->hasName()){
                        bool somethingElse = false;
                        for (auto &block : *calledfunc){
                            for (auto &inst: block){
                                if (!inst.isTerminator()){
                                    somethingElse=true;
                                }
                            }
                        }
                        if (!somethingElse){
                            outs()<<calledfunc->getName()<<"\n";
                            callInstsToErase.push_back(&I);
                        }
                    }
                }
            }
        }   
        for (auto I : callInstsToErase){
            I->eraseFromParent();
        }    
    }

    return PreservedAnalyses::all();
}
