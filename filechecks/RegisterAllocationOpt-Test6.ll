; ModuleID = '/tmp/a.ll'
source_filename = "custom/test6.c"
target datalayout = "e-m:o-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-apple-macosx10.14.0"

; Function Attrs: nounwind ssp uwtable
define void @convolution(i64 %M, i64 %N, i64* %input, i64* %output, [3 x i64]* %filter) #0 {
; CHECK: start convolution 5:

entry:
; CHECK: sp = sub sp [[#SP:]] 64
  br label %for.cond

for.cond:                                         ; preds = %for.inc47, %entry
; CHECK: [[REG:]] load 8 sp [[#SP:]]
  %i.0 = phi i64 [ 0, %entry ], [ %inc48, %for.inc47 ]
  %cmp = icmp slt i64 %i.0, %M
  br i1 %cmp, label %for.body, label %for.cond.cleanup

for.cond.cleanup:                                 ; preds = %for.cond
  br label %for.end49

for.body:                                         ; preds = %for.cond
; CHECK: [[REG:]] store 8 0 sp [[#SP:]]
  br label %for.cond1

for.cond1:                                        ; preds = %for.inc44, %for.body
  %j.0 = phi i64 [ 0, %for.body ], [ %inc45, %for.inc44 ]
  %cmp2 = icmp slt i64 %j.0, %N
  br i1 %cmp2, label %for.body4, label %for.cond.cleanup3

for.cond.cleanup3:                                ; preds = %for.cond1
  br label %for.end46

for.body4:                                        ; preds = %for.cond1
; CHECK: [[REG:]] store 8 0 sp [[#SP:]]
  br label %for.cond5

for.cond5:                                        ; preds = %for.inc41, %for.body4
  %x.0 = phi i64 [ 0, %for.body4 ], [ %inc42, %for.inc41 ]
  %cmp6 = icmp slt i64 %x.0, 3
  br i1 %cmp6, label %for.body8, label %for.cond.cleanup7

for.cond.cleanup7:                                ; preds = %for.cond5
  br label %for.end43

for.body8:                                        ; preds = %for.cond5
; CHECK: [[REG:]] store 8 0 sp [[#SP:]]
 br label %for.cond9

for.cond9:                                        ; preds = %for.inc, %for.body8
  %y.0 = phi i64 [ 0, %for.body8 ], [ %inc, %for.inc ]
  %cmp10 = icmp slt i64 %y.0, 3
  br i1 %cmp10, label %for.body12, label %for.cond.cleanup11

for.cond.cleanup11:                               ; preds = %for.cond9
  br label %for.end

for.body12:                                       ; preds = %for.cond9
  %add = add nsw i64 %i.0, %x.0
  %sub = sub nsw i64 %add, 1
  %cmp13 = icmp slt i64 %sub, 0
  br i1 %cmp13, label %if.then, label %if.end

if.then:                                          ; preds = %for.body12
  br label %for.inc

if.end:                                           ; preds = %for.body12
  %add14 = add nsw i64 %i.0, %x.0
  %sub15 = sub nsw i64 %add14, 1
  %cmp16 = icmp sge i64 %sub15, %M
  br i1 %cmp16, label %if.then17, label %if.end18

if.then17:                                        ; preds = %if.end
  br label %for.inc

if.end18:                                         ; preds = %if.end
  %add19 = add nsw i64 %j.0, %y.0
  %sub20 = sub nsw i64 %add19, 1
  %cmp21 = icmp slt i64 %sub20, 0
  br i1 %cmp21, label %if.then22, label %if.end23

if.then22:                                        ; preds = %if.end18
  br label %for.inc

if.end23:                                         ; preds = %if.end18
  %add24 = add nsw i64 %j.0, %y.0
  %sub25 = sub nsw i64 %add24, 1
  %cmp26 = icmp sge i64 %sub25, %N
  br i1 %cmp26, label %if.then27, label %if.end28

if.then27:                                        ; preds = %if.end23
  br label %for.inc

if.end28:                                         ; preds = %if.end23
  %add29 = add nsw i64 %i.0, %x.0
  %sub30 = sub nsw i64 %add29, 1
  %mul = mul nsw i64 %sub30, %N
  %add31 = add nsw i64 %j.0, %y.0
  %sub32 = sub nsw i64 %add31, 1
  %add33 = add nsw i64 %mul, %sub32
  %arrayidx = getelementptr inbounds i64, i64* %input, i64 %add33
  %0 = load i64, i64* %arrayidx, align 8
  %arrayidx34 = getelementptr inbounds [3 x i64], [3 x i64]* %filter, i64 %x.0
  %arrayidx35 = getelementptr inbounds [3 x i64], [3 x i64]* %arrayidx34, i64 0, i64 %y.0
  %1 = load i64, i64* %arrayidx35, align 8
  %mul36 = mul nsw i64 %0, %1
  %mul37 = mul nsw i64 %i.0, %N
  %add38 = add nsw i64 %mul37, %j.0
  %arrayidx39 = getelementptr inbounds i64, i64* %output, i64 %add38
  %2 = load i64, i64* %arrayidx39, align 8
  %add40 = add nsw i64 %2, %mul36
  store i64 %add40, i64* %arrayidx39, align 8
  br label %for.inc

for.inc:                                          ; preds = %if.end28, %if.then27, %if.then22, %if.then17, %if.then
  %inc = add nsw i64 %y.0, 1
  br label %for.cond9

for.end:                                          ; preds = %for.cond.cleanup11
  br label %for.inc41

for.inc41:                                        ; preds = %for.end
  %inc42 = add nsw i64 %x.0, 1
  br label %for.cond5

for.end43:                                        ; preds = %for.cond.cleanup7
  br label %for.inc44

for.inc44:                                        ; preds = %for.end43
  %inc45 = add nsw i64 %j.0, 1
  br label %for.cond1

for.end46:                                        ; preds = %for.cond.cleanup3
  br label %for.inc47

for.inc47:                                        ; preds = %for.end46
  %inc48 = add nsw i64 %i.0, 1
  br label %for.cond

for.end49:                                        ; preds = %for.cond.cleanup
  ret void
}
; CHECK: end convolution

; Function Attrs: argmemonly nounwind willreturn
declare void @llvm.lifetime.start.p0i8(i64 immarg, i8* nocapture) #1

; Function Attrs: argmemonly nounwind willreturn
declare void @llvm.lifetime.end.p0i8(i64 immarg, i8* nocapture) #1

; Function Attrs: nounwind ssp uwtable
define i32 @main() #0 {
; CHECK: start main 0:

entry:
; CHECK: [[REG:]] store 8 0 sp [[#SP:]]
  %filter = alloca [3 x [3 x i64]], align 16
  %0 = bitcast [3 x [3 x i64]]* %filter to i8*
  %1 = bitcast i8* %0 to [3 x [3 x i64]]*
  %2 = getelementptr inbounds [3 x [3 x i64]], [3 x [3 x i64]]* %1, i64 0, i64 0
  %3 = getelementptr inbounds [3 x i64], [3 x i64]* %2, i64 0, i64 1
  store i64 -1, i64* %3, align 8
  %4 = getelementptr inbounds [3 x i64], [3 x i64]* %2, i64 0, i64 2
  store i64 2, i64* %4, align 16
  %5 = getelementptr inbounds [3 x [3 x i64]], [3 x [3 x i64]]* %1, i64 0, i64 1
  %6 = getelementptr inbounds [3 x i64], [3 x i64]* %5, i64 0, i64 0
  store i64 -1, i64* %6, align 8
  %7 = getelementptr inbounds [3 x i64], [3 x i64]* %5, i64 0, i64 1
  store i64 1, i64* %7, align 8
  %8 = getelementptr inbounds [3 x i64], [3 x i64]* %5, i64 0, i64 2
  store i64 2, i64* %8, align 8
  %9 = getelementptr inbounds [3 x [3 x i64]], [3 x [3 x i64]]* %1, i64 0, i64 2
  %10 = getelementptr inbounds [3 x i64], [3 x i64]* %9, i64 0, i64 0
  store i64 1, i64* %10, align 16
  %call = call i64 (...) @read()
  %call1 = call i64 (...) @read()
  %mul = mul i64 8, %call
  %mul2 = mul i64 %mul, %call1
  %call3 = call i8* @malloc(i64 %mul2) #4
  %11 = bitcast i8* %call3 to i64*
  %mul4 = mul i64 8, %call
  %mul5 = mul i64 %mul4, %call1
  %call6 = call i8* @malloc(i64 %mul5) #4
  %12 = bitcast i8* %call6 to i64*
  br label %for.cond

for.cond:                                         ; preds = %for.inc16, %entry
  %i.0 = phi i64 [ 0, %entry ], [ %inc17, %for.inc16 ]
  %cmp = icmp slt i64 %i.0, %call
  br i1 %cmp, label %for.body, label %for.cond.cleanup

for.cond.cleanup:                                 ; preds = %for.cond
  br label %for.end18

for.body:                                         ; preds = %for.cond
; CHECK: [[REG:]] store 8 0 sp [[#SP:]]
  br label %for.cond7

for.cond7:                                        ; preds = %for.inc, %for.body
  %j.0 = phi i64 [ 0, %for.body ], [ %inc, %for.inc ]
  %cmp8 = icmp slt i64 %j.0, %call1
  br i1 %cmp8, label %for.body10, label %for.cond.cleanup9

for.cond.cleanup9:                                ; preds = %for.cond7
  br label %for.end

for.body10:                                       ; preds = %for.cond7
  %call11 = call i64 (...) @read()
  %mul12 = mul nsw i64 %i.0, %call1
  %add = add nsw i64 %mul12, %j.0
  %arrayidx = getelementptr inbounds i64, i64* %11, i64 %add
  store i64 %call11, i64* %arrayidx, align 8
  %mul13 = mul nsw i64 %i.0, %call1
  %add14 = add nsw i64 %mul13, %j.0
  %arrayidx15 = getelementptr inbounds i64, i64* %12, i64 %add14
  store i64 0, i64* %arrayidx15, align 8
  br label %for.inc

for.inc:                                          ; preds = %for.body10
  %inc = add nsw i64 %j.0, 1
  br label %for.cond7

for.end:                                          ; preds = %for.cond.cleanup9
  br label %for.inc16

for.inc16:                                        ; preds = %for.end
  %inc17 = add nsw i64 %i.0, 1
  br label %for.cond

for.end18:                                        ; preds = %for.cond.cleanup
; CHECK: [[REG:]] store 8 0 sp [[#SP:]]
  %arraydecay = getelementptr inbounds [3 x [3 x i64]], [3 x [3 x i64]]* %filter, i64 0, i64 0
  call void @convolution(i64 %call, i64 %call1, i64* %11, i64* %12, [3 x i64]* %arraydecay)
  br label %for.cond20

for.cond20:                                       ; preds = %for.inc35, %for.end18
  %i19.0 = phi i64 [ 0, %for.end18 ], [ %inc36, %for.inc35 ]
  %cmp21 = icmp slt i64 %i19.0, %call
  br i1 %cmp21, label %for.body23, label %for.cond.cleanup22

for.cond.cleanup22:                               ; preds = %for.cond20
  br label %for.end37

for.body23:                                       ; preds = %for.cond20
  br label %for.cond25

for.cond25:                                       ; preds = %for.inc32, %for.body23
  %j24.0 = phi i64 [ 0, %for.body23 ], [ %inc33, %for.inc32 ]
  %cmp26 = icmp slt i64 %j24.0, %call1
  br i1 %cmp26, label %for.body28, label %for.cond.cleanup27

for.cond.cleanup27:                               ; preds = %for.cond25
  br label %for.end34

for.body28:                                       ; preds = %for.cond25
  %mul29 = mul nsw i64 %i19.0, %call1
  %add30 = add nsw i64 %mul29, %j24.0
  %arrayidx31 = getelementptr inbounds i64, i64* %12, i64 %add30
  %13 = load i64, i64* %arrayidx31, align 8
  call void @write(i64 %13)
  br label %for.inc32

for.inc32:                                        ; preds = %for.body28
  %inc33 = add nsw i64 %j24.0, 1
  br label %for.cond25

for.end34:                                        ; preds = %for.cond.cleanup27
  br label %for.inc35

for.inc35:                                        ; preds = %for.end34
  %inc36 = add nsw i64 %i19.0, 1
  br label %for.cond20

for.end37:                                        ; preds = %for.cond.cleanup22
  ret i32 0
}
; CHECK: end main

declare i64 @read(...) #2

; Function Attrs: allocsize(0)
declare i8* @malloc(i64) #3

declare void @write(i64) #2

attributes #0 = { nounwind ssp uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="penryn" "target-features"="+cx16,+cx8,+fxsr,+mmx,+sahf,+sse,+sse2,+sse3,+sse4.1,+ssse3,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { argmemonly nounwind willreturn }
attributes #2 = { "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="penryn" "target-features"="+cx16,+cx8,+fxsr,+mmx,+sahf,+sse,+sse2,+sse3,+sse4.1,+ssse3,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #3 = { allocsize(0) "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="penryn" "target-features"="+cx16,+cx8,+fxsr,+mmx,+sahf,+sse,+sse2,+sse3,+sse4.1,+ssse3,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #4 = { allocsize(0) }

!llvm.module.flags = !{!0, !1, !2}
!llvm.ident = !{!3}

!0 = !{i32 2, !"SDK Version", [2 x i32] [i32 10, i32 14]}
!1 = !{i32 1, !"wchar_size", i32 4}
!2 = !{i32 7, !"PIC Level", i32 2}
!3 = !{!"clang version 10.0.1 (https://github.com/llvm/llvm-project 92d5c1be9ee93850c0a8903f05f36a23ee835dc2)"}
