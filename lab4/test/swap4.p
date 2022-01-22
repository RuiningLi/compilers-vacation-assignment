var a, b: array 10 of integer;

proc swap(i: integer);
    var x: integer;
begin
    x := a[a[i]];
    a[a[i]] := b[b[i]];
    b[b[i]] := x
end;

begin
    swap(3)
end.

(*<<
>>*)

(*[[
@ picoPascal compiler output
	.include "fixup.s"
	.global pmain

@ proc swap(i: integer);
	.text
_swap:
	mov ip, sp
	stmfd sp!, {r0-r1}
	stmfd sp!, {r4-r10, fp, ip, lr}
	mov fp, sp
@     x := a[a[i]];
	set r5, _a
	ldr r0, [fp, #40]
	lsl r6, r0, #2
	ldr r0, [r5, r6]
	add r5, r5, r0, LSL #2
	ldr r4, [r5]
@     a[a[i]] := b[b[i]];
	set r7, _b
	add r6, r7, r6
	ldr r0, [r6]
	ldr r0, [r7, r0, LSL #2]
	str r0, [r5]
@     b[b[i]] := x
	ldr r0, [r6]
	str r4, [r7, r0, LSL #2]
	ldmfd fp, {r4-r10, fp, sp, pc}
	.ltorg

pmain:
	mov ip, sp
	stmfd sp!, {r4-r10, fp, ip, lr}
	mov fp, sp
@     swap(3)
	mov r0, #3
	bl _swap
	ldmfd fp, {r4-r10, fp, sp, pc}
	.ltorg

	.comm _a, 40, 4
	.comm _b, 40, 4
@ End
]]*)
