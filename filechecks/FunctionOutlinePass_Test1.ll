; ModuleID = '/tmp/a.ll'
source_filename = "/Users/jaeeun/Desktop/llvm_10/team_repo/test/ftest1.c"
target datalayout = "e-m:o-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-apple-macosx10.14.0"

@arr = external global [5 x i32], align 16

; Function Attrs: nounwind ssp uwtable
define i32 @countFibTotal(i32 %n) #0 {
; CHECK:   start countFibTotal 1:
entry:
; CHECK:  sp = sub sp 184 64
; CHECK-NEXT:  r1 = add sp 176 64
; CHECK-NEXT:  store 8 r1 sp 0
; CHECK-NEXT:  store 8 20480 sp 8
; CHECK-NEXT:  r1 = load 8 sp 8
; CHECK-NEXT:  r1 = load 4 r1 0
; CHECK-NEXT:  store 8 r1 sp 16
; CHECK-NEXT:  store 8 20484 sp 24
; CHECK-NEXT:  r1 = load 8 sp 24
; CHECK-NEXT:  r1 = load 4 r1 0
; CHECK-NEXT:  store 8 r1 sp 32
; CHECK-NEXT:  r1 = load 8 sp 16
; CHECK-NEXT:  r2 = load 8 sp 32
; CHECK-NEXT:  r1 = add r1 r2 32
; CHECK-NEXT:  store 8 r1 sp 40
; CHECK-NEXT:  store 8 20488 sp 48
; CHECK-NEXT:  r1 = load 8 sp 48
; CHECK-NEXT:  r1 = load 4 r1 0
; CHECK-NEXT:  store 8 r1 sp 56
; CHECK-NEXT:  r1 = load 8 sp 40
; CHECK-NEXT:  r2 = load 8 sp 56
; CHECK-NEXT:  r1 = add r1 r2 32
; CHECK-NEXT:  store 8 r1 sp 64
; CHECK-NEXT:  store 8 20492 sp 72
; CHECK-NEXT:  r1 = load 8 sp 72
; CHECK-NEXT:  r1 = load 4 r1 0
; CHECK-NEXT:  store 8 r1 sp 80
; CHECK-NEXT:  r1 = load 8 sp 64
; CHECK-NEXT:  r2 = load 8 sp 80
; CHECK-NEXT:  r1 = add r1 r2 32
; CHECK-NEXT:  store 8 r1 sp 88
; CHECK-NEXT:  store 8 20496 sp 96
; CHECK-NEXT:  r1 = load 8 sp 96
; CHECK-NEXT:  r1 = load 4 r1 0
; CHECK-NEXT:  store 8 r1 sp 104
; CHECK-NEXT:  r1 = load 8 sp 88
; CHECK-NEXT:  r2 = load 8 sp 104
; CHECK-NEXT:  r1 = add r1 r2 32
; CHECK-NEXT:  store 8 r1 sp 112
; CHECK-NEXT:  store 8 20480 sp 120
; CHECK-NEXT:  r1 = load 8 sp 120
; CHECK-NEXT:  r1 = load 4 r1 0
; CHECK-NEXT:  store 8 r1 sp 128
; CHECK-NEXT:  r1 = load 8 sp 112
; CHECK-NEXT:  r2 = load 8 sp 128
; CHECK-NEXT:  r1 = sub r1 r2 32
; CHECK-NEXT:  store 8 r1 sp 136
; CHECK-NEXT:  store 8 20480 sp 144
; CHECK-NEXT:  r1 = load 8 sp 144
; CHECK-NEXT:  r1 = load 4 r1 0
; CHECK-NEXT:  store 8 r1 sp 152
; CHECK-NEXT:  r1 = load 8 sp 136
; CHECK-NEXT:  r2 = load 8 sp 152
; CHECK-NEXT:  r1 = add r1 r2 32
; CHECK-NEXT:  store 8 r1 sp 160
; CHECK-NEXT:  r1 = load 8 sp 160
; CHECK-NEXT:  r2 = load 8 sp 0
; CHECK-NEXT:  call countFibTotal.outline r1 r2
; CHECK-NEXT:  r1 = load 8 sp 0
; CHECK-NEXT:  r1 = load 4 r1 0
; CHECK-NEXT:  store 8 r1 sp 168
; CHECK-NEXT:  r1 = load 8 sp 168
; CHECK-NEXT:  ret r1
  %0 = load i32, i32* getelementptr inbounds ([5 x i32], [5 x i32]* @arr, i64 0, i64 0), align 16
  %1 = load i32, i32* getelementptr inbounds ([5 x i32], [5 x i32]* @arr, i64 0, i64 1), align 4
  %add = add nsw i32 %0, %1
  %2 = load i32, i32* getelementptr inbounds ([5 x i32], [5 x i32]* @arr, i64 0, i64 2), align 8
  %add1 = add nsw i32 %add, %2
  %3 = load i32, i32* getelementptr inbounds ([5 x i32], [5 x i32]* @arr, i64 0, i64 3), align 4
  %add2 = add nsw i32 %add1, %3
  %4 = load i32, i32* getelementptr inbounds ([5 x i32], [5 x i32]* @arr, i64 0, i64 4), align 16
  %add3 = add nsw i32 %add2, %4
  %5 = load i32, i32* getelementptr inbounds ([5 x i32], [5 x i32]* @arr, i64 0, i64 0), align 16
  %sub = sub nsw i32 %add3, %5
  %6 = load i32, i32* getelementptr inbounds ([5 x i32], [5 x i32]* @arr, i64 0, i64 0), align 16
  %add4 = add nsw i32 %sub, %6
  %7 = load i32, i32* getelementptr inbounds ([5 x i32], [5 x i32]* @arr, i64 0, i64 1), align 4
  %sub5 = sub nsw i32 %add4, %7
  %8 = load i32, i32* getelementptr inbounds ([5 x i32], [5 x i32]* @arr, i64 0, i64 1), align 4
  %add6 = add nsw i32 %sub5, %8
  ret i32 %add6
}

