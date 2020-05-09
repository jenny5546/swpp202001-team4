#ifndef TEAM4PASSES_H
#define TEAM4PASSES_H

#include "llvm/IR/PassManager.h"
#include "llvm/Passes/PassBuilder.h"
#include "llvm/Passes/PassPlugin.h"
#include "llvm/IR/IRBuilder.h"
#include "llvm/Support/raw_ostream.h"
#include "llvm/IR/PatternMatch.h"
#include "llvm/IR/Function.h"
#include <string>
#include <vector>

using namespace std;
using namespace llvm;
using namespace llvm::PatternMatch;

/* add following lines

class DoSomethingPass : public llvm::PassInfoMixin<DoSomethingPass> {
public:
    PreservedAnalyses run(Function &F, FunctionAnalysisManager &FAM);
};

*/

/*******************************************
 *          Function Outlining Pass
  
 * If a function uses more than 14 registers, 
 * break the block, making sure that the pred
 * block post dominates the succ block, and 
 * replace it into a function call.

********************************************/ 

class FunctionOutlinePass : public llvm::PassInfoMixin<FunctionOutlinePass> {

    /* Helper function to pass 'depdendent regs' as arguments to the new outlined function */
    //Return true if value I is used in one of the instructions in the vector

    bool hasUser(Value *I, vector<Instruction *> vect){
        for (Use &U : I->uses()) {
            User *Usr = U.getUser();
            Instruction *UsrI = dyn_cast<Instruction>(Usr); 
            if (find(vect.begin(), vect.end(), Usr)!= vect.end()) { 
                return true;
            }
        }
        return false;
    }

public:

  PreservedAnalyses run(Module &M, ModuleAnalysisManager &MAM) {

    vector<Instruction *> unOutlinedInsts;
    vector<Instruction *> outlinedInsts;
    vector<Value *> dependentRegs;
    bool outLined = false;

    /* Case 1. If a single block uses more than 16 registers, just break 
    into another function. No need to check for post dominance relations */

    for (auto &F : M){
        
        for (auto &BB : F ){

            int regs = 0;
            outLined = false;
            // BasicBlock *block = &BB;

            /*  1. Iterate through Basic Block, push instructions to outline, 
            only if the basic block uses more than 14 resistors. */

            for (auto &I : BB){

                /* Registers have names %x = (some instruction).
                Keep track of the number of regs.*/

                if (I.hasName()){
                    // outs()<<I.getName()<<"\n";
                    regs ++;
                    
                }
                if (regs<=13){ // If number of registers exceed 13 in one block, split.
                    unOutlinedInsts.push_back(&I); 
                }
                if (regs > 13 && !I.isTerminator()){ // Push back outlined insts to a vector 
                    outLined = true;
                    outlinedInsts.push_back(&I);
                } 
            }

            /*  2. If outline_signal is true, outline the instructions in to a function call */

            if (outLined){
                for(auto ai = F.arg_begin(), ae = F.arg_end(); ai != ae; ++ai){
                    if (hasUser(dyn_cast<Value>(ai),outlinedInsts)){
  
                        dependentRegs.push_back(ai);
                    }
                }
                for (auto i : unOutlinedInsts){
                    if (hasUser(i,outlinedInsts)){
                        // outs()<<"instr with user"<<i->getName()<<"\n";
                        dependentRegs.push_back(i);
                    }
                }
            }


            // outs()<<"size of vec: "<<dependentRegs.size()<<"\n";
            // for (auto &r : dependentRegs){
            //     outs()<<"dependent regs"<<r->getName()<<"\n";
            // }

        } 
        
        
    }
    

    return PreservedAnalyses::all();
  }
};

#endif

// Function *OutlinedFunction = Function::Create(FunctionType::)
// Instruction *breakpoint = dyn_cast<Instruction>(&I);
// IRBuilder<> Builder(breakpoint);
// Builder.CreateCall()
// Instruction *newInst = new Instruction(...); 
// // Instruction *functionCall = new Instruction();

// BB.getInstList().insertAfter(breakpoint, functionCall);
// 1. Pack leftover instructions, make it an outlined function.
// : Dependent registers should be parameters, check for return values
// 2. Insert function call to the block.
// 3. Remove the instructions in the block.
// 4. Return properly 