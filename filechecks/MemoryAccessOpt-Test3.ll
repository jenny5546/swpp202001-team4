; ModuleID = '/tmp/a.ll'
source_filename = "/Users/ohah/Documents/swpp-project/testcases/mytest/Mem4.c"
target datalayout = "e-m:o-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-apple-macosx10.14.0"

@ex = external global i32, align 4

; Function Attrs: nounwind ssp uwtable
define i32 @main() #0 {
; CHECK: start main 0:
entry:
  %mul = mul nsw i32 8, 8
  %conv = sext i32 %mul to i64
  %mul1 = mul i64 %conv, 4
  %call = call i8* @malloc(i64 %mul1) #4
  %0 = bitcast i8* %call to i32*
  store i32 4, i32* @ex, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.inc11, %entry
  %b.0 = phi i32 [ 5, %entry ], [ %b.1, %for.inc11 ]
  %i.0 = phi i32 [ 0, %entry ], [ %inc12, %for.inc11 ]
  %cmp = icmp slt i32 %i.0, 8
  br i1 %cmp, label %for.body, label %for.end13

for.body:                                         ; preds = %for.cond
  br label %for.cond3

for.cond3:                                        ; preds = %for.inc, %for.body
  %j.0 = phi i32 [ 0, %for.body ], [ %inc, %for.inc ]
  %b.1 = phi i32 [ %b.0, %for.body ], [ %add10, %for.inc ]
  %cmp4 = icmp slt i32 %j.0, 8
  br i1 %cmp4, label %for.body6, label %for.end

for.body6:                                        ; preds = %for.cond3
  %add = add nsw i32 %i.0, %j.0
  %mul7 = mul nsw i32 %i.0, 8
  %idx.ext = sext i32 %mul7 to i64
  %add.ptr = getelementptr inbounds i32, i32* %0, i64 %idx.ext
  %idx.ext8 = sext i32 %j.0 to i64
  %add.ptr9 = getelementptr inbounds i32, i32* %add.ptr, i64 %idx.ext8
  store i32 %add, i32* %add.ptr9, align 4
  %add10 = add nsw i32 8, 8
  br label %for.inc

for.inc:                                          ; preds = %for.body6
  %inc = add nsw i32 %j.0, 1
  br label %for.cond3

for.end:                                          ; preds = %for.cond3
  br label %for.inc11

for.inc11:                                        ; preds = %for.end
  %inc12 = add nsw i32 %i.0, 1
  br label %for.cond

for.end13:                                        ; preds = %for.cond
  br label %for.cond14

for.cond14:                                       ; preds = %for.inc28, %for.end13
  %b.2 = phi i32 [ %b.0, %for.end13 ], [ %b.3, %for.inc28 ]
  %i.1 = phi i32 [ 0, %for.end13 ], [ %inc29, %for.inc28 ]
  %cmp15 = icmp slt i32 %i.1, 8
  br i1 %cmp15, label %for.body17, label %for.end30

for.body17:                                       ; preds = %for.cond14
  br label %for.cond18

for.cond18:                                       ; preds = %for.inc25, %for.body17
  %j.1 = phi i32 [ 0, %for.body17 ], [ %inc26, %for.inc25 ]
  %b.3 = phi i32 [ %b.2, %for.body17 ], [ %mul24, %for.inc25 ]
  %cmp19 = icmp slt i32 %j.1, 8
  br i1 %cmp19, label %for.body21, label %for.end27

for.body21:                                       ; preds = %for.cond18
  %1 = load i32, i32* @ex, align 4
  %add22 = add nsw i32 %1, %b.3
  store i32 %add22, i32* @ex, align 4
  %inc23 = add nsw i32 %b.3, 1
  %mul24 = mul nsw i32 %inc23, 8
  br label %for.inc25

for.inc25:                                        ; preds = %for.body21
  %inc26 = add nsw i32 %j.1, 1
  br label %for.cond18

for.end27:                                        ; preds = %for.cond18
  br label %for.inc28

for.inc28:                                        ; preds = %for.end27
  %inc29 = add nsw i32 %i.1, 1
  br label %for.cond14

for.end30:                                        ; preds = %for.cond14
  %2 = bitcast i32* %0 to i8*
  call void @free(i8* %2)
  ret i32 0
}
; CHECK: end main

; Function Attrs: argmemonly nounwind willreturn
declare void @llvm.lifetime.start.p0i8(i64 immarg, i8* nocapture) #1

; Function Attrs: allocsize(0)
declare i8* @malloc(i64) #2

declare void @free(i8*) #3

; Function Attrs: argmemonly nounwind willreturn
declare void @llvm.lifetime.end.p0i8(i64 immarg, i8* nocapture) #1

attributes #0 = { nounwind ssp uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="penryn" "target-features"="+cx16,+cx8,+fxsr,+mmx,+sahf,+sse,+sse2,+sse3,+sse4.1,+ssse3,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { argmemonly nounwind willreturn }
attributes #2 = { allocsize(0) "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="penryn" "target-features"="+cx16,+cx8,+fxsr,+mmx,+sahf,+sse,+sse2,+sse3,+sse4.1,+ssse3,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #3 = { "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="penryn" "target-features"="+cx16,+cx8,+fxsr,+mmx,+sahf,+sse,+sse2,+sse3,+sse4.1,+ssse3,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #4 = { allocsize(0) }

!llvm.module.flags = !{!0, !1, !2}
!llvm.ident = !{!3}

!0 = !{i32 2, !"SDK Version", [2 x i32] [i32 10, i32 14]}
!1 = !{i32 1, !"wchar_size", i32 4}
!2 = !{i32 7, !"PIC Level", i32 2}
!3 = !{!"clang version 10.0.1 (git@github.com:llvm/llvm-project.git 92d5c1be9ee93850c0a8903f05f36a23ee835dc2)"}
