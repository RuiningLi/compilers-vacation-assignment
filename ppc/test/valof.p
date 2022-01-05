var b: boolean;
var i: integer;

begin
    i:=0;
    b:= valof while true do
                  if i > 2021 then resultis (i <= 2021) else i:=i+1 end
              end
        end;
    (* At this point i=2022 and b=false. *)

    print_num(valof i:=i-1; if (i=2021) and not b then resultis i+1 end end);
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
LABEL L3
!                   if i > 2021 then resultis (i <= 2021) else i:=i+1 end
LDGW _i
CONST 2021
JLEQ L7
LDGW _i
CONST 2021
LEQ
JUMP L2
LABEL L7
LDGW _i
CONST 1
PLUS
STGW _i
JUMP L3
LABEL L2
STGC _b
!     print_num(valof i:=i-1; if (i=2021) and not b then resultis i+1 end end);
LDGW _i
CONST 1
MINUS
STGW _i
LDGW _i
CONST 2021
JNEQ L12
LDGC _b
JNEQZ L12
LDGW _i
CONST 1
PLUS
JUMP L9
LABEL L12
CONST 0
LABEL L9
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
! End
]]*)