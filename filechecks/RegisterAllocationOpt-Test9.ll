; ModuleID = '/tmp/a.ll'
source_filename = "custom/test9.c"
target datalayout = "e-m:o-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-apple-macosx10.14.0"

@__const.main.str = private unnamed_addr constant [24 x i32] [i32 84, i32 104, i32 105, i32 115, i32 32, i32 105, i32 115, i32 32, i32 102, i32 111, i32 114, i32 32, i32 83, i32 87, i32 80, i32 80, i32 32, i32 83, i32 112, i32 114, i32 105, i32 110, i32 103, i32 10], align 16
@__const.main.pattern = private unnamed_addr constant [4 x i32] [i32 83, i32 87, i32 80, i32 80], align 16

; Function Attrs: nounwind ssp uwtable
define i32 @my_strlen(i32* %str) #0 {
entry:
; CHECK: .entry:
  br label %for.cond

for.cond:                                         ; preds = %for.inc, %entry
  %i.0 = phi i32 [ 0, %entry ], [ %inc, %for.inc ]
  %cmp = icmp slt i32 %i.0, 10000
  br i1 %cmp, label %for.body, label %for.cond.cleanup

for.cond.cleanup:                                 ; preds = %for.cond
  br label %cleanup

for.body:                                         ; preds = %for.cond
  %idxprom = sext i32 %i.0 to i64
  %arrayidx = getelementptr inbounds i32, i32* %str, i64 %idxprom
  %0 = load i32, i32* %arrayidx, align 4
  %cmp1 = icmp eq i32 %0, 0
  br i1 %cmp1, label %if.then, label %if.end

if.then:                                          ; preds = %for.body
  br label %cleanup

if.end:                                           ; preds = %for.body
  br label %for.inc

for.inc:                                          ; preds = %if.end
  %inc = add nsw i32 %i.0, 1
  br label %for.cond

cleanup:                                          ; preds = %if.then, %for.cond.cleanup
  %cleanup.dest.slot.0 = phi i32 [ 1, %if.then ], [ 2, %for.cond.cleanup ]
  switch i32 %cleanup.dest.slot.0, label %unreachable [
    i32 2, label %for.end
    i32 1, label %return
  ]

for.end:                                          ; preds = %cleanup
  br label %return

return:                                           ; preds = %for.end, %cleanup
  %retval.1 = phi i32 [ %i.0, %cleanup ], [ -1, %for.end ]
  ret i32 %retval.1

unreachable:                                      ; preds = %cleanup
  ret i32 0
}

; Function Attrs: argmemonly nounwind willreturn
declare void @llvm.lifetime.start.p0i8(i64 immarg, i8* nocapture) #1

; Function Attrs: argmemonly nounwind willreturn
declare void @llvm.lifetime.end.p0i8(i64 immarg, i8* nocapture) #1

; Function Attrs: nounwind ssp uwtable
define i32 @cntdiffchr(i32* %str) #0 {
entry:
  %call = call i32 @my_strlen(i32* %str)
  br label %for.cond

for.cond:                                         ; preds = %for.inc9, %entry
  %cnt.0 = phi i32 [ 0, %entry ], [ %cnt.1, %for.inc9 ]
  %i.0 = phi i32 [ 0, %entry ], [ %inc10, %for.inc9 ]
  %cmp = icmp slt i32 %i.0, %call
  br i1 %cmp, label %for.body, label %for.cond.cleanup

for.cond.cleanup:                                 ; preds = %for.cond
  br label %for.end12

for.body:                                         ; preds = %for.cond
  %inc = add nsw i32 %cnt.0, 1
  br label %for.cond1

for.cond1:                                        ; preds = %for.inc, %for.body
  %j.0 = phi i32 [ 0, %for.body ], [ %inc8, %for.inc ]
  %cmp2 = icmp slt i32 %j.0, %i.0
  br i1 %cmp2, label %for.body4, label %for.cond.cleanup3

for.cond.cleanup3:                                ; preds = %for.cond1
  br label %cleanup

for.body4:                                        ; preds = %for.cond1
  %idxprom = sext i32 %j.0 to i64
  %arrayidx = getelementptr inbounds i32, i32* %str, i64 %idxprom
  %0 = load i32, i32* %arrayidx, align 4
  %idxprom5 = sext i32 %i.0 to i64
  %arrayidx6 = getelementptr inbounds i32, i32* %str, i64 %idxprom5
  %1 = load i32, i32* %arrayidx6, align 4
  %cmp7 = icmp eq i32 %0, %1
  br i1 %cmp7, label %if.then, label %if.end

