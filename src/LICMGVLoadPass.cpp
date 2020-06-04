#include "Team4Passes.h"

PreservedAnalyses LICMGVLoadPass::run(Function &F, FunctionAnalysisManager &FAM){
    
    auto &LI = FAM.getResult<LoopAnalysis>(F);

    for(auto &L : LI) {
        BasicBlock *Preheader = L->getLoopPreheader();
        if(!Preheader) continue;
        
        vector<Instruction*> HoistedLoadGVInst;
        vector<Instruction*> RemovableLoadGVInst;

        for(auto *BB : L->getBlocks()) {
            for(auto itr = BB->begin(); itr!=BB->end();) {
                auto &I = *itr++;
                
                if(auto *LI = dyn_cast<LoadInst>(&I)){
                    if(L->hasLoopInvariantOperands(LI)) {
                        bool updatedinLoop = false;
                        bool CanBeReplaced = false;
                        auto *LoadedFrom = LI->getOperand(0);
                        auto *GV= dyn_cast<GlobalVariable>(LoadedFrom);
                        if(!GV) continue;
                        assert(GV && "Only Global Variables can be hoisted!");
                        for(auto *BB2 : L->getBlocks()) {
                            for(auto &I2 : *BB2) {
                                if(auto *SI = dyn_cast<StoreInst>(&I2)) {
                                    if(SI->getOperand(1) == LoadedFrom) updatedinLoop = true;
                                }
                            }
                        }
                        if(updatedinLoop) continue;
                        assert(!updatedinLoop && "Global Variable is being updated in the Loop!");
                        
                        for(auto *J : HoistedLoadGVInst) {
                            if(LoadedFrom == J->getOperand(0)) {
                                CanBeReplaced = true;
                                LI->replaceAllUsesWith(J);
                                RemovableLoadGVInst.push_back(LI);
                                break;
                            }
                        }
                        if(CanBeReplaced) continue;
                        assert(!CanBeReplaced && "Same load instruction is already hoisted. Replace with that!");
                        
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
        // Erase the load GV inst
        if(!HoistedLoadGVInst.empty()) {
            for(auto &I : *Preheader) {
                auto *SI = dyn_cast<StoreInst>(&I);
                if(!SI) continue;
                for(auto *J : HoistedLoadGVInst) {
                    auto *StoredVal = dyn_cast<Instruction>(SI->getOperand(0));
                    if(!StoredVal) continue;
                    auto *StoredIn = SI->getOperand(1);
                    if(StoredIn == J->getOperand(0)) {
                        J->replaceAllUsesWith(StoredVal);
                        RemovableLoadGVInst.push_back(J);
                    }
                }
            }
        }
        for(auto *J : RemovableLoadGVInst) {
            J->eraseFromParent();
        }
    }
    return PreservedAnalyses::all();
}
