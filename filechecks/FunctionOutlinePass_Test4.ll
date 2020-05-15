; ModuleID = '/tmp/a.ll'
source_filename = "test.c"
target datalayout = "e-m:o-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-apple-macosx10.14.0"

; Function Attrs: nounwind ssp uwtable
define i64 @insert(i64* %root, i64 %data, i64 %cnt) #0 {
entry:
;CHECK:    sp = sub sp 448 64
;CHECK-NEXT:    r1 = add sp 416 64
;CHECK-NEXT:    store 8 r1 sp 0
;CHECK-NEXT:    r1 = add sp 424 64
;CHECK-NEXT:    store 8 r1 sp 8
;CHECK-NEXT:    r1 = add sp 432 64
;CHECK-NEXT:    store 8 r1 sp 16
;CHECK-NEXT:    r1 = add sp 440 64
;CHECK-NEXT:    store 8 r1 sp 24
;CHECK-NEXT:    r1 = icmp eq arg3 0 64
;CHECK-NEXT:    store 8 r1 sp 32
;CHECK-NEXT:    store 8 10 sp 408
;CHECK-NEXT:    r1 = load 8 sp 408
;CHECK-NEXT:    store 8 r1 sp 400
;CHECK-NEXT:    r1 = load 8 sp 32
;CHECK-NEXT:    br r1 .return .if.end
  %cmp = icmp eq i64 %cnt, 0
  br i1 %cmp, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  br label %return

if.end:                                           ; preds = %entry
;CHECK:    r1 = mul arg1 1 64
;CHECK-NEXT:    store 8 r1 sp 40
;CHECK-NEXT:    r1 = and arg2 4294967295 64
;CHECK-NEXT:    store 8 r1 sp 48
;CHECK-NEXT:    r1 = load 8 sp 40
;CHECK-NEXT:    r2 = load 8 sp 48
;CHECK-NEXT:    r1 = add r1 r2 32
;CHECK-NEXT:    store 8 r1 sp 56
;CHECK-NEXT:    r1 = load 8 sp 56
;CHECK-NEXT:    r2 = load 8 sp 56
;CHECK-NEXT:    r1 = mul r1 r2 32
;CHECK-NEXT:    store 8 r1 sp 64
;CHECK-NEXT:    r1 = load 8 sp 64
;CHECK-NEXT:    r2 = load 8 sp 56
;CHECK-NEXT:    r1 = mul r1 r2 32
;CHECK-NEXT:    store 8 r1 sp 72
;CHECK-NEXT:    r1 = load 8 sp 72
;CHECK-NEXT:    r1 = add r1 1 32
;CHECK-NEXT:    store 8 r1 sp 80
;CHECK-NEXT:    r1 = load 8 sp 80
;CHECK-NEXT:    r2 = load 8 sp 80
;CHECK-NEXT:    r1 = mul r1 r2 32
;CHECK-NEXT:    store 8 r1 sp 88
;CHECK-NEXT:    r1 = load 8 sp 88
;CHECK-NEXT:    r2 = load 8 sp 80
;CHECK-NEXT:    r1 = mul r1 r2 32
;CHECK-NEXT:    store 8 r1 sp 96
;CHECK-NEXT:    r1 = load 8 sp 96
;CHECK-NEXT:    r1 = add r1 1 32
;CHECK-NEXT:    store 8 r1 sp 104
;CHECK-NEXT:    r1 = load 8 sp 104
;CHECK-NEXT:    r2 = load 8 sp 104
;CHECK-NEXT:    r1 = mul r1 r2 32
;CHECK-NEXT:    store 8 r1 sp 112
;CHECK-NEXT:    r1 = load 8 sp 112
;CHECK-NEXT:    r2 = load 8 sp 104
;CHECK-NEXT:    r1 = mul r1 r2 32
;CHECK-NEXT:    store 8 r1 sp 120
;CHECK-NEXT:    r1 = load 8 sp 120
;CHECK-NEXT:    r1 = add r1 1 32
;CHECK-NEXT:    store 8 r1 sp 128
;CHECK-NEXT:    r1 = load 8 sp 128
;CHECK-NEXT:    r2 = load 8 sp 128
;CHECK-NEXT:    r1 = mul r1 r2 32
;CHECK-NEXT:    store 8 r1 sp 136
;CHECK-NEXT:    r1 = load 8 sp 136
;CHECK-NEXT:    r2 = load 8 sp 128
;CHECK-NEXT:    r3 = load 8 sp 24
;CHECK-NEXT:    r1 = call insert.outline r1 r2 r3
;CHECK-NEXT:    store 8 r1 sp 144
;CHECK-NEXT:    r1 = load 8 sp 24
;CHECK-NEXT:    r1 = load 4 r1 0
;CHECK-NEXT:    store 8 r1 sp 152
;CHECK-NEXT:    r1 = load 8 sp 152
;CHECK-NEXT:    r2 = load 8 sp 56
;CHECK-NEXT:    r1 = mul r1 r2 32
;CHECK-NEXT:    store 8 r1 sp 160
;CHECK-NEXT:    r1 = load 8 sp 160
;CHECK-NEXT:    r2 = load 8 sp 56
;CHECK-NEXT:    r1 = mul r1 r2 32
;CHECK-NEXT:    store 8 r1 sp 168
;CHECK-NEXT:    r1 = load 8 sp 168
;CHECK-NEXT:    r1 = add r1 1 32
;CHECK-NEXT:    store 8 r1 sp 176
;CHECK-NEXT:    r1 = load 8 sp 176
;CHECK-NEXT:    r2 = load 8 sp 176
;CHECK-NEXT:    r1 = mul r1 r2 32
;CHECK-NEXT:    store 8 r1 sp 184
;CHECK-NEXT:    r1 = load 8 sp 184
;CHECK-NEXT:    r2 = load 8 sp 152
;CHECK-NEXT:    r1 = mul r1 r2 32
;CHECK-NEXT:    store 8 r1 sp 192
;CHECK-NEXT:    r1 = load 8 sp 192
;CHECK-NEXT:    r1 = add r1 1 32
;CHECK-NEXT:    store 8 r1 sp 200
;CHECK-NEXT:    r1 = load 8 sp 200
;CHECK-NEXT:    r2 = load 8 sp 200
;CHECK-NEXT:    r1 = mul r1 r2 32
;CHECK-NEXT:    store 8 r1 sp 208
;CHECK-NEXT:    r1 = load 8 sp 208
;CHECK-NEXT:    r2 = load 8 sp 200
;CHECK-NEXT:    r1 = mul r1 r2 32
;CHECK-NEXT:    store 8 r1 sp 216
;CHECK-NEXT:    r1 = load 8 sp 216
;CHECK-NEXT:    r1 = add r1 1 32
;CHECK-NEXT:    store 8 r1 sp 224
;CHECK-NEXT:    r1 = load 8 sp 224
;CHECK-NEXT:    r2 = load 8 sp 224
;CHECK-NEXT:    r1 = mul r1 r2 32
;CHECK-NEXT:    store 8 r1 sp 232
;CHECK-NEXT:    r1 = load 8 sp 232
;CHECK-NEXT:    r2 = load 8 sp 224
;CHECK-NEXT:    r1 = mul r1 r2 32
;CHECK-NEXT:    store 8 r1 sp 240
;CHECK-NEXT:    r1 = load 8 sp 240
;CHECK-NEXT:    r1 = add r1 1 32
;CHECK-NEXT:    store 8 r1 sp 248
;CHECK-NEXT:    r1 = load 8 sp 248
;CHECK-NEXT:    r2 = load 8 sp 248
;CHECK-NEXT:    r1 = mul r1 r2 32
;CHECK-NEXT:    store 8 r1 sp 256
;CHECK-NEXT:    r1 = load 8 sp 144
;CHECK-NEXT:    br r1 .if.then77 .if.else
  %0 = ptrtoint i64* %root to i32
  %conv = trunc i64 %data to i32
  %add = add nsw i32 %0, %conv
  %mul = mul nsw i32 %add, %add
  %mul1 = mul nsw i32 %mul, %add
  %add2 = add nsw i32 %mul1, 1
  %mul3 = mul nsw i32 %add2, %add2
  %mul4 = mul nsw i32 %mul3, %add2
  %add5 = add nsw i32 %mul4, 1
  %mul6 = mul nsw i32 %add5, %add5
  %mul7 = mul nsw i32 %mul6, %add5
  %add8 = add nsw i32 %mul7, 1
  %mul9 = mul nsw i32 %add8, %add8
  %mul10 = mul nsw i32 %mul9, %add8
  %add11 = add nsw i32 %mul10, 1
  %mul12 = mul nsw i32 %add11, %add11
  %mul13 = mul nsw i32 %mul12, %add11
  %add14 = add nsw i32 %mul13, 1
  %mul15 = mul nsw i32 %add14, %add14
  %mul16 = mul nsw i32 %mul15, %add14
  %add17 = add nsw i32 %mul16, 1
  %mul18 = mul nsw i32 %add17, %add17
  %mul19 = mul nsw i32 %mul18, %add17
  %add20 = add nsw i32 %mul19, 1
  %mul21 = mul nsw i32 %add20, %add20
  %mul22 = mul nsw i32 %mul21, %add20
  %add23 = add nsw i32 %mul22, 1
  %mul24 = mul nsw i32 %add23, %add23
  %mul25 = mul nsw i32 %mul24, %add23
  %add26 = add nsw i32 %mul25, 1
  %mul27 = mul nsw i32 %add26, %add26
  %mul28 = mul nsw i32 %mul27, %add26
  %add29 = add nsw i32 %mul28, 1
  %mul30 = mul nsw i32 %add29, %add29
  %mul31 = mul nsw i32 %mul30, %add29
  %add32 = add nsw i32 %mul31, 1
  %mul33 = mul nsw i32 %add32, %add32
  %mul34 = mul nsw i32 %mul33, %add32
  %add35 = add nsw i32 %mul34, 1
  %mul36 = mul nsw i32 %add35, %add35
  %mul37 = mul nsw i32 %mul36, %add35
  %add38 = add nsw i32 %mul37, 1
  %mul39 = mul nsw i32 %add38, %add38
  %mul40 = mul nsw i32 %mul39, %add38
  %add41 = add nsw i32 %mul40, 1
  %mul42 = mul nsw i32 %add41, %add41
  %mul43 = mul nsw i32 %mul42, %add41
  %add44 = add nsw i32 %mul43, 1
  %mul45 = mul nsw i32 %add44, %add44
  %mul46 = mul nsw i32 %mul45, %add44
  %add47 = add nsw i32 %mul46, 1
  %mul48 = mul nsw i32 %add47, %add47
  %mul49 = mul nsw i32 %mul48, %add47
  %add50 = add nsw i32 %mul49, 1
  %mul51 = mul nsw i32 %add50, %add50
  %mul52 = mul nsw i32 %mul51, %add50
  %add53 = add nsw i32 %mul52, 1
  %mul54 = mul nsw i32 %add53, %add53
  %mul55 = mul nsw i32 %mul54, %add53
  %add56 = add nsw i32 %mul55, 1
  %mul57 = mul nsw i32 %add56, %add56
  %mul58 = mul nsw i32 %mul57, %add56
  %add59 = add nsw i32 %mul58, 1
  %mul60 = mul nsw i32 %add59, %add59
  %mul61 = mul nsw i32 %mul60, %add59
  %add62 = add nsw i32 %mul61, 1
  %mul63 = mul nsw i32 %add62, %add62
  %mul64 = mul nsw i32 %mul63, %add62
  %add65 = add nsw i32 %mul64, 1
  %mul66 = mul nsw i32 %add65, %add65
  %mul67 = mul nsw i32 %mul66, %add65
  %add68 = add nsw i32 %mul67, 1
  %mul69 = mul nsw i32 %add68, %add68
  %mul70 = mul nsw i32 %mul69, %add68
  %add71 = add nsw i32 %mul70, 1
  %mul72 = mul nsw i32 %add71, %add71
  %mul73 = mul nsw i32 %mul72, %add71
  %add74 = add nsw i32 %mul73, 1
  %cmp75 = icmp eq i32 %add74, %add71
  br i1 %cmp75, label %if.then77, label %if.else