if.then:                                          ; preds = %for.body4
  %dec = add nsw i32 %inc, -1
  br label %cleanup

if.end:                                           ; preds = %for.body4
  br label %for.inc

for.inc:                                          ; preds = %if.end
  %inc8 = add nsw i32 %j.0, 1
  br label %for.cond1

cleanup:                                          ; preds = %if.then, %for.cond.cleanup3
  %cnt.1 = phi i32 [ %dec, %if.then ], [ %inc, %for.cond.cleanup3 ]
  br label %for.end

for.end:                                          ; preds = %cleanup
  br label %for.inc9

for.inc9:                                         ; preds = %for.end
  %inc10 = add nsw i32 %i.0, 1
  br label %for.cond

for.end12:                                        ; preds = %for.cond.cleanup
  ret i32 %cnt.0
}

; Function Attrs: nounwind ssp uwtable
define i32 @naiveMatching(i32* %str, i32* %pattern) #0 {
entry:
  %call = call i32 @my_strlen(i32* %str)
  %call1 = call i32 @my_strlen(i32* %pattern)
  br label %for.cond

for.cond:                                         ; preds = %for.inc14, %entry
  %retval.0 = phi i32 [ 0, %entry ], [ %retval.1, %for.inc14 ]
  %i.0 = phi i32 [ 0, %entry ], [ %inc15, %for.inc14 ]
  %sub = sub nsw i32 %call, %call1
  %add = add nsw i32 %sub, 1
  %cmp = icmp slt i32 %i.0, %add
  br i1 %cmp, label %for.body, label %for.cond.cleanup

for.cond.cleanup:                                 ; preds = %for.cond
  br label %cleanup16

for.body:                                         ; preds = %for.cond
  br label %for.cond2

for.cond2:                                        ; preds = %for.inc, %for.body
  %j.0 = phi i32 [ 0, %for.body ], [ %inc, %for.inc ]
  %cmp3 = icmp slt i32 %j.0, %call1
  br i1 %cmp3, label %for.body5, label %for.cond.cleanup4

for.cond.cleanup4:                                ; preds = %for.cond2
  br label %cleanup

