var i: integer;

begin
    i:= 1;
    while valof end do i := i+1 end;
    print_num(i); newline()
end.

(*<<
1
>>*)

(*[[
MODULE Main 0 0
IMPORT Lib 0
ENDHDR

PROC MAIN 0 0 0
!     i:= 1;
CONST 1
STGW _i
!     while valof end do i := i+1 end;
JUMP L3
LABEL L2
LDGW _i
CONST 1
PLUS
STGW _i
LABEL L3
CONST 0
JNEQZ L2
!     print_num(i); newline()
LDGW _i
CONST 0
GLOBAL lib.print_num
PCALL 1
CONST 0
GLOBAL lib.newline
PCALL 0
RETURN
END

GLOVAR _i 4
! End
]]*)