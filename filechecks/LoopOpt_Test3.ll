; ModuleID = '/tmp/a.ll'
source_filename = "../swpp202001-team4/licmtest3.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

; Function Attrs: nounwind uwtable
define dso_local void @test1() #0 {
; CHECK:      start test1 0:
; CHECK-NEXT:   .entry:
; CHECK-NEXT:     ; init sp!
; CHECK-NEXT:     sp = sub sp 816 64
; CHECK-NEXT:     r11 = add sp 16 64
; CHECK-NEXT:     store 8 0 sp 0
; CHECK-NEXT:     r10 = mul r11 1 64
; CHECK-NEXT:     br .for.cond
; CHECK:        .for.cond:
; CHECK-NEXT:     r1 = load 8 sp 0
; CHECK-NEXT:     r2 = mul r10 1 64
; CHECK-NEXT:     r12 = icmp ne r1 100 64
; CHECK-NEXT:     store 8 0 sp 8
; CHECK-NEXT:     r9 = mul r11 1 64
; CHECK-NEXT:     br r12 .for.body .for.cond1
; CHECK:        .for.body:
; CHECK-NEXT:     store 8 r1 r2 0
; CHECK-NEXT:     r3 = add r1 1 64
; CHECK-NEXT:     r13 = add r10 8 64
; CHECK-NEXT:     store 8 r3 sp 0
; CHECK-NEXT:     r10 = mul r13 1 64
; CHECK-NEXT:     br .for.cond
; CHECK:        .for.cond1:
; CHECK-NEXT:     r5 = load 8 sp 8
; CHECK-NEXT:     r6 = mul r9 1 64
; CHECK-NEXT:     r7 = icmp ne r5 98 64
; CHECK-NEXT:     br r7 .for.body3 .for.end10
; CHECK:        .for.body3:
; CHECK-NEXT:     r14 = add r9 8 64
; CHECK-NEXT:     r8 = load 8 r14 0
; CHECK-NEXT:     r15 = add r9 16 64
; CHECK-NEXT:     store 8 r1 sp 0
; CHECK-NEXT:     r1 = load 8 r15 0
; CHECK-NEXT:     r8 = sub r8 r1 64
; CHECK-NEXT:     store 8 r8 r6 0
; CHECK-NEXT:     r16 = add r5 1 64
; CHECK-NEXT:     r2 = add r9 8 64
; CHECK-NEXT:     store 8 r16 sp 8
; CHECK-NEXT:     r9 = mul r2 1 64
; CHECK-NEXT:     br .for.cond1
; CHECK:        .for.end10:
; CHECK-NEXT:     ret 0
; CHECK-NEXT: end test1

entry:
  %a = alloca [100 x i64], align 16
  br label %for.cond

for.cond:                                         ; preds = %for.inc, %entry
  %i.0 = phi i64 [ 0, %entry ], [ %inc, %for.inc ]
  %cmp = icmp slt i64 %i.0, 100
  br i1 %cmp, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %arrayidx = getelementptr inbounds [100 x i64], [100 x i64]* %a, i64 0, i64 %i.0
  store i64 %i.0, i64* %arrayidx, align 8
  br label %for.inc

for.inc:                                          ; preds = %for.body
  %inc = add nsw i64 %i.0, 1
  br label %for.cond

for.end:                                          ; preds = %for.cond
  br label %for.cond1

for.cond1:                                        ; preds = %for.inc8, %for.end
  %i.1 = phi i64 [ 0, %for.end ], [ %inc9, %for.inc8 ]
  %cmp2 = icmp slt i64 %i.1, 98
  br i1 %cmp2, label %for.body3, label %for.end10

