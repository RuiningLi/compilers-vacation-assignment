
proc test();
  var x : integer;
  var y : integer;
begin
  x := 0;
  y := 0;
  x := x+1;
  y := x+1;
  print_num(y);
  newline();
end;

begin
  test()
end.

(*<<
2
>>*)

(*[[
@ picoPascal compiler output
	.include "fixup.s"
	.global pmain

@ proc test();
	.text
_test:
	mov ip, sp
	stmfd sp!, {r4-r10, fp, ip, lr}
	mov fp, sp
@   x := 0;
	mov r4, #0
@   y := 0;
	mov r5, #0
@   x := x+1;
	add r4, r4, #1
@   y := x+1;
	add r5, r4, #1
@   print_num(y);
	mov r0, r5
	bl print_num
@   newline();
	bl newline
	ldmfd fp, {r4-r10, fp, sp, pc}
	.ltorg

pmain:
	mov ip, sp
	stmfd sp!, {r4-r10, fp, ip, lr}
	mov fp, sp
@   test()
	bl _test
	ldmfd fp, {r4-r10, fp, sp, pc}
	.ltorg

@ End
]]*)