; Function Attrs: nounwind ssp uwtable
define i32 @main() #0 {
entry:
  ;CHECK: .entry:
  ;CHECK:  sp = sub sp 184 64
  ;CHECK-NEXT:  r1 = malloc 24
  ;CHECK-NEXT:  store 8 20480 sp 0
  ;CHECK-NEXT:  r2 = load 8 sp 0
  ;CHECK-NEXT:  store 4 1 r2 0
  ;CHECK-NEXT:  store 8 20484 sp 8
  ;CHECK-NEXT:  r2 = load 8 sp 8
  ;CHECK-NEXT:  store 4 1 r2 0
  ;CHECK-NEXT:  store 8 2 sp 24
  ;CHECK-NEXT:  r1 = load 8 sp 24
  ;CHECK-NEXT:  store 8 r1 sp 16
  ;CHECK-NEXT:  br .for.cond
  store i32 1, i32* getelementptr inbounds ([5 x i32], [5 x i32]* @arr, i64 0, i64 0), align 16
  store i32 1, i32* getelementptr inbounds ([5 x i32], [5 x i32]* @arr, i64 0, i64 1), align 4
  br label %for.cond

for.cond:                                   ; preds = %for.inc, %entry
;CHECK: r1 = load 8 sp 16
;CHECK-NEXT: r1 = icmp slt r1 5 32
;CHECK-NEXT: store 8 r1 sp 32
;CHECK-NEXT: r1 = load 8 sp 32
;CHECK-NEXT: br r1 .for.body .for.end
  %i.0 = phi i32 [ 2, %entry ], [ %inc, %for.inc ]
  %cmp = icmp slt i32 %i.0, 5
  br i1 %cmp, label %for.body, label %for.cond.cleanup

for.cond.cleanup:                                 ; preds = %for.cond
  br label %for.end

