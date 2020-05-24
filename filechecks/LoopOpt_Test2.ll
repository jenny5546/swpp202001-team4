; ModuleID = '/tmp/a.ll'
source_filename = "../swpp202001-team4/licmtest2.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

; Function Attrs: nounwind uwtable
define dso_local void @test1(i64 %n) #0 {
; CHECK:      start test1 1:
; CHECK-NEXT:   .entry:
; CHECK-NEXT:     ; init sp!
; CHECK-NEXT:     sp = sub sp 8 64
; CHECK-NEXT:     store 8 5 sp 0
; CHECK-NEXT:     br .for.cond
; CHECK:        .for.cond:
; CHECK-NEXT:     r1 = load 8 sp 0
; CHECK-NEXT:     r15 = icmp ne r1 13 64
; CHECK-NEXT:     br r15 .for.body .for.end
; CHECK:        .for.body:
; CHECK-NEXT:     call write arg1
; CHECK-NEXT:     r14 = add r1 1 64
; CHECK-NEXT:     store 8 r14 sp 0
; CHECK-NEXT:     br .for.cond
; CHECK:        .for.end:
; CHECK-NEXT:     ret 0
; CHECK-NEXT: end test1

entry:
  br label %for.cond

for.cond:                                         ; preds = %for.inc, %entry
  %i.0 = phi i64 [ 5, %entry ], [ %inc, %for.inc ]
  %mul = mul nsw i64 %i.0, %i.0
  %mul1 = mul nsw i64 %i.0, 3
  %add = add nsw i64 %mul, %mul1
  %cmp = icmp slt i64 %add, 200
  br i1 %cmp, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  call void @write(i64 %n)
  br label %for.inc

for.inc:                                          ; preds = %for.body
  %inc = add nsw i64 %i.0, 1
  br label %for.cond

for.end:                                          ; preds = %for.cond
  ret void
}

; Function Attrs: argmemonly nounwind willreturn
declare void @llvm.lifetime.start.p0i8(i64 immarg, i8* nocapture) #1

declare dso_local void @write(i64) #2

; Function Attrs: argmemonly nounwind willreturn
declare void @llvm.lifetime.end.p0i8(i64 immarg, i8* nocapture) #1

; Function Attrs: nounwind uwtable
define dso_local void @test2() #0 {
; CHECK:      start test2 0:
; CHECK-NEXT:   .entry:
; CHECK-NEXT:     ret 0
; CHECK-NEXT: end test2
entry:
  br label %for.cond

for.cond:                                         ; preds = %for.inc, %entry
  %i.0 = phi i64 [ 0, %entry ], [ %inc, %for.inc ]
  %cmp = icmp slt i64 %i.0, 100
  br i1 %cmp, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  br label %for.inc

for.inc:                                          ; preds = %for.body
  %inc = add nsw i64 %i.0, 1
  br label %for.cond

for.end:                                          ; preds = %for.cond
  ret void
}

; Function Attrs: nounwind uwtable
define dso_local i32 @main() #0 {
; CHECK:      start main 0:
; CHECK-NEXT:   .entry:
; CHECK-NEXT:     r16 = call read
; CHECK-NEXT:     call test1 r16
; CHECK-NEXT:     call test2
; CHECK-NEXT:     ret 0
; CHECK-NEXT: end main

entry:
  %call = call i64 (...) @read()
  call void @test1(i64 %call)
  call void @test2()
  ret i32 0
}

declare dso_local i64 @read(...) #2

attributes #0 = { nounwind uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="none" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { argmemonly nounwind willreturn }
attributes #2 = { "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="none" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }

!llvm.module.flags = !{!0}
!llvm.ident = !{!1}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{!"clang version 10.0.1 (https://github.com/llvm/llvm-project.git 4b2f37b2202ebb5c6c05cf00026f506c52a62909)"}
