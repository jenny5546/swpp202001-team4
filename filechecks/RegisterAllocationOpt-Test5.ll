; ModuleID = '/tmp/a.ll'
source_filename = "custom/test5.c"
target datalayout = "e-m:o-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-apple-macosx10.14.0"

; Function Attrs: nounwind ssp uwtable
define void @swap(i32* %a, i32* %b) #0 {
; CHECK: start swap 2:
entry:
  %0 = load i32, i32* %b, align 4
  %1 = load i32, i32* %a, align 4
  store i32 %1, i32* %b, align 4
  store i32 %0, i32* %a, align 4
  ret void
}
; CHECK: end swap

; Function Attrs: argmemonly nounwind willreturn
declare void @llvm.lifetime.start.p0i8(i64 immarg, i8* nocapture) #1

; Function Attrs: argmemonly nounwind willreturn
declare void @llvm.lifetime.end.p0i8(i64 immarg, i8* nocapture) #1

; Function Attrs: nounwind ssp uwtable
define i32 @partition(i32* %arr, i32 %low, i32 %high) #0 {
; CHECK: start partition 3:

entry:
; CHECK:     [[REG:r[0-9]+]] = udiv [[ARG:arg[0-9]+]] 2147483648 64
; CHECK-NEXT:     [[REG]] = mul [[REG]] 18446744071562067968 64
; CHECK-NEXT:     [[REG]] = or [[REG]] [[ARG]] 64
; CHECK-NEXT:     [[REG2:r[0-9]+]] = mul [[ARG:arg[0-9]+]] 1 64
; CHECK-NEXT:     [[REG3:r[0-9]+]] = mul [[REG]] 4 64
; CHECK-NEXT:     [[REG2]] = add [[REG2]] [[REG3]]  64
  %idxprom = sext i32 %high to i64
  %arrayidx = getelementptr inbounds i32, i32* %arr, i64 %idxprom
  %0 = load i32, i32* %arrayidx, align 4
  %sub = sub nsw i32 %low, 1
  br label %for.cond

for.cond:                                         ; preds = %for.inc, %entry
  %i.0 = phi i32 [ %sub, %entry ], [ %i.1, %for.inc ]
  %j.0 = phi i32 [ %low, %entry ], [ %inc9, %for.inc ]
  %sub1 = sub nsw i32 %high, 1
  %cmp = icmp sle i32 %j.0, %sub1
  br i1 %cmp, label %for.body, label %for.cond.cleanup

for.cond.cleanup:                                 ; preds = %for.cond
  br label %for.end

for.body:                                         ; preds = %for.cond
  %idxprom2 = sext i32 %j.0 to i64
  %arrayidx3 = getelementptr inbounds i32, i32* %arr, i64 %idxprom2
  %1 = load i32, i32* %arrayidx3, align 4
  %cmp4 = icmp slt i32 %1, %0
  br i1 %cmp4, label %if.then, label %if.end

if.then:                                          ; preds = %for.body
  %inc = add nsw i32 %i.0, 1
  %idxprom5 = sext i32 %inc to i64
  %arrayidx6 = getelementptr inbounds i32, i32* %arr, i64 %idxprom5
  %idxprom7 = sext i32 %j.0 to i64
  %arrayidx8 = getelementptr inbounds i32, i32* %arr, i64 %idxprom7
  call void @swap(i32* %arrayidx6, i32* %arrayidx8)
  br label %if.end

if.end:                                           ; preds = %if.then, %for.body
  %i.1 = phi i32 [ %inc, %if.then ], [ %i.0, %for.body ]
  br label %for.inc

for.inc:                                          ; preds = %if.end
  %inc9 = add nsw i32 %j.0, 1
  br label %for.cond

for.end:                                          ; preds = %for.cond.cleanup
  %add = add nsw i32 %i.0, 1
  %idxprom10 = sext i32 %add to i64
  %arrayidx11 = getelementptr inbounds i32, i32* %arr, i64 %idxprom10
  %idxprom12 = sext i32 %high to i64
  %arrayidx13 = getelementptr inbounds i32, i32* %arr, i64 %idxprom12
  call void @swap(i32* %arrayidx11, i32* %arrayidx13)
  %add14 = add nsw i32 %i.0, 1
  ret i32 %add14
}
; CHECK: end partition

; Function Attrs: nounwind ssp uwtable
define void @quickSort(i32* %arr, i32 %low, i32 %high) #0 {
; CHECK: start quickSort 3:
entry:
  %cmp = icmp slt i32 %low, %high
  br i1 %cmp, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  %call = call i32 @partition(i32* %arr, i32 %low, i32 %high)
  %sub = sub nsw i32 %call, 1
  call void @quickSort(i32* %arr, i32 %low, i32 %sub)
  %add = add nsw i32 %call, 1
  call void @quickSort(i32* %arr, i32 %add, i32 %high)
  br label %if.end

if.end:                                           ; preds = %if.then, %entry
  ret void
}
; CHECK: end quickSort

; Function Attrs: nounwind ssp uwtable
define void @printArray(i32* %arr, i32 %size) #0 {
; CHECK: start printArray 2:    

