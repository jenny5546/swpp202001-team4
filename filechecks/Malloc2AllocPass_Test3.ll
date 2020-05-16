; ModuleID = '/tmp/a.ll'
source_filename = "../swpp202001-team4/Malloc2Alloc_Test3.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

; Function Attrs: nounwind uwtable
define dso_local void @test1() #0 {
; CHECK: start test1 0:
; CHECK-NEXT:   .entry:
; CHECK-NEXT:     ; init sp!
; CHECK-NEXT:     sp = sub sp 168 64
; CHECK-NEXT:     r1 = add sp 104 64
; CHECK-NEXT:     store 8 r1 sp 0
; CHECK-NEXT:     r1 = load 8 sp 0
; CHECK-NEXT:     store 8 r1 sp 8
; CHECK-NEXT:     r1 = load 8 sp 8
; CHECK-NEXT:     store 8 r1 sp 16
; CHECK-NEXT:     r2 = load 8 sp 16
; CHECK-NEXT:     store 4 0 r2 0
; CHECK-NEXT:     r1 = load 8 sp 8
; CHECK-NEXT:     r1 = add r1 4 64
; CHECK-NEXT:     store 8 r1 sp 24
; CHECK-NEXT:     r2 = load 8 sp 24
; CHECK-NEXT:     store 4 1 r2 0
; CHECK-NEXT:     r1 = load 8 sp 8
; CHECK-NEXT:     r1 = add r1 8 64
; CHECK-NEXT:     store 8 r1 sp 32
; CHECK-NEXT:     r2 = load 8 sp 32
; CHECK-NEXT:     store 4 2 r2 0
; CHECK-NEXT:     r1 = load 8 sp 8
; CHECK-NEXT:     r1 = add r1 12 64
; CHECK-NEXT:     store 8 r1 sp 40
; CHECK-NEXT:     r2 = load 8 sp 40
; CHECK-NEXT:     store 4 3 r2 0
; CHECK-NEXT:     store 8 1 sp 48
; CHECK-NEXT:     r1 = load 8 sp 48
; CHECK-NEXT:     br r1 .if.then .if.else
; CHECK:   .if.then:
; CHECK-NEXT:     r1 = load 8 sp 8
; CHECK-NEXT:     r1 = add r1 12 64
; CHECK-NEXT:     store 8 r1 sp 56
; CHECK-NEXT:     r1 = load 8 sp 56
; CHECK-NEXT:     r1 = load 4 r1 0
; CHECK-NEXT:     store 8 r1 sp 64
; CHECK-NEXT:     r1 = load 8 sp 64
; CHECK-NEXT:     call write r1
; CHECK-NEXT:     r1 = load 8 sp 8
; CHECK-NEXT:     store 8 r1 sp 72
; CHECK-NEXT:     br .if.end
; CHECK:   .if.else:
; CHECK-NEXT:     r1 = load 8 sp 8
; CHECK-NEXT:     r1 = add r1 8 64
; CHECK-NEXT:     store 8 r1 sp 80
; CHECK-NEXT:     r1 = load 8 sp 80
; CHECK-NEXT:     r1 = load 4 r1 0
; CHECK-NEXT:     store 8 r1 sp 88
; CHECK-NEXT:     r1 = load 8 sp 88
; CHECK-NEXT:     call write r1
; CHECK-NEXT:     r1 = load 8 sp 8
; CHECK-NEXT:     store 8 r1 sp 96
; CHECK-NEXT:     br .if.end
; CHECK:   .if.end:
; CHECK-NEXT:     ret 0
; CHECK-NEXT: end test1

