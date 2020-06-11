; ModuleID = '/tmp/a.ll'
source_filename = "../swpp202001-team4/licmtest3.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

@N = external dso_local global i64, align 8
@M = external dso_local global i64, align 8

; Function Attrs: nounwind uwtable
define dso_local i64 @test1() #0 {
; CHECK-LABEL: test1
; CHECK-DAG: load 8 20480
; CHECK-DAG: load 8 20488
; CHECK-DAG: reset
; CHECK: .for.cond
entry:
  br label %for.cond

for.cond:                                         ; preds = %for.inc8, %entry
  %i.0 = phi i32 [ 0, %entry ], [ %inc9, %for.inc8 ]
  %conv = sext i32 %i.0 to i64
  %0 = load i64, i64* @N, align 8
  %cmp = icmp slt i64 %conv, %0
  br i1 %cmp, label %for.body, label %for.cond.cleanup

for.cond.cleanup:                                 ; preds = %for.cond
  br label %for.end10

for.body:                                         ; preds = %for.cond
  br label %for.cond2

for.cond2:                                        ; preds = %for.inc, %for.body
  %j.0 = phi i32 [ 0, %for.body ], [ %inc, %for.inc ]
  %conv3 = sext i32 %j.0 to i64
  %1 = load i64, i64* @M, align 8
  %cmp4 = icmp slt i64 %conv3, %1
  br i1 %cmp4, label %for.body7, label %for.cond.cleanup6

for.cond.cleanup6:                                ; preds = %for.cond2
  br label %for.end

for.body7:                                        ; preds = %for.cond2
  %2 = load i64, i64* @N, align 8
  %3 = load i64, i64* @M, align 8
  %mul = mul nsw i64 %2, %3
  call void @write(i64 %mul)
  br label %for.inc

for.inc:                                          ; preds = %for.body7
  %inc = add nsw i32 %j.0, 1
  br label %for.cond2

for.end:                                          ; preds = %for.cond.cleanup6
  br label %for.inc8

for.inc8:                                         ; preds = %for.end
  %inc9 = add nsw i32 %i.0, 1
  br label %for.cond

for.end10:                                        ; preds = %for.cond.cleanup
  ret i64 0
}

; Function Attrs: argmemonly nounwind willreturn
declare void @llvm.lifetime.start.p0i8(i64 immarg, i8* nocapture) #1

declare dso_local void @write(i64) #2

; Function Attrs: argmemonly nounwind willreturn
declare void @llvm.lifetime.end.p0i8(i64 immarg, i8* nocapture) #1

; Function Attrs: nounwind uwtable
define dso_local i32 @main() #0 {
entry:
  store i64 10, i64* @N, align 8
  store i64 20, i64* @M, align 8
  %call = call i64 @test1()
  ret i32 0
}

attributes #0 = { nounwind uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="none" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { argmemonly nounwind willreturn }
attributes #2 = { "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="none" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }

!llvm.module.flags = !{!0}
!llvm.ident = !{!1}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{!"clang version 10.0.1 (https://github.com/llvm/llvm-project.git 4b2f37b2202ebb5c6c05cf00026f506c52a62909)"}
