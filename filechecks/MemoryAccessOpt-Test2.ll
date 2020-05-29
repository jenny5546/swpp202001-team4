; ModuleID = '/tmp/a.ll'
source_filename = "/Users/ohah/Documents/swpp-project/testcases/sprint2memacc/test2.c"
target datalayout = "e-m:o-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-apple-macosx10.14.0"

; Function Attrs: nounwind ssp uwtable
define i32 @main() #0 {
; CHECK: start main 0:
entry:
; CHECK: reset heap
; CHECK: reset stack
  %arr = alloca [3 x i32], align 4
  %conv = sext i32 24 to i64
  %mul = mul i64 %conv, 8
  %call = call noalias i8* @malloc(i64 %mul) #3
  %0 = bitcast i8* %call to i8**
  %conv1 = sext i32 8 to i64
  %mul2 = mul i64 %conv1, 1
  %call3 = call noalias i8* @malloc(i64 %mul2) #3
  %arrayidx = getelementptr inbounds i8*, i8** %0, i64 0
  store i8* %call3, i8** %arrayidx, align 8
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

attributes #0 = { nounwind ssp uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="penryn" "target-features"="+cx16,+cx8,+fxsr,+mmx,+sahf,+sse,+sse2,+sse3,+sse4.1,+ssse3,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { argmemonly nounwind willreturn }
attributes #2 = { allocsize(0) "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="penryn" "target-features"="+cx16,+cx8,+fxsr,+mmx,+sahf,+sse,+sse2,+sse3,+sse4.1,+ssse3,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #3 = { allocsize(0) }

!llvm.module.flags = !{!0, !1, !2}
!llvm.ident = !{!3}

!0 = !{i32 2, !"SDK Version", [2 x i32] [i32 10, i32 14]}
!1 = !{i32 1, !"wchar_size", i32 4}
!2 = !{i32 7, !"PIC Level", i32 2}
!3 = !{!"clang version 10.0.1 (git@github.com:llvm/llvm-project.git 92d5c1be9ee93850c0a8903f05f36a23ee835dc2)"}
