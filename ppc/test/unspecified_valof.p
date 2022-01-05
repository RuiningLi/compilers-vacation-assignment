var i: integer;
var j: integer;

begin
    j:= 2;
    i:= valof 
            if (j = 1) then resultis 1 end;
        end;
    print_num(i); newline()

end.

(*<<
0
>>*)

(*[[
MODULE Main 0 0
IMPORT Lib 0
ENDHDR

PROC MAIN 0 0 0
!     j:= 2;
CONST 2
STGW _j
!             if (j = 1) then resultis 1 end;
LDGW _j
CONST 1
JNEQ L5
CONST 1
JUMP L2
LABEL L5
!         end;
CONST 0
LABEL L2
STGW _i
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
GLOVAR _j 4
! End
]]*)