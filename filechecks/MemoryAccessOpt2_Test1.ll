; Function Attrs: nounwind ssp uwtable
define i32 @main() #0 {
; CHECK: start main 0:
entry:
; CHECK: reset heap
; CHECK: reset stack
; CHECK: reset heap
  %b = alloca i64, align 8
  %arr = alloca [3 x i32], align 4
  store i64 0, i64* %b, align 8
  %conv = sext i32 24 to i64
  %mul = mul i64 %conv, 8
  %call = call noalias i8* @malloc(i64 %mul) #3
  %0 = bitcast i8* %call to i8**
  %conv1 = sext i32 8 to i64
  %mul2 = mul i64 %conv1, 1
  %call3 = call noalias i8* @malloc(i64 %mul2) #3
  %arrayidx = getelementptr inbounds i8*, i8** %0, i64 0
  store i8* %call3, i8** %arrayidx, align 8
  store i64 0, i64* %b, align 8  
  %conv4 = trunc i32 24 to i8
  %arrayidx5 = getelementptr inbounds i8*, i8** %0, i64 0
  %1 = load i8*, i8** %arrayidx5, align 8
  %arrayidx6 = getelementptr inbounds i8, i8* %1, i64 0
  store i8 %conv4, i8* %arrayidx6, align 1
  %conv7 = sext i32 8 to i64
  %mul8 = mul i64 %conv7, 1
  %call9 = call noalias i8* @malloc(i64 %mul8) #3
  %arrayidx10 = getelementptr inbounds i8*, i8** %0, i64 1
  store i8* %call9, i8** %arrayidx10, align 8
  %inc = add nsw i32 24, 1
  %conv11 = trunc i32 24 to i8
  %arrayidx12 = getelementptr inbounds i8*, i8** %0, i64 1
  %2 = load i8*, i8** %arrayidx12, align 8
  %arrayidx13 = getelementptr inbounds i8, i8* %2, i64 0
  store i8 %conv11, i8* %arrayidx13, align 1
  br label %for.cond

for.cond:                                         ; preds = %for.inc, %entry
  %i.0 = phi i32 [ 0, %entry ], [ %inc17, %for.inc ]
  %count.0 = phi i32 [ %inc, %entry ], [ %inc16, %for.inc ]
  %cmp = icmp slt i32 %i.0, 3
  br i1 %cmp, label %for.body, label %for.cond.cleanup

for.cond.cleanup:                                 ; preds = %for.cond
  br label %for.end

for.body:                                         ; preds = %for.cond
  %idxprom = sext i32 %i.0 to i64
  %arrayidx15 = getelementptr inbounds [3 x i32], [3 x i32]* %arr, i64 0, i64 %idxprom
  store i32 %count.0, i32* %arrayidx15, align 4
  %inc16 = add nsw i32 %count.0, 1
  br label %for.inc

for.inc:                                          ; preds = %for.body
  %inc17 = add nsw i32 %i.0, 1
  br label %for.cond

for.end:                                          ; preds = %for.cond.cleanup
  %conv18 = sext i32 8 to i64
  %mul19 = mul i64 %conv18, 1
  %call20 = call noalias i8* @malloc(i64 %mul19) #3
  %arrayidx21 = getelementptr inbounds i8*, i8** %0, i64 4
  store i8* %call20, i8** %arrayidx21, align 8
  %arrayidx22 = getelementptr inbounds [3 x i32], [3 x i32]* %arr, i64 0, i64 2
  %3 = load i32, i32* %arrayidx22, align 4
  %conv23 = trunc i32 %3 to i8
  %arrayidx24 = getelementptr inbounds i8*, i8** %0, i64 4
  %4 = load i8*, i8** %arrayidx24, align 8
  %arrayidx25 = getelementptr inbounds i8, i8* %4, i64 0
  store i8 %conv23, i8* %arrayidx25, align 1
  ret i32 0
}
; CHECK: end main

; Function Attrs: argmemonly nounwind willreturn
declare void @llvm.lifetime.start.p0i8(i64 immarg, i8* nocapture) #1

; Function Attrs: allocsize(0)
declare noalias i8* @malloc(i64) #2

; Function Attrs: argmemonly nounwind willreturn
declare void @llvm.lifetime.end.p0i8(i64 immarg, i8* nocapture) #1