for.body3:                                        ; preds = %for.cond1
  %add = add nsw i64 %i.1, 1
  %arrayidx4 = getelementptr inbounds [100 x i64], [100 x i64]* %a, i64 0, i64 %add
  %0 = load i64, i64* %arrayidx4, align 8
  %add5 = add nsw i64 %i.1, 2
  %arrayidx6 = getelementptr inbounds [100 x i64], [100 x i64]* %a, i64 0, i64 %add5
  %1 = load i64, i64* %arrayidx6, align 8
  %sub = sub nsw i64 %0, %1
  %arrayidx7 = getelementptr inbounds [100 x i64], [100 x i64]* %a, i64 0, i64 %i.1
  store i64 %sub, i64* %arrayidx7, align 8
  br label %for.inc8

for.inc8:                                         ; preds = %for.body3
  %inc9 = add nsw i64 %i.1, 1
  br label %for.cond1

for.end10:                                        ; preds = %for.cond1
  ret void
}

; Function Attrs: argmemonly nounwind willreturn
declare void @llvm.lifetime.start.p0i8(i64 immarg, i8* nocapture) #1

; Function Attrs: argmemonly nounwind willreturn
declare void @llvm.lifetime.end.p0i8(i64 immarg, i8* nocapture) #1

; Function Attrs: nounwind uwtable
define dso_local void @test2() #0 {
; CHECK:      start test2 0:
; CHECK-NEXT:   .entry:
; CHECK-NEXT:     ; init sp!
; CHECK-NEXT:     sp = sub sp 1624 64
; CHECK-NEXT:     r1 = add sp 24 64
; CHECK-NEXT:     r2 = mul r1 1 64
; CHECK-NEXT:     r12 = add sp 824 64
; CHECK-NEXT:     store 8 0 sp 8
; CHECK-NEXT:     r10 = mul r12 1 64
; CHECK-NEXT:     br .for.cond
; CHECK:        .for.cond:
; CHECK-NEXT:     r3 = load 8 sp 8
; CHECK-NEXT:     r4 = mul r10 1 64
; CHECK-NEXT:     r5 = icmp ne r3 100 64
; CHECK-NEXT:     br r5 .for.body .for.end
; CHECK:        .for.body:
; CHECK-NEXT:     store 8 r3 r4 0
; CHECK-NEXT:     r6 = add r3 1 64
; CHECK-NEXT:     r13 = add r10 8 64
; CHECK-NEXT:     store 8 r6 sp 8
; CHECK-NEXT:     r10 = mul r13 1 64
; CHECK-NEXT:     br .for.cond
; CHECK:        .for.end:
; CHECK-NEXT:     r8 = mul r12 1 64
; CHECK-NEXT:     r1 = add r12 8 64
; CHECK-NEXT:     store 8 0 sp 16
; CHECK-NEXT:     r11 = mul r12 1 64
; CHECK-NEXT:     r9 = mul r2 1 64
; CHECK-NEXT:     br .for.cond1
; CHECK:        .for.cond1:
; CHECK-NEXT:     store 8 r2 sp 0
; CHECK-NEXT:     r2 = load 8 sp 16
; CHECK-NEXT:     store 8 r3 sp 8
; CHECK-NEXT:     r3 = mul r11 1 64
; CHECK-NEXT:     r4 = mul r9 1 64
; CHECK-NEXT:     r5 = icmp ne r2 100 64
; CHECK-NEXT:     br r5 .for.body3 .for.end12
; CHECK:        .for.body3:
; CHECK-NEXT:     r3 = load 8 r3 0
; CHECK-NEXT:     r8 = load 8 r8 0
; CHECK-NEXT:     r8 = mul r8 3 64
; CHECK-NEXT:     r3 = add r3 r8 64
; CHECK-NEXT:     r1 = load 8 r1 0
; CHECK-NEXT:     r1 = mul r1 5 64
; CHECK-NEXT:     r16 = add r3 r1 64
; CHECK-NEXT:     store 8 r16 r4 0
; CHECK-NEXT:     r15 = add r2 1 64
; CHECK-NEXT:     r14 = add r9 8 64
; CHECK-NEXT:     r6 = add r11 8 64
; CHECK-NEXT:     store 8 r15 sp 16
; CHECK-NEXT:     r11 = mul r6 1 64
; CHECK-NEXT:     r9 = mul r14 1 64
; CHECK-NEXT:     br .for.cond1
; CHECK:        .for.end12:
; CHECK-NEXT:     store 8 r2 sp 16
; CHECK-NEXT:     r2 = load 8 sp 0
; CHECK-NEXT:     r5 = mul r2 1 64
; CHECK-NEXT:     ret 0
; CHECK-NEXT: end test2

