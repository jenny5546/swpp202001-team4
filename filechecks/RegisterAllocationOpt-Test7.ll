; ModuleID = '/tmp/a.ll'
source_filename = "custom/test7.c"
target datalayout = "e-m:o-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-apple-macosx10.14.0"

@__const.main.arr = private unnamed_addr constant [20 x i32] [i32 10, i32 9, i32 8, i32 7, i32 6, i32 5, i32 4, i32 3, i32 2, i32 1, i32 0, i32 -1, i32 -2, i32 -3, i32 -4, i32 -5, i32 -6, i32 -7, i32 -8, i32 -9], align 16

; Function Attrs: nounwind ssp uwtable
define void @swap(i32* %arr, i32 %i, i32 %j) #0 {
entry:
; CHECK: .entry:
; CHECK-NOT: sp = sub sp [[#SP:]] 64
; CHECK: [[REG:r[0-9]+]] = udiv [[ARG:arg[0-9]+]] 2147483648 64
; CHECK: [[REG]] = mul [[REG]] 18446744071562067968 64
; CHECK: [[REG]] = or [[REG]] [[ARG]] 64
  %idxprom = sext i32 %i to i64
  %arrayidx = getelementptr inbounds i32, i32* %arr, i64 %idxprom
  %0 = load i32, i32* %arrayidx, align 4
; CHECK: [[REG:r[0-9]+]] = udiv [[ARG:arg[0-9]+]] 2147483648 64
; CHECK: [[REG]] = mul [[REG]] 18446744071562067968 64
; CHECK: [[REG]] = or [[REG]] [[ARG]] 64
  %idxprom1 = sext i32 %j to i64
  %arrayidx2 = getelementptr inbounds i32, i32* %arr, i64 %idxprom1
  %1 = load i32, i32* %arrayidx2, align 4
  %idxprom3 = sext i32 %i to i64
  %arrayidx4 = getelementptr inbounds i32, i32* %arr, i64 %idxprom3
  store i32 %1, i32* %arrayidx4, align 4
  %idxprom5 = sext i32 %j to i64
  %arrayidx6 = getelementptr inbounds i32, i32* %arr, i64 %idxprom5
  store i32 %0, i32* %arrayidx6, align 4
  ret void
}

; Function Attrs: nounwind ssp uwtable
define i32 @partition(i32* %arr, i32 %n, i32 %target) #0 {
entry:
; CHECK: .entry:
; CHECK: store 8 0 sp [[SPPHI:[0-9]+]]
  br label %for.cond

for.cond:                                         ; preds = %for.inc, %entry
; CHECK: [[REG:r[0-9]+]] = load 8 sp [[SPPHI]]
  %index.0 = phi i32 [ 0, %entry ], [ %inc, %for.inc ]
  %cmp = icmp slt i32 %index.0, %n
  br i1 %cmp, label %for.body, label %for.cond.cleanup

for.cond.cleanup:                                 ; preds = %for.cond
  br label %cleanup

for.body:                                         ; preds = %for.cond
; CHECK: [[REG1:r[0-9]+]] = udiv [[REG2:r[0-9]+]] 2147483648 64
; CHECK: [[REG1]] = mul [[REG1]] 18446744071562067968 64
; CHECK: [[REG1]] = or [[REG1]] [[REG2]] 64
; CHECK: [[REG3:r[0-9]+]] = mul [[ARG:arg[0-9]+]] 1 64
; CHECK: [[REG4:r[0-9]+]] = mul [[REG1]] 4 64
; CHECK: [[REG3]] = add [[REG3]] [[REG4]] 64
; CHECK: [[REG5:r[0-9]+]] = load 4 [[REG3]] 0
  %idxprom = sext i32 %index.0 to i64
  %arrayidx = getelementptr inbounds i32, i32* %arr, i64 %idxprom
  %0 = load i32, i32* %arrayidx, align 4
  %cmp1 = icmp eq i32 %0, %target
  br i1 %cmp1, label %if.then, label %if.end

if.then:                                          ; preds = %for.body
  br label %cleanup

if.end:                                           ; preds = %for.body
  br label %for.inc

for.inc:                                          ; preds = %if.end
  %inc = add nsw i32 %index.0, 1
  br label %for.cond

cleanup:                                          ; preds = %if.then, %for.cond.cleanup
  br label %for.end

for.end:                                          ; preds = %cleanup
  call void @swap(i32* %arr, i32 0, i32 %index.0)
  br label %for.cond3

for.cond3:                                        ; preds = %for.inc14, %for.end
; CHECK: .for.cond3:
; CHECK: [[REG:r[0-9]+]] = load 8 sp [[#SP2:]]
; CHECK: [[REG:r[0-9]+]] = load 8 sp [[#SP3:]]
  %swap_point.0 = phi i32 [ 0, %for.end ], [ %swap_point.1, %for.inc14 ]
  %index2.0 = phi i32 [ 1, %for.end ], [ %inc15, %for.inc14 ]
  %cmp4 = icmp slt i32 %index2.0, %n
  br i1 %cmp4, label %for.body6, label %for.cond.cleanup5

for.cond.cleanup5:                                ; preds = %for.cond3
  br label %for.end17

for.body6:                                        ; preds = %for.cond3
  %idxprom7 = sext i32 %index2.0 to i64
  %arrayidx8 = getelementptr inbounds i32, i32* %arr, i64 %idxprom7
  %1 = load i32, i32* %arrayidx8, align 4
  %arrayidx9 = getelementptr inbounds i32, i32* %arr, i64 0
  %2 = load i32, i32* %arrayidx9, align 4
  %cmp10 = icmp slt i32 %1, %2
  br i1 %cmp10, label %if.then11, label %if.end13

if.then11:                                        ; preds = %for.body6
  %inc12 = add nsw i32 %swap_point.0, 1
  call void @swap(i32* %arr, i32 %index2.0, i32 %inc12)
  br label %if.end13

if.end13:                                         ; preds = %if.then11, %for.body6
  %swap_point.1 = phi i32 [ %inc12, %if.then11 ], [ %swap_point.0, %for.body6 ]
  br label %for.inc14

for.inc14:                                        ; preds = %if.end13
  %inc15 = add nsw i32 %index2.0, 1
  br label %for.cond3

for.end17:                                        ; preds = %for.cond.cleanup5
  call void @swap(i32* %arr, i32 0, i32 %swap_point.0)
  ret i32 %swap_point.0
}

; Function Attrs: nounwind ssp uwtable
define i32 @linearSelection(i32* %arr, i32 %n, i32 %i) #0 {
entry:
  %cmp = icmp sle i32 %n, 5
  %0 = zext i32 %n to i64
  %vla = alloca i32, i64 %0, align 16
  %add = add nsw i32 %n, 4
  %div = sdiv i32 %add, 5
  %temp1 = zext i32 %div to i64
  %vla29 = alloca i32, i64 %temp1, align 16
  br i1 %cmp, label %if.then, label %if.end27

if.then:                                          ; preds = %entry
  br label %for.cond

for.cond:                                         ; preds = %for.inc, %if.then
  %index.0 = phi i32 [ 0, %if.then ], [ %inc, %for.inc ]
  %cmp1 = icmp slt i32 %index.0, %n
  br i1 %cmp1, label %for.body, label %for.cond.cleanup

for.cond.cleanup:                                 ; preds = %for.cond
  br label %for.end

for.body:                                         ; preds = %for.cond
  %idxprom = sext i32 %index.0 to i64
  %arrayidx = getelementptr inbounds i32, i32* %arr, i64 %idxprom
  %1 = add i32 %n, %n
  %2 = load i32, i32* %arrayidx, align 4
  %idxprom2 = sext i32 %index.0 to i64
  %arrayidx3 = getelementptr inbounds i32, i32* %vla, i64 %idxprom2
  store i32 %2, i32* %arrayidx3, align 4
  br label %for.inc

for.inc:                                          ; preds = %for.body
  %inc = add nsw i32 %index.0, 1
  br label %for.cond

for.end:                                          ; preds = %for.cond.cleanup
  br label %for.cond4

for.cond4:                                        ; preds = %for.inc21, %for.end
  %index1.0 = phi i32 [ 1, %for.end ], [ %inc22, %for.inc21 ]
  %cmp5 = icmp slt i32 %index1.0, %n
  br i1 %cmp5, label %for.body7, label %for.cond.cleanup6

for.cond.cleanup6:                                ; preds = %for.cond4
  br label %for.end23

for.body7:                                        ; preds = %for.cond4
  br label %for.cond8

for.cond8:                                        ; preds = %for.inc19, %for.body7
  %index2.0 = phi i32 [ %index1.0, %for.body7 ], [ %dec, %for.inc19 ]
  %cmp9 = icmp sgt i32 %index2.0, 0
  br i1 %cmp9, label %for.body11, label %for.cond.cleanup10

for.cond.cleanup10:                               ; preds = %for.cond8
  br label %for.end20

for.body11:                                       ; preds = %for.cond8
  %idxprom12 = sext i32 %index2.0 to i64
  %arrayidx13 = getelementptr inbounds i32, i32* %vla, i64 %idxprom12
  %3 = load i32, i32* %arrayidx13, align 4
  %sub = sub nsw i32 %index2.0, 1
  %idxprom14 = sext i32 %sub to i64
  %arrayidx15 = getelementptr inbounds i32, i32* %vla, i64 %idxprom14
  %4 = load i32, i32* %arrayidx15, align 4
  %cmp16 = icmp slt i32 %3, %4
  br i1 %cmp16, label %if.then17, label %if.end

if.then17:                                        ; preds = %for.body11
  %sub18 = sub nsw i32 %index2.0, 1
  call void @swap(i32* %vla, i32 %index2.0, i32 %sub18)
  br label %if.end

if.end:                                           ; preds = %if.then17, %for.body11
  br label %for.inc19

for.inc19:                                        ; preds = %if.end
  %dec = add nsw i32 %index2.0, -1
  br label %for.cond8

for.end20:                                        ; preds = %for.cond.cleanup10
  br label %for.inc21

for.inc21:                                        ; preds = %for.end20
  %inc22 = add nsw i32 %index1.0, 1
  br label %for.cond4

for.end23:                                        ; preds = %for.cond.cleanup6
  %sub24 = sub nsw i32 %i, 1
  %idxprom25 = sext i32 %sub24 to i64
  %arrayidx26 = getelementptr inbounds i32, i32* %vla, i64 %idxprom25
  %5 = load i32, i32* %arrayidx26, align 4
  br label %return

if.end27:                                         ; preds = %entry
  %6 = zext i32 %div to i64
  br label %for.cond30

for.cond30:                                       ; preds = %for.inc42, %if.end27
  %group.0 = phi i32 [ 0, %if.end27 ], [ %inc43, %for.inc42 ]
  %cmp31 = icmp slt i32 %group.0, %div
  br i1 %cmp31, label %for.body33, label %for.cond.cleanup32

for.cond.cleanup32:                               ; preds = %for.cond30
  br label %for.end44

for.body33:                                       ; preds = %for.cond30
  %sub34 = sub nsw i32 %div, 1
  %cmp35 = icmp eq i32 %group.0, %sub34
  br i1 %cmp35, label %land.lhs.true, label %cond.false

land.lhs.true:                                    ; preds = %for.body33
  %rem = srem i32 %n, 5
  %cmp36 = icmp ne i32 %rem, 0
  br i1 %cmp36, label %cond.true, label %cond.false

cond.true:                                        ; preds = %land.lhs.true
  %rem37 = srem i32 %n, 5
  br label %cond.end

cond.false:                                       ; preds = %land.lhs.true, %for.body33
  br label %cond.end

cond.end:                                         ; preds = %cond.false, %cond.true
  %cond = phi i32 [ %rem37, %cond.true ], [ 5, %cond.false ]
  %mul = mul nsw i32 %group.0, 5
  %idx.ext = sext i32 %mul to i64
  %add.ptr = getelementptr inbounds i32, i32* %arr, i64 %idx.ext
  %add38 = add nsw i32 %cond, 1
  %div39 = sdiv i32 %add38, 2
  %call = call i32 @linearSelection(i32* %add.ptr, i32 %cond, i32 %div39)
  %idxprom40 = sext i32 %group.0 to i64
  %arrayidx41 = getelementptr inbounds i32, i32* %vla29, i64 %idxprom40
  store i32 %call, i32* %arrayidx41, align 4
  br label %for.inc42

for.inc42:                                        ; preds = %cond.end
  %inc43 = add nsw i32 %group.0, 1
  br label %for.cond30

for.end44:                                        ; preds = %for.cond.cleanup32
  %add45 = add nsw i32 %div, 1
  %div46 = sdiv i32 %add45, 2
  %call47 = call i32 @linearSelection(i32* %vla29, i32 %div, i32 %div46)
  %call48 = call i32 @partition(i32* %arr, i32 %n, i32 %call47)
  %sub49 = sub nsw i32 %i, 1
  %cmp50 = icmp eq i32 %call48, %sub49
  br i1 %cmp50, label %if.then51, label %if.else

if.then51:                                        ; preds = %for.end44
  %idxprom52 = sext i32 %call48 to i64
  %arrayidx53 = getelementptr inbounds i32, i32* %arr, i64 %idxprom52
  %7 = add i32 %n, %n
  %8 = load i32, i32* %arrayidx53, align 4
  br label %cleanup

if.else:                                          ; preds = %for.end44
  %sub54 = sub nsw i32 %i, 1
  %cmp55 = icmp sgt i32 %call48, %sub54
  br i1 %cmp55, label %if.then56, label %if.else58

if.then56:                                        ; preds = %if.else
  %call57 = call i32 @linearSelection(i32* %arr, i32 %call48, i32 %i)
  br label %cleanup

if.else58:                                        ; preds = %if.else
  %add59 = add nsw i32 %call48, 1
  %idx.ext60 = sext i32 %add59 to i64
  %add.ptr61 = getelementptr inbounds i32, i32* %arr, i64 %idx.ext60
  %sub62 = sub nsw i32 %n, %call48
  %sub63 = sub nsw i32 %sub62, 1
  %sub64 = sub nsw i32 %i, %call48
  %sub65 = sub nsw i32 %sub64, 1
  %call66 = call i32 @linearSelection(i32* %add.ptr61, i32 %sub63, i32 %sub65)
  br label %cleanup

cleanup:                                          ; preds = %if.else58, %if.then56, %if.then51
  %retval.0 = phi i32 [ %8, %if.then51 ], [ %call57, %if.then56 ], [ %call66, %if.else58 ]
  br label %return

return:                                           ; preds = %cleanup, %for.end23
  %retval.1 = phi i32 [ %5, %for.end23 ], [ %retval.0, %cleanup ]
  ret i32 %retval.1
}

; Function Attrs: nounwind ssp uwtable
define i32 @main() #0 {
entry:
  %arr = alloca [20 x i32], align 16
  %0 = bitcast [20 x i32]* %arr to i8*
  %arraydecay = getelementptr inbounds [20 x i32], [20 x i32]* %arr, i64 0, i64 0
  %call = call i32 @linearSelection(i32* %arraydecay, i32 20, i32 10)
  %conv = sext i32 %call to i64
  call void @write(i64 %conv)
  ret i32 0
}

declare void @write(i64) #3

attributes #0 = { nounwind ssp uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="penryn" "target-features"="+cx16,+cx8,+fxsr,+mmx,+sahf,+sse,+sse2,+sse3,+sse4.1,+ssse3,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { argmemonly nounwind willreturn }
attributes #2 = { nounwind }
attributes #3 = { "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="penryn" "target-features"="+cx16,+cx8,+fxsr,+mmx,+sahf,+sse,+sse2,+sse3,+sse4.1,+ssse3,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }

!llvm.module.flags = !{!0, !1, !2}
!llvm.ident = !{!3}

!0 = !{i32 2, !"SDK Version", [2 x i32] [i32 10, i32 14]}
!1 = !{i32 1, !"wchar_size", i32 4}
!2 = !{i32 7, !"PIC Level", i32 2}
!3 = !{!"clang version 10.0.1 (https://github.com/llvm/llvm-project 92d5c1be9ee93850c0a8903f05f36a23ee835dc2)"}
