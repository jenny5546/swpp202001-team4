#include "Team4Passes.h"

/*******************************************
 *          Arithmetic Pass
  
 * Propagates integer equality,
 * and replace add/sub/shl/shr/logical 
 * instructions to mul/div instructions 
 * for particular cases
********************************************/ 

PreservedAnalyses ArithmeticPass::run(Function &F, FunctionAnalysisManager &FAM) {
  // make vectors for each pattern to replace 
  Value *X, *Y;
  DominatorTree &DT = FAM.getResult<DominatorTreeAnalysis>(F);
  ICmpInst::Predicate P1;
  for (auto &BB : F) {
  for (auto &I : BB) {
    // do integer equality propagation here
    if(match(&I,m_ICmp(P1,m_Value(X),m_Value(Y))) && P1 == ICmpInst::ICMP_EQ){

      /* Do not optimize if it is comparing pointer values */
      if (X->getType()->isPointerTy() || Y->getType()->isPointerTy())
          continue;

      Value *Replacement, *Victim;
      Instruction *XI = dyn_cast<Instruction>(X);
      Instruction *YI = dyn_cast<Instruction>(Y);
      Argument *XA = dyn_cast<Argument>(X);
      Argument *YA = dyn_cast<Argument>(Y);
      ConstantInt *XC = dyn_cast<ConstantInt>(X);
      ConstantInt *YC = dyn_cast<ConstantInt>(Y);

      // cost : ConstantInt < Arg < Inst
      if(XC && !YC){ /* 1) X is a constant, Y is not */
        Replacement = X;
        Victim = Y;
      } else if (!XC && YC){ /* 2) Y is a constant, X is not */
        Replacement = Y;
        Victim = X;
      } else if (!XC && !YC){ /* 3) Both X and Y are not constants */
        if(XA && !YA){ /* 3-1) X is an argument and Y is not */
          Replacement = X;
          Victim = Y;
        } else if(!XA && YA){ /* 3-2) Y is an argument and X is not */
          Replacement = Y;
          Victim = X;
        } else{ /* 3-3) Both X and Y are arguments or both X and Y are instructions */
          Replacement = X;
          Victim = Y;
        }
      } else{ /* 4) X and Y are both constants */
        continue;
      }

      /* Search for conditional-branch uses of icmp eq value, and replace every *
        * uses of Victim value that is dominated by conditionally "true" edge    */
      for (auto &U : I.uses()) {
        /* Get instruction instance */
        User *Usr = U.getUser();
        Instruction *UsrI = dyn_cast<Instruction>(Usr);

        /* Check if this instruction is conditional branch */
        BranchInst *brI;
        if (!UsrI)                                    /* Not an instruction */
          continue;
        else if (!UsrI->isTerminator())               /* Not a terminating instruction */
          continue;                                    
        else if (!(brI = dyn_cast<BranchInst>(UsrI))) /* Not a branching instruction */
          continue;
        else if (!brI->isConditional())                /* Not a conditional branch */
          continue;

        /* Create "contional true" edge instance */
        BasicBlock *Parent = UsrI->getParent();
        BasicBlock *TrueSuccessor = UsrI->getSuccessor(0);
        BasicBlockEdge TrueEdge(Parent, TrueSuccessor);

        /* Search for every usage of Victim value, and if it is dominated *
         * by "true" edge, replace with Replacement                       */
        for (auto itr = Victim->use_begin(), 
                  end = Victim->use_end(); itr != end;) {
          /* Get instruction instance */
          Use &U = *itr++;
          User *Usr = U.getUser();
          Instruction *UsrI = dyn_cast<Instruction>(Usr);

          /* Not an instruction instance (ignore) */
          if (!UsrI) 
            continue;

          /* Replace if dominated by "true" edge */
          if (DT.dominates(TrueEdge, U))
            U.set(Replacement);
        }
      }
    }
  }
  }

  Value *A, *B;
  ConstantInt *C;
  ICmpInst::Predicate P2;
  vector<Instruction *> instsofAdd, instsofSub, instsofShl, instsofShr, instsofZero, instsofMul;

  for (auto &BB : F) {
  for (auto &I : BB) {

    // if add (X,X) -> mul(X,2)
    if(match(&I, m_Add(m_Value(A),m_Deferred(A)))){
      instsofAdd.push_back(&I);
    }
    // if sub (X,X) -> 0
    else if(match(&I,m_Sub(m_Value(A),m_Deferred(A)))){
      instsofSub.push_back(&I);
    }
    // if shl (X,Constant) -> X * 2^Constant
    else if(match(&I,m_Shl(m_Value(A),m_ConstantInt(C)))){
      instsofShl.push_back(&I);
    }
    // if ashr (X,Constant) -> X / 2^Constant
    // if lshr (X,Constant) -> X / 2^Constant
    else if(match(&I, m_AShr(m_Value(A),m_ConstantInt(C))) || match(&I, m_LShr(m_Value(A),m_ConstantInt(C)))){
      instsofShr.push_back(&I);
    }
    // if add(X, 0) -> X
    // if sub(X, 0) -> X
    else if((match(&I, m_Add(m_Value(A),m_ConstantInt(C))) || match(&I, m_Sub(m_Value(A),m_ConstantInt(C))))
    && C -> isZero()){
      instsofZero.push_back(&I);
    }
    //  mul(X, 0) -> 0
    else if(match(&I, m_Mul(m_Value(A),m_ConstantInt(C))) && C -> isZero()){
      instsofMul.push_back(&I);
    }
    }
    }

    //iterate through each vector and replace instructions
    for (Instruction *inst : instsofAdd) {
      Instruction *newInst = BinaryOperator::Create(Instruction::Mul, inst->getOperand(0),ConstantInt::get(inst->getOperand(0)->getType(),2));
      ReplaceInstWithInst(inst, newInst);
    }
    for (Instruction *inst : instsofSub) {
      Value *newValue = ConstantInt::get(inst->getOperand(0)->getType(),0);
      inst -> replaceAllUsesWith(newValue);
      inst -> eraseFromParent();
    }
    for (Instruction *inst : instsofShl) {
      Instruction *newInst = BinaryOperator::Create(Instruction::Mul, inst->getOperand(0),
      ConstantExpr::getShl(ConstantInt::get(inst -> getOperand(0)->getType(),1),dyn_cast<ConstantInt>(inst -> getOperand(1))));
      ReplaceInstWithInst(inst, newInst); 
    }
    for (Instruction *inst : instsofShr) {
      Instruction *newInst = BinaryOperator::Create(Instruction::UDiv, inst->getOperand(0),
      ConstantExpr::getShl(ConstantInt::get(inst -> getOperand(0)->getType(),1),dyn_cast<ConstantInt>(inst -> getOperand(1))));
      ReplaceInstWithInst(inst, newInst);
    }
    for (Instruction *inst : instsofZero) {
      Value* newValue = inst->getOperand(0);
      inst -> replaceAllUsesWith(newValue);
      inst -> eraseFromParent();
    }
    for (Instruction *inst : instsofMul){
      Value *newValue = ConstantInt::get(inst->getOperand(0)->getType(),0);
      inst -> replaceAllUsesWith(newValue);
      inst -> eraseFromParent();    
    }

    return PreservedAnalyses::all();
  }