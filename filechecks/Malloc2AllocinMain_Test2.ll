; ModuleID = '/tmp/a.ll'
source_filename = "../swpp202001-team4/Malloc2AllocinMain_Test2.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

@address1 = external dso_local global i64*, align 8
@address2 = external dso_local global i64*, align 8

; Function Attrs: nounwind uwtable
define dso_local void @test1() #0 {
; CHECK:      start test1 0:
; CHECK-NEXT:   .entry:
; CHECK-NEXT:     ; init sp!
; CHECK-NEXT:     sp = sub sp 16 64
; CHECK-NEXT:     store 8 0 sp 0
; CHECK-NEXT:     store 8 0 sp 8
; CHECK-NEXT:     br .for.cond
; CHECK:        .for.cond:
; CHECK-NEXT:     r1 = load 8 sp 0
; CHECK-NEXT:     r2 = load 8 sp 8
; CHECK-NEXT:     r8 = icmp ne r1 10 64
; CHECK-NEXT:     br r8 .for.body .for.end
; CHECK:        .for.body:
; CHECK-NEXT:     r12 = load 8 20480 0
; CHECK-NEXT:     r11 = add r12 r2 64
; CHECK-NEXT:     store 8 r1 r11 0
; CHECK-NEXT:     r10 = add r2 8 64
; CHECK-NEXT:     r9 = add r1 1 64
; CHECK-NEXT:     store 8 r9 sp 0
; CHECK-NEXT:     store 8 r10 sp 8
; CHECK-NEXT:     br .for.cond
; CHECK:        .for.end:
; CHECK-NEXT:     call test2
; CHECK-NEXT:     ret 0
; CHECK-NEXT: end test1

entry:
  br label %for.cond

for.cond:                                         ; preds = %for.inc, %entry
  %i.0 = phi i32 [ 0, %entry ], [ %inc, %for.inc ]
  %cmp = icmp slt i32 %i.0, 10
  br i1 %cmp, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %conv = sext i32 %i.0 to i64
  %0 = load i64*, i64** @address1, align 8
  %idxprom = sext i32 %i.0 to i64
  %arrayidx = getelementptr inbounds i64, i64* %0, i64 %idxprom
  store i64 %conv, i64* %arrayidx, align 8
  br label %for.inc

for.inc:                                          ; preds = %for.body
  %inc = add nsw i32 %i.0, 1
  br label %for.cond

for.end:                                          ; preds = %for.cond
  call void @test2()
  ret void
}

; Function Attrs: argmemonly nounwind willreturn
declare void @llvm.lifetime.start.p0i8(i64 immarg, i8* nocapture) #1

; Function Attrs: argmemonly nounwind willreturn
declare void @llvm.lifetime.end.p0i8(i64 immarg, i8* nocapture) #1

; Function Attrs: nounwind uwtable
define dso_local void @test2() #0 {
; CHECK:      start test2 0:
; CHECK-NEXT:   .entry:
; CHECK-NEXT:     ; init sp!
; CHECK-NEXT:     sp = sub sp 16 64
; CHECK-NEXT:     store 8 0 sp 0
; CHECK-NEXT:     store 8 0 sp 8
; CHECK-NEXT:     br .for.cond
; CHECK:        .for.cond:
; CHECK-NEXT:     r1 = load 8 sp 0
; CHECK-NEXT:     r2 = load 8 sp 8
; CHECK-NEXT:     r14 = load 8 20480 0
; CHECK-NEXT:     r3 = mul r14 1 64
; CHECK-NEXT:     r4 = icmp ne r2 10 32
; CHECK-NEXT:     br r4 .for.body .for.end
; CHECK:        .for.body:
; CHECK-NEXT:     r9 = add r3 r1 64
; CHECK-NEXT:     r13 = load 8 r9 0
; CHECK-NEXT:     r12 = add r13 1 64
; CHECK-NEXT:     r11 = load 8 20488 0
; CHECK-NEXT:     r16 = add r11 r1 64
; CHECK-NEXT:     store 8 r12 r16 0
; CHECK-NEXT:     r10 = add r2 1 32
; CHECK-NEXT:     r15 = add r1 8 64
; CHECK-NEXT:     store 8 r15 sp 0
; CHECK-NEXT:     store 8 r10 sp 8
; CHECK-NEXT:     br .for.cond
; CHECK-NEXT: 
; CHECK:        .for.end:
; CHECK-NEXT:     ret 0
; CHECK-NEXT: end test2

entry:
  br label %for.cond

