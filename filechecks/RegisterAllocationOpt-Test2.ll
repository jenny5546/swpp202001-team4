define i32 @main() #0 {
; CHECK:   start main 0:
; CHECK:     .entry:
; CHECK-NEXT:    ; init sp!
; CHECK-NEXT:    sp = sub sp 344 64
; CHECK-NEXT:    r9 = call read
; CHECK-NEXT:    r1 = add r9 0 64
; CHECK-NEXT:    r2 = add r9 1 64
; CHECK-NEXT:    r3 = add r9 2 64
; CHECK-NEXT:    r4 = add r9 3 64
; CHECK-NEXT:    r5 = add r9 4 64
; CHECK-NEXT:    r6 = add r9 5 64
; CHECK-NEXT:    r7 = add r9 6 64
; CHECK-NEXT:    r8 = add r9 7 64
; CHECK-NEXT:    store 8 r1 sp 0
; CHECK-NEXT:    r1 = add r9 8 64
; CHECK-NEXT:    store 8 r2 sp 8
; CHECK-NEXT:    r2 = add r9 9 64
; CHECK-NEXT:    store 8 r3 sp 16
; CHECK-NEXT:    r3 = add r9 10 64
; CHECK-NEXT:    store 8 r4 sp 24
; CHECK-NEXT:    r4 = add r9 11 64
; CHECK-NEXT:    store 8 r5 sp 32
; CHECK-NEXT:    r5 = add r9 12 64
; CHECK-NEXT:    store 8 r6 sp 40
; CHECK-NEXT:    r6 = add r9 13 64
; CHECK-NEXT:    store 8 r7 sp 48
; CHECK-NEXT:    r7 = add r9 14 64
; CHECK-NEXT:    store 8 r8 sp 56
; CHECK-NEXT:    r8 = add r9 15 64
; CHECK-NEXT:    store 8 r1 sp 64
; CHECK-NEXT:    r1 = add r9 16 64
; CHECK-NEXT:    store 8 r2 sp 72
; CHECK-NEXT:    r2 = add r9 17 64
; CHECK-NEXT:    store 8 r3 sp 80
; CHECK-NEXT:    r3 = add r9 18 64
; CHECK-NEXT:    store 8 r4 sp 88
; CHECK-NEXT:    r4 = add r9 19 64
; CHECK-NEXT:    store 8 r5 sp 96
; CHECK-NEXT:    r5 = add r9 20 64
; CHECK-NEXT:    store 8 r6 sp 104
; CHECK-NEXT:    r6 = add r9 21 64
; CHECK-NEXT:    store 8 r7 sp 112
; CHECK-NEXT:    r7 = add r9 22 64
; CHECK-NEXT:    store 8 r8 sp 120
; CHECK-NEXT:    r8 = add r9 23 64
; CHECK-NEXT:    store 8 r1 sp 128
; CHECK-NEXT:    r1 = add r9 24 64
; CHECK-NEXT:    store 8 r2 sp 136
; CHECK-NEXT:    r2 = add r9 25 64
; CHECK-NEXT:    store 8 r3 sp 144
; CHECK-NEXT:    r3 = add r9 26 64
; CHECK-NEXT:    store 8 r4 sp 152
; CHECK-NEXT:    r4 = add r9 27 64
; CHECK-NEXT:    store 8 r5 sp 160
; CHECK-NEXT:    r5 = add r9 28 64
; CHECK-NEXT:    store 8 r6 sp 168
; CHECK-NEXT:    r6 = add r9 29 64
; CHECK-NEXT:    store 8 r7 sp 176
; CHECK-NEXT:    r7 = add r9 30 64
; CHECK-NEXT:    store 8 r8 sp 184
; CHECK-NEXT:    r8 = add r9 31 64
; CHECK-NEXT:    store 8 r1 sp 192
; CHECK-NEXT:    r1 = add r9 32 64
; CHECK-NEXT:    store 8 r2 sp 200
; CHECK-NEXT:    r2 = add r9 33 64
; CHECK-NEXT:    store 8 r3 sp 208
; CHECK-NEXT:    r3 = add r9 34 64
; CHECK-NEXT:    store 8 r4 sp 216
; CHECK-NEXT:    r4 = add r9 35 64
; CHECK-NEXT:    store 8 r5 sp 224
; CHECK-NEXT:    r5 = add r9 36 64
; CHECK-NEXT:    store 8 r6 sp 232
; CHECK-NEXT:    r6 = add r9 37 64
; CHECK-NEXT:    store 8 r7 sp 240
; CHECK-NEXT:    r7 = add r9 38 64
; CHECK-NEXT:    store 8 r8 sp 248
; CHECK-NEXT:    r8 = add r9 39 64
; CHECK-NEXT:    store 8 r1 sp 256
; CHECK-NEXT:    r16 = add r9 40 64
; CHECK-NEXT:    r15 = add r9 41 64
; CHECK-NEXT:    r14 = add r9 42 64
; CHECK-NEXT:    r13 = add r9 43 64
; CHECK-NEXT:    r12 = add r9 44 64
; CHECK-NEXT:    r11 = add r9 45 64
; CHECK-NEXT:    r10 = add r9 46 64
; CHECK-NEXT:    r1 = add r9 47 64
; CHECK-NEXT:    store 8 r2 sp 264
; CHECK-NEXT:    r2 = add r9 48 64
; CHECK-NEXT:    store 8 r3 sp 272
; CHECK-NEXT:    r3 = add r9 49 64
; CHECK-NEXT:    store 8 r4 sp 280
; CHECK-NEXT:    r4 = load 8 sp 0
; CHECK-NEXT:    call write r4
; CHECK-NEXT:    store 8 r5 sp 288
; CHECK-NEXT:    r5 = load 8 sp 8
; CHECK-NEXT:    call write r5
; CHECK-NEXT:    store 8 r6 sp 296
; CHECK-NEXT:    r6 = load 8 sp 16
; CHECK-NEXT:    call write r6
; CHECK-NEXT:    store 8 r7 sp 304
; CHECK-NEXT:    r7 = load 8 sp 24
; CHECK-NEXT:    call write r7
; CHECK-NEXT:    store 8 r8 sp 312
; CHECK-NEXT:    r8 = load 8 sp 32
; CHECK-NEXT:    call write r8
; CHECK-NEXT:    store 8 r1 sp 320
; CHECK-NEXT:    r1 = load 8 sp 40
; CHECK-NEXT:    call write r1
; CHECK-NEXT:    store 8 r2 sp 328
; CHECK-NEXT:    r2 = load 8 sp 48
; CHECK-NEXT:    call write r2
; CHECK-NEXT:    store 8 r3 sp 336
; CHECK-NEXT:    r3 = load 8 sp 56
; CHECK-NEXT:    call write r3
; CHECK-NEXT:    store 8 r4 sp 0
; CHECK-NEXT:    r4 = load 8 sp 64
; CHECK-NEXT:    call write r4
; CHECK-NEXT:    store 8 r5 sp 8
; CHECK-NEXT:    r5 = load 8 sp 72
; CHECK-NEXT:    call write r5
; CHECK-NEXT:    store 8 r6 sp 16
; CHECK-NEXT:    r6 = load 8 sp 80
; CHECK-NEXT:    call write r6
; CHECK-NEXT:    store 8 r7 sp 24
; CHECK-NEXT:    r7 = load 8 sp 88
; CHECK-NEXT:    call write r7
; CHECK-NEXT:    store 8 r8 sp 32
; CHECK-NEXT:    r8 = load 8 sp 96
; CHECK-NEXT:    call write r8
; CHECK-NEXT:    store 8 r1 sp 40
; CHECK-NEXT:    r1 = load 8 sp 104
; CHECK-NEXT:    call write r1
; CHECK-NEXT:    store 8 r2 sp 48
; CHECK-NEXT:    r2 = load 8 sp 112
; CHECK-NEXT:    call write r2
; CHECK-NEXT:    store 8 r3 sp 56
; CHECK-NEXT:    r3 = load 8 sp 120
; CHECK-NEXT:    call write r3
; CHECK-NEXT:    store 8 r4 sp 64
; CHECK-NEXT:    r4 = load 8 sp 128
; CHECK-NEXT:    call write r4
; CHECK-NEXT:    store 8 r5 sp 72
; CHECK-NEXT:    r5 = load 8 sp 136
; CHECK-NEXT:    call write r5
; CHECK-NEXT:    store 8 r6 sp 80
; CHECK-NEXT:    r6 = load 8 sp 144
; CHECK-NEXT:    call write r6
; CHECK-NEXT:    store 8 r7 sp 88
; CHECK-NEXT:    r7 = load 8 sp 152
; CHECK-NEXT:    call write r7
; CHECK-NEXT:    store 8 r8 sp 96
; CHECK-NEXT:    r8 = load 8 sp 160
; CHECK-NEXT:    call write r8
; CHECK-NEXT:    store 8 r1 sp 104
; CHECK-NEXT:    r1 = load 8 sp 168
; CHECK-NEXT:    call write r1
; CHECK-NEXT:    store 8 r2 sp 112
; CHECK-NEXT:    r2 = load 8 sp 176
; CHECK-NEXT:    call write r2
; CHECK-NEXT:    store 8 r3 sp 120
; CHECK-NEXT:    r3 = load 8 sp 184
; CHECK-NEXT:    call write r3
; CHECK-NEXT:    store 8 r4 sp 128
; CHECK-NEXT:    r4 = load 8 sp 192
; CHECK-NEXT:    call write r4
; CHECK-NEXT:    store 8 r5 sp 136
; CHECK-NEXT:    r5 = load 8 sp 200
; CHECK-NEXT:    call write r5
; CHECK-NEXT:    store 8 r6 sp 144
; CHECK-NEXT:    r6 = load 8 sp 208
; CHECK-NEXT:    call write r6
; CHECK-NEXT:    store 8 r7 sp 152
; CHECK-NEXT:    r7 = load 8 sp 216
; CHECK-NEXT:    call write r7
; CHECK-NEXT:    store 8 r8 sp 160
; CHECK-NEXT:    r8 = load 8 sp 224
; CHECK-NEXT:    call write r8
; CHECK-NEXT:    store 8 r1 sp 168
; CHECK-NEXT:    r1 = load 8 sp 232
; CHECK-NEXT:    call write r1
; CHECK-NEXT:    store 8 r2 sp 176
; CHECK-NEXT:    r2 = load 8 sp 240
; CHECK-NEXT:    call write r2
; CHECK-NEXT:    store 8 r3 sp 184
; CHECK-NEXT:    r3 = load 8 sp 248
; CHECK-NEXT:    call write r3
; CHECK-NEXT:    store 8 r4 sp 192
; CHECK-NEXT:    r4 = load 8 sp 256
; CHECK-NEXT:    call write r4
; CHECK-NEXT:    store 8 r5 sp 200
; CHECK-NEXT:    r5 = load 8 sp 264
; CHECK-NEXT:    call write r5
; CHECK-NEXT:    store 8 r6 sp 208
; CHECK-NEXT:    r6 = load 8 sp 272
; CHECK-NEXT:    call write r6
; CHECK-NEXT:    store 8 r7 sp 216
; CHECK-NEXT:    r7 = load 8 sp 280
; CHECK-NEXT:    call write r7
; CHECK-NEXT:    store 8 r8 sp 224
; CHECK-NEXT:    r8 = load 8 sp 288
; CHECK-NEXT:    call write r8
; CHECK-NEXT:    store 8 r1 sp 232
; CHECK-NEXT:    r1 = load 8 sp 296
; CHECK-NEXT:    call write r1
; CHECK-NEXT:    store 8 r2 sp 240
; CHECK-NEXT:    r2 = load 8 sp 304
; CHECK-NEXT:    call write r2
; CHECK-NEXT:    store 8 r3 sp 248
; CHECK-NEXT:    r3 = load 8 sp 312
; CHECK-NEXT:    call write r3
; CHECK-NEXT:    call write r16
; CHECK-NEXT:    call write r15
; CHECK-NEXT:    call write r14
; CHECK-NEXT:    call write r13
; CHECK-NEXT:    call write r12
; CHECK-NEXT:    call write r11
; CHECK-NEXT:    call write r10
; CHECK-NEXT:    store 8 r4 sp 256
; CHECK-NEXT:    r4 = load 8 sp 320
; CHECK-NEXT:    call write r4
; CHECK-NEXT:    store 8 r5 sp 264
; CHECK-NEXT:    r5 = load 8 sp 328
; CHECK-NEXT:    call write r5
; CHECK-NEXT:    store 8 r6 sp 272
; CHECK-NEXT:    r6 = load 8 sp 336
; CHECK-NEXT:    call write r6
; CHECK-NEXT:    ret 0
entry:
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
; CHECK: end main

declare i64 @read(...) #2
declare void @write(i64) #2