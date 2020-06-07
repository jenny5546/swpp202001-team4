; Function Attrs: nounwind ssp uwtable
define i32 @gcd(i32 %a, i32 %b) #0 {
entry:
; CHECK: store
  %cmp = icmp eq i32 %a, 0
  br i1 %cmp, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  br label %return

if.end:                                           ; preds = %entry
  %rem = srem i32 %b, %a
  %call = call i32 @gcd(i32 %rem, i32 %a)
  br label %return

return:                                           ; preds = %if.end, %if.then
  %retval.0 = phi i32 [ %b, %if.then ], [ %call, %if.end ]
  ret i32 %retval.0
}

; Function Attrs: nounwind ssp uwtable
define i32 @lcm(i32 %a, i32 %b) #0 {
entry:
  %mul = mul nsw i32 %a, %b
  %call = call i32 @gcd(i32 %a, i32 %b)
  %div = sdiv i32 %mul, %call
  ret i32 %div
}

; Function Attrs: nounwind ssp uwtable
define i32 @main() #0 {
; CHECK: start main 0:
entry:
  ret i32 0
}
; CHECK: end main

; Function Attrs: argmemonly nounwind willreturn
declare void @llvm.lifetime.start.p0i8(i64 immarg, i8* nocapture) #1

; Function Attrs: argmemonly nounwind willreturn
declare void @llvm.lifetime.end.p0i8(i64 immarg, i8* nocapture) #1