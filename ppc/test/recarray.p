var g: array 10 of record a: integer; b: char end;

begin
  g[1].a := 3;
  print_num(g[1].a); newline()
end.

(*<<
3
>>*)

(*[[
MODULE Main 0 0
IMPORT Lib 0
ENDHDR

PROC MAIN 0 0 0
!   g[1].a := 3;
CONST 3
GLOBAL _g
STNW 8
!   print_num(g[1].a); newline()
GLOBAL _g
LDNW 8
CONST 0
GLOBAL lib.print_num
PCALL 1
CONST 0
GLOBAL lib.newline
PCALL 0
RETURN
END

GLOVAR _g 80
! End
]]*)