entry:
  %a = alloca [100 x i64], align 16
  %call = call noalias i8* @malloc(i64 800) #3
  %0 = bitcast i8* %call to i64*
  br label %for.cond

for.cond:                                         ; preds = %for.inc, %entry
  %i.0 = phi i64 [ 0, %entry ], [ %inc, %for.inc ]
  %cmp = icmp slt i64 %i.0, 100
  br i1 %cmp, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %arrayidx = getelementptr inbounds [100 x i64], [100 x i64]* %a, i64 0, i64 %i.0
  store i64 %i.0, i64* %arrayidx, align 8
  br label %for.inc

for.inc:                                          ; preds = %for.body
  %inc = add nsw i64 %i.0, 1
  br label %for.cond

for.end:                                          ; preds = %for.cond
  br label %for.cond1

for.cond1:                                        ; preds = %for.inc10, %for.end
  %i.1 = phi i64 [ 0, %for.end ], [ %inc11, %for.inc10 ]
  %cmp2 = icmp slt i64 %i.1, 100
  br i1 %cmp2, label %for.body3, label %for.end12

for.body3:                                        ; preds = %for.cond1
  %arrayidx4 = getelementptr inbounds [100 x i64], [100 x i64]* %a, i64 0, i64 %i.1
  %1 = load i64, i64* %arrayidx4, align 8
  %arrayidx5 = getelementptr inbounds [100 x i64], [100 x i64]* %a, i64 0, i64 0
  %2 = load i64, i64* %arrayidx5, align 16
  %mul = mul nsw i64 %2, 3
  %add = add nsw i64 %1, %mul
  %arrayidx6 = getelementptr inbounds [100 x i64], [100 x i64]* %a, i64 0, i64 1
  %3 = load i64, i64* %arrayidx6, align 8
  %mul7 = mul nsw i64 %3, 5
  %add8 = add nsw i64 %add, %mul7
  %arrayidx9 = getelementptr inbounds i64, i64* %0, i64 %i.1
  store i64 %add8, i64* %arrayidx9, align 8
  br label %for.inc10

for.inc10:                                        ; preds = %for.body3
  %inc11 = add nsw i64 %i.1, 1
  br label %for.cond1

for.end12:                                        ; preds = %for.cond1
  %4 = bitcast i64* %0 to i8*
  call void @free(i8* %4) #3
  ret void
}

; Function Attrs: nounwind
declare dso_local noalias i8* @malloc(i64) #2

; Function Attrs: nounwind
declare dso_local void @free(i8*) #2

; Function Attrs: nounwind uwtable
define dso_local i32 @main() #0 {
; CHECK:      start main 0:
; CHECK-NEXT:   .entry:
; CHECK-NEXT:     call test1
; CHECK-NEXT:     call test2
; CHECK-NEXT:     ret 0
; CHECK-NEXT: end main

entry:
  call void @test1()
  call void @test2()
  ret i32 0
}

attributes #0 = { nounwind uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="none" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { argmemonly nounwind willreturn }
attributes #2 = { nounwind "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="none" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #3 = { nounwind }

!llvm.module.flags = !{!0}
!llvm.ident = !{!1}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{!"clang version 10.0.1 (https://github.com/llvm/llvm-project.git 4b2f37b2202ebb5c6c05cf00026f506c52a62909)"}