if.then77:                                        ; preds = %if.end
;CHECK:    r1 = load 8 sp 256
;CHECK-NEXT:    r2 = load 8 sp 248
;CHECK-NEXT:    r3 = load 8 sp 56
;CHECK-NEXT:    r4 = load 8 sp 16
;CHECK-NEXT:    call insert.outline.1 r1 r2 r3 r4
;CHECK-NEXT:    r1 = load 8 sp 16
;CHECK-NEXT:    r1 = load 4 r1 0
;CHECK-NEXT:    store 8 r1 sp 264
;CHECK-NEXT:    r1 = load 8 sp 264
;CHECK-NEXT:    store 8 r1 sp 288
;CHECK-NEXT:    r1 = load 8 sp 288
;CHECK-NEXT:    store 8 r1 sp 280
;CHECK-NEXT:    br .if.end837
  %mul78 = mul nsw i32 %add74, %add
  %mul79 = mul nsw i32 %mul78, %add
  %add80 = add nsw i32 %mul79, 1
  %mul81 = mul nsw i32 %add80, %add80
  %mul82 = mul nsw i32 %mul81, %add74
  %add83 = add nsw i32 %mul82, 1
  %mul84 = mul nsw i32 %add83, %add83
  %mul85 = mul nsw i32 %mul84, %add83
  %add86 = add nsw i32 %mul85, 1
  %mul87 = mul nsw i32 %add86, %add86
  %mul88 = mul nsw i32 %mul87, %add86
  %add89 = add nsw i32 %mul88, 1
  %mul90 = mul nsw i32 %add89, %add89
  %mul91 = mul nsw i32 %mul90, %add89
  %add92 = add nsw i32 %mul91, 1
  %mul93 = mul nsw i32 %add92, %add92
  %mul94 = mul nsw i32 %mul93, %add92
  %add95 = add nsw i32 %mul94, 1
  %mul96 = mul nsw i32 %add95, %add95
  %mul97 = mul nsw i32 %mul96, %add95
  %add98 = add nsw i32 %mul97, 1
  %mul99 = mul nsw i32 %add98, %add98
  %mul100 = mul nsw i32 %mul99, %add98
  %add101 = add nsw i32 %mul100, 1
  %mul102 = mul nsw i32 %add101, %add101
  %mul103 = mul nsw i32 %mul102, %add101
  %add104 = add nsw i32 %mul103, 1
  %mul105 = mul nsw i32 %add104, %add104
  %mul106 = mul nsw i32 %mul105, %add104
  %add107 = add nsw i32 %mul106, 1
  %mul108 = mul nsw i32 %add107, %add107
  %mul109 = mul nsw i32 %mul108, %add107
  %add110 = add nsw i32 %mul109, 1
  %mul111 = mul nsw i32 %add110, %add110
  %mul112 = mul nsw i32 %mul111, %add110
  %add113 = add nsw i32 %mul112, 1
  %mul114 = mul nsw i32 %add113, %add113
  %mul115 = mul nsw i32 %mul114, %add113
  %add116 = add nsw i32 %mul115, 1
  %mul117 = mul nsw i32 %add116, %add116
  %mul118 = mul nsw i32 %mul117, %add116
  %add119 = add nsw i32 %mul118, 1
  %mul120 = mul nsw i32 %add119, %add119
  %mul121 = mul nsw i32 %mul120, %add119
  %add122 = add nsw i32 %mul121, 1
  %mul123 = mul nsw i32 %add122, %add122
  %mul124 = mul nsw i32 %mul123, %add122
  %add125 = add nsw i32 %mul124, 1
  %mul126 = mul nsw i32 %add125, %add125
  %mul127 = mul nsw i32 %mul126, %add125
  %add128 = add nsw i32 %mul127, 1
  %mul129 = mul nsw i32 %add128, %add128
  %mul130 = mul nsw i32 %mul129, %add128
  %add131 = add nsw i32 %mul130, 1
  %mul132 = mul nsw i32 %add131, %add131
  %mul133 = mul nsw i32 %mul132, %add131
  %add134 = add nsw i32 %mul133, 1
  %mul135 = mul nsw i32 %add134, %add134
  %mul136 = mul nsw i32 %mul135, %add134
  %add137 = add nsw i32 %mul136, 1
  %mul138 = mul nsw i32 %add137, %add137
  %mul139 = mul nsw i32 %mul138, %add137
  %add140 = add nsw i32 %mul139, 1
  %mul141 = mul nsw i32 %add140, %add140
  %mul142 = mul nsw i32 %mul141, %add140
  %add143 = add nsw i32 %mul142, 1
  %mul144 = mul nsw i32 %add143, %add143
  %mul145 = mul nsw i32 %mul144, %add143
  %add146 = add nsw i32 %mul145, 1
  %mul147 = mul nsw i32 %add146, %add146
  %mul148 = mul nsw i32 %mul147, %add146
  %add149 = add nsw i32 %mul148, 1
  %mul150 = mul nsw i32 %add149, %add149
  %mul151 = mul nsw i32 %mul150, %add149
  %add152 = add nsw i32 %mul151, 1
  %mul231 = mul nsw i32 %add152, %add
  %mul232 = mul nsw i32 %mul231, %add
  %add233 = add nsw i32 %mul232, 1
  %mul234 = mul nsw i32 %add233, %add233
  %mul235 = mul nsw i32 %mul234, %add152
  %add236 = add nsw i32 %mul235, 1
  %mul237 = mul nsw i32 %add236, %add236
  %mul238 = mul nsw i32 %mul237, %add236
  %add239 = add nsw i32 %mul238, 1
  %mul240 = mul nsw i32 %add239, %add239
  %mul241 = mul nsw i32 %mul240, %add239
  %add242 = add nsw i32 %mul241, 1
  %mul243 = mul nsw i32 %add242, %add242
  %mul244 = mul nsw i32 %mul243, %add242
  %add245 = add nsw i32 %mul244, 1
  %mul246 = mul nsw i32 %add245, %add245
  %mul247 = mul nsw i32 %mul246, %add245
  %add248 = add nsw i32 %mul247, 1
  %mul249 = mul nsw i32 %add248, %add248
  %mul250 = mul nsw i32 %mul249, %add248
  %add251 = add nsw i32 %mul250, 1
  %mul252 = mul nsw i32 %add251, %add251
  %mul253 = mul nsw i32 %mul252, %add251
  %add254 = add nsw i32 %mul253, 1
  %mul255 = mul nsw i32 %add254, %add254
  %mul256 = mul nsw i32 %mul255, %add254
  %add257 = add nsw i32 %mul256, 1
  %mul258 = mul nsw i32 %add257, %add257
  %mul259 = mul nsw i32 %mul258, %add257
  %add260 = add nsw i32 %mul259, 1
  %mul261 = mul nsw i32 %add260, %add260
  %mul262 = mul nsw i32 %mul261, %add260
  %add263 = add nsw i32 %mul262, 1
  %mul264 = mul nsw i32 %add263, %add263
  %mul265 = mul nsw i32 %mul264, %add263
  %add266 = add nsw i32 %mul265, 1
  %mul267 = mul nsw i32 %add266, %add266
  %mul268 = mul nsw i32 %mul267, %add266
  %add269 = add nsw i32 %mul268, 1
  %mul270 = mul nsw i32 %add269, %add269
  %mul271 = mul nsw i32 %mul270, %add269
  %add272 = add nsw i32 %mul271, 1
  %mul273 = mul nsw i32 %add272, %add272
  %mul274 = mul nsw i32 %mul273, %add272
  %add275 = add nsw i32 %mul274, 1
  %mul276 = mul nsw i32 %add275, %add275
  %mul277 = mul nsw i32 %mul276, %add275
  %add278 = add nsw i32 %mul277, 1
  %mul279 = mul nsw i32 %add278, %add278
  %mul280 = mul nsw i32 %mul279, %add278
  %add281 = add nsw i32 %mul280, 1
  %mul282 = mul nsw i32 %add281, %add281
  %mul283 = mul nsw i32 %mul282, %add281
  %add284 = add nsw i32 %mul283, 1
  %mul285 = mul nsw i32 %add284, %add284
  %mul286 = mul nsw i32 %mul285, %add284
  %add287 = add nsw i32 %mul286, 1
  %mul288 = mul nsw i32 %add287, %add287
  %mul289 = mul nsw i32 %mul288, %add287
  %add290 = add nsw i32 %mul289, 1
  %mul291 = mul nsw i32 %add290, %add290
  %mul292 = mul nsw i32 %mul291, %add290
  %add293 = add nsw i32 %mul292, 1
  %mul294 = mul nsw i32 %add293, %add293
  %mul295 = mul nsw i32 %mul294, %add293
  %add296 = add nsw i32 %mul295, 1
  %mul297 = mul nsw i32 %add296, %add296
  %mul298 = mul nsw i32 %mul297, %add296
  %add299 = add nsw i32 %mul298, 1
  %mul300 = mul nsw i32 %add299, %add299
  %mul301 = mul nsw i32 %mul300, %add299
  %add302 = add nsw i32 %mul301, 1
  %mul303 = mul nsw i32 %add302, %add302
  %mul304 = mul nsw i32 %mul303, %add302
  %add305 = add nsw i32 %mul304, 1
  br label %if.end837

