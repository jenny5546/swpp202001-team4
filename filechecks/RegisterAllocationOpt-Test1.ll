define void @print_bit(i64 %x) #0 {
; CHECK:  start print_bit 1:

entry:
; CHECK:    sp = sub sp [[#SP:]] 64
; CHECK-NEXT:    store 8 63 sp [[#SPPHI:]]
  br label %for.cond

for.cond:                                         ; preds = %for.inc, %entry
; CHECK:    [[REG:r[0-9]+]] = load 8 sp [[#SPPHI:]]
; CHECK-NEXT:    [[REG2:]] = icmp sge [[REG]] 0 64
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

define i32 @main() #0 {
; CHECK: start main 0:
; CHECK:     [[REG:r[0-9]+]] = call read
; CHECK-NEXT:     call print_bit [[REG]]
; CHECK-NEXT:     ret 0
entry:
  %call = call i64 (...) @read()
  call void @print_bit(i64 %call)
  ret i32 0
}

declare i64 @read(...) #2
declare void @write(i64) #2