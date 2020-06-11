#include "Team4Passes.h"
/*
    This pass hoists the Global Variable(GV) Load Instruction I in the loop L to the preheader.
    It reduces cost caused by repetition of GV Load in the loop.
    Before it hoists the load instruction it checks following conditions :
    1. Loop L has prehead where I can be hoisted.
    2. GV is not updated (stored) in the loop L
    3. No other load instruction that loads same GV is already hoisted 
        (if there is one, replace use of I with it)
    
    After hoisting, if GV will be loaded in the prehead block, so use that value without loading it again.

    Lastly, remove all the replaced load instructions.

*/
PreservedAnalyses LICMGVLoadPass::run(Function &F, FunctionAnalysisManager &FAM){
    
    auto &LI = FAM.getResult<LoopAnalysis>(F);

    for(auto &L : LI) {
        BasicBlock *Preheader = L->getLoopPreheader();
        if(!Preheader) continue;
        
        vector<Instruction*> HoistedLoadGVInst;
        vector<Instruction*> RemovableLoadGVInst;

        for(auto *BB1 : L->getBlocks()) {
            for(auto itr = BB1->begin(); itr!=BB1->end();) {
                auto &I = *itr++;
                
                if(auto *LI = dyn_cast<LoadInst>(&I)){
                    if(L->hasLoopInvariantOperands(LI)) {
                        bool updatedinLoop = false;
                        bool canBeReplaced = false;
                        auto *loadedFrom = LI->getOperand(0);
                        auto *GV= dyn_cast<GlobalVariable>(loadedFrom);
                        if(!GV) continue;
                        assert(GV && "Only Global Variables can be hoisted!");
                        
                        // Check if GV is being updated in the same loop.
                        for(auto *BB2 : L->getBlocks()) {
                            for(auto &I2 : *BB2) {
                                if(auto *SI = dyn_cast<StoreInst>(&I2)) {
                                    if(SI->getOperand(1) == loadedFrom) updatedinLoop = true;
                                }
                            }
                        }
                        if(updatedinLoop) continue;
                        assert(!updatedinLoop && "Global Variable is being updated in the Loop!");
                        
                        // Check if same GV load inst is already hoisted.
                        for(auto *hoistedInst : HoistedLoadGVInst) {
                            if(loadedFrom == hoistedInst->getOperand(0)) {
                                canBeReplaced = true;
                                LI->replaceAllUsesWith(hoistedInst);
                                RemovableLoadGVInst.push_back(LI);
                                break;
                            }
                        }
                        if(canBeReplaced) continue;
                        assert(!canBeReplaced && "Same load instruction is already hoisted. Replace with that!");
                        
                        // Hoist GV load instruction LI to the preheader block
                        HoistedLoadGVInst.push_back(LI);
                        Instruction *InsertPtr;
                        InsertPtr = Preheader->getTerminator();
                        LI->moveBefore(InsertPtr);
                    }
                }
            }
        }
        
        // Now if the global variable is stored in the preheader block,
        // Do not load again! Just use that loaded value.
        if(!HoistedLoadGVInst.empty()) {
            for(auto &I : *Preheader) {
                auto *SI = dyn_cast<StoreInst>(&I);
                if(!SI) continue;
                for(auto *hoistedInst : HoistedLoadGVInst) {
                    auto *StoredVal = SI->getOperand(0);
                    auto *StoredIn = SI->getOperand(1);
                    if(StoredIn == hoistedInst->getOperand(0)) {
                        hoistedInst->replaceAllUsesWith(StoredVal);
                        RemovableLoadGVInst.push_back(hoistedInst);
                    }
                }
            }
        }
        
        // Erase all replaced Load Inst.
        for(auto *removableInst : RemovableLoadGVInst) {
            removableInst->eraseFromParent();
        }
    }
    return PreservedAnalyses::all();
}