if.else:                                          ; preds = %if.end
;CHECK:    r1 = load 8 sp 256
;CHECK-NEXT:    r2 = load 8 sp 248
;CHECK-NEXT:    r3 = load 8 sp 56
;CHECK-NEXT:    r4 = load 8 sp 8
;CHECK-NEXT:    call insert.outline.2 r1 r2 r3 r4
;CHECK-NEXT:    r1 = load 8 sp 8
;CHECK-NEXT:    r1 = load 4 r1 0
;CHECK-NEXT:    store 8 r1 sp 272
;CHECK-NEXT:    r1 = load 8 sp 272
;CHECK-NEXT:    store 8 r1 sp 288
;CHECK-NEXT:    r1 = load 8 sp 288
;CHECK-NEXT:    store 8 r1 sp 280
;CHECK-NEXT:    br .if.end837
  %mul306 = mul nsw i32 %add74, %add
  %mul307 = mul nsw i32 %mul306, %add
  %add308 = add nsw i32 %mul307, 1
  %mul309 = mul nsw i32 %add308, %add308
  %mul310 = mul nsw i32 %mul309, %add74
  %add311 = add nsw i32 %mul310, 1
  %mul312 = mul nsw i32 %add311, %add311
  %mul313 = mul nsw i32 %mul312, %add311
  %add314 = add nsw i32 %mul313, 1
  %mul315 = mul nsw i32 %add314, %add314
  %mul316 = mul nsw i32 %mul315, %add314
  %add317 = add nsw i32 %mul316, 1
  %mul318 = mul nsw i32 %add317, %add317
  %mul319 = mul nsw i32 %mul318, %add317
  %add320 = add nsw i32 %mul319, 1
  %mul321 = mul nsw i32 %add320, %add320
  %mul322 = mul nsw i32 %mul321, %add320
  %add323 = add nsw i32 %mul322, 1
  %mul324 = mul nsw i32 %add323, %add323
  %mul325 = mul nsw i32 %mul324, %add323
  %add326 = add nsw i32 %mul325, 1
  %mul327 = mul nsw i32 %add326, %add326
  %mul328 = mul nsw i32 %mul327, %add326
  %add329 = add nsw i32 %mul328, 1
  %mul330 = mul nsw i32 %add329, %add329
  %mul331 = mul nsw i32 %mul330, %add329
  %add332 = add nsw i32 %mul331, 1
  %mul333 = mul nsw i32 %add332, %add332
  %mul334 = mul nsw i32 %mul333, %add332
  %add335 = add nsw i32 %mul334, 1
  %mul336 = mul nsw i32 %add335, %add335
  %mul337 = mul nsw i32 %mul336, %add335
  %add338 = add nsw i32 %mul337, 1
  %mul339 = mul nsw i32 %add338, %add338
  %mul340 = mul nsw i32 %mul339, %add338
  %add341 = add nsw i32 %mul340, 1
  %mul342 = mul nsw i32 %add341, %add341
  %mul343 = mul nsw i32 %mul342, %add341
  %add344 = add nsw i32 %mul343, 1
  %mul345 = mul nsw i32 %add344, %add344
  %mul346 = mul nsw i32 %mul345, %add344
  %add347 = add nsw i32 %mul346, 1
  %mul348 = mul nsw i32 %add347, %add347
  %mul349 = mul nsw i32 %mul348, %add347
  %add350 = add nsw i32 %mul349, 1
  %mul351 = mul nsw i32 %add350, %add350
  %mul352 = mul nsw i32 %mul351, %add350
  %add353 = add nsw i32 %mul352, 1
  %mul354 = mul nsw i32 %add353, %add353
  %mul355 = mul nsw i32 %mul354, %add353
  %add356 = add nsw i32 %mul355, 1
  %mul357 = mul nsw i32 %add356, %add356
  %mul358 = mul nsw i32 %mul357, %add356
  %add359 = add nsw i32 %mul358, 1
  %mul360 = mul nsw i32 %add359, %add359
  %mul361 = mul nsw i32 %mul360, %add359
  %add362 = add nsw i32 %mul361, 1
  %mul363 = mul nsw i32 %add362, %add362
  %mul364 = mul nsw i32 %mul363, %add362
  %add365 = add nsw i32 %mul364, 1
  %mul366 = mul nsw i32 %add365, %add365
  %mul367 = mul nsw i32 %mul366, %add365
  %add368 = add nsw i32 %mul367, 1
  %mul369 = mul nsw i32 %add368, %add368
  %mul370 = mul nsw i32 %mul369, %add368
  %add371 = add nsw i32 %mul370, 1
  %mul372 = mul nsw i32 %add371, %add371
  %mul373 = mul nsw i32 %mul372, %add371
  %add374 = add nsw i32 %mul373, 1
  %mul375 = mul nsw i32 %add374, %add374
  %mul376 = mul nsw i32 %mul375, %add374
  %add377 = add nsw i32 %mul376, 1
  %mul378 = mul nsw i32 %add377, %add377
  %mul379 = mul nsw i32 %mul378, %add377
  %add380 = add nsw i32 %mul379, 1
  %mul459 = mul nsw i32 %add380, %add
  %mul460 = mul nsw i32 %mul459, %add
  %add461 = add nsw i32 %mul460, 1
  %mul462 = mul nsw i32 %add461, %add461
  %mul463 = mul nsw i32 %mul462, %add380
  %add464 = add nsw i32 %mul463, 1
  %mul465 = mul nsw i32 %add464, %add464
  %mul466 = mul nsw i32 %mul465, %add464
  %add467 = add nsw i32 %mul466, 1
  %mul468 = mul nsw i32 %add467, %add467
  %mul469 = mul nsw i32 %mul468, %add467
  %add470 = add nsw i32 %mul469, 1
  %mul471 = mul nsw i32 %add470, %add470
  %mul472 = mul nsw i32 %mul471, %add470
  %add473 = add nsw i32 %mul472, 1
  %mul474 = mul nsw i32 %add473, %add473
  %mul475 = mul nsw i32 %mul474, %add473
  %add476 = add nsw i32 %mul475, 1
  %mul477 = mul nsw i32 %add476, %add476
  %mul478 = mul nsw i32 %mul477, %add476
  %add479 = add nsw i32 %mul478, 1
  %mul480 = mul nsw i32 %add479, %add479
  %mul481 = mul nsw i32 %mul480, %add479
  %add482 = add nsw i32 %mul481, 1
  %mul483 = mul nsw i32 %add482, %add482
  %mul484 = mul nsw i32 %mul483, %add482
  %add485 = add nsw i32 %mul484, 1
  %mul486 = mul nsw i32 %add485, %add485
  %mul487 = mul nsw i32 %mul486, %add485
  %add488 = add nsw i32 %mul487, 1
  %mul489 = mul nsw i32 %add488, %add488
  %mul490 = mul nsw i32 %mul489, %add488
  %add491 = add nsw i32 %mul490, 1
  %mul492 = mul nsw i32 %add491, %add491
  %mul493 = mul nsw i32 %mul492, %add491
  %add494 = add nsw i32 %mul493, 1
  %mul495 = mul nsw i32 %add494, %add494
  %mul496 = mul nsw i32 %mul495, %add494
  %add497 = add nsw i32 %mul496, 1
  %mul498 = mul nsw i32 %add497, %add497
  %mul499 = mul nsw i32 %mul498, %add497
  %add500 = add nsw i32 %mul499, 1
  %mul501 = mul nsw i32 %add500, %add500
  %mul502 = mul nsw i32 %mul501, %add500
  %add503 = add nsw i32 %mul502, 1
  %mul504 = mul nsw i32 %add503, %add503
  %mul505 = mul nsw i32 %mul504, %add503
  %add506 = add nsw i32 %mul505, 1
  %mul507 = mul nsw i32 %add506, %add506
  %mul508 = mul nsw i32 %mul507, %add506
  %add509 = add nsw i32 %mul508, 1
  %mul510 = mul nsw i32 %add509, %add509
  %mul511 = mul nsw i32 %mul510, %add509
  %add512 = add nsw i32 %mul511, 1
  %mul513 = mul nsw i32 %add512, %add512
  %mul514 = mul nsw i32 %mul513, %add512
  %add515 = add nsw i32 %mul514, 1
  %mul516 = mul nsw i32 %add515, %add515
  %mul517 = mul nsw i32 %mul516, %add515
  %add518 = add nsw i32 %mul517, 1
  %mul519 = mul nsw i32 %add518, %add518
  %mul520 = mul nsw i32 %mul519, %add518
  %add521 = add nsw i32 %mul520, 1
  %mul522 = mul nsw i32 %add521, %add521
  %mul523 = mul nsw i32 %mul522, %add521
  %add524 = add nsw i32 %mul523, 1
  %mul525 = mul nsw i32 %add524, %add524
  %mul526 = mul nsw i32 %mul525, %add524
  %add527 = add nsw i32 %mul526, 1
  %mul528 = mul nsw i32 %add527, %add527
  %mul529 = mul nsw i32 %mul528, %add527
  %add530 = add nsw i32 %mul529, 1
  %mul531 = mul nsw i32 %add530, %add530
  %mul532 = mul nsw i32 %mul531, %add530
  %add533 = add nsw i32 %mul532, 1
  %mul534 = mul nsw i32 %add533, %add
  %mul535 = mul nsw i32 %mul534, %add
  %add536 = add nsw i32 %mul535, 1
  %mul537 = mul nsw i32 %add536, %add536
  %mul538 = mul nsw i32 %mul537, %add533
  %add539 = add nsw i32 %mul538, 1
  %mul540 = mul nsw i32 %add539, %add539
  %mul541 = mul nsw i32 %mul540, %add539
  %add542 = add nsw i32 %mul541, 1
  %mul543 = mul nsw i32 %add542, %add542
  %mul544 = mul nsw i32 %mul543, %add542
  %add545 = add nsw i32 %mul544, 1
  %mul546 = mul nsw i32 %add545, %add545
  %mul547 = mul nsw i32 %mul546, %add545
  %add548 = add nsw i32 %mul547, 1
  %mul549 = mul nsw i32 %add548, %add548
  %mul550 = mul nsw i32 %mul549, %add548
  %add551 = add nsw i32 %mul550, 1
  %mul552 = mul nsw i32 %add551, %add551
  %mul553 = mul nsw i32 %mul552, %add551
  %add554 = add nsw i32 %mul553, 1
  %mul555 = mul nsw i32 %add554, %add554
  %mul556 = mul nsw i32 %mul555, %add554
  %add557 = add nsw i32 %mul556, 1
  %mul558 = mul nsw i32 %add557, %add557
  %mul559 = mul nsw i32 %mul558, %add557
  %add560 = add nsw i32 %mul559, 1
  %mul561 = mul nsw i32 %add560, %add560
  %mul562 = mul nsw i32 %mul561, %add560
  %add563 = add nsw i32 %mul562, 1
  %mul564 = mul nsw i32 %add563, %add563
  %mul565 = mul nsw i32 %mul564, %add563
  %add566 = add nsw i32 %mul565, 1
  %mul567 = mul nsw i32 %add566, %add566
  %mul568 = mul nsw i32 %mul567, %add566
  %add569 = add nsw i32 %mul568, 1
  %mul570 = mul nsw i32 %add569, %add569
  %mul571 = mul nsw i32 %mul570, %add569
  %add572 = add nsw i32 %mul571, 1
  %mul573 = mul nsw i32 %add572, %add572
  %mul574 = mul nsw i32 %mul573, %add572
  %add575 = add nsw i32 %mul574, 1
  %mul576 = mul nsw i32 %add575, %add575
  %mul577 = mul nsw i32 %mul576, %add575
  %add578 = add nsw i32 %mul577, 1
  %mul579 = mul nsw i32 %add578, %add578
  %mul580 = mul nsw i32 %mul579, %add578
  %add581 = add nsw i32 %mul580, 1
  %mul582 = mul nsw i32 %add581, %add581
  %mul583 = mul nsw i32 %mul582, %add581
  %add584 = add nsw i32 %mul583, 1
  %mul585 = mul nsw i32 %add584, %add584
  %mul586 = mul nsw i32 %mul585, %add584
  %add587 = add nsw i32 %mul586, 1
  %mul588 = mul nsw i32 %add587, %add587
  %mul589 = mul nsw i32 %mul588, %add587
  %add590 = add nsw i32 %mul589, 1
  %mul591 = mul nsw i32 %add590, %add590
  %mul592 = mul nsw i32 %mul591, %add590
  %add593 = add nsw i32 %mul592, 1
  %mul594 = mul nsw i32 %add593, %add593
  %mul595 = mul nsw i32 %mul594, %add593
  %add596 = add nsw i32 %mul595, 1
  %mul597 = mul nsw i32 %add596, %add596
  %mul598 = mul nsw i32 %mul597, %add596
  %add599 = add nsw i32 %mul598, 1
  %mul600 = mul nsw i32 %add599, %add599
  %mul601 = mul nsw i32 %mul600, %add599
  %add602 = add nsw i32 %mul601, 1
  %mul603 = mul nsw i32 %add602, %add602
  %mul604 = mul nsw i32 %mul603, %add602
  %add605 = add nsw i32 %mul604, 1
  %mul606 = mul nsw i32 %add605, %add605
  %mul607 = mul nsw i32 %mul606, %add605
  %add608 = add nsw i32 %mul607, 1
  %mul609 = mul nsw i32 %add608, %add
  %mul610 = mul nsw i32 %mul609, %add
  %add611 = add nsw i32 %mul610, 1
  %mul612 = mul nsw i32 %add611, %add611
  %mul613 = mul nsw i32 %mul612, %add608
  %add614 = add nsw i32 %mul613, 1
  %mul615 = mul nsw i32 %add614, %add614
  %mul616 = mul nsw i32 %mul615, %add614
  %add617 = add nsw i32 %mul616, 1
  %mul618 = mul nsw i32 %add617, %add617
  %mul619 = mul nsw i32 %mul618, %add617
  %add620 = add nsw i32 %mul619, 1
  %mul621 = mul nsw i32 %add620, %add620
  %mul622 = mul nsw i32 %mul621, %add620
  %add623 = add nsw i32 %mul622, 1
  %mul624 = mul nsw i32 %add623, %add623
  %mul625 = mul nsw i32 %mul624, %add623
  %add626 = add nsw i32 %mul625, 1
  %mul627 = mul nsw i32 %add626, %add626
  %mul628 = mul nsw i32 %mul627, %add626
  %add629 = add nsw i32 %mul628, 1
  %mul630 = mul nsw i32 %add629, %add629
  %mul631 = mul nsw i32 %mul630, %add629
  %add632 = add nsw i32 %mul631, 1
  %mul633 = mul nsw i32 %add632, %add632
  %mul634 = mul nsw i32 %mul633, %add632
  %add635 = add nsw i32 %mul634, 1
  %mul636 = mul nsw i32 %add635, %add635
  %mul637 = mul nsw i32 %mul636, %add635
  %add638 = add nsw i32 %mul637, 1
  %mul639 = mul nsw i32 %add638, %add638
  %mul640 = mul nsw i32 %mul639, %add638
  %add641 = add nsw i32 %mul640, 1
  %mul642 = mul nsw i32 %add641, %add641
  %mul643 = mul nsw i32 %mul642, %add641
  %add644 = add nsw i32 %mul643, 1
  %mul645 = mul nsw i32 %add644, %add644
  %mul646 = mul nsw i32 %mul645, %add644
  %add647 = add nsw i32 %mul646, 1
  %mul648 = mul nsw i32 %add647, %add647
  %mul649 = mul nsw i32 %mul648, %add647
  %add650 = add nsw i32 %mul649, 1
  %mul651 = mul nsw i32 %add650, %add650
  %mul652 = mul nsw i32 %mul651, %add650
  %add653 = add nsw i32 %mul652, 1
  %mul654 = mul nsw i32 %add653, %add653
  %mul655 = mul nsw i32 %mul654, %add653
  %add656 = add nsw i32 %mul655, 1
  %mul657 = mul nsw i32 %add656, %add656
  %mul658 = mul nsw i32 %mul657, %add656
  %add659 = add nsw i32 %mul658, 1
  %mul660 = mul nsw i32 %add659, %add659
  %mul661 = mul nsw i32 %mul660, %add659
  %add662 = add nsw i32 %mul661, 1
  %mul663 = mul nsw i32 %add662, %add662
  %mul664 = mul nsw i32 %mul663, %add662
  %add665 = add nsw i32 %mul664, 1
  %mul666 = mul nsw i32 %add665, %add665
  %mul667 = mul nsw i32 %mul666, %add665
  %add668 = add nsw i32 %mul667, 1
  %mul669 = mul nsw i32 %add668, %add668
  %mul670 = mul nsw i32 %mul669, %add668
  %add671 = add nsw i32 %mul670, 1
  %mul672 = mul nsw i32 %add671, %add671
  %mul673 = mul nsw i32 %mul672, %add671
  %add674 = add nsw i32 %mul673, 1
  %mul675 = mul nsw i32 %add674, %add674
  %mul676 = mul nsw i32 %mul675, %add674
  %add677 = add nsw i32 %mul676, 1
  %mul678 = mul nsw i32 %add677, %add677
  %mul679 = mul nsw i32 %mul678, %add677
  %add680 = add nsw i32 %mul679, 1
  %mul681 = mul nsw i32 %add680, %add680
  %mul682 = mul nsw i32 %mul681, %add680
  %add683 = add nsw i32 %mul682, 1
  %mul762 = mul nsw i32 %add683, %add
  %mul763 = mul nsw i32 %mul762, %add
  %add764 = add nsw i32 %mul763, 1
  %mul765 = mul nsw i32 %add764, %add764
  %mul766 = mul nsw i32 %mul765, %add683
  %add767 = add nsw i32 %mul766, 1
  %mul768 = mul nsw i32 %add767, %add767
  %mul769 = mul nsw i32 %mul768, %add767
  %add770 = add nsw i32 %mul769, 1
  %mul771 = mul nsw i32 %add770, %add770
  %mul772 = mul nsw i32 %mul771, %add770
  %add773 = add nsw i32 %mul772, 1
  %mul774 = mul nsw i32 %add773, %add773
  %mul775 = mul nsw i32 %mul774, %add773
  %add776 = add nsw i32 %mul775, 1
  %mul777 = mul nsw i32 %add776, %add776
  %mul778 = mul nsw i32 %mul777, %add776
  %add779 = add nsw i32 %mul778, 1
  %mul780 = mul nsw i32 %add779, %add779
  %mul781 = mul nsw i32 %mul780, %add779
  %add782 = add nsw i32 %mul781, 1
  %mul783 = mul nsw i32 %add782, %add782
  %mul784 = mul nsw i32 %mul783, %add782
  %add785 = add nsw i32 %mul784, 1
  %mul786 = mul nsw i32 %add785, %add785
  %mul787 = mul nsw i32 %mul786, %add785
  %add788 = add nsw i32 %mul787, 1
  %mul789 = mul nsw i32 %add788, %add788
  %mul790 = mul nsw i32 %mul789, %add788
  %add791 = add nsw i32 %mul790, 1
  %mul792 = mul nsw i32 %add791, %add791
  %mul793 = mul nsw i32 %mul792, %add791
  %add794 = add nsw i32 %mul793, 1
  %mul795 = mul nsw i32 %add794, %add794
  %mul796 = mul nsw i32 %mul795, %add794
  %add797 = add nsw i32 %mul796, 1
  %mul798 = mul nsw i32 %add797, %add797
  %mul799 = mul nsw i32 %mul798, %add797
  %add800 = add nsw i32 %mul799, 1
  %mul801 = mul nsw i32 %add800, %add800
  %mul802 = mul nsw i32 %mul801, %add800
  %add803 = add nsw i32 %mul802, 1
  %mul804 = mul nsw i32 %add803, %add803
  %mul805 = mul nsw i32 %mul804, %add803
  %add806 = add nsw i32 %mul805, 1
  %mul807 = mul nsw i32 %add806, %add806
  %mul808 = mul nsw i32 %mul807, %add806
  %add809 = add nsw i32 %mul808, 1
  %mul810 = mul nsw i32 %add809, %add809
  %mul811 = mul nsw i32 %mul810, %add809
  %add812 = add nsw i32 %mul811, 1
  %mul813 = mul nsw i32 %add812, %add812
  %mul814 = mul nsw i32 %mul813, %add812
  %add815 = add nsw i32 %mul814, 1
  %mul816 = mul nsw i32 %add815, %add815
  %mul817 = mul nsw i32 %mul816, %add815
  %add818 = add nsw i32 %mul817, 1
  %mul819 = mul nsw i32 %add818, %add818
  %mul820 = mul nsw i32 %mul819, %add818
  %add821 = add nsw i32 %mul820, 1
  %mul822 = mul nsw i32 %add821, %add821
  %mul823 = mul nsw i32 %mul822, %add821
  %add824 = add nsw i32 %mul823, 1
  %mul825 = mul nsw i32 %add824, %add824
  %mul826 = mul nsw i32 %mul825, %add824
  %add827 = add nsw i32 %mul826, 1
  %mul828 = mul nsw i32 %add827, %add827
  %mul829 = mul nsw i32 %mul828, %add827
  %add830 = add nsw i32 %mul829, 1
  %mul831 = mul nsw i32 %add830, %add830
  %mul832 = mul nsw i32 %mul831, %add830
  %add833 = add nsw i32 %mul832, 1
  %mul834 = mul nsw i32 %add833, %add833
  %mul835 = mul nsw i32 %mul834, %add833
  %add836 = add nsw i32 %mul835, 1
  br label %if.end837

