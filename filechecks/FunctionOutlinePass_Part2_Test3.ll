; ModuleID = '/tmp/a.ll'
source_filename = "/Users/jaeeun/Desktop/llvmscript/team/test/jaeeuntests/test3/test3.c"
target datalayout = "e-m:o-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-apple-macosx10.14.0"

@arr = external global [100 x i32], align 16

; Function Attrs: nounwind ssp uwtable
define i32 @prevSum(i32 %n) #0 {
; CHECK: start prevSum 1:
entry:
  br label %for.cond

for.cond:                                         ; preds = %for.inc, %entry
  %ret.0 = phi i32 [ 0, %entry ], [ %add122, %for.inc ]
  %i.0 = phi i32 [ 1, %entry ], [ %inc, %for.inc ]
  %cmp = icmp slt i32 %i.0, %n
  br i1 %cmp, label %for.body, label %for.cond.cleanup

for.cond.cleanup:                                 ; preds = %for.cond
  br label %for.end

for.body:                                         ; preds = %for.cond
  %idxprom = sext i32 %i.0 to i64
  %arrayidx = getelementptr inbounds [100 x i32], [100 x i32]* @arr, i64 0, i64 %idxprom
  %0 = load i32, i32* %arrayidx, align 4
  %sub = sub nsw i32 %i.0, 1
  %idxprom1 = sext i32 %sub to i64
  %arrayidx2 = getelementptr inbounds [100 x i32], [100 x i32]* @arr, i64 0, i64 %idxprom1
  %1 = load i32, i32* %arrayidx2, align 4
  %add = add nsw i32 %0, %1
  %add3 = add nsw i32 %ret.0, %add
  %idxprom4 = sext i32 %i.0 to i64
  %arrayidx5 = getelementptr inbounds [100 x i32], [100 x i32]* @arr, i64 0, i64 %idxprom4
  %2 = load i32, i32* %arrayidx5, align 4
  %sub6 = sub nsw i32 %i.0, 1
  %idxprom7 = sext i32 %sub6 to i64
  %arrayidx8 = getelementptr inbounds [100 x i32], [100 x i32]* @arr, i64 0, i64 %idxprom7
  %3 = load i32, i32* %arrayidx8, align 4
  %add9 = add nsw i32 %2, %3
  %add10 = add nsw i32 %add3, %add9
  %idxprom11 = sext i32 %i.0 to i64
  %arrayidx12 = getelementptr inbounds [100 x i32], [100 x i32]* @arr, i64 0, i64 %idxprom11
  %4 = load i32, i32* %arrayidx12, align 4
  %sub13 = sub nsw i32 %i.0, 1
  %idxprom14 = sext i32 %sub13 to i64
  %arrayidx15 = getelementptr inbounds [100 x i32], [100 x i32]* @arr, i64 0, i64 %idxprom14
  %5 = load i32, i32* %arrayidx15, align 4
  %add16 = add nsw i32 %4, %5
  %add17 = add nsw i32 %add10, %add16
  %idxprom18 = sext i32 %i.0 to i64
  %arrayidx19 = getelementptr inbounds [100 x i32], [100 x i32]* @arr, i64 0, i64 %idxprom18
  %6 = load i32, i32* %arrayidx19, align 4
  %sub20 = sub nsw i32 %i.0, 1
  %idxprom21 = sext i32 %sub20 to i64
  %arrayidx22 = getelementptr inbounds [100 x i32], [100 x i32]* @arr, i64 0, i64 %idxprom21
  %7 = load i32, i32* %arrayidx22, align 4
  %add23 = add nsw i32 %6, %7
  %add24 = add nsw i32 %add17, %add23
  %idxprom25 = sext i32 %i.0 to i64
  %arrayidx26 = getelementptr inbounds [100 x i32], [100 x i32]* @arr, i64 0, i64 %idxprom25
  %8 = load i32, i32* %arrayidx26, align 4
  %sub27 = sub nsw i32 %i.0, 1
  %idxprom28 = sext i32 %sub27 to i64
  %arrayidx29 = getelementptr inbounds [100 x i32], [100 x i32]* @arr, i64 0, i64 %idxprom28
  %9 = load i32, i32* %arrayidx29, align 4
  %add30 = add nsw i32 %8, %9
  %add31 = add nsw i32 %add24, %add30
  %idxprom32 = sext i32 %i.0 to i64
  %arrayidx33 = getelementptr inbounds [100 x i32], [100 x i32]* @arr, i64 0, i64 %idxprom32
  %10 = load i32, i32* %arrayidx33, align 4
  %sub34 = sub nsw i32 %i.0, 1
  %idxprom35 = sext i32 %sub34 to i64
  %arrayidx36 = getelementptr inbounds [100 x i32], [100 x i32]* @arr, i64 0, i64 %idxprom35
  %11 = load i32, i32* %arrayidx36, align 4
  %add37 = add nsw i32 %10, %11
  %add38 = add nsw i32 %add31, %add37
  %idxprom39 = sext i32 %i.0 to i64
  %arrayidx40 = getelementptr inbounds [100 x i32], [100 x i32]* @arr, i64 0, i64 %idxprom39
  %12 = load i32, i32* %arrayidx40, align 4
  %sub41 = sub nsw i32 %i.0, 1
  %idxprom42 = sext i32 %sub41 to i64
  %arrayidx43 = getelementptr inbounds [100 x i32], [100 x i32]* @arr, i64 0, i64 %idxprom42
  %13 = load i32, i32* %arrayidx43, align 4
  %add44 = add nsw i32 %12, %13
  %add45 = add nsw i32 %add38, %add44
  %idxprom46 = sext i32 %i.0 to i64
  %arrayidx47 = getelementptr inbounds [100 x i32], [100 x i32]* @arr, i64 0, i64 %idxprom46
  %14 = load i32, i32* %arrayidx47, align 4
  %sub48 = sub nsw i32 %i.0, 1
  %idxprom49 = sext i32 %sub48 to i64
  %arrayidx50 = getelementptr inbounds [100 x i32], [100 x i32]* @arr, i64 0, i64 %idxprom49
  %15 = load i32, i32* %arrayidx50, align 4
  %add51 = add nsw i32 %14, %15
  %add52 = add nsw i32 %add45, %add51
  %idxprom53 = sext i32 %i.0 to i64
  %arrayidx54 = getelementptr inbounds [100 x i32], [100 x i32]* @arr, i64 0, i64 %idxprom53
  %16 = load i32, i32* %arrayidx54, align 4
  %sub55 = sub nsw i32 %i.0, 1
  %idxprom56 = sext i32 %sub55 to i64
  %arrayidx57 = getelementptr inbounds [100 x i32], [100 x i32]* @arr, i64 0, i64 %idxprom56
  %17 = load i32, i32* %arrayidx57, align 4
  %add58 = add nsw i32 %16, %17
  %add59 = add nsw i32 %add52, %add58
  %idxprom60 = sext i32 %i.0 to i64
  %arrayidx61 = getelementptr inbounds [100 x i32], [100 x i32]* @arr, i64 0, i64 %idxprom60
  %18 = load i32, i32* %arrayidx61, align 4
  %sub62 = sub nsw i32 %i.0, 1
  %idxprom63 = sext i32 %sub62 to i64
  %arrayidx64 = getelementptr inbounds [100 x i32], [100 x i32]* @arr, i64 0, i64 %idxprom63
  %19 = load i32, i32* %arrayidx64, align 4
  %add65 = add nsw i32 %18, %19
  %add66 = add nsw i32 %add59, %add65
  %idxprom67 = sext i32 %i.0 to i64
  %arrayidx68 = getelementptr inbounds [100 x i32], [100 x i32]* @arr, i64 0, i64 %idxprom67
  %20 = load i32, i32* %arrayidx68, align 4
  %sub69 = sub nsw i32 %i.0, 1
  %idxprom70 = sext i32 %sub69 to i64
  %arrayidx71 = getelementptr inbounds [100 x i32], [100 x i32]* @arr, i64 0, i64 %idxprom70
  %21 = load i32, i32* %arrayidx71, align 4
  %add72 = add nsw i32 %20, %21
  %add73 = add nsw i32 %add66, %add72
  %idxprom74 = sext i32 %i.0 to i64
  %arrayidx75 = getelementptr inbounds [100 x i32], [100 x i32]* @arr, i64 0, i64 %idxprom74
  %22 = load i32, i32* %arrayidx75, align 4
  %sub76 = sub nsw i32 %i.0, 1
  %idxprom77 = sext i32 %sub76 to i64
  %arrayidx78 = getelementptr inbounds [100 x i32], [100 x i32]* @arr, i64 0, i64 %idxprom77
  %23 = load i32, i32* %arrayidx78, align 4
  %add79 = add nsw i32 %22, %23
  %add80 = add nsw i32 %add73, %add79
  %idxprom81 = sext i32 %i.0 to i64
  %arrayidx82 = getelementptr inbounds [100 x i32], [100 x i32]* @arr, i64 0, i64 %idxprom81
  %24 = load i32, i32* %arrayidx82, align 4
  %sub83 = sub nsw i32 %i.0, 1
  %idxprom84 = sext i32 %sub83 to i64
  %arrayidx85 = getelementptr inbounds [100 x i32], [100 x i32]* @arr, i64 0, i64 %idxprom84
  %25 = load i32, i32* %arrayidx85, align 4
  %add86 = add nsw i32 %24, %25
  %add87 = add nsw i32 %add80, %add86
  %idxprom88 = sext i32 %i.0 to i64
  %arrayidx89 = getelementptr inbounds [100 x i32], [100 x i32]* @arr, i64 0, i64 %idxprom88
  %26 = load i32, i32* %arrayidx89, align 4
  %sub90 = sub nsw i32 %i.0, 1
  %idxprom91 = sext i32 %sub90 to i64
  %arrayidx92 = getelementptr inbounds [100 x i32], [100 x i32]* @arr, i64 0, i64 %idxprom91
  %27 = load i32, i32* %arrayidx92, align 4
  %add93 = add nsw i32 %26, %27
  %add94 = add nsw i32 %add87, %add93
  %idxprom95 = sext i32 %i.0 to i64
  %arrayidx96 = getelementptr inbounds [100 x i32], [100 x i32]* @arr, i64 0, i64 %idxprom95
  %28 = load i32, i32* %arrayidx96, align 4
  %sub97 = sub nsw i32 %i.0, 1
  %idxprom98 = sext i32 %sub97 to i64
  %arrayidx99 = getelementptr inbounds [100 x i32], [100 x i32]* @arr, i64 0, i64 %idxprom98
  %29 = load i32, i32* %arrayidx99, align 4
  %add100 = add nsw i32 %28, %29
  %add101 = add nsw i32 %add94, %add100
  %idxprom102 = sext i32 %i.0 to i64
  %arrayidx103 = getelementptr inbounds [100 x i32], [100 x i32]* @arr, i64 0, i64 %idxprom102
  %30 = load i32, i32* %arrayidx103, align 4
  %sub104 = sub nsw i32 %i.0, 1
  %idxprom105 = sext i32 %sub104 to i64
  %arrayidx106 = getelementptr inbounds [100 x i32], [100 x i32]* @arr, i64 0, i64 %idxprom105
  %31 = load i32, i32* %arrayidx106, align 4
  %add107 = add nsw i32 %30, %31
  %add108 = add nsw i32 %add101, %add107
  %idxprom109 = sext i32 %i.0 to i64
  %arrayidx110 = getelementptr inbounds [100 x i32], [100 x i32]* @arr, i64 0, i64 %idxprom109
  %32 = load i32, i32* %arrayidx110, align 4
  %sub111 = sub nsw i32 %i.0, 1
  %idxprom112 = sext i32 %sub111 to i64
  %arrayidx113 = getelementptr inbounds [100 x i32], [100 x i32]* @arr, i64 0, i64 %idxprom112
  %33 = load i32, i32* %arrayidx113, align 4
  %add114 = add nsw i32 %32, %33
  %add115 = add nsw i32 %add108, %add114
  %idxprom116 = sext i32 %i.0 to i64
  %arrayidx117 = getelementptr inbounds [100 x i32], [100 x i32]* @arr, i64 0, i64 %idxprom116
  %34 = load i32, i32* %arrayidx117, align 4
  %sub118 = sub nsw i32 %i.0, 1
  %idxprom119 = sext i32 %sub118 to i64
  %arrayidx120 = getelementptr inbounds [100 x i32], [100 x i32]* @arr, i64 0, i64 %idxprom119
  %35 = load i32, i32* %arrayidx120, align 4
  %add121 = add nsw i32 %34, %35
  %add122 = add nsw i32 %add115, %add121
  br label %for.inc

