; ModuleID = '/tmp/a.ll'
source_filename = "/Users/jaeeun/Desktop/llvm_10/team_repo/test/test1.c"
target datalayout = "e-m:o-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-apple-macosx10.14.0"

@BitsSetTable64 = external global [64 x i32], align 16

; Function Attrs: nounwind ssp uwtable
define i32 @countSetBits(i32 %n) #0 {
; CHECK:    countSetBits 1:
entry:
; CHECK:        sp = sub sp 128 64
; CHECK-NEXT:   r1 = add sp 120 64
; CHECK-NEXT:   store 8 r1 sp 0
; CHECK-NEXT:   r1 = and arg1 255 32
; CHECK-NEXT:   store 8 r1 sp 8
; CHECK-NEXT:   r1 = load 8 sp 8
; CHECK-NEXT:   r2 = and r1 2147483648 64
; CHECK-NEXT:   r2 = sub 0 r2 64
; CHECK-NEXT:   r1 = or r2 r1 64
; CHECK-NEXT:   store 8 r1 sp 16
; CHECK-NEXT:   r2 = load 8 sp 16
; CHECK-NEXT:   r2 = mul r2 4 64
; CHECK-NEXT:   r1 = add 20480 r2 64
; CHECK-NEXT:   store 8 r1 sp 24
; CHECK-NEXT:   r1 = load 8 sp 24
; CHECK-NEXT:   r1 = load 4 r1 0
; CHECK-NEXT:   store 8 r1 sp 32
; CHECK-NEXT:   r1 = ashr arg1 8 32
; CHECK-NEXT:   store 8 r1 sp 40
; CHECK-NEXT:   r1 = load 8 sp 40
; CHECK-NEXT:   r1 = and r1 255 32
; CHECK-NEXT:   store 8 r1 sp 48
; CHECK-NEXT:   r1 = load 8 sp 48
; CHECK-NEXT:   r2 = and r1 2147483648 64
; CHECK-NEXT:   r2 = sub 0 r2 64
; CHECK-NEXT:   r1 = or r2 r1 64
; CHECK-NEXT:   store 8 r1 sp 56
; CHECK-NEXT:   r2 = load 8 sp 56
; CHECK-NEXT:   r2 = mul r2 4 64
; CHECK-NEXT:   r1 = add 20480 r2 64
; CHECK-NEXT:   store 8 r1 sp 64
; CHECK-NEXT:   r1 = load 8 sp 64
; CHECK-NEXT:   r1 = load 4 r1 0
; CHECK-NEXT:   store 8 r1 sp 72
; CHECK-NEXT:   r1 = load 8 sp 32
; CHECK-NEXT:   r2 = load 8 sp 72
; CHECK-NEXT:   r1 = add r1 r2 32
; CHECK-NEXT:   store 8 r1 sp 80
; CHECK-NEXT:   r1 = ashr arg1 24 32
; CHECK-NEXT:   store 8 r1 sp 88
; CHECK-NEXT:   r1 = load 8 sp 88
; CHECK-NEXT:   r2 = and r1 2147483648 64
; CHECK-NEXT:   r2 = sub 0 r2 64
; CHECK-NEXT:   r1 = or r2 r1 64
; CHECK-NEXT:   store 8 r1 sp 96
; CHECK-NEXT:   r2 = load 8 sp 96
; CHECK-NEXT:   r2 = mul r2 4 64
; CHECK-NEXT:   r1 = add 20480 r2 64
; CHECK-NEXT:   store 8 r1 sp 104
; CHECK-NEXT:   r1 = load 8 sp 104
; CHECK-NEXT:   r2 = load 8 sp 80
; CHECK-NEXT:   r3 = load 8 sp 0
; CHECK-NEXT:   call countSetBits.outline r1 r2 r3
; CHECK-NEXT:   r1 = load 8 sp 0
; CHECK-NEXT:   r1 = load 4 r1 0
; CHECK-NEXT:   store 8 r1 sp 112
; CHECK-NEXT:   r1 = load 8 sp 112
; CHECK-NEXT:   ret r1
; CHECK:   end countSetBits

  %and = and i32 %n, 255
  %idxprom = sext i32 %and to i64
  %arrayidx = getelementptr inbounds [64 x i32], [64 x i32]* @BitsSetTable64, i64 0, i64 %idxprom
  %0 = load i32, i32* %arrayidx, align 4
  %shr = ashr i32 %n, 8
  %and1 = and i32 %shr, 255
  %idxprom2 = sext i32 %and1 to i64
  %arrayidx3 = getelementptr inbounds [64 x i32], [64 x i32]* @BitsSetTable64, i64 0, i64 %idxprom2
  %1 = load i32, i32* %arrayidx3, align 4
  %add = add nsw i32 %0, %1
  %shr4 = ashr i32 %n, 24
  %idxprom5 = sext i32 %shr4 to i64
  %arrayidx6 = getelementptr inbounds [64 x i32], [64 x i32]* @BitsSetTable64, i64 0, i64 %idxprom5
  %2 = load i32, i32* %arrayidx6, align 4
  %add7 = add nsw i32 %add, %2
  ret i32 %add7
}