if.end837:                                        ; preds = %if.else, %if.then77
;CHECK:    r1 = load 8 sp 280
;CHECK-NEXT:    r2 = load 8 sp 56
;CHECK-NEXT:    r1 = mul r1 r2 32
;CHECK-NEXT:    store 8 r1 sp 296
;CHECK-NEXT:    r1 = load 8 sp 296
;CHECK-NEXT:    r2 = load 8 sp 56
;CHECK-NEXT:    r1 = mul r1 r2 32
;CHECK-NEXT:    store 8 r1 sp 304
;CHECK-NEXT:    r1 = load 8 sp 304
;CHECK-NEXT:    r1 = add r1 1 32
;CHECK-NEXT:    store 8 r1 sp 312
;CHECK-NEXT:    r1 = load 8 sp 312
;CHECK-NEXT:    r2 = load 8 sp 312
;CHECK-NEXT:    r1 = mul r1 r2 32
;CHECK-NEXT:    store 8 r1 sp 320
;CHECK-NEXT:    r1 = load 8 sp 320
;CHECK-NEXT:    r2 = load 8 sp 280
;CHECK-NEXT:    r1 = mul r1 r2 32
;CHECK-NEXT:    store 8 r1 sp 328
;CHECK-NEXT:    r1 = load 8 sp 328
;CHECK-NEXT:    r1 = add r1 1 32
;CHECK-NEXT:    store 8 r1 sp 336
;CHECK-NEXT:    r1 = load 8 sp 336
;CHECK-NEXT:    r2 = load 8 sp 336
;CHECK-NEXT:    r1 = mul r1 r2 32
;CHECK-NEXT:    store 8 r1 sp 344
;CHECK-NEXT:    r1 = load 8 sp 344
;CHECK-NEXT:    r2 = load 8 sp 336
;CHECK-NEXT:    r1 = mul r1 r2 32
;CHECK-NEXT:    store 8 r1 sp 352
;CHECK-NEXT:    r1 = load 8 sp 352
;CHECK-NEXT:    r1 = add r1 1 32
;CHECK-NEXT:    store 8 r1 sp 360
;CHECK-NEXT:    r1 = load 8 sp 360
;CHECK-NEXT:    r2 = load 8 sp 360
;CHECK-NEXT:    r1 = mul r1 r2 32
;CHECK-NEXT:    store 8 r1 sp 368
;CHECK-NEXT:    r1 = load 8 sp 368
;CHECK-NEXT:    r2 = load 8 sp 360
;CHECK-NEXT:    r1 = mul r1 r2 32
;CHECK-NEXT:    store 8 r1 sp 376
;CHECK-NEXT:    r1 = load 8 sp 376
;CHECK-NEXT:    r1 = add r1 1 32
;CHECK-NEXT:    store 8 r1 sp 384
;CHECK-NEXT:    r1 = load 8 sp 384
;CHECK-NEXT:    r2 = load 8 sp 56
;CHECK-NEXT:    r4 = load 8 sp 0
;CHECK-NEXT:    call insert.outline.3 r1 r2 arg3 r4
;CHECK-NEXT:    r1 = load 8 sp 0
;CHECK-NEXT:    r1 = load 8 r1 0
;CHECK-NEXT:    store 8 r1 sp 392
;CHECK-NEXT:    r1 = load 8 sp 392
;CHECK-NEXT:    store 8 r1 sp 408
;CHECK-NEXT:    r1 = load 8 sp 408
;CHECK-NEXT:    store 8 r1 sp 400
;CHECK-NEXT:    br .return
  %z.0 = phi i32 [ %add305, %if.then77 ], [ %add836, %if.else ]
  %mul838 = mul nsw i32 %z.0, %add
  %mul839 = mul nsw i32 %mul838, %add
  %add840 = add nsw i32 %mul839, 1
  %mul841 = mul nsw i32 %add840, %add840
  %mul842 = mul nsw i32 %mul841, %z.0
  %add843 = add nsw i32 %mul842, 1
  %mul844 = mul nsw i32 %add843, %add843
  %mul845 = mul nsw i32 %mul844, %add843
  %add846 = add nsw i32 %mul845, 1
  %mul847 = mul nsw i32 %add846, %add846
  %mul848 = mul nsw i32 %mul847, %add846
  %add849 = add nsw i32 %mul848, 1
  %mul850 = mul nsw i32 %add849, %add849
  %mul851 = mul nsw i32 %mul850, %add849
  %add852 = add nsw i32 %mul851, 1
  %mul853 = mul nsw i32 %add852, %add852
  %mul854 = mul nsw i32 %mul853, %add852
  %add855 = add nsw i32 %mul854, 1
  %mul856 = mul nsw i32 %add855, %add855
  %mul857 = mul nsw i32 %mul856, %add855
  %add858 = add nsw i32 %mul857, 1
  %mul859 = mul nsw i32 %add858, %add858
  %mul860 = mul nsw i32 %mul859, %add858
  %add861 = add nsw i32 %mul860, 1
  %mul862 = mul nsw i32 %add861, %add861
  %mul863 = mul nsw i32 %mul862, %add861
  %add864 = add nsw i32 %mul863, 1
  %mul865 = mul nsw i32 %add864, %add864
  %mul866 = mul nsw i32 %mul865, %add864
  %add867 = add nsw i32 %mul866, 1
  %mul868 = mul nsw i32 %add867, %add867
  %mul869 = mul nsw i32 %mul868, %add867
  %add870 = add nsw i32 %mul869, 1
  %mul871 = mul nsw i32 %add870, %add870
  %mul872 = mul nsw i32 %mul871, %add870
  %add873 = add nsw i32 %mul872, 1
  %mul874 = mul nsw i32 %add873, %add873
  %mul875 = mul nsw i32 %mul874, %add873
  %add876 = add nsw i32 %mul875, 1
  %mul877 = mul nsw i32 %add876, %add876
  %mul878 = mul nsw i32 %mul877, %add876
  %add879 = add nsw i32 %mul878, 1
  %mul880 = mul nsw i32 %add879, %add879
  %mul881 = mul nsw i32 %mul880, %add879
  %add882 = add nsw i32 %mul881, 1
  %mul883 = mul nsw i32 %add882, %add882
  %mul884 = mul nsw i32 %mul883, %add882
  %add885 = add nsw i32 %mul884, 1
  %mul886 = mul nsw i32 %add885, %add885
  %mul887 = mul nsw i32 %mul886, %add885
  %add888 = add nsw i32 %mul887, 1
  %mul889 = mul nsw i32 %add888, %add888
  %mul890 = mul nsw i32 %mul889, %add888
  %add891 = add nsw i32 %mul890, 1
  %mul892 = mul nsw i32 %add891, %add891
  %mul893 = mul nsw i32 %mul892, %add891
  %add894 = add nsw i32 %mul893, 1
  %mul895 = mul nsw i32 %add894, %add894
  %mul896 = mul nsw i32 %mul895, %add894
  %add897 = add nsw i32 %mul896, 1
  %mul898 = mul nsw i32 %add897, %add897
  %mul899 = mul nsw i32 %mul898, %add897
  %add900 = add nsw i32 %mul899, 1
  %mul901 = mul nsw i32 %add900, %add900
  %mul902 = mul nsw i32 %mul901, %add900
  %add903 = add nsw i32 %mul902, 1
  %mul904 = mul nsw i32 %add903, %add903
  %mul905 = mul nsw i32 %mul904, %add903
  %add906 = add nsw i32 %mul905, 1
  %mul907 = mul nsw i32 %add906, %add906
  %mul908 = mul nsw i32 %mul907, %add906
  %add909 = add nsw i32 %mul908, 1
  %mul910 = mul nsw i32 %add909, %add909
  %mul911 = mul nsw i32 %mul910, %add909
  %add912 = add nsw i32 %mul911, 1
  %mul991 = mul nsw i32 %add912, %add
  %mul992 = mul nsw i32 %mul991, %add
  %add993 = add nsw i32 %mul992, 1
  %mul994 = mul nsw i32 %add993, %add993
  %mul995 = mul nsw i32 %mul994, %add912
  %add996 = add nsw i32 %mul995, 1
  %mul997 = mul nsw i32 %add996, %add996
  %mul998 = mul nsw i32 %mul997, %add996
  %add999 = add nsw i32 %mul998, 1
  %mul1000 = mul nsw i32 %add999, %add999
  %mul1001 = mul nsw i32 %mul1000, %add999
  %add1002 = add nsw i32 %mul1001, 1
  %mul1003 = mul nsw i32 %add1002, %add1002
  %mul1004 = mul nsw i32 %mul1003, %add1002
  %add1005 = add nsw i32 %mul1004, 1
  %mul1006 = mul nsw i32 %add1005, %add1005
  %mul1007 = mul nsw i32 %mul1006, %add1005
  %add1008 = add nsw i32 %mul1007, 1
  %mul1009 = mul nsw i32 %add1008, %add1008
  %mul1010 = mul nsw i32 %mul1009, %add1008
  %add1011 = add nsw i32 %mul1010, 1
  %mul1012 = mul nsw i32 %add1011, %add1011
  %mul1013 = mul nsw i32 %mul1012, %add1011
  %add1014 = add nsw i32 %mul1013, 1
  %mul1015 = mul nsw i32 %add1014, %add1014
  %mul1016 = mul nsw i32 %mul1015, %add1014
  %add1017 = add nsw i32 %mul1016, 1
  %mul1018 = mul nsw i32 %add1017, %add1017
  %mul1019 = mul nsw i32 %mul1018, %add1017
  %add1020 = add nsw i32 %mul1019, 1
  %mul1021 = mul nsw i32 %add1020, %add1020
  %mul1022 = mul nsw i32 %mul1021, %add1020
  %add1023 = add nsw i32 %mul1022, 1
  %mul1024 = mul nsw i32 %add1023, %add1023
  %mul1025 = mul nsw i32 %mul1024, %add1023
  %add1026 = add nsw i32 %mul1025, 1
  %mul1027 = mul nsw i32 %add1026, %add1026
  %mul1028 = mul nsw i32 %mul1027, %add1026
  %add1029 = add nsw i32 %mul1028, 1
  %mul1030 = mul nsw i32 %add1029, %add1029
  %mul1031 = mul nsw i32 %mul1030, %add1029
  %add1032 = add nsw i32 %mul1031, 1
  %mul1033 = mul nsw i32 %add1032, %add1032
  %mul1034 = mul nsw i32 %mul1033, %add1032
  %add1035 = add nsw i32 %mul1034, 1
  %mul1036 = mul nsw i32 %add1035, %add1035
  %mul1037 = mul nsw i32 %mul1036, %add1035
  %add1038 = add nsw i32 %mul1037, 1
  %mul1039 = mul nsw i32 %add1038, %add1038
  %mul1040 = mul nsw i32 %mul1039, %add1038
  %add1041 = add nsw i32 %mul1040, 1
  %mul1042 = mul nsw i32 %add1041, %add1041
  %mul1043 = mul nsw i32 %mul1042, %add1041
  %add1044 = add nsw i32 %mul1043, 1
  %mul1045 = mul nsw i32 %add1044, %add1044
  %mul1046 = mul nsw i32 %mul1045, %add1044
  %add1047 = add nsw i32 %mul1046, 1
  %mul1048 = mul nsw i32 %add1047, %add1047
  %mul1049 = mul nsw i32 %mul1048, %add1047
  %add1050 = add nsw i32 %mul1049, 1
  %mul1051 = mul nsw i32 %add1050, %add1050
  %mul1052 = mul nsw i32 %mul1051, %add1050
  %add1053 = add nsw i32 %mul1052, 1
  %mul1054 = mul nsw i32 %add1053, %add1053
  %mul1055 = mul nsw i32 %mul1054, %add1053
  %add1056 = add nsw i32 %mul1055, 1
  %mul1057 = mul nsw i32 %add1056, %add1056
  %mul1058 = mul nsw i32 %mul1057, %add1056
  %add1059 = add nsw i32 %mul1058, 1
  %mul1060 = mul nsw i32 %add1059, %add1059
  %mul1061 = mul nsw i32 %mul1060, %add1059
  %add1062 = add nsw i32 %mul1061, 1
  %mul1063 = mul nsw i32 %add1062, %add1062
  %mul1064 = mul nsw i32 %mul1063, %add1062
  %add1065 = add nsw i32 %mul1064, 1
  %conv1066 = sext i32 %add1062 to i64
  %1 = inttoptr i64 %conv1066 to i64*
  %conv1067 = sext i32 %add1065 to i64
  %2 = inttoptr i64 %conv1067 to i64*
  %3 = ptrtoint i64* %2 to i64
  %sub = sub i64 %cnt, 1
  %call = call i64 @insert(i64* %1, i64 %3, i64 %sub)
  %conv1068 = sext i32 0 to i64
  %add1069 = add i64 %conv1068, %call
  %conv1070 = trunc i64 %add1069 to i32
  %conv1299 = sext i32 %conv1070 to i64
  br label %return

