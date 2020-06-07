; Function Attrs: nounwind ssp uwtable
define i64* @input(i64 %n) #0 {
entry:
  %cmp = icmp eq i64 %n, 0
  br i1 %cmp, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  br label %return

if.end:                                           ; preds = %entry
  %mul = mul i64 %n, 8
  %call = call noalias i8* @malloc(i64 %mul) #4
  %0 = bitcast i8* %call to i64*
  br label %for.cond

for.cond:                                         ; preds = %for.inc, %if.end
  %i.0 = phi i64 [ 0, %if.end ], [ %inc, %for.inc ]
  %cmp1 = icmp ult i64 %i.0, %n
  br i1 %cmp1, label %for.body, label %for.cond.cleanup

for.cond.cleanup:                                 ; preds = %for.cond
  br label %for.end

for.body:                                         ; preds = %for.cond
; CHECK: reset heap
; CHECK: reset stack
  %call2 = call i64 (...) @read()
  %arrayidx = getelementptr inbounds i64, i64* %0, i64 %i.0
  store i64 %call2, i64* %arrayidx, align 8
  br label %for.inc

for.inc:                                          ; preds = %for.body
  %inc = add i64 %i.0, 1
  br label %for.cond

for.end:                                          ; preds = %for.cond.cleanup
  br label %return

return:                                           ; preds = %for.end, %if.then
  %retval.0 = phi i64* [ null, %if.then ], [ %0, %for.end ]
  ret i64* %retval.0
}

; Function Attrs: argmemonly nounwind willreturn
declare void @llvm.lifetime.start.p0i8(i64 immarg, i8* nocapture) #1

; Function Attrs: allocsize(0)
declare noalias i8* @malloc(i64) #2

declare i64 @read(...) #3

; Function Attrs: argmemonly nounwind willreturn
declare void @llvm.lifetime.end.p0i8(i64 immarg, i8* nocapture) #1

; Function Attrs: nounwind ssp uwtable
define void @bsort(i64 %n, i64* %ptr) #0 {
entry:
  %cmp = icmp eq i64 %n, 0
  br i1 %cmp, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  br label %for.end15

if.end:                                           ; preds = %entry
  br label %for.cond

for.cond:                                         ; preds = %for.inc14, %if.end
  %i.0 = phi i64 [ 0, %if.end ], [ %inc, %for.inc14 ]
  %cmp1 = icmp ult i64 %i.0, %n
  br i1 %cmp1, label %for.body, label %for.cond.cleanup

for.cond.cleanup:                                 ; preds = %for.cond
  br label %for.end15

for.body:                                         ; preds = %for.cond
  %sub = sub i64 %n, 1
  br label %for.cond2

for.cond2:                                        ; preds = %for.inc, %for.body
  %j.0 = phi i64 [ %sub, %for.body ], [ %dec, %for.inc ]
  %cmp3 = icmp ugt i64 %j.0, %i.0
  br i1 %cmp3, label %for.body5, label %for.cond.cleanup4

for.cond.cleanup4:                                ; preds = %for.cond2
  br label %for.end

for.body5:                                        ; preds = %for.cond2
  %arrayidx = getelementptr inbounds i64, i64* %ptr, i64 %j.0
  %0 = load i64, i64* %arrayidx, align 8
  %sub6 = sub i64 %j.0, 1
  %arrayidx7 = getelementptr inbounds i64, i64* %ptr, i64 %sub6
  %1 = load i64, i64* %arrayidx7, align 8
  %cmp8 = icmp ult i64 %0, %1
  br i1 %cmp8, label %if.then9, label %if.end13

if.then9:                                         ; preds = %for.body5
  %arrayidx10 = getelementptr inbounds i64, i64* %ptr, i64 %j.0
  store i64 %1, i64* %arrayidx10, align 8
  %sub11 = sub i64 %j.0, 1
  %arrayidx12 = getelementptr inbounds i64, i64* %ptr, i64 %sub11
  store i64 %0, i64* %arrayidx12, align 8
  br label %if.end13

if.end13:                                         ; preds = %if.then9, %for.body5
  br label %for.inc

for.inc:                                          ; preds = %if.end13
  %dec = add i64 %j.0, -1
  br label %for.cond2

for.end:                                          ; preds = %for.cond.cleanup4
  br label %for.inc14

for.inc14:                                        ; preds = %for.end
  %inc = add i64 %i.0, 1
  br label %for.cond

for.end15:                                        ; preds = %for.cond.cleanup, %if.then
  ret void
}

; Function Attrs: nounwind ssp uwtable
define void @process(i64 %n, i64* %ptr) #0 {
entry:
  %cmp = icmp eq i64 %n, 0
  br i1 %cmp, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  br label %for.end

if.end:                                           ; preds = %entry
  br label %for.cond

for.cond:                                         ; preds = %for.inc, %if.end
  %i.0 = phi i64 [ 0, %if.end ], [ %inc, %for.inc ]
  %cmp1 = icmp ult i64 %i.0, %n
  br i1 %cmp1, label %for.body, label %for.cond.cleanup

for.cond.cleanup:                                 ; preds = %for.cond
  br label %for.end

for.body:                                         ; preds = %for.cond
  %arrayidx = getelementptr inbounds i64, i64* %ptr, i64 %i.0
  %0 = load i64, i64* %arrayidx, align 8
  call void @write(i64 %0)
  br label %for.inc

for.inc:                                          ; preds = %for.body
  %inc = add i64 %i.0, 1
  br label %for.cond

for.end:                                          ; preds = %for.cond.cleanup, %if.then
  ret void
}

declare void @write(i64) #3

; Function Attrs: nounwind ssp uwtable
define i32 @main() #0 {
    ; CHECK: start main 0:
entry:
  %call = call i64 (...) @read()
  %cmp = icmp eq i64 %call, 0
  br i1 %cmp, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  br label %cleanup

if.end:                                           ; preds = %entry
  %call1 = call i64* @input(i64 %call)
  call void @bsort(i64 %call, i64* %call1)
  call void @process(i64 %call, i64* %call1)
  br label %cleanup

cleanup:                                          ; preds = %if.end, %if.then
  ret i32 0
}
; CHECK: end main