; ModuleID = '/tmp/a.ll'
source_filename = "custom/test8.c"
target datalayout = "e-m:o-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-apple-macosx10.14.0"

; Function Attrs: nounwind ssp uwtable
define i32 @hash(i32 %x, i32 %n) #0 {
entry:
; CHECK: .entry:
  %rem = srem i32 %x, %n
  ret i32 %rem
}

; Function Attrs: nounwind ssp uwtable
define void @hash_insert(i32* %table, i32 %n, i32 %x) #0 {
entry:
; CHECK: .entry:
; CHECK:   [[REG1:r[0-9]+]] = call hash [[ARG:arg[0-9]+]] [[ARG:arg[0-9]+]]
; CHECK:   [[REG2:r[0-9]+]] = udiv [[REG1]] 2147483648 64
; CHECK:   [[REG2]] = mul [[REG2]] 18446744071562067968 64
; CHECK:   [[REG2]] = or [[REG2]] [[REG1]] 64
; CHECK:   [[REG3:r[0-9]+]] = mul [[ARG:arg[0-9]+]] 1 64
; CHECK:   [[REG4:r[0-9]+]] = mul [[REG2]] 4 64
; CHECK:   [[REG3]] = add [[REG3]] [[REG4]] 64
; CHECK:   [[REG5:r[0-9]+]] = load 4 [[REG3]] 0
  %call = call i32 @hash(i32 %x, i32 %n)
  %idxprom = sext i32 %call to i64
  %arrayidx = getelementptr inbounds i32, i32* %table, i64 %idxprom
  %0 = load i32, i32* %arrayidx, align 4
  %cmp = icmp eq i32 %0, -1
  br i1 %cmp, label %if.then, label %if.else

if.then:                                          ; preds = %entry
  %idxprom1 = sext i32 %call to i64
  %arrayidx2 = getelementptr inbounds i32, i32* %table, i64 %idxprom1
  store i32 %x, i32* %arrayidx2, align 4
  br label %cleanup

if.else:                                          ; preds = %entry
  br label %for.cond

for.cond:                                         ; preds = %for.inc, %if.else
  %h.0 = phi i32 [ %call, %if.else ], [ %rem, %for.inc ]
  %idxprom3 = sext i32 %h.0 to i64
  %arrayidx4 = getelementptr inbounds i32, i32* %table, i64 %idxprom3
  %1 = load i32, i32* %arrayidx4, align 4
  %cmp5 = icmp ne i32 %1, -1
  br i1 %cmp5, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  br label %for.inc

for.inc:                                          ; preds = %for.body
  %mul = mul nsw i32 %h.0, %h.0
  %add = add nsw i32 %mul, %h.0
  %add6 = add nsw i32 %add, 1
  %rem = srem i32 %add6, %n
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %idxprom7 = sext i32 %h.0 to i64
  %arrayidx8 = getelementptr inbounds i32, i32* %table, i64 %idxprom7
  store i32 %x, i32* %arrayidx8, align 4
  br label %cleanup

cleanup:                                          ; preds = %for.end, %if.then
  ret void
}

; Function Attrs: argmemonly nounwind willreturn
declare void @llvm.lifetime.start.p0i8(i64 immarg, i8* nocapture) #1

; Function Attrs: argmemonly nounwind willreturn
declare void @llvm.lifetime.end.p0i8(i64 immarg, i8* nocapture) #1

; Function Attrs: nounwind ssp uwtable
define void @hash_delete(i32* %table, i32 %n, i32 %x) #0 {
entry:
  %call = call i32 @hash(i32 %x, i32 %n)
  %idxprom = sext i32 %call to i64
  %arrayidx = getelementptr inbounds i32, i32* %table, i64 %idxprom
  %0 = load i32, i32* %arrayidx, align 4
  %cmp = icmp eq i32 %0, %x
  br i1 %cmp, label %if.then, label %if.else

