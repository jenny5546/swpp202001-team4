; ModuleID = '/tmp/a.ll'
source_filename = "../swpp202001-team4/GVNPass_Test4.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

; Function Attrs: nounwind uwtable
define dso_local void @test1(i64* %ptr, i32 %n) #0 {
; CHECK-LABEL: test1
entry:
  br label %for.cond

for.cond:                                         ; preds = %for.inc, %entry
  %i.0 = phi i32 [ 1, %entry ], [ %inc, %for.inc ]
  %cmp = icmp slt i32 %i.0, %n
  br i1 %cmp, label %for.body, label %for.cond.cleanup

for.cond.cleanup:                                 ; preds = %for.cond
  br label %for.end

for.body:                                         ; preds = %for.cond
; CHECK: .for.body:
; CHECK: [[REG1:r[0-9]+]] = load 8 [[REG2:r[0-9]+]]
; CHECK: [[REG3:r[0-9]+]] = load 8 [[REG4:r[0-9]+]]
  %idxprom = sext i32 %i.0 to i64
  %arrayidx = getelementptr inbounds i64, i64* %ptr, i64 %idxprom
  %0 = load i64, i64* %arrayidx, align 8
  %sub = sub nsw i32 %i.0, 1
  %idxprom1 = sext i32 %sub to i64
  %arrayidx2 = getelementptr inbounds i64, i64* %ptr, i64 %idxprom1
  %1 = load i64, i64* %arrayidx2, align 8
  %cmp3 = icmp ult i64 %0, %1
  br i1 %cmp3, label %if.then, label %if.end

if.then:                                          ; preds = %for.body
; CHECK: .if.then:
; CHECK-NOT: mul
; CHECK-DAG: store 8 [[REG1]]
; CHECK-DAG: store 8 [[REG3]]
  %idxprom4 = sext i32 %i.0 to i64
  %arrayidx5 = getelementptr inbounds i64, i64* %ptr, i64 %idxprom4
  store i64 %1, i64* %arrayidx5, align 8
  %sub6 = sub nsw i32 %i.0, 1
  %idxprom7 = sext i32 %sub6 to i64
  %arrayidx8 = getelementptr inbounds i64, i64* %ptr, i64 %idxprom7
  store i64 %0, i64* %arrayidx8, align 8
  br label %if.end

if.end:                                           ; preds = %if.then, %for.body
  br label %for.inc

for.inc:                                          ; preds = %if.end
  %inc = add nsw i32 %i.0, 1
  br label %for.cond

for.end:                                          ; preds = %for.cond.cleanup
  ret void
}

; Function Attrs: argmemonly nounwind willreturn
declare void @llvm.lifetime.start.p0i8(i64 immarg, i8* nocapture) #1

; Function Attrs: argmemonly nounwind willreturn
declare void @llvm.lifetime.end.p0i8(i64 immarg, i8* nocapture) #1

; Function Attrs: nounwind uwtable
define dso_local i32 @main() #0 {
; CHECK-LABEL: main
; CHECK-NOT: malloc
; CHECK-NOT: free
entry:
  %mul = mul nsw i32 8, 10
  %conv = sext i32 %mul to i64
  %call = call noalias i8* @malloc(i64 %conv) #3
  %0 = bitcast i8* %call to i64*
  br label %for.cond

for.cond:                                         ; preds = %for.inc, %entry
  %i.0 = phi i32 [ 0, %entry ], [ %inc, %for.inc ]
  %cmp = icmp slt i32 %i.0, 10
  br i1 %cmp, label %for.body, label %for.cond.cleanup

for.cond.cleanup:                                 ; preds = %for.cond
  br label %for.end

for.body:                                         ; preds = %for.cond
  %conv2 = sext i32 %i.0 to i64
  %idxprom = sext i32 %i.0 to i64
  %arrayidx = getelementptr inbounds i64, i64* %0, i64 %idxprom
  store i64 %conv2, i64* %arrayidx, align 8
  br label %for.inc

for.inc:                                          ; preds = %for.body
  %inc = add nsw i32 %i.0, 1
  br label %for.cond

for.end:                                          ; preds = %for.cond.cleanup
  call void @test1(i64* %0, i32 10)
  %1 = bitcast i64* %0 to i8*
  call void @free(i8* %1) #3
  ret i32 0
}

; Function Attrs: nounwind
declare dso_local noalias i8* @malloc(i64) #2

; Function Attrs: nounwind
declare dso_local void @free(i8*) #2

attributes #0 = { nounwind uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="none" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { argmemonly nounwind willreturn }
attributes #2 = { nounwind "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="none" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #3 = { nounwind }

!llvm.module.flags = !{!0}
!llvm.ident = !{!1}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{!"clang version 10.0.1 (https://github.com/llvm/llvm-project.git 4b2f37b2202ebb5c6c05cf00026f506c52a62909)"}
