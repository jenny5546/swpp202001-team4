define void @main() {
; CHECK: start main 0:
entry:
; CHECK: sp = sub sp 64 64
; CHECK-NEXT: r1 = add sp 56 64
; CHECK-NEXT: store 8 r1 sp 0
; CHECK-NEXT: r1 = load 8 sp 0
; CHECK-NEXT: store 8 r1 sp 8
; CHECK-NEXT: r2 = load 8 sp 8
; CHECK-NEXT: store 4 1 r2 0
; CHECK-NEXT: r1 = load 8 sp 8
; CHECK-NEXT: r1 = load 4 r1 0
; CHECK-NEXT: store 8 r1 sp 16
; CHECK-NEXT: r2 = load 8 sp 8
; CHECK-NEXT: store 4 1 r2 0
; CHECK-NEXT: r1 = load 8 sp 8
; CHECK-NEXT: r1 = load 4 r1 0
; CHECK-NEXT: store 8 r1 sp 24
; CHECK-NEXT: r2 = load 8 sp 8
; CHECK-NEXT: store 4 1 r2 0
; CHECK-NEXT: r1 = load 8 sp 8
; CHECK-NEXT: r1 = load 4 r1 0
; CHECK-NEXT: store 8 r1 sp 32
; CHECK-NEXT: r2 = load 8 sp 8
; CHECK-NEXT: store 4 1 r2 0
; CHECK-NEXT: r1 = load 8 sp 8
; CHECK-NEXT: r1 = load 4 r1 0
; CHECK-NEXT: store 8 r1 sp 40
; CHECK-NEXT: r1 = load 8 sp 8
; CHECK-NEXT: store 8 r1 sp 48
; CHECK-NEXT: ret 0
	%call = tail call noalias i8* @malloc(i64 16) #1
	%0 = bitcast i8* %call to i32*
	store i32 1, i32* %0, align 4
	%1 = load i32, i32* %0, align 4
	store i32 1, i32* %0, align 4
	%2 = load i32, i32* %0, align 4
	store i32 1, i32* %0, align 4
	%3 = load i32, i32* %0, align 4	
	store i32 1, i32* %0, align 4
	%4 = load i32, i32* %0, align 4	
	%5 = bitcast i32* %0 to i8*
	call void @free(i8* %5) #1
	ret void
}
; CHECK: end main

declare noalias i8* @malloc(i64) #1

declare void @free(i8* nocapture) #1
