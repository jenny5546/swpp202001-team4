; ModuleID = '/tmp/a.ll'
source_filename = "../swpp202001-team4/Malloc2Alloc_Test2.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

; Function Attrs: nounwind uwtable
define dso_local void @test1() #0 {
; CHECK-LABEL: test1
; CHECK-NOT: malloc
; CHECK-NOT: free
  
entry:
  %call = call noalias i8* @malloc(i64 800) #4
  %0 = bitcast i8* %call to i64*
  br label %for.cond

for.cond:                                         ; preds = %for.inc, %entry
  %i.0 = phi i32 [ 0, %entry ], [ %inc, %for.inc ]
  %cmp = icmp slt i32 %i.0, 100
  br i1 %cmp, label %for.body, label %for.cond.cleanup

for.cond.cleanup:                                 ; preds = %for.cond
  br label %for.end

for.body:                                         ; preds = %for.cond
  %conv = sext i32 %i.0 to i64
  %idxprom = sext i32 %i.0 to i64
  %arrayidx = getelementptr inbounds i64, i64* %0, i64 %idxprom
  store i64 %conv, i64* %arrayidx, align 8
  %idxprom1 = sext i32 %i.0 to i64
  %arrayidx2 = getelementptr inbounds i64, i64* %0, i64 %idxprom1
  %1 = load i64, i64* %arrayidx2, align 8
  call void @bar(i64 %1)
  br label %for.inc

for.inc:                                          ; preds = %for.body
  %inc = add nsw i32 %i.0, 1
  br label %for.cond

for.end:                                          ; preds = %for.cond.cleanup
  %2 = bitcast i64* %0 to i8*
  call void @free(i8* %2) #4
  ret void
}

; Function Attrs: argmemonly nounwind willreturn
declare void @llvm.lifetime.start.p0i8(i64 immarg, i8* nocapture) #1

; Function Attrs: nounwind
declare dso_local noalias i8* @malloc(i64) #2

; Function Attrs: nounwind uwtable
define dso_local void @bar(i64 %a) #0 {
; CHECK: start bar 1:
; CHECK-NEXT:   .entry:
; CHECK-NEXT:     call write arg1
; CHECK-NEXT:     ret 0
; CHECK-NEXT: end bar
entry:
  call void @write(i64 %a)
  ret void
}

; Function Attrs: argmemonly nounwind willreturn
declare void @llvm.lifetime.end.p0i8(i64 immarg, i8* nocapture) #1

; Function Attrs: nounwind
declare dso_local void @free(i8*) #2

; Function Attrs: nounwind uwtable
define dso_local void @test2() #0 {
; CHECK-LABEL: test2
; CHECK-NOT: malloc
; CHECK-NOT: free

entry:
  %call = call noalias i8* @malloc(i64 2048) #4
  %0 = bitcast i8* %call to i64*
  br label %for.cond

for.cond:                                         ; preds = %for.inc, %entry
  %i.0 = phi i32 [ 0, %entry ], [ %inc, %for.inc ]
  %cmp = icmp slt i32 %i.0, 256
  br i1 %cmp, label %for.body, label %for.cond.cleanup

for.cond.cleanup:                                 ; preds = %for.cond
  br label %for.end

for.body:                                         ; preds = %for.cond
  %conv = sext i32 %i.0 to i64
  %idxprom = sext i32 %i.0 to i64
  %arrayidx = getelementptr inbounds i64, i64* %0, i64 %idxprom
  store i64 %conv, i64* %arrayidx, align 8
  %idxprom1 = sext i32 %i.0 to i64
  %arrayidx2 = getelementptr inbounds i64, i64* %0, i64 %idxprom1
  %1 = load i64, i64* %arrayidx2, align 8
  call void @bar(i64 %1)
  br label %for.inc

for.inc:                                          ; preds = %for.body
  %inc = add nsw i32 %i.0, 1
  br label %for.cond

for.end:                                          ; preds = %for.cond.cleanup
  %2 = bitcast i64* %0 to i8*
  call void @free(i8* %2) #4
  ret void
}

; Function Attrs: nounwind uwtable
define dso_local void @test3() #0 {
; CHECK-LABEL: test3
; CHECK: malloc
; CHECK: free

entry:
  %call = call noalias i8* @malloc(i64 2400) #4
  %0 = bitcast i8* %call to i64*
  br label %for.cond

for.cond:                                         ; preds = %for.inc, %entry
  %i.0 = phi i32 [ 0, %entry ], [ %inc, %for.inc ]
  %cmp = icmp slt i32 %i.0, 300
  br i1 %cmp, label %for.body, label %for.cond.cleanup

for.cond.cleanup:                                 ; preds = %for.cond
  br label %for.end

for.body:                                         ; preds = %for.cond
  %conv = sext i32 %i.0 to i64
  %idxprom = sext i32 %i.0 to i64
  %arrayidx = getelementptr inbounds i64, i64* %0, i64 %idxprom
  store i64 %conv, i64* %arrayidx, align 8
  %idxprom1 = sext i32 %i.0 to i64
  %arrayidx2 = getelementptr inbounds i64, i64* %0, i64 %idxprom1
  %1 = load i64, i64* %arrayidx2, align 8
  call void @bar(i64 %1)
  br label %for.inc

for.inc:                                          ; preds = %for.body
  %inc = add nsw i32 %i.0, 1
  br label %for.cond

for.end:                                          ; preds = %for.cond.cleanup
  %2 = bitcast i64* %0 to i8*
  call void @free(i8* %2) #4
  ret void
}

declare dso_local void @write(i64) #3

; Function Attrs: nounwind uwtable
define dso_local i32 @main() #0 {

entry:
  call void @test1()
  call void @test2()
  call void @test3()
  ret i32 0
}

attributes #0 = { nounwind uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="none" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { argmemonly nounwind willreturn }
attributes #2 = { nounwind "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="none" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #3 = { "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="none" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #4 = { nounwind }

!llvm.module.flags = !{!0}
!llvm.ident = !{!1}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{!"clang version 10.0.1 (https://github.com/llvm/llvm-project.git b11ecd196540d87cb7db190d405056984740d2ce)"}