; CHECK:     [[REG:r[0-9]+]] = udiv [[REG0:r[0-9]+]] 2147483648 64
; CHECK-NEXT:     [[REG]] = mul [[REG]] 18446744071562067968 64
; CHECK-NEXT:     [[REG]] = or [[REG]] [[REG0]] 64
; CHECK-NEXT:     [[REG2:r[0-9]+]] = mul [[ARG:arg[0-9]+]] 1 64
; CHECK-NEXT:     [[REG3:r[0-9]+]] = mul [[REG]] 4 64
; CHECK-NEXT:     [[REG2]] = add [[REG2]] [[REG3]] 64

entry:
  br label %for.cond

for.cond:                                         ; preds = %for.inc, %entry
  %i.0 = phi i32 [ 0, %entry ], [ %inc, %for.inc ]
  %cmp = icmp slt i32 %i.0, %size
  br i1 %cmp, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %idxprom = sext i32 %i.0 to i64
  %arrayidx = getelementptr inbounds i32, i32* %arr, i64 %idxprom
  %0 = load i32, i32* %arrayidx, align 4
  %conv = sext i32 %0 to i64
  call void @write(i64 %conv)
  br label %for.inc

for.inc:                                          ; preds = %for.body
  %inc = add nsw i32 %i.0, 1
  br label %for.cond

for.end:                                          ; preds = %for.cond
  ret void
}
; CHECK: end printArray

declare void @write(i64) #2

; Function Attrs: nounwind ssp uwtable
define i32 @main() #0 {
; CHECK: start main 0:
entry:
  %arr = alloca [15 x i32], align 16
  %arrayidx = getelementptr inbounds [15 x i32], [15 x i32]* %arr, i64 0, i64 0
  store i32 11, i32* %arrayidx, align 16
  %arrayidx1 = getelementptr inbounds [15 x i32], [15 x i32]* %arr, i64 0, i64 1
  store i32 10, i32* %arrayidx1, align 4
  %arrayidx2 = getelementptr inbounds [15 x i32], [15 x i32]* %arr, i64 0, i64 2
  store i32 12, i32* %arrayidx2, align 8
  %arrayidx3 = getelementptr inbounds [15 x i32], [15 x i32]* %arr, i64 0, i64 3
  store i32 2, i32* %arrayidx3, align 4
  %arrayidx4 = getelementptr inbounds [15 x i32], [15 x i32]* %arr, i64 0, i64 4
  store i32 7, i32* %arrayidx4, align 16
  %arrayidx5 = getelementptr inbounds [15 x i32], [15 x i32]* %arr, i64 0, i64 5
  store i32 3, i32* %arrayidx5, align 4
  %arrayidx6 = getelementptr inbounds [15 x i32], [15 x i32]* %arr, i64 0, i64 6
  store i32 8, i32* %arrayidx6, align 8
  %arrayidx7 = getelementptr inbounds [15 x i32], [15 x i32]* %arr, i64 0, i64 7
  store i32 14, i32* %arrayidx7, align 4
  %arrayidx8 = getelementptr inbounds [15 x i32], [15 x i32]* %arr, i64 0, i64 8
  store i32 4, i32* %arrayidx8, align 16
  %arrayidx9 = getelementptr inbounds [15 x i32], [15 x i32]* %arr, i64 0, i64 9
  store i32 9, i32* %arrayidx9, align 4
  %arrayidx10 = getelementptr inbounds [15 x i32], [15 x i32]* %arr, i64 0, i64 10
  store i32 15, i32* %arrayidx10, align 8
  %arrayidx11 = getelementptr inbounds [15 x i32], [15 x i32]* %arr, i64 0, i64 11
  store i32 1, i32* %arrayidx11, align 4
  %arrayidx12 = getelementptr inbounds [15 x i32], [15 x i32]* %arr, i64 0, i64 12
  store i32 13, i32* %arrayidx12, align 16
  %arrayidx13 = getelementptr inbounds [15 x i32], [15 x i32]* %arr, i64 0, i64 13
  store i32 6, i32* %arrayidx13, align 4
  %arrayidx14 = getelementptr inbounds [15 x i32], [15 x i32]* %arr, i64 0, i64 14
  store i32 5, i32* %arrayidx14, align 8
  %arraydecay = getelementptr inbounds [15 x i32], [15 x i32]* %arr, i64 0, i64 0
  %sub = sub nsw i32 15, 1
  call void @quickSort(i32* %arraydecay, i32 0, i32 %sub)
  %arraydecay15 = getelementptr inbounds [15 x i32], [15 x i32]* %arr, i64 0, i64 0
  call void @printArray(i32* %arraydecay15, i32 15)
  ret i32 0
}
; CHECK: end main

attributes #0 = { nounwind ssp uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="penryn" "target-features"="+cx16,+cx8,+fxsr,+mmx,+sahf,+sse,+sse2,+sse3,+sse4.1,+ssse3,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { argmemonly nounwind willreturn }
attributes #2 = { "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="penryn" "target-features"="+cx16,+cx8,+fxsr,+mmx,+sahf,+sse,+sse2,+sse3,+sse4.1,+ssse3,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }

!llvm.module.flags = !{!0, !1, !2}
!llvm.ident = !{!3}

!0 = !{i32 2, !"SDK Version", [2 x i32] [i32 10, i32 14]}
!1 = !{i32 1, !"wchar_size", i32 4}
!2 = !{i32 7, !"PIC Level", i32 2}
!3 = !{!"clang version 10.0.1 (https://github.com/llvm/llvm-project 92d5c1be9ee93850c0a8903f05f36a23ee835dc2)"}
