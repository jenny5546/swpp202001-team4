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
          if (I->getParent()!=Block)
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
        CodeExtractorAnalysisCache CEAC(F);

        // Get Function arguments and save them in a vector
        for (auto *itr = F.arg_begin(), *end = F.arg_end(); itr != end; ++itr)
            funcArgs.push_back(&*itr);
        unsigned regsInFunc = 0;
        unsigned blockCnt = 0;
        for (auto &BB : F) {
            blockCnt++;
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
                       
                }
                if (regsInBlock ==15 && !I.isTerminator()){
                    pointToInsert = &I;
                    point= totalInsts;
                }
                if (regsInBlock >= 15 && !I.isTerminator()){ 
                    splitBlockFlag = true;
                } 
            }

            regsInFunc+=regsInBlock;

            /* [Case 1] Split a single big block into pieces */

            if (splitBlockFlag){
                BasicBlock *succ;
                unsigned countArgs=0;
                bool canSplit = false;
                succ = SplitBlock(&BB, pointToInsert); 
                countArgs = countOutlinedArgs(succ, funcArgs);
                /* Is unsafe to split, outlines to func args with more than 10 args */
                if (countArgs>=15){
                    while(totalInsts-point>3){
                        pointToInsert = pointToInsert->getNextNode();
                        MergeBlockIntoPredecessor(succ);
                        succ = SplitBlock(&BB, pointToInsert); 
                        countArgs = countOutlinedArgs(succ, funcArgs);
                        point++;
                        if (countArgs<15){
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
                    // Function *OutlineF = CodeExtractor(succ).extractCodeRegion(CEAC);
                }
                else{
                }
            }
            /* [Case 2] Split whole blocks if the function uses a lot of regs */
            if (regsInFunc >= 15 && blockCnt>1 && regsInBlock>10 && !splitBlockFlag){ 
                BBs.push_back(&BB);
                if (const InvokeInst *II = dyn_cast<InvokeInst>(BB.getTerminator()))
                    BBs.push_back(II->getUnwindDest());
            }
        }
        for (auto BB : BBs){
            /* Is safe to split */
            if (countOutlinedArgs(BB, funcArgs)<15){
                // CodeExtractorAnalysisCache CEAC(F);
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
                if (countArgs>=15){
                    while(instsInBlock-splitPoint>3){
                        pointToInsert = pointToInsert->getNextNode();
                        MergeBlockIntoPredecessor(succ);
                        succ = SplitBlock(BB, pointToInsert); 
                        countArgs = countOutlinedArgs(succ, funcArgs);
                        splitPoint++;
                        
                        if (countArgs<15){
                            canSplit= true;
                            break;
                        }
                    }
                    
                }
                else{
                    canSplit= true;
                }
                if (canSplit){
                    // CodeExtractorAnalysisCache CEAC(F);
                    Function *OutlineF = CodeExtractor(succ).extractCodeRegion(CEAC);
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