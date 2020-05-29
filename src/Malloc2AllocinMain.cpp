#include "Team4Passes.h"
/*
  This pass converts the malloc instruction in main function to alloca instruction.
  
  Assumption:
  1. Main function will not be called recursively.
  2. Pointer in 'main' is transferred to other function in only 2 ways.
    a) through global variables
    b) through argument of call to function.
  
  It converts all malloc inst in main function to alloca (heap -> stack) and replace all uses.
  (using Malloc2AllocPass)
  It tracks the use of malloc-ed pointer in other functions and if it is freed, remove that free inst.
  
  ** Malloc2AllocPass and GVNPass must be run before this pass to 
  be guaranteed that all unnecessary store/load is gone.
*/
#define MAXSIZE 2048

PreservedAnalyses Malloc2AllocinMainPass::run(Module &M, ModuleAnalysisManager &MAM){
  auto M2APass = Malloc2AllocPass();
  vector<Instruction*> ReplaceableMallocs;
  vector<pair<Instruction*, vector<Value*>>> ReplaceableMallocsandStoredAddr;
  vector<Instruction*> ShouldbeRemovedFrees;

  FunctionAnalysisManager &FAM = MAM.getResult<FunctionAnalysisManagerModuleProxy>(M).getManager();
  
  for (auto &F : M) {
    if (F.getName() == "main") {
      auto &TLI = FAM.getResult<TargetLibraryAnalysis>(F);
      auto &LI = FAM.getResult<LoopAnalysis>(F);
      auto &DL = F.getParent()->getDataLayout();

      // Stage 1 : find Malloc inst in main function and store in ReplaceableMallocs
      M2APass.findPossibleMallocs(F, ReplaceableMallocs, MAXSIZE);
      
      // Stage 2 : find store inst that stores pointer of malloc-ed memory.
      // (This is necessary to track the pointer and remove free inst in other func)
      for(auto *MI : ReplaceableMallocs) {
        // find all addresses where malloc-ed pointer is stored. 
        // put them in StoredAddrs
        vector<Value*> StoredAddrs;
        for (auto &BB : F){
          for (auto &J : BB) {
            if(auto *SI = dyn_cast<StoreInst>(&J)){
              bool StoresMalloc = false;
              Value *StoredData = SI->getOperand(0);
              SmallVector<const Value *, 4> PointerTrack;
              GetUnderlyingObjects(StoredData, PointerTrack, DL, &LI);
              for(auto *A : PointerTrack){
                if(dyn_cast<Instruction>(A) && MI == dyn_cast<Instruction>(A)) {
                  StoresMalloc = true;
                  break;
                }
              }
              if(!StoresMalloc) continue;
              auto *StoredAddr = SI->getOperand(1);
              StoredAddrs.push_back(StoredAddr);
            }
          }
        }
        ReplaceableMallocsandStoredAddr.push_back(make_pair(MI,StoredAddrs));
      }

      // Stage 3 : Track malloc-ed pointer to find corresponding free inst.
      // 2 ways : i) passed by argument ii) stored in global var
      // Store corresponding free inst in ShouldbeRemovedFrees
      for(auto P : ReplaceableMallocsandStoredAddr) {
        // i) Check if pointer is passed through by argument. Store it in PassedMallocPtrbyArg(funcName,ArgNo)
        vector<pair<Function*,unsigned int>> PassedMallocPtrbyArg;
        for(auto &BB : F) {
          for(auto &I : BB) {
            if(auto *CI = dyn_cast<CallInst>(&I)) {
              for(unsigned int i = 0; i < CI->getNumArgOperands(); i++) {
                bool PassedbyArg = false;
                SmallVector<const Value *, 4> PointerTrack;
                GetUnderlyingObjects(CI->getArgOperand(i), PointerTrack, DL, &LI);
                for(auto *A : PointerTrack){
                  auto * UnderlyingI = dyn_cast<Instruction>(A);
                  if(UnderlyingI && UnderlyingI == P.first) {
                    PassedbyArg = true;
                    break;
                  }
                }
                if(PassedbyArg) {
                  //found arg of malloc-ed ptr
                  PassedMallocPtrbyArg.push_back(make_pair(CI->getCalledFunction(),i));
                }
              }
            }
          }
        }
        for(auto &CheckFunc : M) {
          if(CheckFunc.empty()) continue;
          // ii) Check if pointer is passed through by global var. Store it in LoadedMalloc
          auto &TLI2 = FAM.getResult<TargetLibraryAnalysis>(CheckFunc);
          auto &LI2 = FAM.getResult<LoopAnalysis>(CheckFunc);
          auto &DL2 = CheckFunc.getParent()->getDataLayout();
          vector<Instruction *> LoadedMalloc;
          for(auto &BB : CheckFunc){
            for(auto &I : BB) {
              auto *LI = dyn_cast<LoadInst>(&I);
              if(LI && find(P.second.begin(),P.second.end(),LI->getOperand(0))!=P.second.end()){
                //found use of malloc-ed ptr
                LoadedMalloc.push_back(LI);
              }
            }
          }
          // iii) Now check if there is free inst that frees pointers passed by PassedMAllocPtrbyArg or LoadedMalloc
          for(auto &BB : CheckFunc) {
            for(auto &I : BB) {
              bool FreesMalloc = false;
              if(isFreeCall(&I,&TLI2)) {
                SmallVector<const Value *, 4> PointerTrack;  
                GetUnderlyingObjects(I.getOperand(0),PointerTrack,DL2,&LI2);
                for(auto *A : PointerTrack){
                  auto *UnderlyingI = dyn_cast<Instruction>(A);
                  if(UnderlyingI && find(LoadedMalloc.begin(),LoadedMalloc.end(),UnderlyingI)!=LoadedMalloc.end()) {
                    FreesMalloc = true;
                    break;
                  }
                  auto *UnderlyingArg = dyn_cast<Argument>(A);
                  if(!UnderlyingArg) continue; 
                  for(auto &PA : PassedMallocPtrbyArg) {
                    if(PA.first != &CheckFunc) continue;
                    if(PA.second == UnderlyingArg->getArgNo()) {
                      FreesMalloc = true;
                      break;
                    }
                  }
                }
              }
              if(FreesMalloc) ShouldbeRemovedFrees.push_back(&I);
            }
          }
        }
      }
      // Stage 4 : replace malloc with alloca and remove corresponding frees.
      M2APass.replaceMallocwithAlloc(F,FAM,ReplaceableMallocs,ShouldbeRemovedFrees);
    }
  }
  return PreservedAnalyses::all();
}