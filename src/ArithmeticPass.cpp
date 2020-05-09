#include "Team4Passes.h"
#include "llvm/Transforms/Utils/BasicBlockUtils.h"
#include "llvm/Transforms/InstCombine/InstCombine.h"

PreservedAnalyses ArithmeticPass::run(Function &F, FunctionAnalysisManager &FAM) {

  DominatorTree &DT = FAM.getResult<DominatorTreeAnalysis>(F);

    for (auto &BB : F) {
      for (auto &I : BB) {
        Value *X, *Y;
        ConstantInt *C;
        ICmpInst::Predicate Pred;
        Instruction *newInst;
        
        // if add (X,X) -> mul(X,2)
        if(match(&I, m_Add(m_Value(X),m_Deferred(X)))){
          newInst = BinaryOperator::Create(Instruction::Mul,I.getOperand(0),ConstantInt::get(I.getOperand(0)->getType(),2));
          ReplaceInstWithInst(&I,newInst);
          //BinaryOperator *BI = dyn_cast<BinaryOperator>(&I);
        }
        // if sub (X,X) -> 0
        else if(match(&I,m_Sub(m_Value(X),m_Deferred(X)))){
          
          
        }
        // if shl (X,Constant) -> X * 2^Constant
        else if(match(&I,m_Shl(m_Value(X),m_ConstantInt(C)))){

        }
        // if shr (X,Constant) -> X * 2^Constant
        else if(match(&I,m_Shr(m_Value(X),m_ConstantInt(C)))){

        }
        // if and (X,Constant) -> urem (X,8)
        else if(1){


        } 
        // %cond = icmp eq(X,Y)
        // br i1 %cond, label %BB1, label %BB2
        // -> 
        // %cond = xor (X,Y)
        // br i1 %cond, label %BB2, label %BB1
        else if(1){

        }
        // constant folding
        else if(1){

        }
        
      }
    }

    return PreservedAnalyses::all();
  }





/*
class ArithmeticPass : public llvm::PassInfoMixin<ArithmeticPass> {

public:
  PreservedAnalyses run(Function &F, FunctionAnalysisManager &FAM) {

    DominatorTree &DT = FAM.getResult<DominatorTreeAnalysis>(F);

    for (auto &BB : F) {
      for (auto &I : BB) {
        Value *X, *Y;
        ConstantInt *C;
        ICmpInst::Predicate Pred;
        Instruction *newInst;
        
        // if add (X,X) -> mul(X,2)
        if(match(&I, m_Add(m_Value(X),m_Deferred(X)))){
          //BinaryOperator *BI = dyn_cast<BinaryOperator>(&I);
          newInst = BinaryOperator::Create(Instruction::Mul,I.getOperand(0),ConstantInt::get(I.getOperand(0)->getType(),2));
          ReplaceInstWithInst(&I,newInst);
          //I.getOpcode.replaceAllUsesWith(m_Mul);
          //Value* RHS = I.getOperand(1);
          //I.replaceAllUsesWith(BinaryOperator::CreateMul(X,ConstantInt::2));
          //ReplaceInstWithValue(I,BinaryOperator::CreateMul(X,ConstantInt::2));

          //newInstCreateMul(X,2);
          //ReplaceInstWithInst(I,BinaryOperator::CreateMul(X,2));
          //X =  BinaryOperator::CreateNeg(2);
          //ReplaceInstWithValue
          //ReplaceInstWithInst(I,)         

        }
        // if sub (X,X) -> 0
        else if(match(&I,m_Sub(m_Value(X),m_Deferred(X)))){
          
        }
        // if shl (X,Constant) -> X * 2^Constant
        else if(match(&I,m_Shl(m_Value(X),m_ConstantInt(C)))){

        }
        // if shr (X,Constant) -> X * 2^Constant
        else if(match(&I,m_Shr(m_Value(X),m_ConstantInt(C)))){

        }
        // if and (X,Constant) -> urem (X,8)
        else if(1){


        } 
        // %cond = icmp eq(X,Y)
        // br i1 %cond, label %BB1, label %BB2
        // -> 
        // %cond = xor (X,Y)
        // br i1 %cond, label %BB2, label %BB1
        else if(1){

        }
        // constant folding
        else if(1){

        }
        
      }
    }

    return PreservedAnalyses::all();
  }
};
*/