; Function Attrs: nounwind ssp uwtable
define i32 @main() #0 {
; CHECK: start main 0:
entry:
  store i32 0, i32* getelementptr inbounds ([64 x i32], [64 x i32]* @BitsSetTable64, i64 0, i64 0), align 16
  br label %for.cond
; CHECK:  sp = sub sp 136 64
; CHECK-NEXT:   r1 = malloc 256
; CHECK-NEXT:   store 8 20480 sp 0
; CHECK-NEXT:   r2 = load 8 sp 0
; CHECK-NEXT:   store 4 0 r2 0
; CHECK-NEXT:   store 8 0 sp 16
; CHECK-NEXT:   r1 = load 8 sp 16
; CHECK-NEXT:   store 8 r1 sp 8
; CHECK-NEXT:   br .for.cond



for.cond:                                       ; preds = %for.inc, %entry
  %i.0 = phi i32 [ 0, %entry ], [ %inc, %for.inc ]
  %cmp = icmp slt i32 %i.0, 64
  br i1 %cmp, label %for.body, label %for.cond.cleanup

; CHECK:  r1 = load 8 sp 8
; CHECK-NEXT:  r1 = icmp slt r1 64 32
; CHECK-NEXT:  store 8 r1 sp 24
; CHECK-NEXT:  r1 = load 8 sp 24
; CHECK-NEXT:  br r1 .for.body .for.end

for.cond.cleanup:                                 ; preds = %for.cond
  br label %for.end

for.body:                                         ; preds = %for.cond
  %and = and i32 %i.0, 1
  %div = sdiv i32 %i.0, 2
  %idxprom = sext i32 %div to i64
  %arrayidx = getelementptr inbounds [64 x i32], [64 x i32]* @BitsSetTable64, i64 0, i64 %idxprom
  %0 = load i32, i32* %arrayidx, align 4
  %add = add nsw i32 %and, %0
  %idxprom1 = sext i32 %i.0 to i64
  %arrayidx2 = getelementptr inbounds [64 x i32], [64 x i32]* @BitsSetTable64, i64 0, i64 %idxprom1
  store i32 %add, i32* %arrayidx2, align 4
  br label %for.inc