for.body5:                                        ; preds = %for.cond2
; CHECK: .for.body5:
; CHECK: [[REG1:r[0-9]+]] = load 8 sp [[#SP1:]]
; CHECK: [[REG3:r[0-9]+]] = add [[REG1]] [[REG2:r[0-9]+]] 32
  %add6 = add nsw i32 %i.0, %j.0
  %idxprom = sext i32 %add6 to i64
  %arrayidx = getelementptr inbounds i32, i32* %str, i64 %idxprom
  %0 = load i32, i32* %arrayidx, align 4
  %idxprom7 = sext i32 %j.0 to i64
  %arrayidx8 = getelementptr inbounds i32, i32* %pattern, i64 %idxprom7
  %1 = load i32, i32* %arrayidx8, align 4
  %cmp9 = icmp ne i32 %0, %1
  br i1 %cmp9, label %if.then, label %if.end

if.then:                                          ; preds = %for.body5
  br label %cleanup

if.end:                                           ; preds = %for.body5
  %sub10 = sub nsw i32 %call1, 1
  %cmp11 = icmp eq i32 %j.0, %sub10
  br i1 %cmp11, label %if.then12, label %if.end13

if.then12:                                        ; preds = %if.end
  br label %cleanup

if.end13:                                         ; preds = %if.end
  br label %for.inc

for.inc:                                          ; preds = %if.end13
  %inc = add nsw i32 %j.0, 1
  br label %for.cond2

cleanup:                                          ; preds = %if.then12, %if.then, %for.cond.cleanup4
  %retval.1 = phi i32 [ %retval.0, %if.then ], [ %i.0, %if.then12 ], [ %retval.0, %for.cond.cleanup4 ]
  %cleanup.dest.slot.0 = phi i32 [ 5, %if.then ], [ 1, %if.then12 ], [ 5, %for.cond.cleanup4 ]
  switch i32 %cleanup.dest.slot.0, label %cleanup16 [
    i32 5, label %for.end
  ]

for.end:                                          ; preds = %cleanup
  br label %for.inc14

for.inc14:                                        ; preds = %for.end
  %inc15 = add nsw i32 %i.0, 1
  br label %for.cond

cleanup16:                                        ; preds = %cleanup, %for.cond.cleanup
  %retval.2 = phi i32 [ %retval.1, %cleanup ], [ %retval.0, %for.cond.cleanup ]
  %cleanup.dest.slot.1 = phi i32 [ %cleanup.dest.slot.0, %cleanup ], [ 2, %for.cond.cleanup ]
  switch i32 %cleanup.dest.slot.1, label %cleanup19 [
    i32 2, label %for.end18
  ]

for.end18:                                        ; preds = %cleanup16
  br label %cleanup19

cleanup19:                                        ; preds = %for.end18, %cleanup16
  %retval.3 = phi i32 [ %retval.2, %cleanup16 ], [ -1, %for.end18 ]
  ret i32 %retval.3
}

; Function Attrs: nounwind ssp uwtable
define i32 @kmpMatching(i32* %str, i32* %pattern) #0 {
entry:
  %call = call i32 @my_strlen(i32* %str)
  %call1 = call i32 @my_strlen(i32* %pattern)
  %0 = zext i32 %call1 to i64
  %1 = add i32 1, 1
  %vla = alloca i32, i64 %0, align 16
  %arrayidx = getelementptr inbounds i32, i32* %vla, i64 0
  store i32 -1, i32* %arrayidx, align 16
  br label %while.cond

while.cond:                                       ; preds = %if.end, %entry
  %j.0 = phi i32 [ 0, %entry ], [ %j.1, %if.end ]
  %k.0 = phi i32 [ -1, %entry ], [ %k.1, %if.end ]
  %cmp = icmp slt i32 %j.0, %call1
  br i1 %cmp, label %while.body, label %while.end

while.body:                                       ; preds = %while.cond
  %cmp2 = icmp eq i32 %k.0, -1
  br i1 %cmp2, label %if.then, label %lor.lhs.false

lor.lhs.false:                                    ; preds = %while.body
  %idxprom = sext i32 %j.0 to i64
  %arrayidx3 = getelementptr inbounds i32, i32* %pattern, i64 %idxprom
  %2 = load i32, i32* %arrayidx3, align 4
  %idxprom4 = sext i32 %k.0 to i64
  %arrayidx5 = getelementptr inbounds i32, i32* %pattern, i64 %idxprom4
  %3 = load i32, i32* %arrayidx5, align 4
  %cmp6 = icmp eq i32 %2, %3
  br i1 %cmp6, label %if.then, label %if.else

if.then:                                          ; preds = %lor.lhs.false, %while.body
  %inc = add nsw i32 %j.0, 1
  %inc7 = add nsw i32 %k.0, 1
  %idxprom8 = sext i32 %inc to i64
  %arrayidx9 = getelementptr inbounds i32, i32* %vla, i64 %idxprom8
  store i32 %inc7, i32* %arrayidx9, align 4
  br label %if.end

if.else:                                          ; preds = %lor.lhs.false
  %idxprom10 = sext i32 %k.0 to i64
  %arrayidx11 = getelementptr inbounds i32, i32* %vla, i64 %idxprom10
  %4 = load i32, i32* %arrayidx11, align 4
  br label %if.end

if.end:                                           ; preds = %if.else, %if.then
  %j.1 = phi i32 [ %inc, %if.then ], [ %j.0, %if.else ]
  %k.1 = phi i32 [ %inc7, %if.then ], [ %4, %if.else ]
  br label %while.cond

while.end:                                        ; preds = %while.cond
  br label %while.cond12

while.cond12:                                     ; preds = %if.end31, %while.end
  %i.0 = phi i32 [ 0, %while.end ], [ %i.1, %if.end31 ]
  %j.2 = phi i32 [ 0, %while.end ], [ %j.3, %if.end31 ]
  %cmp13 = icmp slt i32 %i.0, %call
  br i1 %cmp13, label %while.body14, label %while.end32

while.body14:                                     ; preds = %while.cond12
  %cmp15 = icmp eq i32 %j.2, -1
  br i1 %cmp15, label %if.then22, label %lor.lhs.false16

lor.lhs.false16:                                  ; preds = %while.body14
  %idxprom17 = sext i32 %i.0 to i64
  %arrayidx18 = getelementptr inbounds i32, i32* %str, i64 %idxprom17
  %5 = load i32, i32* %arrayidx18, align 4
  %idxprom19 = sext i32 %j.2 to i64
  %arrayidx20 = getelementptr inbounds i32, i32* %pattern, i64 %idxprom19
  %6 = load i32, i32* %arrayidx20, align 4
  %cmp21 = icmp eq i32 %5, %6
  br i1 %cmp21, label %if.then22, label %if.else25

if.then22:                                        ; preds = %lor.lhs.false16, %while.body14
  %inc23 = add nsw i32 %i.0, 1
  %inc24 = add nsw i32 %j.2, 1
  br label %if.end28

if.else25:                                        ; preds = %lor.lhs.false16
  %idxprom26 = sext i32 %j.2 to i64
  %arrayidx27 = getelementptr inbounds i32, i32* %vla, i64 %idxprom26
  %7 = load i32, i32* %arrayidx27, align 4
  br label %if.end28

if.end28:                                         ; preds = %if.else25, %if.then22
  %i.1 = phi i32 [ %inc23, %if.then22 ], [ %i.0, %if.else25 ]
  %j.3 = phi i32 [ %inc24, %if.then22 ], [ %7, %if.else25 ]
  %cmp29 = icmp eq i32 %j.3, %call1
  br i1 %cmp29, label %if.then30, label %if.end31

if.then30:                                        ; preds = %if.end28
  %sub = sub nsw i32 %i.1, %call1
  br label %cleanup

if.end31:                                         ; preds = %if.end28
  br label %while.cond12

while.end32:                                      ; preds = %while.cond12
  br label %cleanup

cleanup:                                          ; preds = %while.end32, %if.then30
  %retval.0 = phi i32 [ %sub, %if.then30 ], [ -1, %while.end32 ]
  ret i32 %retval.0
}

