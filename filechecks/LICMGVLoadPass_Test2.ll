; ModuleID = '/tmp/a.ll'
source_filename = "../swpp202001-team4/licmtest2.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

@N = external dso_local global i64, align 8
@array1 = external dso_local global i64*, align 8
@array2 = external dso_local global i64*, align 8

; Function Attrs: nounwind uwtable
define dso_local i32 @test1() #0 {
; CHECK-LABEL: test1
; CHECK: load 8 20480 0
; CHECK: load 8 20488 0
; CHECK: .for.cond
; CHECK-NOT: load 8 20480 0
; CHECK-NOT: load 8 20488 0
; CHECK: end test1

entry:
  br label %for.cond

for.cond:                                         ; preds = %for.inc, %entry
  %i.0 = phi i32 [ 2, %entry ], [ %inc, %for.inc ]
  %conv = sext i32 %i.0 to i64
  %0 = load i64, i64* @N, align 8
  %cmp = icmp slt i64 %conv, %0
  br i1 %cmp, label %for.body, label %for.cond.cleanup

for.cond.cleanup:                                 ; preds = %for.cond
  br label %for.end

for.body:                                         ; preds = %for.cond
  %1 = load i64*, i64** @array1, align 8
  %sub = sub nsw i32 %i.0, 1
  %idxprom = sext i32 %sub to i64
  %arrayidx = getelementptr inbounds i64, i64* %1, i64 %idxprom
  %2 = load i64, i64* %arrayidx, align 8
  %3 = load i64*, i64** @array1, align 8
  %sub2 = sub nsw i32 %i.0, 2
  %idxprom3 = sext i32 %sub2 to i64
  %arrayidx4 = getelementptr inbounds i64, i64* %3, i64 %idxprom3
  %4 = load i64, i64* %arrayidx4, align 8
  %add = add nsw i64 %2, %4
  %5 = load i64*, i64** @array1, align 8
  %idxprom5 = sext i32 %i.0 to i64
  %arrayidx6 = getelementptr inbounds i64, i64* %5, i64 %idxprom5
  store i64 %add, i64* %arrayidx6, align 8
  br label %for.inc

for.inc:                                          ; preds = %for.body
  %inc = add nsw i32 %i.0, 1
  br label %for.cond

for.end:                                          ; preds = %for.cond.cleanup
  ret i32 0
}

; Function Attrs: argmemonly nounwind willreturn
declare void @llvm.lifetime.start.p0i8(i64 immarg, i8* nocapture) #1

; Function Attrs: argmemonly nounwind willreturn
declare void @llvm.lifetime.end.p0i8(i64 immarg, i8* nocapture) #1

; Function Attrs: nounwind uwtable
define dso_local i32 @test2() #0 {
; CHECK-LABEL: test2
; CHECK: load 8 20496 0
; CHECK: .for.cond:
; CHECK: load 8 20480 0

entry:
  br label %for.cond

for.cond:                                         ; preds = %for.inc, %entry
  %i.0 = phi i32 [ 0, %entry ], [ %inc, %for.inc ]
  %conv = sext i32 %i.0 to i64
  %0 = load i64, i64* @N, align 8
  %cmp = icmp slt i64 %conv, %0
  br i1 %cmp, label %for.body, label %for.cond.cleanup

for.cond.cleanup:                                 ; preds = %for.cond
  br label %for.end

for.body:                                         ; preds = %for.cond
  %1 = load i64*, i64** @array2, align 8
  %idxprom = sext i32 %i.0 to i64
  %arrayidx = getelementptr inbounds i64, i64* %1, i64 %idxprom
  %2 = load i64, i64* %arrayidx, align 8
  call void @write(i64 %2)
  %3 = load i64, i64* @N, align 8
  %dec = add nsw i64 %3, -1
  store i64 %dec, i64* @N, align 8
  br label %for.inc

for.inc:                                          ; preds = %for.body
  %inc = add nsw i32 %i.0, 1
  br label %for.cond

for.end:                                          ; preds = %for.cond.cleanup
  ret i32 0
}

declare dso_local void @write(i64) #2

; Function Attrs: nounwind uwtable
define dso_local i32 @main() #0 {
; CHECK-LABEL: main
; CHECK: .for.cond4:
; CHECK-NOT: load 8 20480 0
; CHECK-NOT: load 8 20496 0
; CHECK: br

entry:
  store i64 100, i64* @N, align 8
  %0 = load i64, i64* @N, align 8
  %mul = mul nsw i64 8, %0
  %call = call noalias i8* @malloc(i64 %mul) #4
  %1 = bitcast i8* %call to i64*
  store i64* %1, i64** @array1, align 8
  %2 = load i64, i64* @N, align 8
  %mul1 = mul nsw i64 8, %2
  %call2 = call noalias i8* @malloc(i64 %mul1) #4
  %3 = bitcast i8* %call2 to i64*
  store i64* %3, i64** @array2, align 8
  br label %for.cond

for.cond:                                         ; preds = %for.inc, %entry
  %i.0 = phi i32 [ 0, %entry ], [ %inc, %for.inc ]
  %cmp = icmp slt i32 %i.0, 2
  br i1 %cmp, label %for.body, label %for.cond.cleanup

for.cond.cleanup:                                 ; preds = %for.cond
  br label %for.end

for.body:                                         ; preds = %for.cond
  %4 = load i64*, i64** @array1, align 8
  %idxprom = sext i32 %i.0 to i64
  %arrayidx = getelementptr inbounds i64, i64* %4, i64 %idxprom
  store i64 1, i64* %arrayidx, align 8
  br label %for.inc

for.inc:                                          ; preds = %for.body
  %inc = add nsw i32 %i.0, 1
  br label %for.cond

for.end:                                          ; preds = %for.cond.cleanup
  br label %for.cond4

for.cond4:                                        ; preds = %for.inc12, %for.end
  %i3.0 = phi i32 [ 0, %for.end ], [ %inc13, %for.inc12 ]
  %conv = sext i32 %i3.0 to i64
  %5 = load i64, i64* @N, align 8
  %cmp5 = icmp slt i64 %conv, %5
  br i1 %cmp5, label %for.body8, label %for.cond.cleanup7

for.cond.cleanup7:                                ; preds = %for.cond4
  br label %for.end14

for.body8:                                        ; preds = %for.cond4
  %conv9 = sext i32 %i3.0 to i64
  %6 = load i64*, i64** @array2, align 8
  %idxprom10 = sext i32 %i3.0 to i64
  %arrayidx11 = getelementptr inbounds i64, i64* %6, i64 %idxprom10
  store i64 %conv9, i64* %arrayidx11, align 8
  br label %for.inc12

for.inc12:                                        ; preds = %for.body8
  %inc13 = add nsw i32 %i3.0, 1
  br label %for.cond4

for.end14:                                        ; preds = %for.cond.cleanup7
  %call15 = call i32 @test1()
  %call16 = call i32 @test2()
  ret i32 0
}

; Function Attrs: nounwind
declare dso_local noalias i8* @malloc(i64) #3

attributes #0 = { nounwind uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="none" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { argmemonly nounwind willreturn }
attributes #2 = { "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="none" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #3 = { nounwind "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="none" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #4 = { nounwind }

!llvm.module.flags = !{!0}
!llvm.ident = !{!1}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{!"clang version 10.0.1 (https://github.com/llvm/llvm-project.git 4b2f37b2202ebb5c6c05cf00026f506c52a62909)"}
