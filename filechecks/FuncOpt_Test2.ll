; Function Attrs: nounwind ssp uwtable
define i32 @recSearch(i32* %arr, i32 %l, i32 %r, i32 %x) #0 {
entry:
; CHECK: mul
; CHECK: br
  %cmp = icmp slt i32 %r, %l
  br i1 %cmp, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  br label %return

if.end:                                           ; preds = %entry
  %idxprom = sext i32 %l to i64
  %arrayidx = getelementptr inbounds i32, i32* %arr, i64 %idxprom
  %0 = load i32, i32* %arrayidx, align 4
  %cmp1 = icmp eq i32 %0, %x
  br i1 %cmp1, label %if.then2, label %if.end3

if.then2:                                         ; preds = %if.end
  br label %return

if.end3:                                          ; preds = %if.end
  %idxprom4 = sext i32 %r to i64
  %arrayidx5 = getelementptr inbounds i32, i32* %arr, i64 %idxprom4
  %1 = load i32, i32* %arrayidx5, align 4
  %cmp6 = icmp eq i32 %1, %x
  br i1 %cmp6, label %if.then7, label %if.end8

if.then7:                                         ; preds = %if.end3
  br label %return

if.end8:                                          ; preds = %if.end3
  %add = add nsw i32 %l, 1
  %sub = sub nsw i32 %r, 1
  %call = call i32 @recSearch(i32* %arr, i32 %add, i32 %sub, i32 %x)
  br label %return

return:                                           ; preds = %if.end8, %if.then7, %if.then2, %if.then
  %retval.0 = phi i32 [ -1, %if.then ], [ %l, %if.then2 ], [ %r, %if.then7 ], [ %call, %if.end8 ]
  ret i32 %retval.0
}

; Function Attrs: nounwind ssp uwtable
define i32 @main() #0 {
; CHECK: start main 0:
entry:
  %call = call i64 (...) @read()
  %conv = trunc i64 %call to i32
  %mul = mul i32 %conv, %conv
  %conv1 = zext i32 %mul to i64
  %mul2 = mul i64 %conv1, 8
  %call3 = call noalias i8* @malloc(i64 %mul2) #4
  %0 = bitcast i8* %call3 to i64*
  %mul4 = mul i32 %conv, %conv
  %conv5 = zext i32 %mul4 to i64
  %mul6 = mul i64 %conv5, 8
  %call7 = call noalias i8* @malloc(i64 %mul6) #4
  %1 = bitcast i64* %0 to i32*
  %sub = sub i32 %conv, 1
  %call8 = call i32 @recSearch(i32* %1, i32 0, i32 %sub, i32 3)
  ret i32 0
}
; CHECK: end main

; Function Attrs: argmemonly nounwind willreturn
declare void @llvm.lifetime.start.p0i8(i64 immarg, i8* nocapture) #1

declare i64 @read(...) #2

; Function Attrs: allocsize(0)
declare noalias i8* @malloc(i64) #3

; Function Attrs: argmemonly nounwind willreturn
declare void @llvm.lifetime.end.p0i8(i64 immarg, i8* nocapture) #1