; Function Attrs: nounwind ssp uwtable
define i32 @boyer_mooreMatching(i32* %str, i32* %pattern) #0 {
entry:
  %skip = alloca [1000 x i32], align 16
  %call = call i32 @my_strlen(i32* %str)
  %call1 = call i32 @my_strlen(i32* %pattern)
  br label %for.cond

for.cond:                                         ; preds = %for.inc, %entry
  %i.0 = phi i32 [ 0, %entry ], [ %inc, %for.inc ]
  %cmp = icmp slt i32 %i.0, 1000
  br i1 %cmp, label %for.body, label %for.cond.cleanup

for.cond.cleanup:                                 ; preds = %for.cond
  br label %for.end

for.body:                                         ; preds = %for.cond
  %idxprom = sext i32 %i.0 to i64
  %arrayidx = getelementptr inbounds [1000 x i32], [1000 x i32]* %skip, i64 0, i64 %idxprom
  store i32 %call1, i32* %arrayidx, align 4
  br label %for.inc

for.inc:                                          ; preds = %for.body
  %inc = add nsw i32 %i.0, 1
  br label %for.cond

for.end:                                          ; preds = %for.cond.cleanup
  %sub = sub nsw i32 %call1, 2
  br label %for.cond3

for.cond3:                                        ; preds = %for.inc18, %for.end
  %i2.0 = phi i32 [ %sub, %for.end ], [ %dec, %for.inc18 ]
  %cmp4 = icmp sge i32 %i2.0, 0
  br i1 %cmp4, label %for.body6, label %for.cond.cleanup5

for.cond.cleanup5:                                ; preds = %for.cond3
  br label %for.end19

for.body6:                                        ; preds = %for.cond3
  %idxprom7 = sext i32 %i2.0 to i64
  %arrayidx8 = getelementptr inbounds i32, i32* %pattern, i64 %idxprom7
  %0 = load i32, i32* %arrayidx8, align 4
  %idxprom9 = sext i32 %0 to i64
  %arrayidx10 = getelementptr inbounds [1000 x i32], [1000 x i32]* %skip, i64 0, i64 %idxprom9
  %1 = load i32, i32* %arrayidx10, align 4
  %cmp11 = icmp eq i32 %1, %call1
  br i1 %cmp11, label %if.then, label %if.end

