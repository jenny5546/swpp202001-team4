define i32 @main() #0 {
; CHECK: start main 0:
entry:
; CHECK: sp = sub sp [[#SP:]] 64
; CHECK: [[REG:r[0-9]+]] = call read
; CHECK: [[REG:r[0-9]+]] = add [[REG:r[0-9]+]] 1 64
; CHECK-NEXT: [[REG:r[0-9]+]] = add [[REG:r[0-9]+]] 2 64
; CHECK-NEXT: [[REG:r[0-9]+]] = add [[REG:r[0-9]+]] 3 64
; CHECK-NEXT: [[REG:r[0-9]+]] = add [[REG:r[0-9]+]] 4 64
; CHECK-NEXT: [[REG:r[0-9]+]] = add [[REG:r[0-9]+]] 5 64
  %call = call i64 (...) @read()
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
  call void @write(i64 %add)
  call void @write(i64 %add1)
  call void @write(i64 %add2)
  call void @write(i64 %add3)
  call void @write(i64 %add4)
  call void @write(i64 %add5)
  call void @write(i64 %add6)
  call void @write(i64 %add7)
  call void @write(i64 %add8)
  call void @write(i64 %add9)
  call void @write(i64 %add10)
  call void @write(i64 %add11)
  call void @write(i64 %add12)
  call void @write(i64 %add13)
  call void @write(i64 %add14)
  call void @write(i64 %add15)
  call void @write(i64 %add16)
  call void @write(i64 %add17)
  call void @write(i64 %add18)
  call void @write(i64 %add19)
  call void @write(i64 %add20)
  call void @write(i64 %add21)
  call void @write(i64 %add22)
  call void @write(i64 %add23)
  call void @write(i64 %add24)
  call void @write(i64 %add25)
  call void @write(i64 %add26)
  call void @write(i64 %add27)
  call void @write(i64 %add28)
  call void @write(i64 %add29)
  call void @write(i64 %add30)
  call void @write(i64 %add31)
  call void @write(i64 %add32)
  call void @write(i64 %add33)
  call void @write(i64 %add34)
  call void @write(i64 %add35)
  call void @write(i64 %add36)
  call void @write(i64 %add37)
  call void @write(i64 %add38)
  call void @write(i64 %add39)
  call void @write(i64 %add40)
  call void @write(i64 %add41)
  call void @write(i64 %add42)
  call void @write(i64 %add43)
  call void @write(i64 %add44)
  call void @write(i64 %add45)
  call void @write(i64 %add46)
  call void @write(i64 %add47)
  call void @write(i64 %add48)
  call void @write(i64 %add49)
  ret i32 0
}

declare i64 @read(...) #2
declare void @write(i64) #2