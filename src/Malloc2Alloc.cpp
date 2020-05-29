#include "Team4Passes.h"
#define MAXSIZE 2048

  // find all malloc call instructions in the function and check if they satisfy the condition
  // Condition 1. allocated size should be Constant. no dynamic allocation.
  // Condition 2. Size should be lower than 2048
  void  Malloc2AllocPass::findPossibleMallocs(Function &F, vector<Instruction*> &PossibleMallocs) {
    for(auto &BB : F) {
      for(auto &I : BB) {
        // check if the instruction I is malloc call instruction
        auto *CI = dyn_cast<CallInst>(&I);
        if(CI && (CI->getCalledFunction()->getName() == "malloc")) {
          ConstantInt *MallocSize = dyn_cast<ConstantInt>(CI->getArgOperand(0));
          // check if the size of malloc-ed block is constant && smaller than 2048.
          if(MallocSize && MallocSize->getZExtValue() <= MAXSIZE) {
            assert(MallocSize && "malloc instruction does not have constant argument : dynamic allocation!");
            assert(MallocSize->getZExtValue() <= MAXSIZE && "malloc allocates more than 2048 bytes!");
            PossibleMallocs.push_back(CI);
          }
        }
      }
    }
  }

  // Find malloc call instruction among PossibleMallocs that can be replaced with alloc.
  // If malloc is freed in every path to the exit block, that malloc is replaceable.
  void  Malloc2AllocPass::findReplaceableMallocs(Function &F, FunctionAnalysisManager &FAM, vector<Instruction*> &PossibleMallocs, 
  vector<Instruction*> &ReplaceableMallocs, vector<Instruction*> &RemovableFrees) {
      auto &TLI = FAM.getResult<TargetLibraryAnalysis>(F);
      auto &DL = F.getParent()->getDataLayout();

      for(auto &I : PossibleMallocs) {
        bool IsReplaceable = false;
        BasicBlock *Parent = I->getParent();
        // First, check if malloc I is freed in the same block
        for(auto &J : (*Parent)) {
          if(isFreeCall(&J,&TLI) && (GetUnderlyingObject(J.getOperand(0),DL) == I)){
            RemovableFrees.push_back(&J);
            ReplaceableMallocs.push_back(I);
            IsReplaceable = true;
            break;
          }
        }
        if(IsReplaceable || (Parent->getTerminator()->getNumSuccessors() == 0)) continue;

        // Now, we know that malloc is not freed in the same block. Check if malloc is being freed in successor blocks.
        // Use DFS-like method to find go over all path to the exit block.
        // If it is freed in every path to the exit block, malloc is replaceable. If not, it is not replaceable.
        vector<pair<BasicBlock*,vector<Instruction*>>> DFSStack;
        for(auto SuccBB : successors(Parent)) {
          vector<Instruction*> MallocPtrs;
          MallocPtrs.push_back(I);
          // Store malloc pointers transferred by PHINodes.
          for(auto J = SuccBB->begin(); J != BasicBlock::iterator(SuccBB->getFirstNonPHI()); J++) {
            auto *PHI = dyn_cast<PHINode>(J);
            if(PHI->getBasicBlockIndex(Parent) >= 0 && GetUnderlyingObject(PHI->getIncomingValueForBlock(Parent),DL) == I) {
                MallocPtrs.push_back(PHI);
            }
          }
          DFSStack.push_back(make_pair(SuccBB, MallocPtrs));
        }

        pair<BasicBlock*,vector<Instruction*>> StackElem;
        vector<BasicBlock*> Visited;
        IsReplaceable = true;
        vector<Instruction*> temp_RemovableFrees;
        // Begin DFS-like visiting method
        while(!DFSStack.empty()) {
          bool IsFreed = false;
          StackElem = DFSStack.back(); 
          DFSStack.pop_back();
          Visited.push_back(StackElem.first);
          for(auto &J : *(StackElem.first) ){
            if(isFreeCall(&J,&TLI)) {
              auto *FreePtr = GetUnderlyingObject(J.getOperand(0),DL);
              if(find(StackElem.second.begin(),StackElem.second.end(),FreePtr) != StackElem.second.end()) {
                // Malloc is freed in this particular path. No more need to observe through the path.
                temp_RemovableFrees.push_back(&J);
                IsFreed = true;
                break;
              }
            }            
          }
          if(IsFreed) continue;
          // Malloc is not yet freed. Check next successors.
          bool HasUnvisitedSucc = false;
          for(auto SuccBB : successors(StackElem.first)) {
            if(find(Visited.begin(),Visited.end(),SuccBB) != Visited.end()) {
              // This block is already visited, thus already checked. No need to observe through it.
              continue;
            } 
            // This block is not yet visited. Needs to be checked. Push into DFSStack after updating Malloc pointers.
            HasUnvisitedSucc = true;
            vector<Instruction*> MallocPtrs;
            MallocPtrs.push_back(I);
            for(auto J = SuccBB->begin(); J != BasicBlock::iterator(SuccBB->getFirstNonPHI()); J++) {
              auto *PHI = dyn_cast<PHINode>(J);
              if(PHI->getBasicBlockIndex(Parent) >= 0 && GetUnderlyingObject(PHI->getIncomingValueForBlock(Parent),DL) == I) {
                  MallocPtrs.push_back(PHI);
              }
            }
            DFSStack.push_back(make_pair(SuccBB, MallocPtrs));
          }
          if(!HasUnvisitedSucc) {
            // All successors are already visited or it is exit block.
            if(StackElem.first->getTerminator()->getNumSuccessors() == 0) {
              IsReplaceable = false;
              break;
            }
          }
        }
        // Now, search is finished. If malloc is replaceable, push it into ReplaceableMallocs. If not, dont'.
        if(IsReplaceable) {
          // Malloc Inst I is freed in all paths.
          for(auto *J : temp_RemovableFrees)
            if(find(RemovableFrees.begin(), RemovableFrees.end(), J) == RemovableFrees.end())
              RemovableFrees.push_back(J);
          ReplaceableMallocs.push_back(I);
        }
    }
  }

  void  Malloc2AllocPass::replaceMallocwithAlloc(Function &F, FunctionAnalysisManager &FAM, vector<Instruction*> 
  &ReplaceableMallocs, vector<Instruction*> &RemovableFrees) {
      LLVMContext &Context = F.getContext();
      IRBuilder<> IB(Context);
      auto &TLI = FAM.getResult<TargetLibraryAnalysis>(F);
      auto &DL = F.getParent()->getDataLayout();
      // Remove free call instructions
      for(auto &I : RemovableFrees) {
          I->eraseFromParent();
      }
      // Replace malloc call instructions with alloc instructions
      for(Instruction *I : ReplaceableMallocs) {
          auto *CI = dyn_cast<CallInst>(I);
          auto *MallocType = (getMallocAllocatedType(CI, &TLI));
          //if (!MallocType) continue;
          Value *MallocSize = getMallocArraySize(CI, DL, &TLI, true);
          IB.SetInsertPoint(dyn_cast<Instruction>(F.getEntryBlock().getFirstInsertionPt()));
          auto InstType = CI->getType();
          Value *Alloca = IB.CreateBitCast(IB.CreateAlloca(MallocType, MallocSize),InstType);
          Alloca->takeName(CI);
          CI->replaceAllUsesWith(Alloca);
          CI->eraseFromParent();
    }
  }

  PreservedAnalyses Malloc2AllocPass::run(Function &F, FunctionAnalysisManager &FAM) {

    vector<Instruction*> PossibleMallocs;
    vector<Instruction*> ReplaceableMallocs;
    vector<Instruction*> RemovableFrees;
    //outs()<<"Function : "<<F.getName()<<"\n";
    findPossibleMallocs(F, PossibleMallocs);
    findReplaceableMallocs(F,FAM,PossibleMallocs,ReplaceableMallocs,RemovableFrees);
    //for(auto I : ReplaceableMallocs) outs()<<"Replaceable malloc : "<<*I<<"\n";
    //for(auto I : RemovableFrees) outs()<<"Removable free : "<<*I<<"\n";
    replaceMallocwithAlloc(F, FAM, ReplaceableMallocs,RemovableFrees);
    //outs()<<"Replaced!\n";
    return PreservedAnalyses::all();
  }