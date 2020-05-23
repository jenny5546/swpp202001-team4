; ModuleID = '/tmp/a.ll'
source_filename = "custom/test4.c"
target datalayout = "e-m:o-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-apple-macosx10.14.0"

; Function Attrs: nounwind ssp uwtable
define i32 @main() #0 {
; CHECK: start main 0:
; CHECK:   .entry:
; CHECK-NEXT:     ; init sp!
; CHECK-NEXT:     sp = sub sp 24 64
; CHECK-NEXT:     store 8 0 sp 0
; CHECK-NEXT:     store 8 0 sp 8
; CHECK-NEXT:     br .for.cond
; CHECK:   .for.cond:
; CHECK-NEXT:     r1 = load 8 sp 0
; CHECK-NEXT:     r3 = load 8 sp 8
; CHECK-NEXT:     r6 = icmp ult r1 10 64
; CHECK-NEXT:     r9 = mul r1 1 64
; CHECK-NEXT:     r15 = mul r3 1 64
; CHECK-NEXT:     br r6 .for.cond1 .for.end28
; CHECK:   .for.cond1:
; CHECK-NEXT:     r8 = icmp ult r9 10 64
; CHECK-NEXT:     r1 = load 8 sp 0
; CHECK-NEXT:     r11 = mul r1 1 64
; CHECK-NEXT:     r13 = mul r15 1 64
; CHECK-NEXT:     br r8 .for.cond4 .for.inc26
; CHECK:   .for.end28:
; CHECK-NEXT:     r3 = load 8 sp 8
; CHECK-NEXT:     call write r3
; CHECK-NEXT:     ret 0
; CHECK:   .for.cond4:
; CHECK-NEXT:     r4 = icmp ult r11 r9 64
; CHECK-NEXT:     store 8 10000000 sp 16
; CHECK-NEXT:     r14 = mul r13 1 64
; CHECK-NEXT:     br r4 .for.cond7 .for.inc23
; CHECK:   .for.inc26:
; CHECK-NEXT:     r1 = load 8 sp 0
; CHECK-NEXT:     r16 = add r1 1 64
; CHECK-NEXT:     store 8 r16 sp 0
; CHECK-NEXT:     store 8 r15 sp 8
; CHECK-NEXT:     br .for.cond
; CHECK:   .for.cond7:
; CHECK-NEXT:     r7 = load 8 sp 16
; CHECK-NEXT:     r2 = icmp ult r7 10005000 64
; CHECK-NEXT:     br r2 .for.body9 .for.inc20
; CHECK:   .for.inc23:
; CHECK-NEXT:     r5 = add r9 1 64
; CHECK-NEXT:     r9 = mul r5 1 64
; CHECK-NEXT:     r15 = mul r13 1 64
; CHECK-NEXT:     br .for.cond1
; CHECK:   .for.body9:
; CHECK-NEXT:     store 8 r1 sp 0
; CHECK-NEXT:     r7 = load 8 sp 16
; CHECK-NEXT:     r1 = sub r7 100 64
; CHECK-NEXT:     r10 = mul r1 1 64
; CHECK-NEXT:     r12 = mul r14 1 64
; CHECK-NEXT:     br .for.cond10
; CHECK:   .for.inc20:
; CHECK-NEXT:     store 8 r3 sp 8
; CHECK-NEXT:     r3 = add r11 1 64
; CHECK-NEXT:     r11 = mul r3 1 64
; CHECK-NEXT:     r13 = mul r14 1 64
; CHECK-NEXT:     br .for.cond4
; CHECK:   .for.cond10:
; CHECK-NEXT:     r7 = load 8 sp 16
; CHECK-NEXT:     r6 = icmp ult r10 r7 64
; CHECK-NEXT:     br r6 .for.body12 .for.inc17
; CHECK:   .for.body12:
; CHECK-NEXT:     r8 = load 8 sp 0
; CHECK-NEXT:     r4 = add r8 r9 64
; CHECK-NEXT:     r4 = add r4 r11 64
; CHECK-NEXT:     r7 = load 8 sp 16
; CHECK-NEXT:     r4 = add r4 r7 64
; CHECK-NEXT:     r4 = add r4 r10 64
; CHECK-NEXT:     r4 = add r12 r4 64
; CHECK-NEXT:     store 8 r7 sp 16
; CHECK-NEXT:     r7 = add r10 1 64
; CHECK-NEXT:     r10 = mul r7 1 64
; CHECK-NEXT:     r12 = mul r4 1 64
; CHECK-NEXT:     br .for.cond10
; CHECK:   .for.inc17:
; CHECK-NEXT:     r2 = load 8 sp 16
; CHECK-NEXT:     r5 = add r2 1 64
; CHECK-NEXT:     store 8 r5 sp 16
; CHECK-NEXT:     r14 = mul r12 1 64
; CHECK-NEXT:     br .for.cond7
entry:
  br label %for.cond