for.body:  
;CHECK:  r1 = load 8 sp 16
;CHECK-NEXT:  r1 = sub r1 2 32
;CHECK-NEXT:  store 8 r1 sp 40
;CHECK-NEXT:  r1 = load 8 sp 40
;CHECK-NEXT:  r2 = and r1 2147483648 64
;CHECK-NEXT:  r2 = sub 0 r2 64
;CHECK-NEXT:  r1 = or r2 r1 64
;CHECK-NEXT:  store 8 r1 sp 48
;CHECK-NEXT:  r2 = load 8 sp 48
;CHECK-NEXT:  r2 = mul r2 4 64
;CHECK-NEXT:  r1 = add 20480 r2 64
;CHECK-NEXT:  store 8 r1 sp 56
;CHECK-NEXT:  r1 = load 8 sp 56
;CHECK-NEXT:  r1 = load 4 r1 0
;CHECK-NEXT:  store 8 r1 sp 64
;CHECK-NEXT:  r1 = load 8 sp 16
;CHECK-NEXT:  r2 = and r1 2147483648 64
;CHECK-NEXT:  r2 = sub 0 r2 64
;CHECK-NEXT:  r1 = or r2 r1 64
;CHECK-NEXT:  store 8 r1 sp 72
;CHECK-NEXT:  r2 = load 8 sp 72
;CHECK-NEXT:  r2 = mul r2 4 64
;CHECK-NEXT:  r1 = add 20480 r2 64
;CHECK-NEXT:  store 8 r1 sp 80
;CHECK-NEXT:  r1 = load 8 sp 80
;CHECK-NEXT:  r1 = load 4 r1 0
;CHECK-NEXT:  store 8 r1 sp 88
;CHECK-NEXT:  r1 = load 8 sp 88
;CHECK-NEXT:  r2 = load 8 sp 64
;CHECK-NEXT:  r1 = add r1 r2 32
;CHECK-NEXT:  store 8 r1 sp 96
;CHECK-NEXT:  r1 = load 8 sp 96
;CHECK-NEXT:  r2 = load 8 sp 80
;CHECK-NEXT:  store 4 r1 r2 0
;CHECK-NEXT:  r1 = load 8 sp 16
;CHECK-NEXT:  r1 = sub r1 1 32
;CHECK-NEXT:  store 8 r1 sp 104
;CHECK-NEXT:  r1 = load 8 sp 104
;CHECK-NEXT:  r2 = and r1 2147483648 64
;CHECK-NEXT:  r2 = sub 0 r2 64
;CHECK-NEXT:  r1 = or r2 r1 64
;CHECK-NEXT:  store 8 r1 sp 112
;CHECK-NEXT:  r2 = load 8 sp 112
;CHECK-NEXT:  r2 = mul r2 4 64
;CHECK-NEXT:  r1 = add 20480 r2 64
;CHECK-NEXT:  store 8 r1 sp 120
;CHECK-NEXT:  r1 = load 8 sp 120
;CHECK-NEXT:  r1 = load 4 r1 0
;CHECK-NEXT:  store 8 r1 sp 128
;CHECK-NEXT:  r1 = load 8 sp 16
;CHECK-NEXT:  r2 = and r1 2147483648 64
;CHECK-NEXT:  r2 = sub 0 r2 64
;CHECK-NEXT:  r1 = or r2 r1 64
;CHECK-NEXT:  store 8 r1 sp 136
;CHECK-NEXT:  r1 = load 8 sp 136
;CHECK-NEXT:  r2 = load 8 sp 128
;CHECK-NEXT:  call main.outline r1 r2
;CHECK-NEXT:  r1 = load 8 sp 16
;CHECK-NEXT:  r1 = add r1 1 32
;CHECK-NEXT:  store 8 r1 sp 144
;CHECK-NEXT:  r1 = load 8 sp 144
;CHECK-NEXT:  store 8 r1 sp 24
;CHECK-NEXT:  r1 = load 8 sp 24
;CHECK-NEXT:  store 8 r1 sp 16
;CHECK-NEXT:  br .for.cond                                       
  %sub = sub nsw i32 %i.0, 2
  %idxprom = sext i32 %sub to i64
  %arrayidx = getelementptr inbounds [5 x i32], [5 x i32]* @arr, i64 0, i64 %idxprom
  %0 = load i32, i32* %arrayidx, align 4
  %idxprom1 = sext i32 %i.0 to i64
  %arrayidx2 = getelementptr inbounds [5 x i32], [5 x i32]* @arr, i64 0, i64 %idxprom1
  %1 = load i32, i32* %arrayidx2, align 4
  %add = add nsw i32 %1, %0
  store i32 %add, i32* %arrayidx2, align 4
  %sub3 = sub nsw i32 %i.0, 1
  %idxprom4 = sext i32 %sub3 to i64
  %arrayidx5 = getelementptr inbounds [5 x i32], [5 x i32]* @arr, i64 0, i64 %idxprom4
  %2 = load i32, i32* %arrayidx5, align 4
  %idxprom6 = sext i32 %i.0 to i64
  %arrayidx7 = getelementptr inbounds [5 x i32], [5 x i32]* @arr, i64 0, i64 %idxprom6
  %3 = load i32, i32* %arrayidx7, align 4
  %add8 = add nsw i32 %3, %2
  store i32 %add8, i32* %arrayidx7, align 4
  br label %for.inc

for.inc:                                          ; preds = %for.body
  %inc = add nsw i32 %i.0, 1
  br label %for.cond