if.then:                                          ; preds = %for.body6
  %sub12 = sub nsw i32 %call1, 1
  %sub13 = sub nsw i32 %sub12, %i2.0
  %idxprom14 = sext i32 %i2.0 to i64
  %arrayidx15 = getelementptr inbounds i32, i32* %pattern, i64 %idxprom14
  %2 = load i32, i32* %arrayidx15, align 4
  %idxprom16 = sext i32 %2 to i64
  %arrayidx17 = getelementptr inbounds [1000 x i32], [1000 x i32]* %skip, i64 0, i64 %idxprom16
  store i32 %sub13, i32* %arrayidx17, align 4
  br label %if.end

if.end:                                           ; preds = %if.then, %for.body6
  br label %for.inc18

for.inc18:                                        ; preds = %if.end
  %dec = add nsw i32 %i2.0, -1
  br label %for.cond3

for.end19:                                        ; preds = %for.cond.cleanup5
  br label %for.cond21

for.cond21:                                       ; preds = %for.inc48, %for.end19
  %retval.0 = phi i32 [ 0, %for.end19 ], [ %retval.1, %for.inc48 ]
  %i20.0 = phi i32 [ 0, %for.end19 ], [ %inc49, %for.inc48 ]
  %sub22 = sub nsw i32 %call, %call1
  %add = add nsw i32 %sub22, 1
  %cmp23 = icmp slt i32 %i20.0, %add
  br i1 %cmp23, label %for.body25, label %for.cond.cleanup24

for.cond.cleanup24:                               ; preds = %for.cond21
  br label %cleanup50

for.body25:                                       ; preds = %for.cond21
  %sub26 = sub nsw i32 %call1, 1
  %add27 = add nsw i32 %i20.0, %call1
  %sub28 = sub nsw i32 %add27, 1
  br label %while.cond

while.cond:                                       ; preds = %while.body, %for.body25
  %j.0 = phi i32 [ %sub26, %for.body25 ], [ %dec35, %while.body ]
  %k.0 = phi i32 [ %sub28, %for.body25 ], [ %dec36, %while.body ]
  %cmp29 = icmp sge i32 %j.0, 0
  br i1 %cmp29, label %land.rhs, label %land.end

land.rhs:                                         ; preds = %while.cond
  %idxprom30 = sext i32 %k.0 to i64
  %arrayidx31 = getelementptr inbounds i32, i32* %str, i64 %idxprom30
  %3 = load i32, i32* %arrayidx31, align 4
  %idxprom32 = sext i32 %j.0 to i64
  %arrayidx33 = getelementptr inbounds i32, i32* %pattern, i64 %idxprom32
  %4 = load i32, i32* %arrayidx33, align 4
  %cmp34 = icmp eq i32 %3, %4
  br label %land.end

land.end:                                         ; preds = %land.rhs, %while.cond
  %5 = phi i1 [ false, %while.cond ], [ %cmp34, %land.rhs ]
  br i1 %5, label %while.body, label %while.end

while.body:                                       ; preds = %land.end
  %dec35 = add nsw i32 %j.0, -1
  %dec36 = add nsw i32 %k.0, -1
  br label %while.cond

while.end:                                        ; preds = %land.end
  %cmp37 = icmp slt i32 %j.0, 0
  br i1 %cmp37, label %if.then38, label %if.end39

if.then38:                                        ; preds = %while.end
  br label %cleanup

if.end39:                                         ; preds = %while.end
  %add40 = add nsw i32 %i20.0, %call1
  %sub41 = sub nsw i32 %add40, 1
  %idxprom42 = sext i32 %sub41 to i64
  %arrayidx43 = getelementptr inbounds i32, i32* %pattern, i64 %idxprom42
  %6 = load i32, i32* %arrayidx43, align 4
  %idxprom44 = sext i32 %6 to i64
  %arrayidx45 = getelementptr inbounds [1000 x i32], [1000 x i32]* %skip, i64 0, i64 %idxprom44
  %7 = load i32, i32* %arrayidx45, align 4
  %add46 = add nsw i32 %i20.0, %7
  br label %cleanup

cleanup:                                          ; preds = %if.end39, %if.then38
  %retval.1 = phi i32 [ %i20.0, %if.then38 ], [ %retval.0, %if.end39 ]
  %i20.1 = phi i32 [ %i20.0, %if.then38 ], [ %add46, %if.end39 ]
  %cleanup.dest.slot.0 = phi i32 [ 1, %if.then38 ], [ 0, %if.end39 ]
  switch i32 %cleanup.dest.slot.0, label %cleanup50 [
    i32 0, label %cleanup.cont
  ]

