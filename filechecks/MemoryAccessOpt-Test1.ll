; ModuleID = '/tmp/a.ll'
source_filename = "/Users/ohah/Documents/swpp-project/testcases/mytest/Mem1.c"
target datalayout = "e-m:o-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-apple-macosx10.14.0"

; Function Attrs: nounwind ssp uwtable
define i32 @main() #0 {
; start main 0: 
entry:
  %numArr = alloca [10 x i32], align 16
  %conv = sext i32 8 to i64
  %mul = mul i64 %conv, 4
  %call = call i8* @malloc(i64 %mul) #4
  %0 = bitcast i8* %call to i32*
  br label %for.cond

for.cond:                                         ; preds = %for.inc, %entry
  %i.0 = phi i32 [ 0, %entry ], [ %inc, %for.inc ]
  %cmp = icmp slt i32 %i.0, 8
  br i1 %cmp, label %for.body, label %for.cond.cleanup

for.cond.cleanup:                                 ; preds = %for.cond
  br label %for.end

for.body:                                         ; preds = %for.cond
; CHECK: reset heap
; CHECK: reset stack
  %idxprom = sext i32 %i.0 to i64
  %arrayidx = getelementptr inbounds i32, i32* %0, i64 %idxprom
  store i32 %i.0, i32* %arrayidx, align 4
  br label %for.inc

for.inc:                                          ; preds = %for.body
  %inc = add nsw i32 %i.0, 1
  br label %for.cond

for.end:                                          ; preds = %for.cond.cleanup
  %arraydecay = getelementptr inbounds [10 x i32], [10 x i32]* %numArr, i64 0, i64 0
  call void @dataInput(i32* %arraydecay)
  br label %for.cond3

for.cond3:                                        ; preds = %for.inc12, %for.end
  %i2.0 = phi i32 [ 0, %for.end ], [ %inc13, %for.inc12 ]
  %cmp4 = icmp slt i32 %i2.0, 8
  br i1 %cmp4, label %for.body7, label %for.cond.cleanup6

for.cond.cleanup6:                                ; preds = %for.cond3
  br label %for.end14

for.body7:                                        ; preds = %for.cond3
; CHECK: reset heap
; CHECK: reset stack
  %idxprom8 = sext i32 %i2.0 to i64
  %arrayidx9 = getelementptr inbounds i32, i32* %0, i64 %idxprom8
  %1 = load i32, i32* %arrayidx9, align 4
  %idxprom10 = sext i32 %i2.0 to i64
  %arrayidx11 = getelementptr inbounds [10 x i32], [10 x i32]* %numArr, i64 0, i64 %idxprom10
  store i32 %1, i32* %arrayidx11, align 4
  br label %for.inc12

for.inc12:                                        ; preds = %for.body7
  %inc13 = add nsw i32 %i2.0, 1
  br label %for.cond3

for.end14:                                        ; preds = %for.cond.cleanup6
  br label %while.cond

while.cond:                                       ; preds = %while.body, %for.end14
  %a.0 = phi i32 [ 10, %for.end14 ], [ %inc19, %while.body ]
  %cmp15 = icmp sle i32 %a.0, 10
  br i1 %cmp15, label %while.body, label %while.end

while.body:                                       ; preds = %while.cond
  %idxprom17 = sext i32 %a.0 to i64
  %arrayidx18 = getelementptr inbounds [10 x i32], [10 x i32]* %numArr, i64 0, i64 %idxprom17
  store i32 %a.0, i32* %arrayidx18, align 4
  %inc19 = add nsw i32 %a.0, 1
  br label %while.cond

while.end:                                        ; preds = %while.cond
  %cmp20 = icmp ne i32* %0, null
  br i1 %cmp20, label %if.then, label %if.end

if.then:                                          ; preds = %while.end
  %2 = bitcast i32* %0 to i8*
  call void @free(i8* %2)
  br label %if.end

if.end:                                           ; preds = %if.then, %while.end
  ret i32 0
}
; CHECK: end main

; Function Attrs: argmemonly nounwind willreturn
declare void @llvm.lifetime.start.p0i8(i64 immarg, i8* nocapture) #1

; Function Attrs: allocsize(0)
declare i8* @malloc(i64) #2

; Function Attrs: argmemonly nounwind willreturn
declare void @llvm.lifetime.end.p0i8(i64 immarg, i8* nocapture) #1

; Function Attrs: nounwind ssp uwtable
define void @dataInput(i32* %arr) #0 {
entry:
  br label %for.cond

for.cond:                                         ; preds = %for.inc, %entry
  %i.0 = phi i32 [ 0, %entry ], [ %inc, %for.inc ]
  %cmp = icmp slt i32 %i.0, 10
  br i1 %cmp, label %for.body, label %for.cond.cleanup

for.cond.cleanup:                                 ; preds = %for.cond
  br label %for.end

for.body:                                         ; preds = %for.cond
  %idxprom = sext i32 %i.0 to i64
  %arrayidx = getelementptr inbounds i32, i32* %arr, i64 %idxprom
  store i32 %i.0, i32* %arrayidx, align 4
  br label %for.inc

for.inc:                                          ; preds = %for.body
  %inc = add nsw i32 %i.0, 1
  br label %for.cond

for.end:                                          ; preds = %for.cond.cleanup
  ret void
}

declare void @free(i8*) #3

attributes #0 = { nounwind ssp uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="penryn" "target-features"="+cx16,+cx8,+fxsr,+mmx,+sahf,+sse,+sse2,+sse3,+sse4.1,+ssse3,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { argmemonly nounwind willreturn }
attributes #2 = { allocsize(0) "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="penryn" "target-features"="+cx16,+cx8,+fxsr,+mmx,+sahf,+sse,+sse2,+sse3,+sse4.1,+ssse3,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #3 = { "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="penryn" "target-features"="+cx16,+cx8,+fxsr,+mmx,+sahf,+sse,+sse2,+sse3,+sse4.1,+ssse3,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #4 = { allocsize(0) }

!llvm.module.flags = !{!0, !1, !2}
!llvm.ident = !{!3}

!0 = !{i32 2, !"SDK Version", [2 x i32] [i32 10, i32 14]}
!1 = !{i32 1, !"wchar_size", i32 4}
!2 = !{i32 7, !"PIC Level", i32 2}
!3 = !{!"clang version 10.0.1 (git@github.com:llvm/llvm-project.git 92d5c1be9ee93850c0a8903f05f36a23ee835dc2)"}
