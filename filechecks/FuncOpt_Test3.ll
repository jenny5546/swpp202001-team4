; ModuleID = '/tmp/a.ll'
source_filename = "/Users/ohah/Documents/swpp-project/testcases/mod_functopt/2.c"
target datalayout = "e-m:o-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-apple-macosx10.14.0"

; Function Attrs: nounwind ssp uwtable
define i32 @main() #0 {
; CHECK: start main 0:
entry:
  %call = call i32 @fibonacci(i32 10)
  ret i32 0
}
; CHECK: end main

; Function Attrs: argmemonly nounwind willreturn
declare void @llvm.lifetime.start.p0i8(i64 immarg, i8* nocapture) #1

; Function Attrs: nounwind ssp uwtable
define i32 @fibonacci(i32 %n) #0 {
; CHECK: start fibonacci 1:
entry:
  %cmp = icmp eq i32 %n, 0
  br i1 %cmp, label %if.then, label %if.else

if.then:                                          ; preds = %entry
  br label %return

if.else:                                          ; preds = %entry
  %cmp1 = icmp eq i32 %n, 1
  br i1 %cmp1, label %if.then2, label %if.else3

if.then2:                                         ; preds = %if.else
  br label %return

if.else3:                                         ; preds = %if.else
; CHECK: .if.else3:
  ; CHECK-NOT: store
  ; CHECK: call
  ; CHECK: call
  ; CHECK: .return:
  %sub = sub nsw i32 %n, 1
  %call = call i32 @fibonacci(i32 %sub)
  %sub4 = sub nsw i32 %n, 2
  %call5 = call i32 @fibonacci(i32 %sub4)
  %add = add nsw i32 %call, %call5
  br label %return

return:                                           ; preds = %if.else3, %if.then2, %if.then
  %retval.0 = phi i32 [ 0, %if.then ], [ 1, %if.then2 ], [ %add, %if.else3 ]
  ret i32 %retval.0
}
; CHECK: end fibonacci

; Function Attrs: argmemonly nounwind willreturn
declare void @llvm.lifetime.end.p0i8(i64 immarg, i8* nocapture) #1

attributes #0 = { nounwind ssp uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="penryn" "target-features"="+cx16,+cx8,+fxsr,+mmx,+sahf,+sse,+sse2,+sse3,+sse4.1,+ssse3,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { argmemonly nounwind willreturn }

!llvm.module.flags = !{!0, !1, !2}
!llvm.ident = !{!3}

!0 = !{i32 2, !"SDK Version", [2 x i32] [i32 10, i32 14]}
!1 = !{i32 1, !"wchar_size", i32 4}
!2 = !{i32 7, !"PIC Level", i32 2}
!3 = !{!"clang version 10.0.1 (git@github.com:llvm/llvm-project.git 92d5c1be9ee93850c0a8903f05f36a23ee835dc2)"}
