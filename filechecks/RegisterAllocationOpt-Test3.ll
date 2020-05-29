define i32 @main() #0 {

entry:
  %call = call i64 (...) @read()
; CHECK: [[REG:]] store 8 0 sp [[#SP:]]
; CHECK-NEXT: [[REG:]] store 8 0 sp [[#SP:]]
; CHECK-NEXT: [[REG:]] store 8 0 sp [[#SP:]]
; CHECK-NEXT: [[REG:]] store 8 0 sp [[#SP:]]
; CHECK-NEXT: [[REG:]] store 8 0 sp [[#SP:]]
; CHECK-NEXT: [[REG:]] store 8 0 sp [[#SP:]]
; CHECK-NEXT: [[REG:]] store 8 0 sp [[#SP:]]
; CHECK-NEXT: [[REG:]] store 8 0 sp [[#SP:]]
; CHECK-NEXT: [[REG:]] store 8 0 sp [[#SP:]]
; CHECK-NEXT: [[REG:]] store 8 0 sp [[#SP:]]
; CHECK-NEXT: [[REG:]] store 8 0 sp [[#SP:]]
  br label %for.cond

for.cond:                                         ; preds = %for.inc, %entry
; CHECK: [[REG:]] =  load 8 sp [[#SP:]]
  %a0.0 = phi i64 [ 0, %entry ], [ %add, %for.inc ]
  %a1.0 = phi i64 [ 0, %entry ], [ %add1, %for.inc ]
  %a2.0 = phi i64 [ 0, %entry ], [ %add2, %for.inc ]
  %a3.0 = phi i64 [ 0, %entry ], [ %add3, %for.inc ]
  %a4.0 = phi i64 [ 0, %entry ], [ %add4, %for.inc ]
  %a5.0 = phi i64 [ 0, %entry ], [ %add5, %for.inc ]
  %a6.0 = phi i64 [ 0, %entry ], [ %add6, %for.inc ]
  %a7.0 = phi i64 [ 0, %entry ], [ %add7, %for.inc ]
  %a8.0 = phi i64 [ 0, %entry ], [ %add8, %for.inc ]
  %a9.0 = phi i64 [ 0, %entry ], [ %add9, %for.inc ]
  %a10.0 = phi i64 [ 0, %entry ], [ %add10, %for.inc ]
  %a11.0 = phi i64 [ 0, %entry ], [ %add11, %for.inc ]
  %a12.0 = phi i64 [ 0, %entry ], [ %add12, %for.inc ]
  %a13.0 = phi i64 [ 0, %entry ], [ %add13, %for.inc ]
  %a14.0 = phi i64 [ 0, %entry ], [ %add14, %for.inc ]
  %a15.0 = phi i64 [ 0, %entry ], [ %add15, %for.inc ]
  %a16.0 = phi i64 [ 0, %entry ], [ %add16, %for.inc ]
  %a17.0 = phi i64 [ 0, %entry ], [ %add17, %for.inc ]
  %a18.0 = phi i64 [ 0, %entry ], [ %add18, %for.inc ]
  %a19.0 = phi i64 [ 0, %entry ], [ %add19, %for.inc ]
  %a20.0 = phi i64 [ 0, %entry ], [ %add20, %for.inc ]
  %a21.0 = phi i64 [ 0, %entry ], [ %add21, %for.inc ]
  %a22.0 = phi i64 [ 0, %entry ], [ %add22, %for.inc ]
  %a23.0 = phi i64 [ 0, %entry ], [ %add23, %for.inc ]
  %a24.0 = phi i64 [ 0, %entry ], [ %add24, %for.inc ]
  %a25.0 = phi i64 [ 0, %entry ], [ %add25, %for.inc ]
  %a26.0 = phi i64 [ 0, %entry ], [ %add26, %for.inc ]
  %a27.0 = phi i64 [ 0, %entry ], [ %add27, %for.inc ]
  %a28.0 = phi i64 [ 0, %entry ], [ %add28, %for.inc ]
  %a29.0 = phi i64 [ 0, %entry ], [ %add29, %for.inc ]
  %a30.0 = phi i64 [ 0, %entry ], [ %add30, %for.inc ]
  %a31.0 = phi i64 [ 0, %entry ], [ %add31, %for.inc ]
  %a32.0 = phi i64 [ 0, %entry ], [ %add32, %for.inc ]
  %a33.0 = phi i64 [ 0, %entry ], [ %add33, %for.inc ]
  %a34.0 = phi i64 [ 0, %entry ], [ %add34, %for.inc ]
  %a35.0 = phi i64 [ 0, %entry ], [ %add35, %for.inc ]
  %a36.0 = phi i64 [ 0, %entry ], [ %add36, %for.inc ]
  %a37.0 = phi i64 [ 0, %entry ], [ %add37, %for.inc ]
  %a38.0 = phi i64 [ 0, %entry ], [ %add38, %for.inc ]
  %a39.0 = phi i64 [ 0, %entry ], [ %add39, %for.inc ]
  %a40.0 = phi i64 [ 0, %entry ], [ %add40, %for.inc ]
  %a41.0 = phi i64 [ 0, %entry ], [ %add41, %for.inc ]
  %a42.0 = phi i64 [ 0, %entry ], [ %add42, %for.inc ]
  %a43.0 = phi i64 [ 0, %entry ], [ %add43, %for.inc ]
  %a44.0 = phi i64 [ 0, %entry ], [ %add44, %for.inc ]
  %a45.0 = phi i64 [ 0, %entry ], [ %add45, %for.inc ]
  %a46.0 = phi i64 [ 0, %entry ], [ %add46, %for.inc ]
  %a47.0 = phi i64 [ 0, %entry ], [ %add47, %for.inc ]
  %a48.0 = phi i64 [ 0, %entry ], [ %add48, %for.inc ]
  %a49.0 = phi i64 [ 0, %entry ], [ %add49, %for.inc ]
  %i.0 = phi i32 [ 0, %entry ], [ %inc, %for.inc ]
  %cmp = icmp sle i32 %i.0, 50
  br i1 %cmp, label %for.body, label %for.cond.cleanup

for.cond.cleanup:                                 ; preds = %for.cond
  br label %for.end

for.body:                                         ; preds = %for.cond
  %add = add i64 %call, 0
  %add1 = add i64 %call, 1
  %add2 = add i64 %call, 2
  %add3 = add i64 %call, 3
  %add4 = add i64 %call, 4
  %add5 = add i64 %call, 5
  %add6 = add i64 %call, 6
  %add7 = add i64 %call, 7
  %add8 = add i64 %call, 8
  %add9 = add i64 %call, 9
  %add10 = add i64 %call, 10
  %add11 = add i64 %call, 11
  %add12 = add i64 %call, 12
  %add13 = add i64 %call, 13
  %add14 = add i64 %call, 14
  %add15 = add i64 %call, 15
  %add16 = add i64 %call, 16
  %add17 = add i64 %call, 17
  %add18 = add i64 %call, 18
  %add19 = add i64 %call, 19
  %add20 = add i64 %call, 20
  %add21 = add i64 %call, 21
  %add22 = add i64 %call, 22
  %add23 = add i64 %call, 23
  %add24 = add i64 %call, 24
  %add25 = add i64 %call, 25
  %add26 = add i64 %call, 26
  %add27 = add i64 %call, 27
  %add28 = add i64 %call, 28
  %add29 = add i64 %call, 29
  %add30 = add i64 %call, 30
  %add31 = add i64 %call, 31
  %add32 = add i64 %call, 32
  %add33 = add i64 %call, 33
  %add34 = add i64 %call, 34
  %add35 = add i64 %call, 35
  %add36 = add i64 %call, 36
  %add37 = add i64 %call, 37
  %add38 = add i64 %call, 38
  %add39 = add i64 %call, 39
  %add40 = add i64 %call, 40
  %add41 = add i64 %call, 41
  %add42 = add i64 %call, 42
  %add43 = add i64 %call, 43
  %add44 = add i64 %call, 44
  %add45 = add i64 %call, 45
  %add46 = add i64 %call, 46
  %add47 = add i64 %call, 47
  %add48 = add i64 %call, 48
  %add49 = add i64 %call, 49
  br label %for.inc

for.inc:                                          ; preds = %for.body
  %inc = add nsw i32 %i.0, 1
  br label %for.cond

for.end:                                          ; preds = %for.cond.cleanup
  br label %for.cond51

for.cond51:                                       ; preds = %for.inc55, %for.end
  %i50.0 = phi i32 [ 0, %for.end ], [ %inc56, %for.inc55 ]
  %cmp52 = icmp sle i32 %i50.0, 50
  br i1 %cmp52, label %for.body54, label %for.cond.cleanup53

for.cond.cleanup53:                               ; preds = %for.cond51
  br label %for.end57

for.body54:                                       ; preds = %for.cond51
; CHECK: call write [[REG:]]
; CHECK: [[REG:]] = load 8 sp [[#SP:]]
; CHECK-NEXT: call write [[REG]]
; CHECK: [[REG:]] = load 8 sp [[#SP:]]
; CHECK-NEXT: call write [[REG]]
; CHECK: [[REG:]] = load 8 sp [[#SP:]]
; CHECK-NEXT: call write [[REG]]
; CHECK: [[REG:]] = load 8 sp [[#SP:]]
; CHECK-NEXT: call write [[REG]]
; CHECK: [[REG:]] = load 8 sp [[#SP:]]
; CHECK-NEXT: call write [[REG]]
  call void @write(i64 %a0.0)
  call void @write(i64 %a1.0)
  call void @write(i64 %a2.0)
  call void @write(i64 %a3.0)
  call void @write(i64 %a4.0)
  call void @write(i64 %a5.0)
  call void @write(i64 %a6.0)
  call void @write(i64 %a7.0)
  call void @write(i64 %a8.0)
  call void @write(i64 %a9.0)
  call void @write(i64 %a10.0)
  call void @write(i64 %a11.0)
  call void @write(i64 %a12.0)
  call void @write(i64 %a13.0)
  call void @write(i64 %a14.0)
  call void @write(i64 %a15.0)
  call void @write(i64 %a16.0)
  call void @write(i64 %a17.0)
  call void @write(i64 %a18.0)
  call void @write(i64 %a19.0)
  call void @write(i64 %a20.0)
  call void @write(i64 %a21.0)
  call void @write(i64 %a22.0)
  call void @write(i64 %a23.0)
  call void @write(i64 %a24.0)
  call void @write(i64 %a25.0)
  call void @write(i64 %a26.0)
  call void @write(i64 %a27.0)
  call void @write(i64 %a28.0)
  call void @write(i64 %a29.0)
  call void @write(i64 %a30.0)
  call void @write(i64 %a31.0)
  call void @write(i64 %a32.0)
  call void @write(i64 %a33.0)
  call void @write(i64 %a34.0)
  call void @write(i64 %a35.0)
  call void @write(i64 %a36.0)
  call void @write(i64 %a37.0)
  call void @write(i64 %a38.0)
  call void @write(i64 %a39.0)
  call void @write(i64 %a40.0)
  call void @write(i64 %a41.0)
  call void @write(i64 %a42.0)
  call void @write(i64 %a43.0)
  call void @write(i64 %a44.0)
  call void @write(i64 %a45.0)
  call void @write(i64 %a46.0)
  call void @write(i64 %a47.0)
  call void @write(i64 %a48.0)
  call void @write(i64 %a49.0)
  br label %for.inc55

for.inc55:                                        ; preds = %for.body54
  %inc56 = add nsw i32 %i50.0, 1
  br label %for.cond51

for.end57:                                        ; preds = %for.cond.cleanup53
  ret i32 0
}
; CHECK:   end main

declare i64 @read(...) #2
declare void @write(i64) #2