entry:
  %call = call noalias i8* @malloc(i64 32) #4
  %0 = bitcast i8* %call to i32*
  %arrayidx = getelementptr inbounds i32, i32* %0, i64 0
  store i32 0, i32* %arrayidx, align 4
  %arrayidx1 = getelementptr inbounds i32, i32* %0, i64 1
  store i32 1, i32* %arrayidx1, align 4
  %arrayidx2 = getelementptr inbounds i32, i32* %0, i64 2
  store i32 2, i32* %arrayidx2, align 4
  %arrayidx3 = getelementptr inbounds i32, i32* %0, i64 3
  store i32 3, i32* %arrayidx3, align 4
  %tobool = icmp ne i32 1, 0
  br i1 %tobool, label %if.then, label %if.else

if.then:                                          ; preds = %entry
  %arrayidx4 = getelementptr inbounds i32, i32* %0, i64 3
  %1 = load i32, i32* %arrayidx4, align 4
  call void @write(i32 %1)
  %2 = bitcast i32* %0 to i8*
  call void @free(i8* %2) #4
  br label %if.end

if.else:                                          ; preds = %entry
  %arrayidx5 = getelementptr inbounds i32, i32* %0, i64 2
  %3 = load i32, i32* %arrayidx5, align 4
  call void @write(i32 %3)
  %4 = bitcast i32* %0 to i8*
  call void @free(i8* %4) #4
  br label %if.end

if.end:                                           ; preds = %if.else, %if.then
  ret void
}

; Function Attrs: argmemonly nounwind willreturn
declare void @llvm.lifetime.start.p0i8(i64 immarg, i8* nocapture) #1

; Function Attrs: nounwind
declare dso_local noalias i8* @malloc(i64) #2

declare dso_local void @write(i32) #3

; Function Attrs: nounwind
declare dso_local void @free(i8*) #2

; Function Attrs: argmemonly nounwind willreturn
declare void @llvm.lifetime.end.p0i8(i64 immarg, i8* nocapture) #1

; Function Attrs: nounwind uwtable
define dso_local void @test2() #0 {
; CHECK: start test2 0:
; CHECK-NEXT:   .entry:
; CHECK-NEXT:     ; init sp!
; CHECK-NEXT:     sp = sub sp 96 64
; CHECK-NEXT:     r1 = malloc 32
; CHECK-NEXT:     store 8 r1 sp 0
; CHECK-NEXT:     r1 = load 8 sp 0
; CHECK-NEXT:     store 8 r1 sp 8
; CHECK-NEXT:     r1 = load 8 sp 8
; CHECK-NEXT:     store 8 r1 sp 16
; CHECK-NEXT:     r2 = load 8 sp 16
; CHECK-NEXT:     store 4 0 r2 0
; CHECK-NEXT:     r1 = load 8 sp 8
; CHECK-NEXT:     r1 = add r1 4 64
; CHECK-NEXT:     store 8 r1 sp 24
; CHECK-NEXT:     r2 = load 8 sp 24
; CHECK-NEXT:     store 4 1 r2 0
; CHECK-NEXT:     r1 = load 8 sp 8
; CHECK-NEXT:     r1 = add r1 8 64
; CHECK-NEXT:     store 8 r1 sp 32
; CHECK-NEXT:     r2 = load 8 sp 32
; CHECK-NEXT:     store 4 2 r2 0
; CHECK-NEXT:     r1 = load 8 sp 8
; CHECK-NEXT:     r1 = add r1 12 64
; CHECK-NEXT:     store 8 r1 sp 40
; CHECK-NEXT:     r2 = load 8 sp 40
; CHECK-NEXT:     store 4 3 r2 0
; CHECK-NEXT:     store 8 1 sp 48
; CHECK-NEXT:     r1 = load 8 sp 48
; CHECK-NEXT:     br r1 .if.then .if.else
; CHECK:   .if.then:
; CHECK-NEXT:     r1 = load 8 sp 8
; CHECK-NEXT:     r1 = add r1 12 64
; CHECK-NEXT:     store 8 r1 sp 56
; CHECK-NEXT:     r1 = load 8 sp 56
; CHECK-NEXT:     r1 = load 4 r1 0
; CHECK-NEXT:     store 8 r1 sp 64
; CHECK-NEXT:     r1 = load 8 sp 64
; CHECK-NEXT:     call write r1
; CHECK-NEXT:     r1 = load 8 sp 8
; CHECK-NEXT:     store 8 r1 sp 72
; CHECK-NEXT:     r1 = load 8 sp 72
; CHECK-NEXT:     free r1
; CHECK-NEXT:     br .if.end
; CHECK:   .if.else:
; CHECK-NEXT:     r1 = load 8 sp 8
; CHECK-NEXT:     r1 = add r1 8 64
; CHECK-NEXT:     store 8 r1 sp 80
; CHECK-NEXT:     r1 = load 8 sp 80
; CHECK-NEXT:     r1 = load 4 r1 0
; CHECK-NEXT:     store 8 r1 sp 88
; CHECK-NEXT:     r1 = load 8 sp 88
; CHECK-NEXT:     call write r1
; CHECK-NEXT:     br .if.end
; CHECK:   .if.end:
; CHECK-NEXT:     ret 0
; CHECK-NEXT: end test2