return:                                           ; preds = %if.end837, %if.then
;CHECK:    r1 = load 8 sp 400
;CHECK-NEXT:    ret r1
;CHECK-NEXT:    end insert
  %retval.0 = phi i64 [ 10, %if.then ], [ %conv1299, %if.end837 ]
  ret i64 %retval.0
}

; Function Attrs: argmemonly nounwind willreturn
declare void @llvm.lifetime.start.p0i8(i64 immarg, i8* nocapture) #1

; Function Attrs: argmemonly nounwind willreturn
declare void @llvm.lifetime.end.p0i8(i64 immarg, i8* nocapture) #1

; Function Attrs: nounwind ssp uwtable
define i32 @main() #0 {
entry:
  br label %for.cond

for.cond:                                         ; preds = %for.inc, %entry
  %result.0 = phi i64 [ 0, %entry ], [ %add, %for.inc ]
  %i.0 = phi i64 [ 0, %entry ], [ %inc, %for.inc ]
  %cmp = icmp ult i64 %i.0, 1000
  br i1 %cmp, label %for.body, label %for.cond.cleanup

for.cond.cleanup:                                 ; preds = %for.cond
  br label %for.end

for.body:                                         ; preds = %for.cond
  %call = call i64 @insert(i64* null, i64 0, i64 4)
  %add = add i64 %result.0, %call
  br label %for.inc

for.inc:                                          ; preds = %for.body
  %inc = add i64 %i.0, 1
  br label %for.cond

for.end:                                          ; preds = %for.cond.cleanup
  call void @write(i64 %result.0)
  ret i32 0
}


declare void @write(i64) #2

attributes #0 = { nounwind ssp uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="penryn" "target-features"="+cx16,+cx8,+fxsr,+mmx,+sahf,+sse,+sse2,+sse3,+sse4.1,+ssse3,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { argmemonly nounwind willreturn }
attributes #2 = { "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="penryn" "target-features"="+cx16,+cx8,+fxsr,+mmx,+sahf,+sse,+sse2,+sse3,+sse4.1,+ssse3,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }

!llvm.module.flags = !{!0, !1, !2}
!llvm.ident = !{!3}

!0 = !{i32 2, !"SDK Version", [2 x i32] [i32 10, i32 14]}
!1 = !{i32 1, !"wchar_size", i32 4}
!2 = !{i32 7, !"PIC Level", i32 2}
!3 = !{!"clang version 10.0.1 (https://github.com/llvm/llvm-project 92d5c1be9ee93850c0a8903f05f36a23ee835dc2)"}
