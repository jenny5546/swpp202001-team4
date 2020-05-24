; ModuleID = '/tmp/a.ll'
source_filename = "../swpp202001-team4/Malloc2AllocinMain_Test3.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

; Function Attrs: nounwind uwtable
define dso_local void @test1(i64* %ptr1) #0 {
; CHECK:      start test1 1:
; CHECK-NEXT:   .entry:
; CHECK-NEXT:     ; init sp!
; CHECK-NEXT:     sp = sub sp 8 64
; CHECK-NEXT:     store 8 0 sp 0
; CHECK-NEXT:     r10 = mul arg1 1 64
; CHECK-NEXT:     br .for.cond
; CHECK:        .for.cond:
; CHECK-NEXT:     r1 = load 8 sp 0
; CHECK-NEXT:     r11 = icmp ne r1 10 32
; CHECK-NEXT:     br r11 .for.body .for.end
; CHECK:        .for.body:
; CHECK-NEXT:     r14 = load 8 r10 0
; CHECK-NEXT:     call write r14
; CHECK-NEXT:     r13 = add r1 1 32
; CHECK-NEXT:     r12 = add r10 8 64
; CHECK-NEXT:     store 8 r13 sp 0
; CHECK-NEXT:     r10 = mul r12 1 64
; CHECK-NEXT:     br .for.cond
; CHECK:        .for.end:
; CHECK-NEXT:     r2 = mul arg1 1 64
; CHECK-NEXT:     ret 0
; CHECK-NEXT: end test1

entry:
  br label %for.cond

for.cond:                                         ; preds = %for.inc, %entry
  %i.0 = phi i32 [ 0, %entry ], [ %inc, %for.inc ]
  %cmp = icmp slt i32 %i.0, 10
  br i1 %cmp, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %idxprom = sext i32 %i.0 to i64
  %arrayidx = getelementptr inbounds i64, i64* %ptr1, i64 %idxprom
  %0 = load i64, i64* %arrayidx, align 8
  call void @write(i64 %0)
  br label %for.inc

for.inc:                                          ; preds = %for.body
  %inc = add nsw i32 %i.0, 1
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %1 = bitcast i64* %ptr1 to i8*
  call void @free(i8* %1) #4
  ret void
}

; Function Attrs: argmemonly nounwind willreturn
declare void @llvm.lifetime.start.p0i8(i64 immarg, i8* nocapture) #1

declare dso_local void @write(i64) #2

; Function Attrs: nounwind
declare dso_local void @free(i8*) #3

; Function Attrs: argmemonly nounwind willreturn
declare void @llvm.lifetime.end.p0i8(i64 immarg, i8* nocapture) #1

; Function Attrs: nounwind uwtable
define dso_local void @test2(i64* %ptr2) #0 {
; CHECK:      start test2 1:
; CHECK-NEXT:   .entry:
; CHECK-NEXT:     ; init sp!
; CHECK-NEXT:     sp = sub sp 8 64
; CHECK-NEXT:     store 8 0 sp 0
; CHECK-NEXT:     r11 = mul arg1 1 64
; CHECK-NEXT:     br .for.cond
; CHECK:        .for.cond:
; CHECK-NEXT:     r1 = load 8 sp 0
; CHECK-NEXT:     r15 = icmp ne r1 10 32
; CHECK-NEXT:     br r15 .for.body .for.end
; CHECK:        .for.body:
; CHECK-NEXT:     r13 = load 8 r11 0
; CHECK-NEXT:     call write r13
; CHECK-NEXT:     r12 = add r1 1 32
; CHECK-NEXT:     r14 = add r11 8 64
; CHECK-NEXT:     store 8 r12 sp 0
; CHECK-NEXT:     r11 = mul r14 1 64
; CHECK-NEXT:     br .for.cond
; CHECK:        .for.end:
; CHECK-NEXT:     ret 0
; CHECK-NEXT: end test2

entry:
  br label %for.cond

