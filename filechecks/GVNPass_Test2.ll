; ModuleID = '/tmp/a.ll'
source_filename = "../swpp202001-team4/GVNPass_Test3.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

@num = external dso_local global i64, align 8

; Function Attrs: nounwind uwtable
define dso_local void @test1() #0 {
; CHECK-LABEL: test1
; CHECK: .while.body:
; CHECK: store
; CHECK-NOT: load
; CHECK: call foo

entry:
  store i64 0, i64* @num, align 8
  br label %while.cond

while.cond:                                       ; preds = %if.end, %entry
  %i.0 = phi i32 [ 0, %entry ], [ %inc1, %if.end ]
  %cmp = icmp slt i32 %i.0, 100
  br i1 %cmp, label %while.body, label %while.end

while.body:                                       ; preds = %while.cond
  %0 = load i64, i64* @num, align 8
  %inc = add nsw i64 %0, 1
  store i64 %inc, i64* @num, align 8
  %1 = load i64, i64* @num, align 8
  %call = call i32 @foo(i64 %1)
  %tobool = icmp ne i32 %call, 0
  br i1 %tobool, label %if.then, label %if.end

if.then:                                          ; preds = %while.body
  br label %while.end

if.end:                                           ; preds = %while.body
  %inc1 = add nsw i32 %i.0, 1
  br label %while.cond

while.end:                                        ; preds = %if.then, %while.cond
  ret void
}

; Function Attrs: argmemonly nounwind willreturn
declare void @llvm.lifetime.start.p0i8(i64 immarg, i8* nocapture) #1

; Function Attrs: nounwind uwtable
define dso_local i32 @foo(i64 %a) #0 {
entry:
  %cmp = icmp eq i64 %a, 10
  br i1 %cmp, label %if.then, label %if.else

if.then:                                          ; preds = %entry
  br label %return

if.else:                                          ; preds = %entry
  br label %return

return:                                           ; preds = %if.else, %if.then
  %retval.0 = phi i32 [ 1, %if.then ], [ 0, %if.else ]
  ret i32 %retval.0
}

; Function Attrs: argmemonly nounwind willreturn
declare void @llvm.lifetime.end.p0i8(i64 immarg, i8* nocapture) #1

; Function Attrs: nounwind uwtable
define dso_local i32 @main() #0 {
entry:
  call void @test1()
  ret i32 0
}

attributes #0 = { nounwind uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="none" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { argmemonly nounwind willreturn }

!llvm.module.flags = !{!0}
!llvm.ident = !{!1}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{!"clang version 10.0.1 (https://github.com/llvm/llvm-project.git 4b2f37b2202ebb5c6c05cf00026f506c52a62909)"}
