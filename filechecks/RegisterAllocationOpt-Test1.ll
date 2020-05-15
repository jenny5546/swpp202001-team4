define void @print_bit(i64 %x) #0 {
; CHECK:  start print_bit 1:
; CHECK:  .entry:
; CHECK-NEXT:    ; init sp!
; CHECK-NEXT:    sp = sub sp 8 64
; CHECK-NEXT:    store 8 63 sp 0
; CHECK-NEXT:    br .for.cond
; CHECK:  .for.cond:
; CHECK-NEXT:    r1 = load 8 sp 0
; CHECK-NEXT:    r15 = icmp sge r1 0 64
; CHECK-NEXT:    br r15 .for.body .for.cond.cleanup
; CHECK:  .for.body:
; CHECK-NEXT:    r14 = lshr arg1 r1 64
; CHECK-NEXT:    r13 = and r14 1 64
; CHECK-NEXT:    call write r13
; CHECK-NEXT:    br .for.inc
; CHECK:  .for.cond.cleanup:
; CHECK-NEXT:    br .for.end
; CHECK:  .for.inc:
; CHECK-NEXT:    r12 = add r1 18446744073709551615 64
; CHECK-NEXT:    store 8 r12 sp 0
; CHECK-NEXT:    br .for.cond
; CHECK:  .for.end:
; CHECK-NEXT:    call write 10
; CHECK-NEXT:    ret 0
entry:
  br label %for.cond

for.cond:                                         ; preds = %for.inc, %entry
  %i1.0 = phi i64 [ 63, %entry ], [ %dec, %for.inc ]
  %cmp = icmp sge i64 %i1.0, 0
  br i1 %cmp, label %for.body, label %for.cond.cleanup

for.cond.cleanup:                                 ; preds = %for.cond
  br label %for.end

for.body:                                         ; preds = %for.cond
  %shr = lshr i64 %x, %i1.0
  %and = and i64 %shr, 1
  call void @write(i64 %and)
  br label %for.inc

for.inc:                                          ; preds = %for.body
  %dec = add i64 %i1.0, -1
  br label %for.cond

for.end:                                          ; preds = %for.cond.cleanup
  call void @write(i64 10)
  ret void
}
; CHECK: end print_bit

define i32 @main() #0 {
; CHECK: start main 0:
; CHECK:   .entry:
; CHECK-NEXT:     r16 = call read
; CHECK-NEXT:     call print_bit r16
; CHECK-NEXT:     ret 0
entry:
  %call = call i64 (...) @read()
  call void @print_bit(i64 %call)
  ret i32 0
}
; CHECK: end main

declare i64 @read(...) #2
declare void @write(i64) #2