if.then:                                          ; preds = %entry
  %idxprom1 = sext i32 %call to i64
  %arrayidx2 = getelementptr inbounds i32, i32* %table, i64 %idxprom1
  store i32 -1, i32* %arrayidx2, align 4
  br label %cleanup

if.else:                                          ; preds = %entry
  br label %for.cond

for.cond:                                         ; preds = %for.inc, %if.else
  %h.0 = phi i32 [ %call, %if.else ], [ %add6, %for.inc ]
  %idxprom3 = sext i32 %h.0 to i64
  %arrayidx4 = getelementptr inbounds i32, i32* %table, i64 %idxprom3
  %1 = load i32, i32* %arrayidx4, align 4
  %cmp5 = icmp ne i32 %1, %x
  br i1 %cmp5, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  br label %for.inc

for.inc:                                          ; preds = %for.body
  %mul = mul nsw i32 %h.0, %h.0
  %add = add nsw i32 %mul, %h.0
  %add6 = add nsw i32 %add, 1
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %idxprom7 = sext i32 %h.0 to i64
  %arrayidx8 = getelementptr inbounds i32, i32* %table, i64 %idxprom7
  store i32 -1, i32* %arrayidx8, align 4
  br label %cleanup

cleanup:                                          ; preds = %for.end, %if.then
  ret void
}

; Function Attrs: nounwind ssp uwtable
define void @print_hash_table(i32* %table, i32 %n) #0 {
entry:
  br label %for.cond

for.cond:                                         ; preds = %for.inc, %entry
  %i.0 = phi i32 [ 0, %entry ], [ %inc, %for.inc ]
  %cmp = icmp slt i32 %i.0, %n
  br i1 %cmp, label %for.body, label %for.cond.cleanup

for.cond.cleanup:                                 ; preds = %for.cond
  br label %for.end

for.body:                                         ; preds = %for.cond
  %idxprom = sext i32 %i.0 to i64
  %arrayidx = getelementptr inbounds i32, i32* %table, i64 %idxprom
  %0 = load i32, i32* %arrayidx, align 4
  %conv = sext i32 %0 to i64
  call void @write(i64 %conv)
  br label %for.inc

for.inc:                                          ; preds = %for.body
  %inc = add nsw i32 %i.0, 1
  br label %for.cond

for.end:                                          ; preds = %for.cond.cleanup
  ret void
}

declare void @write(i64) #2

; Function Attrs: nounwind ssp uwtable
define i32 @main() #0 {
entry:
; CHECK:  .entry:
; CHECK:    [[REG:r[0-9]+]] = add sp 0 64
; CHECK:    store 4 4294967295 [[REGC:r[0-9]+]] 0
; CHECK:    [[REG:r[0-9]+]] = add [[REGC]] 4 64
; CHECK:    store 4 4294967295 [[REG]] 0
; CHECK:    [[REG:r[0-9]+]] = add [[REGC]] 8 64
; CHECK:    store 4 4294967295 [[REG]] 0
; CHECK:    [[REG:r[0-9]+]] = add [[REGC]] 12 64
; CHECK:    store 4 4294967295 [[REG]] 0
; CHECK:    [[REG:r[0-9]+]] = add [[REGC]] 16 64
; CHECK:    store 4 4294967295 [[REG]] 0
; CHECK:    [[REG:r[0-9]+]] = add [[REGC]] 20 64
; CHECK:    store 4 4294967295 [[REG]] 0
; CHECK:    [[REG:r[0-9]+]] = add [[REGC]] 24 64
; CHECK:    store 4 4294967295 [[REG]] 0
  %hash_table = alloca [7 x i32], align 16
  br label %for.cond

for.cond:                                         ; preds = %for.inc, %entry
  %i.0 = phi i32 [ 0, %entry ], [ %inc, %for.inc ]
  %cmp = icmp slt i32 %i.0, 7
  br i1 %cmp, label %for.body, label %for.cond.cleanup

for.cond.cleanup:                                 ; preds = %for.cond
  br label %for.end

