; ModuleID = '/tmp/a.ll'
source_filename = "/Users/jaeeun/Desktop/llvmscript/team/test/jaeeuntests/test2/test2.c"
target datalayout = "e-m:o-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-apple-macosx10.14.0"

@arr = external global [100 x i32], align 16

; Function Attrs: nounwind ssp uwtable
define i32 @unefficientSum(i32 %n) #0 {
entry:
  br label %for.cond

for.cond:                                         ; preds = %for.inc, %entry
  %sum.0 = phi i32 [ 0, %entry ], [ %add, %for.inc ]
  %i.0 = phi i32 [ 0, %entry ], [ %inc, %for.inc ]
  %cmp = icmp slt i32 %i.0, %n
  br i1 %cmp, label %for.body, label %for.cond.cleanup

for.cond.cleanup:                                 ; preds = %for.cond
  br label %for.end

for.body:                                         ; preds = %for.cond
  %idxprom = sext i32 %i.0 to i64
  %arrayidx = getelementptr inbounds [100 x i32], [100 x i32]* @arr, i64 0, i64 %idxprom
  %0 = load i32, i32* %arrayidx, align 4
  %add = add nsw i32 %sum.0, %0
  br label %for.inc

for.inc:                                          ; preds = %for.body
  %inc = add nsw i32 %i.0, 1
  br label %for.cond

for.end:                                          ; preds = %for.cond.cleanup
  br label %for.cond2

for.cond2:                                        ; preds = %for.inc8, %for.end
  %sum.1 = phi i32 [ %sum.0, %for.end ], [ %sub, %for.inc8 ]
  %i1.0 = phi i32 [ 0, %for.end ], [ %inc9, %for.inc8 ]
  %cmp3 = icmp slt i32 %i1.0, %n
  br i1 %cmp3, label %for.body5, label %for.cond.cleanup4

for.cond.cleanup4:                                ; preds = %for.cond2
  br label %for.end10

for.body5:                                        ; preds = %for.cond2
  %idxprom6 = sext i32 %i1.0 to i64
  %arrayidx7 = getelementptr inbounds [100 x i32], [100 x i32]* @arr, i64 0, i64 %idxprom6
  %1 = load i32, i32* %arrayidx7, align 4
  %sub = sub nsw i32 %sum.1, %1
  br label %for.inc8

for.inc8:                                         ; preds = %for.body5
  %inc9 = add nsw i32 %i1.0, 1
  br label %for.cond2

for.end10:                                        ; preds = %for.cond.cleanup4
  br label %for.cond12

for.cond12:                                       ; preds = %for.inc19, %for.end10
  %sum.2 = phi i32 [ %sum.1, %for.end10 ], [ %add18, %for.inc19 ]
  %i11.0 = phi i32 [ 0, %for.end10 ], [ %inc20, %for.inc19 ]
  %cmp13 = icmp slt i32 %i11.0, %n
  br i1 %cmp13, label %for.body15, label %for.cond.cleanup14

for.cond.cleanup14:                               ; preds = %for.cond12
  br label %for.end21

for.body15:                                       ; preds = %for.cond12
  %idxprom16 = sext i32 %i11.0 to i64
  %arrayidx17 = getelementptr inbounds [100 x i32], [100 x i32]* @arr, i64 0, i64 %idxprom16
  %2 = load i32, i32* %arrayidx17, align 4
  %add18 = add nsw i32 %sum.2, %2
  br label %for.inc19

for.inc19:                                        ; preds = %for.body15
  %inc20 = add nsw i32 %i11.0, 1
  br label %for.cond12

for.end21:                                        ; preds = %for.cond.cleanup14
  ret i32 %sum.2
}

; Function Attrs: argmemonly nounwind willreturn
declare void @llvm.lifetime.start.p0i8(i64 immarg, i8* nocapture) #1

; Function Attrs: argmemonly nounwind willreturn
declare void @llvm.lifetime.end.p0i8(i64 immarg, i8* nocapture) #1

; Function Attrs: nounwind ssp uwtable
define i32 @main() #0 {
entry:
  br label %for.cond

for.cond:                                         ; preds = %for.inc, %entry
  %i.0 = phi i32 [ 0, %entry ], [ %inc, %for.inc ]
  %cmp = icmp slt i32 %i.0, 100
  br i1 %cmp, label %for.body, label %for.cond.cleanup

for.cond.cleanup:                                 ; preds = %for.cond
  br label %for.end

for.body:                                         ; preds = %for.cond
  %idxprom = sext i32 %i.0 to i64
  %arrayidx = getelementptr inbounds [100 x i32], [100 x i32]* @arr, i64 0, i64 %idxprom
  store i32 %i.0, i32* %arrayidx, align 4
  br label %for.inc

for.inc:                                          ; preds = %for.body
  %inc = add nsw i32 %i.0, 1
  br label %for.cond

for.end:                                          ; preds = %for.cond.cleanup
  %call = call i64 (...) @read()
  %conv = trunc i64 %call to i32
  %call1 = call i32 @unefficientSum(i32 %conv)
  %conv2 = sext i32 %call1 to i64
  call void @write(i64 %conv2)
  ret i32 0
}


; CHECK:  start unefficientSum.for.body5 3:
; CHECK:    .newFuncRoot:
; CHECK:  end unefficientSum.for.body5

; CHECK:  start unefficientSum.for.body15 3:
; CHECK:    .newFuncRoot:
; CHECK:  end unefficientSum.for.body15


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