for.cond:                                         ; preds = %for.inc26, %entry
  %a.0 = phi i64 [ 0, %entry ], [ %inc27, %for.inc26 ]
  %f.0 = phi i64 [ 0, %entry ], [ %f.1, %for.inc26 ]
  %cmp = icmp ult i64 %a.0, 10
  br i1 %cmp, label %for.body, label %for.end28

for.body:                                         ; preds = %for.cond
  br label %for.cond1

for.cond1:                                        ; preds = %for.inc23, %for.body
  %b.0 = phi i64 [ %a.0, %for.body ], [ %inc24, %for.inc23 ]
  %f.1 = phi i64 [ %f.0, %for.body ], [ %f.2, %for.inc23 ]
  %cmp2 = icmp ult i64 %b.0, 10
  br i1 %cmp2, label %for.body3, label %for.end25

for.body3:                                        ; preds = %for.cond1
  br label %for.cond4

for.cond4:                                        ; preds = %for.inc20, %for.body3
  %c.0 = phi i64 [ %a.0, %for.body3 ], [ %inc21, %for.inc20 ]
  %f.2 = phi i64 [ %f.1, %for.body3 ], [ %f.3, %for.inc20 ]
  %cmp5 = icmp ult i64 %c.0, %b.0
  br i1 %cmp5, label %for.body6, label %for.end22

for.body6:                                        ; preds = %for.cond4
  br label %for.cond7

for.cond7:                                        ; preds = %for.inc17, %for.body6
  %d.0 = phi i64 [ 10000000, %for.body6 ], [ %inc18, %for.inc17 ]
  %f.3 = phi i64 [ %f.2, %for.body6 ], [ %f.4, %for.inc17 ]
  %cmp8 = icmp ult i64 %d.0, 10005000
  br i1 %cmp8, label %for.body9, label %for.end19

for.body9:                                        ; preds = %for.cond7
  %sub = sub i64 %d.0, 100
  br label %for.cond10

for.cond10:                                       ; preds = %for.inc, %for.body9
  %e.0 = phi i64 [ %sub, %for.body9 ], [ %inc, %for.inc ]
  %f.4 = phi i64 [ %f.3, %for.body9 ], [ %add16, %for.inc ]
  %cmp11 = icmp ult i64 %e.0, %d.0
  br i1 %cmp11, label %for.body12, label %for.end

for.body12:                                       ; preds = %for.cond10
  %add = add i64 %a.0, %b.0
  %add13 = add i64 %add, %c.0
  %add14 = add i64 %add13, %d.0
  %add15 = add i64 %add14, %e.0
  %add16 = add i64 %f.4, %add15
  br label %for.inc

for.inc:                                          ; preds = %for.body12
  %inc = add i64 %e.0, 1
  br label %for.cond10

for.end:                                          ; preds = %for.cond10
  br label %for.inc17

for.inc17:                                        ; preds = %for.end
  %inc18 = add i64 %d.0, 1
  br label %for.cond7

for.end19:                                        ; preds = %for.cond7
  br label %for.inc20

for.inc20:                                        ; preds = %for.end19
  %inc21 = add i64 %c.0, 1
  br label %for.cond4

for.end22:                                        ; preds = %for.cond4
  br label %for.inc23

for.inc23:                                        ; preds = %for.end22
  %inc24 = add i64 %b.0, 1
  br label %for.cond1

for.end25:                                        ; preds = %for.cond1
  br label %for.inc26

for.inc26:                                        ; preds = %for.end25
  %inc27 = add i64 %a.0, 1
  br label %for.cond

for.end28:                                        ; preds = %for.cond
  call void @write(i64 %f.0)
  ret i32 0
}
; CHECK: end main

; Function Attrs: argmemonly nounwind willreturn
declare void @llvm.lifetime.start.p0i8(i64 immarg, i8* nocapture) #1

declare void @write(i64) #2

; Function Attrs: argmemonly nounwind willreturn
declare void @llvm.lifetime.end.p0i8(i64 immarg, i8* nocapture) #1

attributes #0 = { nounwind ssp uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="penryn" "target-features"="+cx16,+cx8,+fxsr,+mmx,+sahf,+sse,+sse2,+sse3,+sse4.1,+ssse3,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { argmemonly nounwind willreturn }
attributes #2 = { "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="penryn" "target-features"="+cx16,+cx8,+fxsr,+mmx,+sahf,+sse,+sse2,+sse3,+sse4.1,+ssse3,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }

!llvm.module.flags = !{!0, !1, !2}
!llvm.ident = !{!3}

!0 = !{i32 2, !"SDK Version", [2 x i32] [i32 10, i32 14]}
!1 = !{i32 1, !"wchar_size", i32 4}
!2 = !{i32 7, !"PIC Level", i32 2}
!3 = !{!"clang version 10.0.1 (https://github.com/llvm/llvm-project 92d5c1be9ee93850c0a8903f05f36a23ee835dc2)"}
