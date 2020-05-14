; ModuleID = '/tmp/a.ll'
source_filename = "/Users/ohah/Documents/swpp-project/swpp202001-team4/filechecks/ArithmeticPass-Test2.c"
target datalayout = "e-m:o-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-apple-macosx10.14.0"

; Function Attrs: nounwind ssp uwtable
define i32 @doShift(i64 %x, i64 %y, i64 %z) #0 {
; CHECK: start doShift 3:
entry:
; CHECK: sp = sub sp 64 64
; CHECK-NEXT: r1 = udiv arg1 4 64
; CHECK-NEXT: store 8 r1 sp 0
; CHECK-NEXT: r1 = mul arg3 16 64
; CHECK-NEXT: store 8 r1 sp 8
; CHECK-NEXT: r1 = udiv arg2 8 64
; CHECK-NEXT: store 8 r1 sp 16
; CHECK-NEXT: r1 = load 8 sp 0
; CHECK-NEXT: r2 = load 8 sp 8
; CHECK-NEXT: r1 = add r1 r2 64
; CHECK-NEXT: store 8 r1 sp 24
; CHECK-NEXT: r1 = load 8 sp 24
; CHECK-NEXT: r2 = load 8 sp 16
; CHECK-NEXT: r1 = add r1 r2 64
; CHECK-NEXT: store 8 r1 sp 32
; CHECK-NEXT: r1 = load 8 sp 32
; CHECK-NEXT: r2 = load 8 sp 0
; CHECK-NEXT: r1 = sub r1 r2 64
; CHECK-NEXT: store 8 r1 sp 40
; CHECK-NEXT: r1 = load 8 sp 40
; CHECK-NEXT: r1 = mul r1 2 64
; CHECK-NEXT: store 8 r1 sp 48
; CHECK-NEXT: r1 = load 8 sp 48
; CHECK-NEXT: r1 = and r1 4294967295 64
; CHECK-NEXT: store 8 r1 sp 56
; CHECK-NEXT: r1 = load 8 sp 56
; CHECK-NEXT: ret r1
  %shr = lshr i64 %x, 2
  %shl = shl i64 %z, 4
  %shr1 = lshr i64 %y, 3
  %add = add i64 %shr, %shl
  %add2 = add i64 %add, %shr1
  %sub = sub i64 %add2, %shr
  %add3 = add i64 %sub, %sub
  %conv = trunc i64 %add3 to i32
  ret i32 %conv
}
; CHECK: end doShift

; Function Attrs: argmemonly nounwind willreturn
declare void @llvm.lifetime.start.p0i8(i64 immarg, i8* nocapture) #1

; Function Attrs: argmemonly nounwind willreturn
declare void @llvm.lifetime.end.p0i8(i64 immarg, i8* nocapture) #1

; Function Attrs: nounwind ssp uwtable
define i32 @main() #0 {
; CHECK: start main 0:
entry:
; CHECK: sp = sub sp 40 64
; CHECK-NEXT: r1 = call read
; CHECK-NEXT: store 8 r1 sp 0
; CHECK-NEXT: r1 = call read
; CHECK-NEXT: store 8 r1 sp 8
; CHECK-NEXT: r1 = call read
; CHECK-NEXT: store 8 r1 sp 16
; CHECK-NEXT: r1 = load 8 sp 0
; CHECK-NEXT: r2 = load 8 sp 8
; CHECK-NEXT: r3 = load 8 sp 16
; CHECK-NEXT: r1 = call doShift r1 r2 r3
; CHECK-NEXT: store 8 r1 sp 24
; CHECK-NEXT: r1 = load 8 sp 24
; CHECK-NEXT: r2 = and r1 2147483648 64
; CHECK-NEXT: r2 = sub 0 r2 64
; CHECK-NEXT: r1 = or r2 r1 64
; CHECK-NEXT: store 8 r1 sp 32
; CHECK-NEXT: r1 = load 8 sp 32
; CHECK-NEXT: call write r1
; CHECK-NEXT: ret 0
  %call = call i64 (...) @read()
  %call1 = call i64 (...) @read()
  %call2 = call i64 (...) @read()
  %call3 = call i32 @doShift(i64 %call, i64 %call1, i64 %call2)
  %conv = sext i32 %call3 to i64
  call void @write(i64 %conv)
  ret i32 0
}
; CHECK: end main

declare i64 @read(...) #2

declare void @write(i64) #2

attributes #0 = { nounwind ssp uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="penryn" "target-features"="+cx16,+cx8,+fxsr,+mmx,+sahf,+sse,+sse2,+sse3,+sse4.1,+ssse3,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { argmemonly nounwind willreturn }
attributes #2 = { "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="penryn" "target-features"="+cx16,+cx8,+fxsr,+mmx,+sahf,+sse,+sse2,+sse3,+sse4.1,+ssse3,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }

!llvm.module.flags = !{!0, !1, !2}
!llvm.ident = !{!3}

!0 = !{i32 2, !"SDK Version", [2 x i32] [i32 10, i32 14]}
!1 = !{i32 1, !"wchar_size", i32 4}
!2 = !{i32 7, !"PIC Level", i32 2}
!3 = !{!"clang version 10.0.1 (git@github.com:llvm/llvm-project.git 92d5c1be9ee93850c0a8903f05f36a23ee835dc2)"}