for.end:
;CHECK:  r1 = call read
;CHECK-NEXT:  store 8 r1 sp 152
;CHECK-NEXT:  r1 = load 8 sp 152
;CHECK-NEXT:  r1 = and r1 4294967295 64
;CHECK-NEXT:  store 8 r1 sp 160
;CHECK-NEXT:  r1 = load 8 sp 160
;CHECK-NEXT:  r1 = call countFibTotal r1
;CHECK-NEXT:  store 8 r1 sp 168
;CHECK-NEXT:  r1 = load 8 sp 168
;CHECK-NEXT:  r2 = and r1 2147483648 64
;CHECK-NEXT:  r2 = sub 0 r2 64
;CHECK-NEXT:  r1 = or r2 r1 64
;CHECK-NEXT:  store 8 r1 sp 176
;CHECK-NEXT:  r1 = load 8 sp 176
;CHECK-NEXT:  call write r1
;CHECK-NEXT:  ret 0                                          
  %call = call i64 (...) @read()
  %conv = trunc i64 %call to i32
  %call9 = call i32 @countFibTotal(i32 %conv)
  %conv10 = sext i32 %call9 to i64
  call void @write(i64 %conv10)
  ret i32 0
}

;CHECK:  start countFibTotal.outline 2:
;CHECK-NEXT:    .newFuncRoot:
;CHECK-NEXT:      ; init sp!
;CHECK-NEXT:      sp = sub sp 48 64
;CHECK-NEXT:      store 8 20484 sp 0
;CHECK-NEXT:      r1 = load 8 sp 0
;CHECK-NEXT:      r1 = load 4 r1 0
;CHECK-NEXT:      store 8 r1 sp 8
;CHECK-NEXT:      r2 = load 8 sp 8
;CHECK-NEXT:      r1 = sub arg1 r2 32
;CHECK-NEXT:      store 8 r1 sp 16
;CHECK-NEXT:      store 8 20484 sp 24
;CHECK-NEXT:      r1 = load 8 sp 24
;CHECK-NEXT:      r1 = load 4 r1 0
;CHECK-NEXT:      store 8 r1 sp 32
;CHECK-NEXT:      r1 = load 8 sp 16
;CHECK-NEXT:      r2 = load 8 sp 32
;CHECK-NEXT:      r1 = add r1 r2 32
;CHECK-NEXT:      store 8 r1 sp 40
;CHECK-NEXT:      r1 = load 8 sp 40
;CHECK-NEXT:      store 4 r1 arg2 0
;CHECK-NEXT:      ret 0
;CHECK-NEXT:  end countFibTotal.outline


;CHECK:  start main.outline 2:
;CHECK-NEXT:    .newFuncRoot:
;CHECK-NEXT:      ; init sp!
;CHECK-NEXT:      sp = sub sp 24 64
;CHECK-NEXT:      r2 = mul arg1 4 64
;CHECK-NEXT:      r1 = add 20480 r2 64
;CHECK-NEXT:      store 8 r1 sp 0
;CHECK-NEXT:      r1 = load 8 sp 0
;CHECK-NEXT:      r1 = load 4 r1 0
;CHECK-NEXT:      store 8 r1 sp 8
;CHECK-NEXT:      r1 = load 8 sp 8
;CHECK-NEXT:      r1 = add r1 arg2 32
;CHECK-NEXT:      store 8 r1 sp 16
;CHECK-NEXT:      r1 = load 8 sp 16
;CHECK-NEXT:      r2 = load 8 sp 0
;CHECK-NEXT:      store 4 r1 r2 0
;CHECK-NEXT:      ret 0
;CHECK-NEXT:  end main.outline

; Function Attrs: argmemonly nounwind willreturn
declare void @llvm.lifetime.start.p0i8(i64 immarg, i8* nocapture) #1

; Function Attrs: argmemonly nounwind willreturn
declare void @llvm.lifetime.end.p0i8(i64 immarg, i8* nocapture) #1

declare void @write(i64) #2

declare i64 @read(...) #2

attributes #0 = { nounwind ssp uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="penryn" "target-features"="+cx16,+cx8,+fxsr,+mmx,+sahf,+sse,+sse2,+sse3,+sse4.1,+ssse3,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { argmemonly nounwind willreturn }
attributes #2 = { "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="penryn" "target-features"="+cx16,+cx8,+fxsr,+mmx,+sahf,+sse,+sse2,+sse3,+sse4.1,+ssse3,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }

!llvm.module.flags = !{!0, !1, !2}
!llvm.ident = !{!3}

!0 = !{i32 2, !"SDK Version", [2 x i32] [i32 10, i32 14]}
!1 = !{i32 1, !"wchar_size", i32 4}
!2 = !{i32 7, !"PIC Level", i32 2}
!3 = !{!"clang version 10.0.1 (https://github.com/llvm/llvm-project.git edbe962459da6e3b7b4168118f93a77847b54e02)"}
