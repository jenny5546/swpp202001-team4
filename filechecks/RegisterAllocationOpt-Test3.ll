define i32 @main() #0 {
; CHECK:   start main 0:
; CHECK:     .entry:
; CHECK-NEXT:       ; init sp!
; CHECK-NEXT:       sp = sub sp 792 64
; CHECK-NEXT:       r9 = call read
; CHECK-NEXT:       store 8 0 sp 0
; CHECK-NEXT:       store 8 0 sp 8
; CHECK-NEXT:       store 8 0 sp 16
; CHECK-NEXT:       store 8 0 sp 24
; CHECK-NEXT:       store 8 0 sp 32
; CHECK-NEXT:       store 8 0 sp 40
; CHECK-NEXT:       store 8 0 sp 48
; CHECK-NEXT:       store 8 0 sp 56
; CHECK-NEXT:       store 8 0 sp 64
; CHECK-NEXT:       store 8 0 sp 72
; CHECK-NEXT:       store 8 0 sp 80
; CHECK-NEXT:       store 8 0 sp 88
; CHECK-NEXT:       store 8 0 sp 96
; CHECK-NEXT:       store 8 0 sp 104
; CHECK-NEXT:       store 8 0 sp 112
; CHECK-NEXT:       store 8 0 sp 120
; CHECK-NEXT:       store 8 0 sp 128
; CHECK-NEXT:       store 8 0 sp 136
; CHECK-NEXT:       store 8 0 sp 144
; CHECK-NEXT:       store 8 0 sp 152
; CHECK-NEXT:       store 8 0 sp 160
; CHECK-NEXT:       store 8 0 sp 168
; CHECK-NEXT:       store 8 0 sp 176
; CHECK-NEXT:       store 8 0 sp 184
; CHECK-NEXT:       store 8 0 sp 192
; CHECK-NEXT:       store 8 0 sp 200
; CHECK-NEXT:       store 8 0 sp 208
; CHECK-NEXT:       store 8 0 sp 216
; CHECK-NEXT:       store 8 0 sp 224
; CHECK-NEXT:       store 8 0 sp 232
; CHECK-NEXT:       store 8 0 sp 240
; CHECK-NEXT:       store 8 0 sp 248
; CHECK-NEXT:       store 8 0 sp 256
; CHECK-NEXT:       store 8 0 sp 264
; CHECK-NEXT:       store 8 0 sp 272
; CHECK-NEXT:       store 8 0 sp 280
; CHECK-NEXT:       store 8 0 sp 288
; CHECK-NEXT:       store 8 0 sp 296
; CHECK-NEXT:       store 8 0 sp 304
; CHECK-NEXT:       store 8 0 sp 312
; CHECK-NEXT:       store 8 0 sp 320
; CHECK-NEXT:       store 8 0 sp 328
; CHECK-NEXT:       store 8 0 sp 336
; CHECK-NEXT:       store 8 0 sp 344
; CHECK-NEXT:       store 8 0 sp 352
; CHECK-NEXT:       store 8 0 sp 360
; CHECK-NEXT:       store 8 0 sp 368
; CHECK-NEXT:       store 8 0 sp 376
; CHECK-NEXT:       store 8 0 sp 384
; CHECK-NEXT:       store 8 0 sp 392
; CHECK-NEXT:       store 8 0 sp 400
; CHECK-NEXT:       br .for.cond
; CHECK:     .for.cond:
; CHECK-NEXT:       r1 = load 8 sp 400
; CHECK-NEXT:       r2 = icmp sle r1 50 32
; CHECK-NEXT:       br r2 .for.body .for.cond.cleanup
; CHECK:     .for.cond.cleanup:
; CHECK-NEXT:       br .for.end
; CHECK:     .for.body:
; CHECK-NEXT:       r3 = add r9 0 64
; CHECK-NEXT:       r4 = add r9 1 64
; CHECK-NEXT:       r5 = add r9 2 64
; CHECK-NEXT:       r6 = add r9 3 64
; CHECK-NEXT:       r7 = add r9 4 64
; CHECK-NEXT:       r8 = add r9 5 64
; CHECK-NEXT:       store 8 r1 sp 400
; CHECK-NEXT:       r1 = add r9 6 64
; CHECK-NEXT:       store 8 r2 sp 408
; CHECK-NEXT:       r2 = add r9 7 64
; CHECK-NEXT:       store 8 r3 sp 416
; CHECK-NEXT:       r3 = add r9 8 64
; CHECK-NEXT:       store 8 r4 sp 424
; CHECK-NEXT:       r4 = add r9 9 64
; CHECK-NEXT:       store 8 r5 sp 432
; CHECK-NEXT:       r5 = add r9 10 64
; CHECK-NEXT:       store 8 r6 sp 440
; CHECK-NEXT:       r6 = add r9 11 64
; CHECK-NEXT:       store 8 r7 sp 448
; CHECK-NEXT:       r7 = add r9 12 64
; CHECK-NEXT:       store 8 r8 sp 456
; CHECK-NEXT:       r8 = add r9 13 64
; CHECK-NEXT:       store 8 r1 sp 464
; CHECK-NEXT:       r1 = add r9 14 64
; CHECK-NEXT:       store 8 r2 sp 472
; CHECK-NEXT:       r2 = add r9 15 64
; CHECK-NEXT:       store 8 r3 sp 480
; CHECK-NEXT:       r3 = add r9 16 64
; CHECK-NEXT:       store 8 r4 sp 488
; CHECK-NEXT:       r4 = add r9 17 64
; CHECK-NEXT:       store 8 r5 sp 496
; CHECK-NEXT:       r5 = add r9 18 64
; CHECK-NEXT:       store 8 r6 sp 504
; CHECK-NEXT:       r6 = add r9 19 64
; CHECK-NEXT:       store 8 r7 sp 512
; CHECK-NEXT:       r7 = add r9 20 64
; CHECK-NEXT:       store 8 r8 sp 520
; CHECK-NEXT:       r8 = add r9 21 64
; CHECK-NEXT:       store 8 r1 sp 528
; CHECK-NEXT:       r1 = add r9 22 64
; CHECK-NEXT:       store 8 r2 sp 536
; CHECK-NEXT:       r2 = add r9 23 64
; CHECK-NEXT:       store 8 r3 sp 544
; CHECK-NEXT:       r3 = add r9 24 64
; CHECK-NEXT:       store 8 r4 sp 552
; CHECK-NEXT:       r4 = add r9 25 64
; CHECK-NEXT:       store 8 r5 sp 560
; CHECK-NEXT:       r5 = add r9 26 64
; CHECK-NEXT:       store 8 r6 sp 568
; CHECK-NEXT:       r6 = add r9 27 64
; CHECK-NEXT:       store 8 r7 sp 576
; CHECK-NEXT:       r7 = add r9 28 64
; CHECK-NEXT:       store 8 r8 sp 584
; CHECK-NEXT:       r8 = add r9 29 64
; CHECK-NEXT:       store 8 r1 sp 592
; CHECK-NEXT:       r1 = add r9 30 64
; CHECK-NEXT:       store 8 r2 sp 600
; CHECK-NEXT:       r2 = add r9 31 64
; CHECK-NEXT:       store 8 r3 sp 608
; CHECK-NEXT:       r3 = add r9 32 64
; CHECK-NEXT:       store 8 r4 sp 616
; CHECK-NEXT:       r4 = add r9 33 64
; CHECK-NEXT:       store 8 r5 sp 624
; CHECK-NEXT:       r5 = add r9 34 64
; CHECK-NEXT:       store 8 r6 sp 632
; CHECK-NEXT:       r6 = add r9 35 64
; CHECK-NEXT:       store 8 r7 sp 640
; CHECK-NEXT:       r7 = add r9 36 64
; CHECK-NEXT:       store 8 r8 sp 648
; CHECK-NEXT:       r8 = add r9 37 64
; CHECK-NEXT:       store 8 r1 sp 656
; CHECK-NEXT:       r1 = add r9 38 64
; CHECK-NEXT:       store 8 r2 sp 664
; CHECK-NEXT:       r2 = add r9 39 64
; CHECK-NEXT:       store 8 r3 sp 672
; CHECK-NEXT:       r3 = add r9 40 64
; CHECK-NEXT:       store 8 r4 sp 680
; CHECK-NEXT:       r4 = add r9 41 64
; CHECK-NEXT:       store 8 r5 sp 688
; CHECK-NEXT:       r5 = add r9 42 64
; CHECK-NEXT:       store 8 r6 sp 696
; CHECK-NEXT:       r6 = add r9 43 64
; CHECK-NEXT:       store 8 r7 sp 704
; CHECK-NEXT:       r7 = add r9 44 64
; CHECK-NEXT:       store 8 r8 sp 712
; CHECK-NEXT:       r8 = add r9 45 64
; CHECK-NEXT:       store 8 r1 sp 720
; CHECK-NEXT:       r16 = add r9 46 64
; CHECK-NEXT:       r15 = add r9 47 64
; CHECK-NEXT:       r14 = add r9 48 64
; CHECK-NEXT:       r13 = add r9 49 64
; CHECK-NEXT:       br .for.inc
; CHECK:     .for.inc:
; CHECK-NEXT:       r1 = load 8 sp 400
; CHECK-NEXT:       store 8 r2 sp 728
; CHECK-NEXT:       r12 = add r1 1 32
; CHECK-NEXT:       r2 = load 8 sp 416
; CHECK-NEXT:       store 8 r2 sp 0
; CHECK-NEXT:       store 8 r3 sp 736
; CHECK-NEXT:       r3 = load 8 sp 424
; CHECK-NEXT:       store 8 r3 sp 8
; CHECK-NEXT:       store 8 r4 sp 744
; CHECK-NEXT:       r4 = load 8 sp 432
; CHECK-NEXT:       store 8 r4 sp 16
; CHECK-NEXT:       store 8 r5 sp 752
; CHECK-NEXT:       r5 = load 8 sp 440
; CHECK-NEXT:       store 8 r5 sp 24
; CHECK-NEXT:       store 8 r6 sp 760
; CHECK-NEXT:       r6 = load 8 sp 448
; CHECK-NEXT:       store 8 r6 sp 32
; CHECK-NEXT:       store 8 r7 sp 768
; CHECK-NEXT:       r7 = load 8 sp 456
; CHECK-NEXT:       store 8 r7 sp 40
; CHECK-NEXT:       store 8 r8 sp 776
; CHECK-NEXT:       r8 = load 8 sp 464
; CHECK-NEXT:       store 8 r8 sp 48
; CHECK-NEXT:       store 8 r1 sp 400
; CHECK-NEXT:       r1 = load 8 sp 472
; CHECK-NEXT:       store 8 r1 sp 56
; CHECK-NEXT:       store 8 r2 sp 416
; CHECK-NEXT:       r2 = load 8 sp 480
; CHECK-NEXT:       store 8 r2 sp 64
; CHECK-NEXT:       store 8 r3 sp 424
; CHECK-NEXT:       r3 = load 8 sp 488
; CHECK-NEXT:       store 8 r3 sp 72
; CHECK-NEXT:       store 8 r4 sp 432
; CHECK-NEXT:       r4 = load 8 sp 496
; CHECK-NEXT:       store 8 r4 sp 80
; CHECK-NEXT:       store 8 r5 sp 440
; CHECK-NEXT:       r5 = load 8 sp 504
; CHECK-NEXT:       store 8 r5 sp 88
; CHECK-NEXT:       store 8 r6 sp 448
; CHECK-NEXT:       r6 = load 8 sp 512
; CHECK-NEXT:       store 8 r6 sp 96
; CHECK-NEXT:       store 8 r7 sp 456
; CHECK-NEXT:       r7 = load 8 sp 520
; CHECK-NEXT:       store 8 r7 sp 104
; CHECK-NEXT:       store 8 r8 sp 464
; CHECK-NEXT:       r8 = load 8 sp 528
; CHECK-NEXT:       store 8 r8 sp 112
; CHECK-NEXT:       store 8 r1 sp 472
; CHECK-NEXT:       r1 = load 8 sp 536
; CHECK-NEXT:       store 8 r1 sp 120
; CHECK-NEXT:       store 8 r2 sp 480
; CHECK-NEXT:       r2 = load 8 sp 544
; CHECK-NEXT:       store 8 r2 sp 128
; CHECK-NEXT:       store 8 r3 sp 488
; CHECK-NEXT:       r3 = load 8 sp 552
; CHECK-NEXT:       store 8 r3 sp 136
; CHECK-NEXT:       store 8 r4 sp 496
; CHECK-NEXT:       r4 = load 8 sp 560
; CHECK-NEXT:       store 8 r4 sp 144
; CHECK-NEXT:       store 8 r5 sp 504
; CHECK-NEXT:       r5 = load 8 sp 568
; CHECK-NEXT:       store 8 r5 sp 152
; CHECK-NEXT:       store 8 r6 sp 512
; CHECK-NEXT:       r6 = load 8 sp 576
; CHECK-NEXT:       store 8 r6 sp 160
; CHECK-NEXT:       store 8 r7 sp 520
; CHECK-NEXT:       r7 = load 8 sp 584
; CHECK-NEXT:       store 8 r7 sp 168
; CHECK-NEXT:       store 8 r8 sp 528
; CHECK-NEXT:       r8 = load 8 sp 592
; CHECK-NEXT:       store 8 r8 sp 176
; CHECK-NEXT:       store 8 r1 sp 536
; CHECK-NEXT:       r1 = load 8 sp 600
; CHECK-NEXT:       store 8 r1 sp 184
; CHECK-NEXT:       store 8 r2 sp 544
; CHECK-NEXT:       r2 = load 8 sp 608
; CHECK-NEXT:       store 8 r2 sp 192
; CHECK-NEXT:       store 8 r3 sp 552
; CHECK-NEXT:       r3 = load 8 sp 616
; CHECK-NEXT:       store 8 r3 sp 200
; CHECK-NEXT:       store 8 r4 sp 560
; CHECK-NEXT:       r4 = load 8 sp 624
; CHECK-NEXT:       store 8 r4 sp 208
; CHECK-NEXT:       store 8 r5 sp 568
; CHECK-NEXT:       r5 = load 8 sp 632
; CHECK-NEXT:       store 8 r5 sp 216
; CHECK-NEXT:       store 8 r6 sp 576
; CHECK-NEXT:       r6 = load 8 sp 640
; CHECK-NEXT:       store 8 r6 sp 224
; CHECK-NEXT:       store 8 r7 sp 584
; CHECK-NEXT:       r7 = load 8 sp 648
; CHECK-NEXT:       store 8 r7 sp 232
; CHECK-NEXT:       store 8 r8 sp 592
; CHECK-NEXT:       r8 = load 8 sp 656
; CHECK-NEXT:       store 8 r8 sp 240
; CHECK-NEXT:       store 8 r1 sp 600
; CHECK-NEXT:       r1 = load 8 sp 664
; CHECK-NEXT:       store 8 r1 sp 248
; CHECK-NEXT:       store 8 r2 sp 608
; CHECK-NEXT:       r2 = load 8 sp 672
; CHECK-NEXT:       store 8 r2 sp 256
; CHECK-NEXT:       store 8 r3 sp 616
; CHECK-NEXT:       r3 = load 8 sp 680
; CHECK-NEXT:       store 8 r3 sp 264
; CHECK-NEXT:       store 8 r4 sp 624
; CHECK-NEXT:       r4 = load 8 sp 688
; CHECK-NEXT:       store 8 r4 sp 272
; CHECK-NEXT:       store 8 r5 sp 632
; CHECK-NEXT:       r5 = load 8 sp 696
; CHECK-NEXT:       store 8 r5 sp 280
; CHECK-NEXT:       store 8 r6 sp 640
; CHECK-NEXT:       r6 = load 8 sp 704
; CHECK-NEXT:       store 8 r6 sp 288
; CHECK-NEXT:       store 8 r7 sp 648
; CHECK-NEXT:       r7 = load 8 sp 712
; CHECK-NEXT:       store 8 r7 sp 296
; CHECK-NEXT:       store 8 r8 sp 656
; CHECK-NEXT:       r8 = load 8 sp 720
; CHECK-NEXT:       store 8 r8 sp 304
; CHECK-NEXT:       store 8 r1 sp 664
; CHECK-NEXT:       r1 = load 8 sp 728
; CHECK-NEXT:       store 8 r1 sp 312
; CHECK-NEXT:       store 8 r2 sp 672
; CHECK-NEXT:       r2 = load 8 sp 736
; CHECK-NEXT:       store 8 r2 sp 320
; CHECK-NEXT:       store 8 r3 sp 680
; CHECK-NEXT:       r3 = load 8 sp 744
; CHECK-NEXT:       store 8 r3 sp 328
; CHECK-NEXT:       store 8 r4 sp 688
; CHECK-NEXT:       r4 = load 8 sp 752
; CHECK-NEXT:       store 8 r4 sp 336
; CHECK-NEXT:       store 8 r5 sp 696
; CHECK-NEXT:       r5 = load 8 sp 760
; CHECK-NEXT:       store 8 r5 sp 344
; CHECK-NEXT:       store 8 r6 sp 704
; CHECK-NEXT:       r6 = load 8 sp 768
; CHECK-NEXT:       store 8 r6 sp 352
; CHECK-NEXT:       store 8 r7 sp 712
; CHECK-NEXT:       r7 = load 8 sp 776
; CHECK-NEXT:       store 8 r7 sp 360
; CHECK-NEXT:       store 8 r16 sp 368
; CHECK-NEXT:       store 8 r15 sp 376
; CHECK-NEXT:       store 8 r14 sp 384
; CHECK-NEXT:       store 8 r13 sp 392
; CHECK-NEXT:       store 8 r12 sp 400
; CHECK-NEXT:       br .for.cond
; CHECK:     .for.end:
; CHECK-NEXT:       store 8 0 sp 784
; CHECK-NEXT:       br .for.cond51
; CHECK:     .for.cond51:
; CHECK-NEXT:       store 8 r8 sp 720
; CHECK-NEXT:       r8 = load 8 sp 784
; CHECK-NEXT:       store 8 r1 sp 728
; CHECK-NEXT:       r11 = icmp sle r8 50 32
; CHECK-NEXT:       br r11 .for.body54 .for.cond.cleanup53
; CHECK:     .for.cond.cleanup53:
; CHECK-NEXT:       br .for.end57
; CHECK:     .for.body54:
; CHECK-NEXT:       r1 = load 8 sp 0
; CHECK-NEXT:       call write r1
; CHECK-NEXT:       store 8 r2 sp 736
; CHECK-NEXT:       r2 = load 8 sp 8
; CHECK-NEXT:       call write r2
; CHECK-NEXT:       store 8 r3 sp 744
; CHECK-NEXT:       r3 = load 8 sp 16
; CHECK-NEXT:       call write r3
; CHECK-NEXT:       store 8 r4 sp 752
; CHECK-NEXT:       r4 = load 8 sp 24
; CHECK-NEXT:       call write r4
; CHECK-NEXT:       store 8 r5 sp 760
; CHECK-NEXT:       r5 = load 8 sp 32
; CHECK-NEXT:       call write r5
; CHECK-NEXT:       store 8 r6 sp 768
; CHECK-NEXT:       r6 = load 8 sp 40
; CHECK-NEXT:       call write r6
; CHECK-NEXT:       store 8 r7 sp 776
; CHECK-NEXT:       r7 = load 8 sp 48
; CHECK-NEXT:       call write r7
; CHECK-NEXT:       store 8 r8 sp 784
; CHECK-NEXT:       r8 = load 8 sp 56
; CHECK-NEXT:       call write r8
; CHECK-NEXT:       store 8 r1 sp 0
; CHECK-NEXT:       r1 = load 8 sp 64
; CHECK-NEXT:       call write r1
; CHECK-NEXT:       store 8 r2 sp 8
; CHECK-NEXT:       r2 = load 8 sp 72
; CHECK-NEXT:       call write r2
; CHECK-NEXT:       store 8 r3 sp 16
; CHECK-NEXT:       r3 = load 8 sp 80
; CHECK-NEXT:       call write r3
; CHECK-NEXT:       store 8 r4 sp 24
; CHECK-NEXT:       r4 = load 8 sp 88
; CHECK-NEXT:       call write r4
; CHECK-NEXT:       store 8 r5 sp 32
; CHECK-NEXT:       r5 = load 8 sp 96
; CHECK-NEXT:       call write r5
; CHECK-NEXT:       store 8 r6 sp 40
; CHECK-NEXT:       r6 = load 8 sp 104
; CHECK-NEXT:       call write r6
; CHECK-NEXT:       store 8 r7 sp 48
; CHECK-NEXT:       r7 = load 8 sp 112
; CHECK-NEXT:       call write r7
; CHECK-NEXT:       store 8 r8 sp 56
; CHECK-NEXT:       r8 = load 8 sp 120
; CHECK-NEXT:       call write r8
; CHECK-NEXT:       store 8 r1 sp 64
; CHECK-NEXT:       r1 = load 8 sp 128
; CHECK-NEXT:       call write r1
; CHECK-NEXT:       store 8 r2 sp 72
; CHECK-NEXT:       r2 = load 8 sp 136
; CHECK-NEXT:       call write r2
; CHECK-NEXT:       store 8 r3 sp 80
; CHECK-NEXT:       r3 = load 8 sp 144
; CHECK-NEXT:       call write r3
; CHECK-NEXT:       store 8 r4 sp 88
; CHECK-NEXT:       r4 = load 8 sp 152
; CHECK-NEXT:       call write r4
; CHECK-NEXT:       store 8 r5 sp 96
; CHECK-NEXT:       r5 = load 8 sp 160
; CHECK-NEXT:       call write r5
; CHECK-NEXT:       store 8 r6 sp 104
; CHECK-NEXT:       r6 = load 8 sp 168
; CHECK-NEXT:       call write r6
; CHECK-NEXT:       store 8 r7 sp 112
; CHECK-NEXT:       r7 = load 8 sp 176
; CHECK-NEXT:       call write r7
; CHECK-NEXT:       store 8 r8 sp 120
; CHECK-NEXT:       r8 = load 8 sp 184
; CHECK-NEXT:       call write r8
; CHECK-NEXT:       store 8 r1 sp 128
; CHECK-NEXT:       r1 = load 8 sp 192
; CHECK-NEXT:       call write r1
; CHECK-NEXT:       store 8 r2 sp 136
; CHECK-NEXT:       r2 = load 8 sp 200
; CHECK-NEXT:       call write r2
; CHECK-NEXT:       store 8 r3 sp 144
; CHECK-NEXT:       r3 = load 8 sp 208
; CHECK-NEXT:       call write r3
; CHECK-NEXT:       store 8 r4 sp 152
; CHECK-NEXT:       r4 = load 8 sp 216
; CHECK-NEXT:       call write r4
; CHECK-NEXT:       store 8 r5 sp 160
; CHECK-NEXT:       r5 = load 8 sp 224
; CHECK-NEXT:       call write r5
; CHECK-NEXT:       store 8 r6 sp 168
; CHECK-NEXT:       r6 = load 8 sp 232
; CHECK-NEXT:       call write r6
; CHECK-NEXT:       store 8 r7 sp 176
; CHECK-NEXT:       r7 = load 8 sp 240
; CHECK-NEXT:       call write r7
; CHECK-NEXT:       store 8 r8 sp 184
; CHECK-NEXT:       r8 = load 8 sp 248
; CHECK-NEXT:       call write r8
; CHECK-NEXT:       store 8 r1 sp 192
; CHECK-NEXT:       r1 = load 8 sp 256
; CHECK-NEXT:       call write r1
; CHECK-NEXT:       store 8 r2 sp 200
; CHECK-NEXT:       r2 = load 8 sp 264
; CHECK-NEXT:       call write r2
; CHECK-NEXT:       store 8 r3 sp 208
; CHECK-NEXT:       r3 = load 8 sp 272
; CHECK-NEXT:       call write r3
; CHECK-NEXT:       store 8 r4 sp 216
; CHECK-NEXT:       r4 = load 8 sp 280
; CHECK-NEXT:       call write r4
; CHECK-NEXT:       store 8 r5 sp 224
; CHECK-NEXT:       r5 = load 8 sp 288
; CHECK-NEXT:       call write r5
; CHECK-NEXT:       store 8 r6 sp 232
; CHECK-NEXT:       r6 = load 8 sp 296
; CHECK-NEXT:       call write r6
; CHECK-NEXT:       store 8 r7 sp 240
; CHECK-NEXT:       r7 = load 8 sp 304
; CHECK-NEXT:       call write r7
; CHECK-NEXT:       store 8 r8 sp 248
; CHECK-NEXT:       r8 = load 8 sp 312
; CHECK-NEXT:       call write r8
; CHECK-NEXT:       store 8 r1 sp 256
; CHECK-NEXT:       r1 = load 8 sp 320
; CHECK-NEXT:       call write r1
; CHECK-NEXT:       store 8 r2 sp 264
; CHECK-NEXT:       r2 = load 8 sp 328
; CHECK-NEXT:       call write r2
; CHECK-NEXT:       store 8 r3 sp 272
; CHECK-NEXT:       r3 = load 8 sp 336
; CHECK-NEXT:       call write r3
; CHECK-NEXT:       store 8 r4 sp 280
; CHECK-NEXT:       r4 = load 8 sp 344
; CHECK-NEXT:       call write r4
; CHECK-NEXT:       store 8 r5 sp 288
; CHECK-NEXT:       r5 = load 8 sp 352
; CHECK-NEXT:       call write r5
; CHECK-NEXT:       store 8 r6 sp 296
; CHECK-NEXT:       r6 = load 8 sp 360
; CHECK-NEXT:       call write r6
; CHECK-NEXT:       store 8 r7 sp 304
; CHECK-NEXT:       r7 = load 8 sp 368
; CHECK-NEXT:       call write r7
; CHECK-NEXT:       store 8 r8 sp 312
; CHECK-NEXT:       r8 = load 8 sp 376
; CHECK-NEXT:       call write r8
; CHECK-NEXT:       store 8 r1 sp 320
; CHECK-NEXT:       r1 = load 8 sp 384
; CHECK-NEXT:       call write r1
; CHECK-NEXT:       store 8 r2 sp 328
; CHECK-NEXT:       r2 = load 8 sp 392
; CHECK-NEXT:       call write r2
; CHECK-NEXT:       br .for.inc55
; CHECK:     .for.inc55:
; CHECK-NEXT:       store 8 r3 sp 336
; CHECK-NEXT:       r3 = load 8 sp 784
; CHECK-NEXT:       store 8 r4 sp 344
; CHECK-NEXT:       r10 = add r3 1 32
; CHECK-NEXT:       store 8 r10 sp 784
; CHECK-NEXT:       br .for.cond51
; CHECK:     .for.end57:
; CHECK-NEXT:       ret 0
entry:
  %call = call i64 (...) @read()
  br label %for.cond

for.cond:                                         ; preds = %for.inc, %entry
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