for.cond:                                         ; preds = %for.inc, %entry
  %i.0 = phi i32 [ 0, %entry ], [ %inc, %for.inc ]
  %cmp = icmp slt i32 %i.0, 10
  br i1 %cmp, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %idxprom = sext i32 %i.0 to i64
  %arrayidx = getelementptr inbounds i64, i64* %ptr2, i64 %idxprom
  %0 = load i64, i64* %arrayidx, align 8
  call void @write(i64 %0)
  br label %for.inc

for.inc:                                          ; preds = %for.body
  %inc = add nsw i32 %i.0, 1
  br label %for.cond

for.end:                                          ; preds = %for.cond
  ret void
}

; Function Attrs: nounwind uwtable
define dso_local i32 @main() #0 {
; CHECK: start main 0:
; CHECK-NEXT:   .entry:
; CHECK-NEXT:     ; init sp!
; CHECK-NEXT:     sp = sub sp 168 64
; CHECK-NEXT:     r15 = add sp 8 64
; CHECK-NEXT:     r1 = mul r15 1 64
; CHECK-NEXT:     r16 = add sp 88 64
; CHECK-NEXT:     r2 = mul r16 1 64
; CHECK-NEXT:     store 8 0 sp 0
; CHECK-NEXT:     r9 = mul r2 1 64
; CHECK-NEXT:     r10 = mul r1 1 64
; CHECK-NEXT:     br .for.cond
; CHECK:        .for.cond:
; CHECK-NEXT:     r3 = load 8 sp 0
; CHECK-NEXT:     r4 = mul r9 1 64
; CHECK-NEXT:     r5 = mul r10 1 64
; CHECK-NEXT:     r13 = icmp ne r3 10 64
; CHECK-NEXT:     br r13 .for.body .for.end
; CHECK:        .for.body:
; CHECK-NEXT:     store 8 r3 r4 0
; CHECK-NEXT:     r11 = add r3 1 64
; CHECK-NEXT:     store 8 r11 r5 0
; CHECK-NEXT:     r14 = add r10 8 64
; CHECK-NEXT:     r12 = add r9 8 64
; CHECK-NEXT:     store 8 r11 sp 0
; CHECK-NEXT:     r9 = mul r12 1 64
; CHECK-NEXT:     r10 = mul r14 1 64
; CHECK-NEXT:     br .for.cond
; CHECK:        .for.end:
; CHECK-NEXT:     call test1 r2
; CHECK-NEXT:     call test2 r1
; CHECK-NEXT:     ret 0
; CHECK-NEXT: end main


entry:
  %call = call noalias i8* @malloc(i64 80) #4
  %0 = bitcast i8* %call to i64*
  %call1 = call noalias i8* @malloc(i64 80) #4
  %1 = bitcast i8* %call1 to i64*
  br label %for.cond

for.cond:                                         ; preds = %for.inc, %entry
  %i.0 = phi i32 [ 0, %entry ], [ %inc, %for.inc ]
  %cmp = icmp slt i32 %i.0, 10
  br i1 %cmp, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %conv = sext i32 %i.0 to i64
  %idxprom = sext i32 %i.0 to i64
  %arrayidx = getelementptr inbounds i64, i64* %0, i64 %idxprom
  store i64 %conv, i64* %arrayidx, align 8
  %add = add nsw i32 %i.0, 1
  %conv2 = sext i32 %add to i64
  %idxprom3 = sext i32 %i.0 to i64
  %arrayidx4 = getelementptr inbounds i64, i64* %1, i64 %idxprom3
  store i64 %conv2, i64* %arrayidx4, align 8
  br label %for.inc

for.inc:                                          ; preds = %for.body
  %inc = add nsw i32 %i.0, 1
  br label %for.cond

for.end:                                          ; preds = %for.cond
  call void @test1(i64* %0)
  call void @test2(i64* %1)
  ret i32 0
}

; Function Attrs: nounwind
declare dso_local noalias i8* @malloc(i64) #3

attributes #0 = { nounwind uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="none" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { argmemonly nounwind willreturn }
attributes #2 = { "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="none" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #3 = { nounwind "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="none" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #4 = { nounwind }

!llvm.module.flags = !{!0}
!llvm.ident = !{!1}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{!"clang version 10.0.1 (https://github.com/llvm/llvm-project.git 4b2f37b2202ebb5c6c05cf00026f506c52a62909)"}
