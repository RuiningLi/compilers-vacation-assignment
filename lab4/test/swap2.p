var a, b: array 10 of integer;

proc swap(i: integer);
    var x: integer;
begin
    x := a[i];
    a[i] := b[i];
    b[i] := x
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
@     x := a[i];
	ldr r0, [fp, #40]
	lsl r5, r0, #2
	set r0, _a
	add r6, r0, r5
	ldr r4, [r6]
@     a[i] := b[i];
	set r0, _b
	add r5, r0, r5
	ldr r0, [r5]
	str r0, [r6]
@     b[i] := x
	str r4, [r5]
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
