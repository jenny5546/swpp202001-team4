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

    /* [Most Simple Case] If a single function with only an entry block uses more than 13 registers, 
    just break into another function. No need to check for post dominance relations */

    for (auto &F : M){
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
                if (regs > 13 && !I.isTerminator()){ // Push back outlined insts to a vector 
                    pointToInsert = &I;
                    outLined = true;
                    outlinedInsts.push_back(&I);
                } 

            }

            /*  2. If outline_signal is true, push dependent registers to use as function args */

            if (outLined){

                /* 1. Outline function uses regs from the previous insts. (Dependent!) */
                for(auto ai = F.arg_begin(), ae = F.arg_end(); ai != ae; ++ai){
                    if (hasUser(dyn_cast<Value>(ai),outlinedInsts)){
                        dependentRegs.push_back(ai);
                    }
                }
                /* 2. Outline function uses the func parameters. (Dependent!) */
                for (auto i : unOutlinedInsts){
                    if (hasUser(i,outlinedInsts)){
                        // outs()<<"instr with user"<<i->getName()<<"\n";
                        dependentRegs.push_back(i);
                    }
                }
                /*  3. Create the new outlined function  */
                vector<Type*> ArgTypes;

                // Get argument types from the 'dependentRegs'

                for (auto &r : dependentRegs){
                    ArgTypes.push_back(r->getType());
                }
                FunctionType *FTy = FunctionType::get(F.getFunctionType()->getReturnType(),
                                        ArgTypes, F.getFunctionType()->isVarArg());

                string FunctionName = "OUTLINED_FUNCTION";
                Function *OutlinedF = Function::Create(FTy, F.getLinkage(), F.getAddressSpace(),
                                        FunctionName, F.getParent());
                
                Function::arg_iterator args = OutlinedF->arg_begin();

                for (auto &r : dependentRegs){
                    args->setName(r->getName());
                    &*args++; // FIXME: This results in warning: expression result unused [-Wunused-value] 
                }
                
                /*  4. Now, copy the 'need-to-outline' instructions to the outlined function  */

                BasicBlock* EntryBlock = BasicBlock::Create(M.getContext(), "entry", OutlinedF);
                IRBuilder<> builder(EntryBlock);
                builder.SetInsertPoint(EntryBlock);
                builder.CreateRet(builder.getInt32(0));
                // verifyFunction(*OutlinedF);
                // M.dump();
                
                for (auto &I : outlinedInsts){
                    Instruction* inst = I->clone();
                    inst->setName(I->getName());
                    // outs()<<"cloned instruction: "<<inst->getOperand(0)->getName()<<"\n";
                    inst->dropAllReferences();
                    inst->setDebugLoc(DebugLoc());
                    builder.Insert(inst);
                }

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