cleanup.cont:                                     ; preds = %cleanup
  br label %for.inc48

for.inc48:                                        ; preds = %cleanup.cont
  %inc49 = add nsw i32 %i20.1, 1
  br label %for.cond21

cleanup50:                                        ; preds = %cleanup, %for.cond.cleanup24
  %retval.2 = phi i32 [ %retval.1, %cleanup ], [ %retval.0, %for.cond.cleanup24 ]
  %cleanup.dest.slot.1 = phi i32 [ %cleanup.dest.slot.0, %cleanup ], [ 8, %for.cond.cleanup24 ]
  switch i32 %cleanup.dest.slot.1, label %cleanup53 [
    i32 8, label %for.end52
  ]

for.end52:                                        ; preds = %cleanup50
  br label %cleanup53

cleanup53:                                        ; preds = %for.end52, %cleanup50
  %retval.3 = phi i32 [ %retval.2, %cleanup50 ], [ -1, %for.end52 ]
  ret i32 %retval.3
}

; Function Attrs: nounwind ssp uwtable
define i32 @main() #0 {
entry:
; CHECK: start main 0:
; CHECK: [[REGOP1:r[0-9]+]] = mul [[REG:r[0-9]+]] 1 64
; CHECK: [[REGOP2:r[0-9]+]] = mul  [[REG:r[0-9]+]] 1 64
; CHECK: [[REGOP:r[0-9]+]] = call naiveMatching [[REGOP1]] [[REGOP2]]
; CHECK: [[REG:r[0-9]+]] = udiv [[REGOP]] 2147483648 64
; CHECK: [[REG]] = mul [[REG]] 18446744071562067968 64
; CHECK: [[REG]] = or [[REG]] [[REGOP]] 64
; CHECK: call write [[REG]]
; CHECK: [[REGOP:r[0-9]+]] = call kmpMatching [[REGOP1]] [[REGOP2]]
; CHECK: [[REG:r[0-9]+]] = udiv [[REGOP]] 2147483648 64
; CHECK: [[REG]] = mul [[REG]] 18446744071562067968 64
; CHECK: [[REG]] = or [[REG]] [[REGOP]] 64
; CHECK: call write [[REG]]
; CHECK: [[REGOP:r[0-9]+]] = call boyer_mooreMatching [[REGOP1]] [[REGOP2]]
; CHECK: [[REG:r[0-9]+]] = udiv [[REGOP]] 2147483648 64
; CHECK: [[REG]] = mul [[REG]] 18446744071562067968 64
; CHECK: [[REG]] = or [[REG]] [[REGOP]] 64
; CHECK: call write [[REG]]
  %str = alloca [24 x i32], align 16
  %pattern = alloca [4 x i32], align 16
  %0 = bitcast [24 x i32]* %str to i8*
  %1 = bitcast [4 x i32]* %pattern to i8*
  %arraydecay = getelementptr inbounds [24 x i32], [24 x i32]* %str, i64 0, i64 0
  %arraydecay1 = getelementptr inbounds [4 x i32], [4 x i32]* %pattern, i64 0, i64 0
  %call = call i32 @naiveMatching(i32* %arraydecay, i32* %arraydecay1)
  %conv = sext i32 %call to i64
  call void @write(i64 %conv)
  %arraydecay2 = getelementptr inbounds [24 x i32], [24 x i32]* %str, i64 0, i64 0
  %arraydecay3 = getelementptr inbounds [4 x i32], [4 x i32]* %pattern, i64 0, i64 0
  %call4 = call i32 @kmpMatching(i32* %arraydecay2, i32* %arraydecay3)
  %conv5 = sext i32 %call4 to i64
  call void @write(i64 %conv5)
  %arraydecay6 = getelementptr inbounds [24 x i32], [24 x i32]* %str, i64 0, i64 0
  %arraydecay7 = getelementptr inbounds [4 x i32], [4 x i32]* %pattern, i64 0, i64 0
  %call8 = call i32 @boyer_mooreMatching(i32* %arraydecay6, i32* %arraydecay7)
  %conv9 = sext i32 %call8 to i64
  call void @write(i64 %conv9)
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
