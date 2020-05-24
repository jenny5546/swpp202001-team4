; ModuleID = '/tmp/a.ll'
source_filename = "/Users/jaeeun/Desktop/llvmscript/team/test/jaeeuntests/test1/test1.c"
target datalayout = "e-m:o-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-apple-macosx10.14.0"

@arr = external global [100 x i32], align 16

; Function Attrs: nounwind ssp uwtable
define i32 @unrolledSum(i32 %n) #0 {
; CHECK:  start unrolledSum 1:

entry:
  br label %for.cond

for.cond:                                         ; preds = %for.inc, %entry
  %sum.0 = phi i32 [ 0, %entry ], [ %add12, %for.inc ]
  %i.0 = phi i32 [ 0, %entry ], [ %add13, %for.inc ]
  %cmp = icmp slt i32 %i.0, %n
  br i1 %cmp, label %for.body, label %for.cond.cleanup

for.cond.cleanup:                                 ; preds = %for.cond
  br label %for.end

for.body:                                         ; preds = %for.cond
  %idxprom = sext i32 %i.0 to i64
  %arrayidx = getelementptr inbounds [100 x i32], [100 x i32]* @arr, i64 0, i64 %idxprom
  %0 = load i32, i32* %arrayidx, align 4
  %add = add nsw i32 %sum.0, %0
  %add1 = add nsw i32 %i.0, 1
  %idxprom2 = sext i32 %add1 to i64
  %arrayidx3 = getelementptr inbounds [100 x i32], [100 x i32]* @arr, i64 0, i64 %idxprom2
  %1 = load i32, i32* %arrayidx3, align 4
  %add4 = add nsw i32 %add, %1
  %add5 = add nsw i32 %i.0, 2
  %idxprom6 = sext i32 %add5 to i64
  %arrayidx7 = getelementptr inbounds [100 x i32], [100 x i32]* @arr, i64 0, i64 %idxprom6
  %2 = load i32, i32* %arrayidx7, align 4
  %add8 = add nsw i32 %add4, %2
  %add9 = add nsw i32 %i.0, 3
  %idxprom10 = sext i32 %add9 to i64
  %arrayidx11 = getelementptr inbounds [100 x i32], [100 x i32]* @arr, i64 0, i64 %idxprom10
  %3 = load i32, i32* %arrayidx11, align 4
  %add12 = add nsw i32 %add8, %3
  br label %for.inc

for.inc:                                          ; preds = %for.body
  %add13 = add nsw i32 %i.0, 4
  br label %for.cond

for.end:                                          ; preds = %for.cond.cleanup
  ret i32 %sum.0
}

; Function Attrs: argmemonly nounwind willreturn
declare void @llvm.lifetime.start.p0i8(i64 immarg, i8* nocapture) #1

; Function Attrs: argmemonly nounwind willreturn
declare void @llvm.lifetime.end.p0i8(i64 immarg, i8* nocapture) #1

; Function Attrs: nounwind ssp uwtable
define i32 @main() #0 {
entry:
  store i32 1, i32* getelementptr inbounds ([100 x i32], [100 x i32]* @arr, i64 0, i64 0), align 16
  store i32 1, i32* getelementptr inbounds ([100 x i32], [100 x i32]* @arr, i64 0, i64 1), align 4
  br label %for.cond

for.cond:                                         ; preds = %for.inc, %entry
  %i.0 = phi i32 [ 2, %entry ], [ %inc, %for.inc ]
  %cmp = icmp slt i32 %i.0, 100
  br i1 %cmp, label %for.body, label %for.cond.cleanup

for.cond.cleanup:                                 ; preds = %for.cond
  br label %for.end

for.body:                                         ; preds = %for.cond
  %sub = sub nsw i32 %i.0, 1
  %idxprom = sext i32 %sub to i64
  %arrayidx = getelementptr inbounds [100 x i32], [100 x i32]* @arr, i64 0, i64 %idxprom
  %0 = load i32, i32* %arrayidx, align 4
  %mul = mul nsw i32 %0, 2
  %idxprom1 = sext i32 %i.0 to i64
  %arrayidx2 = getelementptr inbounds [100 x i32], [100 x i32]* @arr, i64 0, i64 %idxprom1
  %1 = load i32, i32* %arrayidx2, align 4
  %add = add nsw i32 %1, %mul
  store i32 %add, i32* %arrayidx2, align 4
  %sub3 = sub nsw i32 %i.0, 2
  %idxprom4 = sext i32 %sub3 to i64
  %arrayidx5 = getelementptr inbounds [100 x i32], [100 x i32]* @arr, i64 0, i64 %idxprom4
  %2 = load i32, i32* %arrayidx5, align 4
  %mul6 = mul nsw i32 %2, 4
  %idxprom7 = sext i32 %i.0 to i64
  %arrayidx8 = getelementptr inbounds [100 x i32], [100 x i32]* @arr, i64 0, i64 %idxprom7
  %3 = load i32, i32* %arrayidx8, align 4
  %add9 = add nsw i32 %3, %mul6
  store i32 %add9, i32* %arrayidx8, align 4
  br label %for.inc

for.inc:                                          ; preds = %for.body
  %inc = add nsw i32 %i.0, 1
  br label %for.cond

for.end:                                          ; preds = %for.cond.cleanup
  %call = call i64 (...) @read()
  %conv = trunc i64 %call to i32
  %call10 = call i32 @unrolledSum(i32 %conv)
  %conv11 = sext i32 %call10 to i64
  call void @write(i64 %conv11)
  ret i32 0
}

; CHECK: start unrolledSum.for.body.split 4:
; CHECK:     r16 = add arg1 arg2 32
; CHECK: end unrolledSum.for.body.split

; CHECK: start main.for.body.split 2:
; CHECK:   .newFuncRoot:
; CHECK: end main.for.body.split

; CHECK: start main.for.end 0:
; CHECK:   .newFuncRoot:

; CHECK: end main.for.end

declare void @write(i64) #2

declare i64 @read(...) #2

attributes #0 = { nounwind ssp uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="penryn" "target-features"="+cx16,+cx8,+fxsr,+mmx,+sahf,+sse,+sse2,+sse3,+sse4.1,+ssse3,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { argmemonly nounwind willreturn }
attributes #2 = { "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="penryn" "target-features"="+cx16,+cx8,+fxsr,+mmx,+sahf,+sse,+sse2,+sse3,+sse4.1,+ssse3,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }

!llvm.module.flags = !{!0, !1, !2}
!llvm.ident = !{!3}

!0 = !{i32 2, !"SDK Version", [2 x i32] [i32 10, i32 14]}
!1 = !{i32 1, !"wchar_size", i32 4}
!2 = !{i32 7, !"PIC Level", i32 2}
!3 = !{!"clang version 10.0.1 (https://github.com/llvm/llvm-project.git f79cd71e145c6fd005ba4dd1238128dfa0dc2cb6)"}