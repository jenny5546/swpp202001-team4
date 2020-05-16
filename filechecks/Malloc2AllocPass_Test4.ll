; ModuleID = '/tmp/a.ll'
source_filename = "../swpp202001-team4/Malloc2Alloc_Test4.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

; Function Attrs: nounwind uwtable
define dso_local void @test1() #0 {
; CHECK: start test1 0:
; CHECK-NEXT:   .entry:
; CHECK-NEXT:     ; init sp!
; CHECK-NEXT:     sp = sub sp 904 64
; CHECK-NEXT:     r1 = add sp 104 64
; CHECK-NEXT:     store 8 r1 sp 0
; CHECK-NEXT:     r1 = load 8 sp 0
; CHECK-NEXT:     store 8 r1 sp 8
; CHECK-NEXT:     store 8 0 sp 24
; CHECK-NEXT:     r1 = load 8 sp 24
; CHECK-NEXT:     store 8 r1 sp 16
; CHECK-NEXT:     br .for.cond
; CHECK:   .for.cond:
; CHECK-NEXT:     r1 = load 8 sp 16
; CHECK-NEXT:     r1 = icmp slt r1 100 32
; CHECK-NEXT:     store 8 r1 sp 32
; CHECK-NEXT:     r1 = load 8 sp 32
; CHECK-NEXT:     br r1 .for.body .for.cond.cleanup
; CHECK:   .for.cond.cleanup:
; CHECK-NEXT:     br .for.end
; CHECK:   .for.body:
; CHECK-NEXT:     r1 = load 8 sp 16
; CHECK-NEXT:     r2 = and r1 2147483648 64
; CHECK-NEXT:     r2 = sub 0 r2 64
; CHECK-NEXT:     r1 = or r2 r1 64
; CHECK-NEXT:     store 8 r1 sp 40
; CHECK-NEXT:     r1 = load 8 sp 16
; CHECK-NEXT:     r2 = and r1 2147483648 64
; CHECK-NEXT:     r2 = sub 0 r2 64
; CHECK-NEXT:     r1 = or r2 r1 64
; CHECK-NEXT:     store 8 r1 sp 48
; CHECK-NEXT:     r1 = load 8 sp 8
; CHECK-NEXT:     r2 = load 8 sp 48
; CHECK-NEXT:     r2 = mul r2 8 64
; CHECK-NEXT:     r1 = add r1 r2 64
; CHECK-NEXT:     store 8 r1 sp 56
; CHECK-NEXT:     r1 = load 8 sp 40
; CHECK-NEXT:     r2 = load 8 sp 56
; CHECK-NEXT:     store 8 r1 r2 0
; CHECK-NEXT:     r1 = load 8 sp 16
; CHECK-NEXT:     r2 = and r1 2147483648 64
; CHECK-NEXT:     r2 = sub 0 r2 64
; CHECK-NEXT:     r1 = or r2 r1 64
; CHECK-NEXT:     store 8 r1 sp 64
; CHECK-NEXT:     r1 = load 8 sp 8
; CHECK-NEXT:     r2 = load 8 sp 64
; CHECK-NEXT:     r2 = mul r2 8 64
; CHECK-NEXT:     r1 = add r1 r2 64
; CHECK-NEXT:     store 8 r1 sp 72
; CHECK-NEXT:     r1 = load 8 sp 72
; CHECK-NEXT:     r1 = load 8 r1 0
; CHECK-NEXT:     store 8 r1 sp 80
; CHECK-NEXT:     r1 = load 8 sp 80
; CHECK-NEXT:     call bar r1
; CHECK-NEXT:     br .for.inc
; CHECK:   .for.inc:
; CHECK-NEXT:     r1 = load 8 sp 16
; CHECK-NEXT:     r1 = add r1 1 32
; CHECK-NEXT:     store 8 r1 sp 88
; CHECK-NEXT:     r1 = load 8 sp 88
; CHECK-NEXT:     store 8 r1 sp 24
; CHECK-NEXT:     r1 = load 8 sp 24
; CHECK-NEXT:     store 8 r1 sp 16
; CHECK-NEXT:     br .for.cond
; CHECK:   .for.end:
; CHECK-NEXT:     r1 = load 8 sp 8
; CHECK-NEXT:     store 8 r1 sp 96
; CHECK-NEXT:     ret 0
; CHECK-NEXT: end test1

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
; CHECK: ; Function bar
; CHECK-NEXT: start bar 1:
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
; CHECK: start test2 0:
; CHECK-NEXT:   .entry:
; CHECK-NEXT:     ; init sp!
; CHECK-NEXT:     sp = sub sp 2152 64
; CHECK-NEXT:     r1 = add sp 104 64
; CHECK-NEXT:     store 8 r1 sp 0
; CHECK-NEXT:     r1 = load 8 sp 0
; CHECK-NEXT:     store 8 r1 sp 8
; CHECK-NEXT:     store 8 0 sp 24
; CHECK-NEXT:     r1 = load 8 sp 24
; CHECK-NEXT:     store 8 r1 sp 16
; CHECK-NEXT:     br .for.cond
; CHECK:   .for.cond:
; CHECK-NEXT:     r1 = load 8 sp 16
; CHECK-NEXT:     r1 = icmp slt r1 256 32
; CHECK-NEXT:     store 8 r1 sp 32
; CHECK-NEXT:     r1 = load 8 sp 32
; CHECK-NEXT:     br r1 .for.body .for.cond.cleanup
; CHECK:   .for.cond.cleanup:
; CHECK-NEXT:     br .for.end
; CHECK:   .for.body:
; CHECK-NEXT:     r1 = load 8 sp 16
; CHECK-NEXT:     r2 = and r1 2147483648 64
; CHECK-NEXT:     r2 = sub 0 r2 64
; CHECK-NEXT:     r1 = or r2 r1 64
; CHECK-NEXT:     store 8 r1 sp 40
; CHECK-NEXT:     r1 = load 8 sp 16
; CHECK-NEXT:     r2 = and r1 2147483648 64
; CHECK-NEXT:     r2 = sub 0 r2 64
; CHECK-NEXT:     r1 = or r2 r1 64
; CHECK-NEXT:     store 8 r1 sp 48
; CHECK-NEXT:     r1 = load 8 sp 8
; CHECK-NEXT:     r2 = load 8 sp 48
; CHECK-NEXT:     r2 = mul r2 8 64
; CHECK-NEXT:     r1 = add r1 r2 64
; CHECK-NEXT:     store 8 r1 sp 56
; CHECK-NEXT:     r1 = load 8 sp 40
; CHECK-NEXT:     r2 = load 8 sp 56
; CHECK-NEXT:     store 8 r1 r2 0
; CHECK-NEXT:     r1 = load 8 sp 16
; CHECK-NEXT:     r2 = and r1 2147483648 64
; CHECK-NEXT:     r2 = sub 0 r2 64
; CHECK-NEXT:     r1 = or r2 r1 64
; CHECK-NEXT:     store 8 r1 sp 64
; CHECK-NEXT:     r1 = load 8 sp 8
; CHECK-NEXT:     r2 = load 8 sp 64
; CHECK-NEXT:     r2 = mul r2 8 64
; CHECK-NEXT:     r1 = add r1 r2 64
; CHECK-NEXT:     store 8 r1 sp 72
; CHECK-NEXT:     r1 = load 8 sp 72
; CHECK-NEXT:     r1 = load 8 r1 0
; CHECK-NEXT:     store 8 r1 sp 80
; CHECK-NEXT:     r1 = load 8 sp 80
; CHECK-NEXT:     call bar r1
; CHECK-NEXT:     br .for.inc
; CHECK:   .for.inc:
; CHECK-NEXT:     r1 = load 8 sp 16
; CHECK-NEXT:     r1 = add r1 1 32
; CHECK-NEXT:     store 8 r1 sp 88
; CHECK-NEXT:     r1 = load 8 sp 88
; CHECK-NEXT:     store 8 r1 sp 24
; CHECK-NEXT:     r1 = load 8 sp 24
; CHECK-NEXT:     store 8 r1 sp 16
; CHECK-NEXT:     br .for.cond
; CHECK:   .for.end:
; CHECK-NEXT:     r1 = load 8 sp 8
; CHECK-NEXT:     store 8 r1 sp 96
; CHECK-NEXT:     ret 0
; CHECK-NEXT: end test2

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

declare dso_local void @write(i64) #3

; Function Attrs: nounwind uwtable
define dso_local i32 @main() #0 {
; CHECK: start main 0:
; CHECK-NEXT:   .entry:
; CHECK-NEXT:     call test1
; CHECK-NEXT:     call test2
; CHECK-NEXT:     ret 0
; CHECK-NEXT: end main

entry:
  call void @test1()
  call void @test2()
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
