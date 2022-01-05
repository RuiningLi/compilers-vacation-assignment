var b: boolean;
var i: integer;
var j: integer;

begin
    i:=0;
    b:= valof j := valof resultis 2021 end;
              while true do
                  if i > j then resultis (i <= j) else i:= valof resultis i+1 end end
              end
        end;
    (* At this point i=2022 and b=false. *)

    print_num(valof i:= valof resultis i-1 end; if (i=j) and not b then resultis i+1 end end);
    newline(); print_num(i); newline()
    (* The program should print 2022 and 2021. *)

end.

(*<<
2022
2021
>>*)

(*[[
MODULE Main 0 0
IMPORT Lib 0
ENDHDR

PROC MAIN 0 0 0
!     i:=0;
CONST 0
STGW _i
!     b:= valof j := valof resultis 2021 end;
CONST 2021
STGW _j
LABEL L4
!                   if i > j then resultis (i <= j) else i:= valof resultis i+1 end end
LDGW _i
LDGW _j
JLEQ L8
LDGW _i
LDGW _j
LEQ
JUMP L2
LABEL L8
LDGW _i
CONST 1
PLUS
STGW _i
JUMP L4
LABEL L2
STGC _b
!     print_num(valof i:= valof resultis i-1 end; if (i=j) and not b then resultis i+1 end end);
LDGW _i
CONST 1
MINUS
STGW _i
LDGW _i
LDGW _j
JNEQ L15
LDGC _b
JNEQZ L15
LDGW _i
CONST 1
PLUS
JUMP L11
LABEL L15
CONST 0
LABEL L11
CONST 0
GLOBAL lib.print_num
PCALL 1
!     newline(); print_num(i); newline()
CONST 0
GLOBAL lib.newline
PCALL 0
LDGW _i
CONST 0
GLOBAL lib.print_num
PCALL 1
CONST 0
GLOBAL lib.newline
PCALL 0
RETURN
END

GLOVAR _b 1
GLOVAR _i 4
GLOVAR _j 4
! End
]]*)