entry:
  %call = call noalias i8* @malloc(i64 32) #4
  %0 = bitcast i8* %call to i32*
  %arrayidx = getelementptr inbounds i32, i32* %0, i64 0
  store i32 0, i32* %arrayidx, align 4
  %arrayidx1 = getelementptr inbounds i32, i32* %0, i64 1
  store i32 1, i32* %arrayidx1, align 4
  %arrayidx2 = getelementptr inbounds i32, i32* %0, i64 2
  store i32 2, i32* %arrayidx2, align 4
  %arrayidx3 = getelementptr inbounds i32, i32* %0, i64 3
  store i32 3, i32* %arrayidx3, align 4
  %tobool = icmp ne i32 1, 0
  br i1 %tobool, label %if.then, label %if.else

if.then:                                          ; preds = %entry
  %arrayidx4 = getelementptr inbounds i32, i32* %0, i64 3
  %1 = load i32, i32* %arrayidx4, align 4
  call void @write(i32 %1)
  %2 = bitcast i32* %0 to i8*
  call void @free(i8* %2) #4
  br label %if.end

if.else:                                          ; preds = %entry
  %arrayidx5 = getelementptr inbounds i32, i32* %0, i64 2
  %3 = load i32, i32* %arrayidx5, align 4
  call void @write(i32 %3)
  br label %if.end

if.end:                                           ; preds = %if.else, %if.then
  ret void
}

; Function Attrs: nounwind uwtable
define dso_local void @test3() #0 {
; CHECK: start test3 0:
; CHECK-NEXT:   .entry:
; CHECK-NEXT:     ; init sp!
; CHECK-NEXT:     sp = sub sp 160 64
; CHECK-NEXT:     r1 = add sp 64 64
; CHECK-NEXT:     store 8 r1 sp 0
; CHECK-NEXT:     r1 = add sp 96 64
; CHECK-NEXT:     store 8 r1 sp 8
; CHECK-NEXT:     store 8 1 sp 16
; CHECK-NEXT:     r1 = load 8 sp 16
; CHECK-NEXT:     br r1 .if.then .if.else
; CHECK:   .if.then:
; CHECK-NEXT:     r1 = load 8 sp 8
; CHECK-NEXT:     store 8 r1 sp 24
; CHECK-NEXT:     r1 = load 8 sp 24
; CHECK-NEXT:     store 8 r1 sp 48
; CHECK-NEXT:     r1 = load 8 sp 48
; CHECK-NEXT:     store 8 r1 sp 40
; CHECK-NEXT:     br .if.end
; CHECK:   .if.else:
; CHECK-NEXT:     r1 = load 8 sp 0
; CHECK-NEXT:     store 8 r1 sp 32
; CHECK-NEXT:     r1 = load 8 sp 32
; CHECK-NEXT:     store 8 r1 sp 48
; CHECK-NEXT:     r1 = load 8 sp 48
; CHECK-NEXT:     store 8 r1 sp 40
; CHECK-NEXT:     br .if.end
; CHECK:   .if.end:
; CHECK-NEXT:     r1 = load 8 sp 40
; CHECK-NEXT:     store 8 r1 sp 56
; CHECK-NEXT:     ret 0
; CHECK-NEXT: end test3