for.body:                                         ; preds = %for.cond
  %idxprom = sext i32 %i.0 to i64
  %arrayidx = getelementptr inbounds [7 x i32], [7 x i32]* %hash_table, i64 0, i64 %idxprom
  store i32 -1, i32* %arrayidx, align 4
  br label %for.inc

for.inc:                                          ; preds = %for.body
  %inc = add nsw i32 %i.0, 1
  br label %for.cond

for.end:                                          ; preds = %for.cond.cleanup
  %arraydecay = getelementptr inbounds [7 x i32], [7 x i32]* %hash_table, i64 0, i64 0
  call void @hash_insert(i32* %arraydecay, i32 7, i32 1)
  %arraydecay1 = getelementptr inbounds [7 x i32], [7 x i32]* %hash_table, i64 0, i64 0
  call void @hash_insert(i32* %arraydecay1, i32 7, i32 2)
  %arraydecay2 = getelementptr inbounds [7 x i32], [7 x i32]* %hash_table, i64 0, i64 0
  call void @hash_insert(i32* %arraydecay2, i32 7, i32 3)
  %arraydecay3 = getelementptr inbounds [7 x i32], [7 x i32]* %hash_table, i64 0, i64 0
  call void @hash_insert(i32* %arraydecay3, i32 7, i32 3)
  %arraydecay4 = getelementptr inbounds [7 x i32], [7 x i32]* %hash_table, i64 0, i64 0
  call void @hash_insert(i32* %arraydecay4, i32 7, i32 2)
  %arraydecay5 = getelementptr inbounds [7 x i32], [7 x i32]* %hash_table, i64 0, i64 0
  call void @hash_insert(i32* %arraydecay5, i32 7, i32 11)
  %arraydecay6 = getelementptr inbounds [7 x i32], [7 x i32]* %hash_table, i64 0, i64 0
  call void @hash_insert(i32* %arraydecay6, i32 7, i32 33)
  %arraydecay7 = getelementptr inbounds [7 x i32], [7 x i32]* %hash_table, i64 0, i64 0
  call void @hash_delete(i32* %arraydecay7, i32 7, i32 33)
  %arraydecay8 = getelementptr inbounds [7 x i32], [7 x i32]* %hash_table, i64 0, i64 0
  call void @hash_delete(i32* %arraydecay8, i32 7, i32 11)
  %arraydecay9 = getelementptr inbounds [7 x i32], [7 x i32]* %hash_table, i64 0, i64 0
  call void @hash_delete(i32* %arraydecay9, i32 7, i32 2)
  %arraydecay10 = getelementptr inbounds [7 x i32], [7 x i32]* %hash_table, i64 0, i64 0
  call void @hash_delete(i32* %arraydecay10, i32 7, i32 3)
  %arraydecay11 = getelementptr inbounds [7 x i32], [7 x i32]* %hash_table, i64 0, i64 0
  call void @hash_delete(i32* %arraydecay11, i32 7, i32 1)
  %arraydecay12 = getelementptr inbounds [7 x i32], [7 x i32]* %hash_table, i64 0, i64 0
  call void @print_hash_table(i32* %arraydecay12, i32 7)
  ret i32 0
}

attributes #0 = { nounwind ssp uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="penryn" "target-features"="+cx16,+cx8,+fxsr,+mmx,+sahf,+sse,+sse2,+sse3,+sse4.1,+ssse3,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { argmemonly nounwind willreturn }
attributes #2 = { "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="penryn" "target-features"="+cx16,+cx8,+fxsr,+mmx,+sahf,+sse,+sse2,+sse3,+sse4.1,+ssse3,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }

!llvm.module.flags = !{!0, !1, !2}
!llvm.ident = !{!3}

!0 = !{i32 2, !"SDK Version", [2 x i32] [i32 10, i32 14]}
!1 = !{i32 1, !"wchar_size", i32 4}
!2 = !{i32 7, !"PIC Level", i32 2}
!3 = !{!"clang version 10.0.1 (https://github.com/llvm/llvm-project 92d5c1be9ee93850c0a8903f05f36a23ee835dc2)"}
