#include "Team4Passes.h"

PreservedAnalyses ArithmeticPass::run(Function &F, FunctionAnalysisManager &FAM) {
  // make vectors for each pattern to replace 
  Value *X, *Y;
  DominatorTree &DT = FAM.getResult<DominatorTreeAnalysis>(F);
  vector<Instruction *> instsofAdd, instsofSub, instsofShl, instsofShr, instsEqBr, instsNeqBr;
  ConstantInt *C, *D;
  ICmpInst::Predicate Pred;
  for (auto &BB : F) {
  for (auto &I : BB) {
    bool icmp_x_y = match(&I,m_ICmp(Pred,m_Value(X),m_Value(Y)));
    bool icmp_x_c = match(&I,m_ICmp(Pred,m_Value(X),m_ConstantInt(C)));
    bool icmp_c_x = match(&I,m_ICmp(Pred,m_ConstantInt(C),m_Value(X)));
    bool icmp_c_d = match(&I,m_ICmp(Pred,m_ConstantInt(C),m_ConstantInt(D)));

    // do integer equality propagation here
    if(icmp_x_y){
      Value *Replacement, *Victim;
      Instruction *XI = dyn_cast<Instruction>(X);
      Instruction *YI = dyn_cast<Instruction>(Y);
      Argument *XA = dyn_cast<Argument>(X);
      Argument *YA = dyn_cast<Argument>(Y);
      if (XI && YI) { /* Both X and Y are instructions */
        if (DT.dominates(XI, YI)) { /* X dominates Y */
          Replacement = X;
          Victim = Y;
        } else {                    /* Y dominates X */
          Replacement = Y;
          Victim = X;
        }
      } else if (XI && YA) { /* X is an instruction, Y is an argument */
        Replacement = Y;
        Victim = X;
      } else if (XA && YI) { /* X is an argument, Y is an instruction */
        Replacement = X;
        Victim = Y;
      } else if (XA && YA) { /* Both X and Y are function arguments */
        if (XA->getArgNo() < YA->getArgNo()) { /* X comes first */
          Replacement = X;
          Victim = Y;
        } else {                               /* Y comes first */
          Replacement = Y;
          Victim = X;
        }
      } else /* Either X or Y is neither instruction nor function argument (ignore) */
        continue;

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

    // if add (X,X) -> mul(X,2)
    if(match(&I, m_Add(m_Value(X),m_Deferred(X)))){
      instsofAdd.push_back(&I);
    }
    // if sub (X,X) -> 0
    else if(match(&I,m_Sub(m_Value(X),m_Deferred(X)))){
      instsofSub.push_back(&I);
    }
    // if shl (X,Constant) -> X * 2^Constant
    else if(match(&I,m_Shl(m_Value(X),m_ConstantInt(C)))){
      instsofShl.push_back(&I);
    }
    // if shr (X,Constant) -> X / 2^Constant
    else if(match(&I,m_Shr(m_Value(X),m_ConstantInt(C)))){
      instsofShr.push_back(&I);
    }
    // %cond = icmp eq(X,Y)
    // br i1 %cond, label %BB1, label %BB2
    // -> 
    // %cond = xor (X,Y)
    // br i1 %cond, label %BB2, label %BB1
    // include when compared between value and constant / constant and constant
    else if((icmp_x_y || icmp_x_c || icmp_c_x || icmp_c_d) && Pred == ICmpInst::ICMP_EQ){
      instsEqBr.push_back(&I);
    }
    // %cond = icmp ne (X,Y)
    else if((icmp_x_y || icmp_x_c || icmp_c_x || icmp_c_d) && Pred == ICmpInst::ICMP_NE){
      instsNeqBr.push_back(&I);
        }
      }
    }

    //iterate through each vector and replace instructions
    for (Instruction *inst : instsofAdd) {
      Instruction *newInst = BinaryOperator::Create(Instruction::Mul, inst->getOperand(0),ConstantInt::get(inst->getOperand(0)->getType(),2));
      ReplaceInstWithInst(inst, newInst);
    }
    for (Instruction *inst : instsofSub) {
      inst -> replaceAllUsesWith(ConstantInt::get(inst->getOperand(0)->getType(),0));
      inst -> eraseFromParent();
    }
    for (Instruction *inst : instsofShl) {
      Instruction *newInst = BinaryOperator::Create(Instruction::Mul, inst->getOperand(0),ConstantExpr::getShl(ConstantInt::get(inst -> getOperand(0)->getType(),1),C));
      ReplaceInstWithInst(inst, newInst);
    }
    for (Instruction *inst : instsofShr) {
      Instruction *newInst = BinaryOperator::Create(Instruction::UDiv, inst->getOperand(0),ConstantExpr::getShl(ConstantInt::get(inst -> getOperand(0)->getType(),1),C));
      ReplaceInstWithInst(inst, newInst);
    }
    for (Instruction *inst : instsEqBr){

      // bool do_opt = true;

      // for (auto itr = inst-> use_begin(),end = inst->use_begin();itr!=end;){
      //   Use &U = *itr++;
      //   User *Usr = U.getUser();
      //   BranchInst *UsrI = dyn_cast<BranchInst>(Usr);
      //   if(!UsrI) {
      //     do_opt = false;
      //   }
      // }
      // if(do_opt){
      // Instruction *newInst = BinaryOperator::Create(Instruction::Xor, inst->getOperand(0),inst->getOperand(1));
      // ReplaceInstWithInst(inst,newInst);
      // for(auto itr=newInst -> use_begin(),end= newInst -> use_end();itr!=end;){
      //   Use &U = *itr++;
      //   User *Usr = U.getUser();
      //   BranchInst *UsrI = dyn_cast<BranchInst>(Usr);
      //   if(UsrI && UsrI -> isConditional() && (UsrI -> getNumSuccessors() == 2)){
      //     Value* lhs = UsrI -> getSuccessor(0);
      //     Value* rhs = UsrI -> getSuccessor(1);
      //     UsrI->setOperand(0, rhs);
      //     UsrI->setOperand(1, lhs);
      //     }
      // }
      // }
    }
    for (Instruction *inst : instsNeqBr){
      // ICmpInst* CI = dyn_cast<ICmpInst>(inst);
      // Instruction *newInst = BinaryOperator::Create(Instruction::Xor,CI->getOperand(0),CI->getOperand(1));
      // ReplaceInstWithInst(inst,newInst);
    }

    return PreservedAnalyses::all();
  }