; CHECK:   r1 = load 8 sp 8
; CHECK-NEXT:   r1 = and r1 1 32
; CHECK-NEXT:   store 8 r1 sp 32
; CHECK-NEXT:   r1 = load 8 sp 8
; CHECK-NEXT:   r1 = sdiv r1 2 32
; CHECK-NEXT:   store 8 r1 sp 40
; CHECK-NEXT:   r1 = load 8 sp 40
; CHECK-NEXT:   r2 = and r1 2147483648 64
; CHECK-NEXT:   r2 = sub 0 r2 64
; CHECK-NEXT:   r1 = or r2 r1 64
; CHECK-NEXT:   store 8 r1 sp 48
; CHECK-NEXT:   r2 = load 8 sp 48
; CHECK-NEXT:   r2 = mul r2 4 64
; CHECK-NEXT:   r1 = add 20480 r2 64
; CHECK-NEXT:   store 8 r1 sp 56
; CHECK-NEXT:   r1 = load 8 sp 56
; CHECK-NEXT:   r1 = load 4 r1 0
; CHECK-NEXT:   store 8 r1 sp 64
; CHECK-NEXT:   r1 = load 8 sp 32
; CHECK-NEXT:   r2 = load 8 sp 64
; CHECK-NEXT:   r1 = add r1 r2 32
; CHECK-NEXT:   store 8 r1 sp 72
; CHECK-NEXT:   r1 = load 8 sp 8
; CHECK-NEXT:   r2 = and r1 2147483648 64
; CHECK-NEXT:   r2 = sub 0 r2 64
; CHECK-NEXT:   r1 = or r2 r1 64
; CHECK-NEXT:   store 8 r1 sp 80
; CHECK-NEXT:   r2 = load 8 sp 80
; CHECK-NEXT:   r2 = mul r2 4 64
; CHECK-NEXT:   r1 = add 20480 r2 64
; CHECK-NEXT:   store 8 r1 sp 88
; CHECK-NEXT:   r1 = load 8 sp 72
; CHECK-NEXT:   r2 = load 8 sp 88
; CHECK-NEXT:   store 4 r1 r2 0
; CHECK-NEXT:   r1 = load 8 sp 8
; CHECK-NEXT:   r1 = add r1 1 32
; CHECK-NEXT:   store 8 r1 sp 96
; CHECK-NEXT:   r1 = load 8 sp 96
; CHECK-NEXT:   store 8 r1 sp 16
; CHECK-NEXT:   r1 = load 8 sp 16
; CHECK-NEXT:   store 8 r1 sp 8
; CHECK-NEXT:   br .for.cond

for.inc:                                          ; preds = %for.body
  %inc = add nsw i32 %i.0, 1
  br label %for.cond

for.end:                                          ; preds = %for.cond.cleanup
  %call = call i64 (...) @read()
  %conv = trunc i64 %call to i32
  %call3 = call i32 @countSetBits(i32 %conv)
  %conv4 = sext i32 %call3 to i64
  call void @write(i64 %conv4)
  ret i32 0
; CHECK:   r1 = call read
; CHECK-NEXT:   store 8 r1 sp 104
; CHECK-NEXT:   r1 = load 8 sp 104
; CHECK-NEXT:   r1 = and r1 4294967295 64
; CHECK-NEXT:   store 8 r1 sp 112
; CHECK-NEXT:   r1 = load 8 sp 112
; CHECK-NEXT:   r1 = call countSetBits r1
; CHECK-NEXT:   store 8 r1 sp 120
; CHECK-NEXT:   r1 = load 8 sp 120
; CHECK-NEXT:   r2 = and r1 2147483648 64
; CHECK-NEXT:   r2 = sub 0 r2 64
; CHECK-NEXT:   r1 = or r2 r1 64
; CHECK-NEXT:   store 8 r1 sp 128
; CHECK-NEXT:   r1 = load 8 sp 128
; CHECK-NEXT:   call write r1
; CHECK-NEXT:   ret 0
}

;CHECK  start countSetBits.outline 3:
; CHECK-NEXT:   sp = sub sp 16 64
; CHECK-NEXT:   r1 = load 4 arg1 0
; CHECK-NEXT:   store 8 r1 sp 0
; CHECK-NEXT:   r2 = load 8 sp 0
; CHECK-NEXT:   r1 = add arg2 r2 32
; CHECK-NEXT:   store 8 r1 sp 8
; CHECK-NEXT:   r1 = load 8 sp 8
; CHECK-NEXT:   store 4 r1 arg3 0
; CHECK-NEXT:   ret 0
; CHECK-NEXT  end countSetBits.outline


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
