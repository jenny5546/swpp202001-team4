#include "Team4Passes.h"
#include "llvm/Analysis/MemorySSA.h"
#include "llvm/Analysis/MemorySSAUpdater.h"

PreservedAnalyses LICMGVLoadPass::run(Function &F, FunctionAnalysisManager &FAM){
    
    auto &LI = FAM.getResult<LoopAnalysis>(F);

    //outs()<<"Function Name : "<<F.getName()<<"\n";
    for(auto &L : LI) {
        //outs()<<"Loop Name : "<<L->getName()<<"\n";
        //outs()<<"Preheader Block : "<<L->getLoopPreheader()->getName()<<"\n";
        BasicBlock *Preheader = L->getLoopPreheader();
        if(!Preheader) continue;
        

        
        for(auto *BB : L->getBlocks()) {
            //outs()<<BB->getName()<<"\n";
            for(auto itr = BB->begin(); itr!=BB->end();) {
                auto &I = *itr++;
                if(auto *LI = dyn_cast<LoadInst>(&I)){
                    if(L->hasLoopInvariantOperands(LI)) {
                        bool updatedinLoop = false;
                        auto *LoadedValue = LI->getOperand(0);
                        auto *GV= dyn_cast<GlobalVariable>(LoadedValue);
                        if(!GV) continue;
                        for(auto *BB2 : L->getBlocks()) {
                            for(auto &I2 : *BB2) {
                                if(auto *SI = dyn_cast<StoreInst>(&I2)) {
                                    if(SI->getOperand(1) == LoadedValue) updatedinLoop = true;
                                }
                            }
                        }
                        if(updatedinLoop) continue;
                        outs()<<"Function Name : "<<F.getName()<<"\n";
                        outs()<<I<<"\n";
                        outs()<<"Can hoist!\n";
                        Instruction *InsertPtr;
                        InsertPtr = Preheader->getTerminator();
                        LI->moveBefore(InsertPtr);
                        // load하는 global이 같으면 없애기. replaceAllUses하기.
                        //outs()<<"Moved\n";
                        //MemorySSAUpdater *MSSAU;
                        //if(auto *MUD = MSSAU->getMemorySSA()->getMemoryAccess(&I)){
                        //    MSSAU->moveToPlace(MUD, InsertPtr->getParent(), MemorySSA::BeforeTerminator);
                        //}

                    }
                }
            }
        }
    }
    return PreservedAnalyses::all();
}