for.inc:                                          ; preds = %for.body
  %inc = add nsw i32 %i.0, 1
  br label %for.cond

for.end:                                          ; preds = %for.cond.cleanup
  ret i32 %ret.0
}

; Function Attrs: argmemonly nounwind willreturn
declare void @llvm.lifetime.start.p0i8(i64 immarg, i8* nocapture) #1

; Function Attrs: argmemonly nounwind willreturn
declare void @llvm.lifetime.end.p0i8(i64 immarg, i8* nocapture) #1

; Function Attrs: nounwind ssp uwtable
define i32 @main() #0 {
entry:
  store i32 1, i32* getelementptr inbounds ([100 x i32], [100 x i32]* @arr, i64 0, i64 0), align 16
  store i32 1, i32* getelementptr inbounds ([100 x i32], [100 x i32]* @arr, i64 0, i64 1), align 4
  br label %for.cond

for.cond:                                         ; preds = %for.inc, %entry
  %i.0 = phi i32 [ 2, %entry ], [ %inc, %for.inc ]
  %cmp = icmp slt i32 %i.0, 100
  br i1 %cmp, label %for.body, label %for.cond.cleanup

for.cond.cleanup:                                 ; preds = %for.cond
  br label %for.end

for.body:                                         ; preds = %for.cond
  %sub = sub nsw i32 %i.0, 2
  %idxprom = sext i32 %sub to i64
  %arrayidx = getelementptr inbounds [100 x i32], [100 x i32]* @arr, i64 0, i64 %idxprom
  %0 = load i32, i32* %arrayidx, align 4
  %mul = mul nsw i32 %0, 2
  %idxprom1 = sext i32 %i.0 to i64
  %arrayidx2 = getelementptr inbounds [100 x i32], [100 x i32]* @arr, i64 0, i64 %idxprom1
  %1 = load i32, i32* %arrayidx2, align 4
  %add = add nsw i32 %1, %mul
  store i32 %add, i32* %arrayidx2, align 4
  %sub3 = sub nsw i32 %i.0, 1
  %idxprom4 = sext i32 %sub3 to i64
  %arrayidx5 = getelementptr inbounds [100 x i32], [100 x i32]* @arr, i64 0, i64 %idxprom4
  %2 = load i32, i32* %arrayidx5, align 4
  %mul6 = mul nsw i32 %2, 3
  %idxprom7 = sext i32 %i.0 to i64
  %arrayidx8 = getelementptr inbounds [100 x i32], [100 x i32]* @arr, i64 0, i64 %idxprom7
  %3 = load i32, i32* %arrayidx8, align 4
  %add9 = add nsw i32 %3, %mul6
  store i32 %add9, i32* %arrayidx8, align 4
  br label %for.inc

for.inc:                                          ; preds = %for.body
  %inc = add nsw i32 %i.0, 1
  br label %for.cond

for.end:                                          ; preds = %for.cond.cleanup
  %call = call i64 (...) @read()
  %conv = trunc i64 %call to i32
  %call10 = call i32 @prevSum(i32 %conv)
  %conv11 = sext i32 %call10 to i64
  call void @write(i64 %conv11)
  ret i32 0
}

; CHECK-NOT:  start main.for.body [[SCOPE:[0-10]+]]:
; CHECK-NOT:  end main.for.body



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
!3 = !{!"clang version 10.0.1 (https://github.com/llvm/llvm-project.git f79cd71e145c6fd005ba4dd1238128dfa0dc2cb6)"}