entry:
  %tobool = icmp ne i32 1, 0
  br i1 %tobool, label %if.then, label %if.else

if.then:                                          ; preds = %entry
  %call = call noalias i8* @malloc(i64 32) #4
  %0 = bitcast i8* %call to i32*
  br label %if.end

if.else:                                          ; preds = %entry
  %call1 = call noalias i8* @malloc(i64 16) #4
  %1 = bitcast i8* %call1 to i32*
  br label %if.end

if.end:                                           ; preds = %if.else, %if.then
  %x.0 = phi i32* [ %0, %if.then ], [ %1, %if.else ]
  %2 = bitcast i32* %x.0 to i8*
  call void @free(i8* %2) #4
  ret void
}

; Function Attrs: nounwind uwtable
define dso_local void @test4() #0 {
; CHECK: start test4 0:
; CHECK-NEXT:   .entry:
; CHECK-NEXT:     ; init sp!
; CHECK-NEXT:     sp = sub sp 128 64
; CHECK-NEXT:     r1 = add sp 64 64
; CHECK-NEXT:     store 8 r1 sp 0
; CHECK-NEXT:     store 8 1 sp 8
; CHECK-NEXT:     r1 = load 8 sp 8
; CHECK-NEXT:     br r1 .if.then .if.else
; CHECK:   .if.then:
; CHECK-NEXT:     r1 = load 8 sp 0
; CHECK-NEXT:     store 8 r1 sp 16
; CHECK-NEXT:     r1 = load 8 sp 16
; CHECK-NEXT:     store 8 r1 sp 48
; CHECK-NEXT:     r1 = load 8 sp 48
; CHECK-NEXT:     store 8 r1 sp 40
; CHECK-NEXT:     br .if.end
; CHECK:   .if.else:
; CHECK-NEXT:     r1 = malloc 3000
; CHECK-NEXT:     store 8 r1 sp 24
; CHECK-NEXT:     r1 = load 8 sp 24
; CHECK-NEXT:     store 8 r1 sp 32
; CHECK-NEXT:     r1 = load 8 sp 32
; CHECK-NEXT:     store 8 r1 sp 48
; CHECK-NEXT:     r1 = load 8 sp 48
; CHECK-NEXT:     store 8 r1 sp 40
; CHECK-NEXT:     br .if.end
; CHECK:   .if.end:
; CHECK-NEXT:     r1 = load 8 sp 40
; CHECK-NEXT:     store 8 r1 sp 56
; CHECK-NEXT:     ret 0
; CHECK-NEXT: end test4

entry:
  %tobool = icmp ne i32 1, 0
  br i1 %tobool, label %if.then, label %if.else

if.then:                                          ; preds = %entry
  %call = call noalias i8* @malloc(i64 32) #4
  %0 = bitcast i8* %call to i32*
  br label %if.end

if.else:                                          ; preds = %entry
  %call1 = call noalias i8* @malloc(i64 3000) #4
  %1 = bitcast i8* %call1 to i32*
  br label %if.end

if.end:                                           ; preds = %if.else, %if.then
  %x.0 = phi i32* [ %0, %if.then ], [ %1, %if.else ]
  %2 = bitcast i32* %x.0 to i8*
  call void @free(i8* %2) #4
  ret void
}

; Function Attrs: nounwind uwtable
define dso_local i32 @main() #0 {
; CHECK: start main 0:
; CHECK-NEXT:   .entry:
; CHECK-NEXT:     call test1
; CHECK-NEXT:     call test2
; CHECK-NEXT:     call test3
; CHECK-NEXT:     call test4
; CHECK-NEXT:     ret 0
; CHECK-NEXT: end main

entry:
  call void @test1()
  call void @test2()
  call void @test3()
  call void @test4()
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
