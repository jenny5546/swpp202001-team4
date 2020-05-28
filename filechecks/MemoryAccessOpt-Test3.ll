; ModuleID = '/tmp/a.ll'
source_filename = "/Users/ohah/Documents/swpp-project/testcases/sprint2memacc/test3.c"
target datalayout = "e-m:o-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-apple-macosx10.14.0"

; Function Attrs: nounwind ssp uwtable
define i32 @main() #0 {
; CHECK: start main 0:
entry:
; CHECK: reset stack
  %call = call noalias i8* @malloc(i64 32) #4
  %0 = bitcast i8* %call to i32*
  %arrayidx = getelementptr inbounds i32, i32* %0, i64 3
  store i32 0, i32* %arrayidx, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.inc, %entry
  %b.0 = phi i32 [ 0, %entry ], [ %mul, %for.inc ]
  %i.0 = phi i32 [ 0, %entry ], [ %inc2, %for.inc ]
  %a.0 = phi i32 [ 0, %entry ], [ %inc, %for.inc ]
  %cmp = icmp slt i32 %i.0, 8
  br i1 %cmp, label %for.body, label %for.cond.cleanup

for.cond.cleanup:                                 ; preds = %for.cond
  br label %for.end

for.body:                                         ; preds = %for.cond
; CHECK: reset stack
  %add = add nsw i32 %a.0, %b.0
  %idxprom = sext i32 %i.0 to i64
  %arrayidx1 = getelementptr inbounds i32, i32* %0, i64 %idxprom
  store i32 %add, i32* %arrayidx1, align 4
  %inc = add nsw i32 %a.0, 1
  %mul = mul nsw i32 %b.0, 2
  br label %for.inc

for.inc:                                          ; preds = %for.body
  %inc2 = add nsw i32 %i.0, 1
  br label %for.cond

for.end:                                          ; preds = %for.cond.cleanup
  %cmp3 = icmp ne i32* %0, null
  br i1 %cmp3, label %if.then, label %if.end

if.then:                                          ; preds = %for.end
  %1 = bitcast i32* %0 to i8*
  call void @free(i8* %1)
  br label %if.end

if.end:                                           ; preds = %if.then, %for.end
; CHECK: reset heap
; CHECK: reset stack
; CHECK: reset heap
  %call4 = call noalias i8* @malloc(i64 64) #4
  %2 = bitcast i8* %call4 to i32*
  %add5 = add nsw i32 %a.0, %a.0
  %arrayidx6 = getelementptr inbounds i32, i32* %2, i64 10
  store i32 %add5, i32* %arrayidx6, align 4
  %add7 = add nsw i32 %b.0, %b.0
  %arrayidx8 = getelementptr inbounds i32, i32* %2, i64 11
  store i32 %add7, i32* %arrayidx8, align 4
  %cmp9 = icmp ne i32* %2, null
  br i1 %cmp9, label %if.then10, label %if.end11

if.then10:                                        ; preds = %if.end
  %3 = bitcast i32* %2 to i8*
  call void @free(i8* %3)
  br label %if.end11

if.end11:                                         ; preds = %if.then10, %if.end
  ret i32 0
}
; CHECK: end main

; Function Attrs: argmemonly nounwind willreturn
declare void @llvm.lifetime.start.p0i8(i64 immarg, i8* nocapture) #1

; Function Attrs: allocsize(0)
declare noalias i8* @malloc(i64) #2

; Function Attrs: argmemonly nounwind willreturn
declare void @llvm.lifetime.end.p0i8(i64 immarg, i8* nocapture) #1

declare void @free(i8*) #3

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
