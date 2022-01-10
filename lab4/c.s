@ picoPascal compiler output
	.include "fixup.s"
	.global pmain

@ proc swap(i: integer);
@ Initial code:
@     x := a[i];
@ <STOREW,
@   <LOADW,
@     <OFFSET,
@       <GLOBAL _a>,
@       <TIMES, <LOADW, <OFFSET, <LOCAL 0>, <CONST 40>>>, <CONST 4>>>>,
@   <REGVAR 0>>
@     a[i] := b[i];
@ <STOREW,
@   <LOADW,
@     <OFFSET,
@       <GLOBAL _b>,
@       <TIMES, <LOADW, <OFFSET, <LOCAL 0>, <CONST 40>>>, <CONST 4>>>>,
@   <OFFSET,
@     <GLOBAL _a>,
@     <TIMES, <LOADW, <OFFSET, <LOCAL 0>, <CONST 40>>>, <CONST 4>>>>
@     b[i] := x
@ <STOREW,
@   <LOADW, <REGVAR 0>>,
@   <OFFSET,
@     <GLOBAL _b>,
@     <TIMES, <LOADW, <OFFSET, <LOCAL 0>, <CONST 40>>>, <CONST 4>>>>
@ <LABEL L1>

@ After simplification:
@     x := a[i];
@ <STOREW,
@   <LOADW, <OFFSET, <GLOBAL _a>, <LSL, <LOADW, <LOCAL 40>>, <CONST 2>>>>,
@   <REGVAR 0>>
@     a[i] := b[i];
@ <STOREW,
@   <LOADW, <OFFSET, <GLOBAL _b>, <LSL, <LOADW, <LOCAL 40>>, <CONST 2>>>>,
@   <OFFSET, <GLOBAL _a>, <LSL, <LOADW, <LOCAL 40>>, <CONST 2>>>>
@     b[i] := x
@ <STOREW,
@   <LOADW, <REGVAR 0>>,
@   <OFFSET, <GLOBAL _b>, <LSL, <LOADW, <LOCAL 40>>, <CONST 2>>>>

@ After sharing:
@     x := a[i];
@ <DEFTEMP 1, <GLOBAL _a>>
@ <DEFTEMP 2, <LOADW, <LOCAL 40>>>
@ <STOREW,
@   <LOADW, <OFFSET, <TEMP 1>, <LSL, <TEMP 2>, <CONST 2>>>>,
@   <REGVAR 0>>
@     a[i] := b[i];
@ <DEFTEMP 3, <GLOBAL _b>>
@ <STOREW,
@   <LOADW, <OFFSET, <TEMP 3>, <LSL, <TEMP 2>, <CONST 2>>>>,
@   <OFFSET, <TEMP 1>, <LSL, <TEMP 2>, <CONST 2>>>>
@     b[i] := x
@ <STOREW,
@   <LOADW, <REGVAR 0>>,
@   <OFFSET, <TEMP 3>, <LSL, <TEMP 2>, <CONST 2>>>>

	.text
_swap:
	mov ip, sp
	stmfd sp!, {r0-r1}
	stmfd sp!, {r4-r10, fp, ip, lr}
	mov fp, sp
@     x := a[i];
@ <DEFTEMP 1, <GLOBAL _a>>
	set r5, _a
@ <DEFTEMP 2, <LOADW, <LOCAL 40>>>
	ldr r6, [fp, #40]
@ <STOREW,
@   <LOADW, <OFFSET, <TEMP 1>, <LSL, <TEMP 2>, <CONST 2>>>>,
@   <REGVAR 0>>
	ldr r4, [r5, r6, LSL #2]
@     a[i] := b[i];
@ <DEFTEMP 3, <GLOBAL _b>>
	set r7, _b
@ <STOREW,
@   <LOADW, <OFFSET, <TEMP 3>, <LSL, <TEMP 2>, <CONST 2>>>>,
@   <OFFSET, <TEMP 1>, <LSL, <TEMP 2>, <CONST 2>>>>
	ldr r0, [r7, r6, LSL #2]
	str r0, [r5, r6, LSL #2]
@     b[i] := x
@ <STOREW,
@   <LOADW, <REGVAR 0>>,
@   <OFFSET, <TEMP 3>, <LSL, <TEMP 2>, <CONST 2>>>>
	str r4, [r7, r6, LSL #2]
	ldmfd fp, {r4-r10, fp, sp, pc}
	.ltorg

@ Initial code:
@     swap(3)
@ <CALL 1, <GLOBAL _swap>, <STATLINK, <CONST 0>>, <ARG 0, <CONST 3>>>
@ <LABEL L2>

@ After simplification:
@     swap(3)
@ <CALL 1, <GLOBAL _swap>, <ARG 0, <CONST 3>>>

@ After sharing:
@     swap(3)
@ <CALL 1, <GLOBAL _swap>, <ARG 0, <CONST 3>>>

pmain:
	mov ip, sp
	stmfd sp!, {r4-r10, fp, ip, lr}
	mov fp, sp
@     swap(3)
@ <ARG 0, <CONST 3>>
	mov r0, #3
@ <CALL 1, <GLOBAL _swap>>
	bl _swap
	ldmfd fp, {r4-r10, fp, sp, pc}
	.ltorg

	.comm _a, 40, 4
	.comm _b, 40, 4
@ End
