; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main() #0 {
; CHECK: start main 0:
entry:
; CHECK: sp = sub sp 112 64
; CHECK-NEXT: r1 = add sp 88 64
; CHECK-NEXT: store 8 r1 sp 0
; CHECK-NEXT: r1 = add sp 96 64
; CHECK-NEXT: store 8 r1 sp 8
; CHECK-NEXT: r2 = load 8 sp 0
; CHECK-NEXT: store 4 0 r2 0
; CHECK-NEXT: r1 = add sp 104 64
; CHECK-NEXT: store 8 r1 sp 16
; CHECK-NEXT: r1 = load 8 sp 16
; CHECK-NEXT: store 8 r1 sp 24
; CHECK-NEXT: r1 = load 8 sp 24
; CHECK-NEXT: store 8 r1 sp 32
; CHECK-NEXT: r2 = load 8 sp 32
; CHECK-NEXT: store 8 0 r2 0
; CHECK-NEXT: r1 = load 8 sp 24
; CHECK-NEXT: r1 = add r1 8 64
; CHECK-NEXT: store 8 r1 sp 40
; CHECK-NEXT: r2 = load 8 sp 40
; CHECK-NEXT: store 8 1 r2 0
; CHECK-NEXT: r1 = load 8 sp 24
; CHECK-NEXT: r1 = add r1 16 64
; CHECK-NEXT: store 8 r1 sp 48
; CHECK-NEXT: r2 = load 8 sp 48
; CHECK-NEXT: store 8 2 r2 0
; CHECK-NEXT: r1 = load 8 sp 24
; CHECK-NEXT: r1 = add r1 24 64
; CHECK-NEXT: store 8 r1 sp 56
; CHECK-NEXT: r2 = load 8 sp 56
; CHECK-NEXT: store 8 3 r2 0
; CHECK-NEXT: r1 = load 8 sp 24
; CHECK-NEXT: r1 = add r1 24 64
; CHECK-NEXT: store 8 r1 sp 64
; CHECK-NEXT: r1 = load 8 sp 64
; CHECK-NEXT: r1 = load 8 r1 0
; CHECK-NEXT: store 8 r1 sp 72
; CHECK-NEXT: r1 = load 8 sp 72
; CHECK-NEXT: call write r1
; CHECK-NEXT: r1 = load 8 sp 24
; CHECK-NEXT: store 8 r1 sp 80
; CHECK-NEXT: ret 0
  %retval = alloca i32, align 4
  %a = alloca i64*, align 8
  store i32 0, i32* %retval, align 4
  %call = call noalias i8* @malloc(i64 32) #3
  %0 = bitcast i8* %call to i64*
  %arrayidx = getelementptr inbounds i64, i64* %0, i64 0
  store i64 0, i64* %arrayidx, align 8
  %arrayidx1 = getelementptr inbounds i64, i64* %0, i64 1
  store i64 1, i64* %arrayidx1, align 8
  %arrayidx2 = getelementptr inbounds i64, i64* %0, i64 2
  store i64 2, i64* %arrayidx2, align 8
  %arrayidx3 = getelementptr inbounds i64, i64* %0, i64 3
  store i64 3, i64* %arrayidx3, align 8
  %arrayidx4 = getelementptr inbounds i64, i64* %0, i64 3
  %1 = load i64, i64* %arrayidx4, align 8
  call void @write(i64 %1)
  %2 = bitcast i64* %0 to i8*
  call void @free(i8* %2) #3
  ret i32 0
}
; CHECK: end main

; Function Attrs: nounwind
declare dso_local noalias i8* @malloc(i64) #1

declare dso_local void @write(i64) #2

; Function Attrs: nounwind
declare dso_local void @free(i8*) #1

attributes #0 = { noinline nounwind optnone uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #2 = { "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #3 = { nounwind }

