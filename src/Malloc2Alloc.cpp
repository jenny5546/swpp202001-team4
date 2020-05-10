#include "Team4Passes.h"
#include "llvm/Analysis/MemoryBuiltins.h"
#include "llvm/Analysis/TargetLibraryInfo.h"
#include "llvm/IR/DataLayout.h"
#include "llvm/Pass.h"
#include "llvm/PassAnalysisSupport.h"
#include "llvm/Analysis/ValueTracking.h"
#include "llvm/ADT/SmallPtrSet.h"
#include "llvm/ADT/SmallVector.h"
#include "llvm/IR/Constants.h"


  uint64_t MAXSIZE = 2048;

  // find all malloc call instructions in the function and check if they satisfy the condition
  // Condition 1. Size should be lower than 2048
  void  Malloc2AllocPass::findPossibleMallocs(Function &F, vector<Instruction*> &PossibleMallocs) {
    for(auto &BB : F) {
      for(auto &I : BB) {
        // check if the instruction I is malloc call instruction
        auto *CI = dyn_cast<CallInst>(&I);
        if(CI && (CI->getCalledFunction()->getName() == "malloc")) {
          ConstantInt *MallocSize = dyn_cast<ConstantInt>(CI->getArgOperand(0));
          // check if the size of malloc-ed block is smaller than 2048.
          if((*MallocSize).getZExtValue() <= MAXSIZE) {
            PossibleMallocs.push_back(CI);
          }
        }
      }
    }
  }

  // Find malloc call instruction among PossibleMallocs that can be replaced with alloc.
  // If free instruction is in the successor block && it frees the same pointer allocated by malloc,
  // that malloc is replaceable.
  void  Malloc2AllocPass::findReplaceableMallocs(Function &F, vector<Instruction*> &PossibleMallocs, vector<Instruction*> &ReplaceableMallocs, vector<Instruction*> &RemovableFrees) {

      auto &DL = F.getParent()->getDataLayout();

      for(auto &I : PossibleMallocs) {
        BasicBlock *Parent = I->getParent();
        //outs()<<"Checking Instruction : "<< *I << " in block ( "<<Parent->getName()<<" ) \n";

        // find the basic blocks that are reachable from the Parent and store them in 'reachables'
        std::vector<BasicBlock*> reachables;
        std::vector<BasicBlock*> blockQueue;
        blockQueue.push_back(Parent);

        while (!blockQueue.empty()) {
            BasicBlock *block = blockQueue.front();
            blockQueue.erase(blockQueue.begin());
            std::string blockName = block->getName();
            if (std::find(reachables.begin(), reachables.end(), block) != reachables.end())
                continue;
            reachables.push_back(block);

            unsigned successorCnt = block->getTerminator()->getNumSuccessors();
            for (unsigned i = 0; i < successorCnt; i++)
                blockQueue.push_back(block->getTerminator()->getSuccessor(i));
        }
      
        for(auto *BB : reachables) {
            for(auto &J : (*BB)) {
                auto *CI = dyn_cast<CallInst>(&J);
                // Check if CI is free call instruction.
                if(CI && (CI->getCalledFunction()->getName() == "free")) {
                    //outs()<<"found free call instruction : "<<*CI<<"\n";
                    SmallPtrSet<Instruction *, 4> MallocCalls;
                    MallocCalls.insert(I);
                    auto *freeptr = GetUnderlyingObject(CI->getOperand(0),DL);
                    //outs() << "Getunderlyingobject gets : " << *freeptr<<"\n";
                    // Check if pointer freed by Fre inst CI points to the same block allocated by Malloc inst I.
                    if(MallocCalls.count(cast<Instruction>(freeptr))) {
                        //outs()<<*I<< " is freed by "<<*CI<<"\n";
                        ReplaceableMallocs.push_back(I);
                        RemovableFrees.push_back(CI);
                    }
                }
            }
        }
    }
  }

  void  Malloc2AllocPass::replaceMallocwithAlloc(Function &F, FunctionAnalysisManager &FAM, vector<Instruction*> &ReplaceableMallocs, vector<Instruction*> &RemovableFrees) {
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
          Type *MallocType = getMallocAllocatedType(CI, &TLI);
          Value *MallocSize = getMallocArraySize(CI, DL, &TLI, true);
          //outs()<<"MallocType : "<<*MallocType<<"\nMallocSize : "<<*MallocSize<<"\n";
          IB.SetInsertPoint(CI);
          //Value *Alloca = IB.CreateBitCast(IB.CreateAlloca(MallocType, MallocSize),CI->getType());
          Value *Alloca = IB.CreateAlloca(MallocType, MallocSize);
          Alloca->takeName(CI);
          CI->replaceAllUsesWith(Alloca);
          CI->eraseFromParent();
    }
  }

  PreservedAnalyses Malloc2AllocPass::run(Function &F, FunctionAnalysisManager &FAM) {

    vector<Instruction*> PossibleMallocs;
    vector<Instruction*> ReplaceableMallocs;
    vector<Instruction*> RemovableFrees;
    
    //outs()<<"start Malloc2Alloc Pass\n";
    findPossibleMallocs(F, PossibleMallocs);
    /*outs()<<PossibleMallocs.size()<<"\n";
    for(auto *I : PossibleMallocs) {
        outs()<<"Malloc : "<<*I<<"\n";
    }*/

    findReplaceableMallocs(F,PossibleMallocs,ReplaceableMallocs,RemovableFrees);
    //outs()<<ReplaceableMallocs.size()<<"\n";
    /*for(auto *I : ReplaceableMallocs) {
        outs()<<"Replace Malloc : "<<*I<<"\n";
    }
    //outs()<<RemovableFrees.size()<<"\n";
    for(auto *I : RemovableFrees) {
        outs()<<"Remove Free : "<<*I<<"\n";
    }*/

    replaceMallocwithAlloc(F, FAM, ReplaceableMallocs,RemovableFrees);

    return PreservedAnalyses::all();
  }