for.cond:                                         ; preds = %for.inc, %entry
  %i.0 = phi i32 [ 0, %entry ], [ %inc, %for.inc ]
  %cmp = icmp slt i32 %i.0, 10
  br i1 %cmp, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %0 = load i64*, i64** @address1, align 8
  %idxprom = sext i32 %i.0 to i64
  %arrayidx = getelementptr inbounds i64, i64* %0, i64 %idxprom
  %1 = load i64, i64* %arrayidx, align 8
  %add = add nsw i64 %1, 1
  %2 = load i64*, i64** @address2, align 8
  %idxprom1 = sext i32 %i.0 to i64
  %arrayidx2 = getelementptr inbounds i64, i64* %2, i64 %idxprom1
  store i64 %add, i64* %arrayidx2, align 8
  br label %for.inc

for.inc:                                          ; preds = %for.body
  %inc = add nsw i32 %i.0, 1
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %3 = load i64*, i64** @address1, align 8
  %4 = bitcast i64* %3 to i8*
  call void @free(i8* %4) #4
  ret void
}

; Function Attrs: nounwind
declare dso_local void @free(i8*) #2

; Function Attrs: nounwind uwtable
define dso_local i32 @main() #0 {
; CHECK:      start main 0:
; CHECK-NEXT:   .entry:
; CHECK-NEXT:     ; init sp!
; CHECK-NEXT:     sp = sub sp 176 64
; CHECK-NEXT:     r1 = malloc 8
; CHECK-NEXT:     r1 = malloc 8
; CHECK-NEXT:     r16 = add sp 16 64
; CHECK-NEXT:     r1 = mul r16 1 64
; CHECK-NEXT:     r15 = add sp 96 64
; CHECK-NEXT:     store 8 r15 20480 0
; CHECK-NEXT:     store 8 r1 20488 0
; CHECK-NEXT:     call test1
; CHECK-NEXT:     store 8 0 sp 0
; CHECK-NEXT:     store 8 0 sp 8
; CHECK-NEXT:     br .for.cond
; CHECK:        .for.cond:
; CHECK-NEXT:     r5 = load 8 sp 0
; CHECK-NEXT:     r6 = load 8 sp 8
; CHECK-NEXT:     r12 = load 8 20488 0
; CHECK-NEXT:     r7 = mul r12 1 64
; CHECK-NEXT:     r9 = icmp ne r6 10 32
; CHECK-NEXT:     br r9 .for.body .for.end
; CHECK:        .for.body:
; CHECK-NEXT:     r13 = add r7 r5 64
; CHECK-NEXT:     r11 = load 8 r13 0
; CHECK-NEXT:     call write r11
; CHECK-NEXT:     r10 = add r6 1 32
; CHECK-NEXT:     r14 = add r5 8 64
; CHECK-NEXT:     store 8 r14 sp 0
; CHECK-NEXT:     store 8 r10 sp 8
; CHECK-NEXT:     br .for.cond
; CHECK:        .for.end:
; CHECK-NEXT:     ret 0
; CHECK-NEXT: end main

entry:
  %call = call noalias i8* @malloc(i64 80) #4
  %0 = bitcast i8* %call to i64*
  store i64* %0, i64** @address1, align 8
  %call1 = call noalias i8* @malloc(i64 80) #4
  %1 = bitcast i8* %call1 to i64*
  store i64* %1, i64** @address2, align 8
  %call2 = call noalias i8* @malloc(i64 88) #4
  call void @test1()
  br label %for.cond

for.cond:                                         ; preds = %for.inc, %entry
  %i.0 = phi i32 [ 0, %entry ], [ %inc, %for.inc ]
  %cmp = icmp slt i32 %i.0, 10
  br i1 %cmp, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %2 = load i64*, i64** @address2, align 8
  %idxprom = sext i32 %i.0 to i64
  %arrayidx = getelementptr inbounds i64, i64* %2, i64 %idxprom
  %3 = load i64, i64* %arrayidx, align 8
  call void @write(i64 %3)
  br label %for.inc

for.inc:                                          ; preds = %for.body
  %inc = add nsw i32 %i.0, 1
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %4 = load i64*, i64** @address2, align 8
  %5 = bitcast i64* %4 to i8*
  call void @free(i8* %5) #4
  ret i32 0
}

; Function Attrs: nounwind
declare dso_local noalias i8* @malloc(i64) #2

declare dso_local void @write(i64) #3

attributes #0 = { nounwind uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="none" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { argmemonly nounwind willreturn }
attributes #2 = { nounwind "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="none" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #3 = { "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="none" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #4 = { nounwind }

!llvm.module.flags = !{!0}
!llvm.ident = !{!1}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{!"clang version 10.0.1 (https://github.com/llvm/llvm-project.git 4b2f37b2202ebb5c6c05cf00026f506c52a62909)"}
