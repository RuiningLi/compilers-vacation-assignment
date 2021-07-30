! Test program -- pointers without garbage collection
MODULE Main 0 0
IMPORT Lib 0
ENDHDR

PROC _build 4 0 0
!   if n <= 1 then
LDLW 16
CONST 1
JGT L3
!     return nil
CONST 0
RETURNW
LABEL L3
!     new(t);
CONST 8
CONST 0
GLOBAL lib.new
PCALLW 1
STLW -4
!     t^.left := build(n-2);
LDLW 16
CONST 2
MINUS
CONST 0
GLOBAL _build
PCALLW 1
LDLW -4
STOREW
!     t^.right := build(n-1);
LDLW 16
CONST 1
MINUS
CONST 0
GLOBAL _build
PCALLW 1
LDLW -4
STNW 4
!     return t
LDLW -4
RETURNW
END

PROC _print 0 0 0
!   if t = nil then
LDLW 16
JEQZ L5
JUMP L6
LABEL L5
!     print_char('.')
CONST 46
CONST 0
GLOBAL lib.print_char
PCALL 1
JUMP L7
LABEL L6
!     print_char('(');
CONST 40
CONST 0
GLOBAL lib.print_char
PCALL 1
!     print(t^.left);
LDLW 16
LOADW
CONST 0
GLOBAL _print
PCALL 1
!     print(t^.right);
LDLW 16
LDNW 4
CONST 0
GLOBAL _print
PCALL 1
!     print_char(')')
CONST 41
CONST 0
GLOBAL lib.print_char
PCALL 1
LABEL L7
RETURN
END

PROC _count 0 0 0
!   if t = nil then
LDLW 16
JEQZ L14
JUMP L15
LABEL L14
!     return 1
CONST 1
RETURNW
LABEL L15
!     return count(t^.left) + count(t^.right)
LDLW 16
LOADW
CONST 0
GLOBAL _count
PCALLW 1
LDLW 16
LDNW 4
CONST 0
GLOBAL _count
PCALLW 1
PLUS
RETURNW
END

PROC MAIN 0 0 0
!   p := build(7);
CONST 7
CONST 0
GLOBAL _build
PCALLW 1
STGW _p
!   print(p); newline();
LDGW _p
CONST 0
GLOBAL _print
PCALL 1
CONST 0
GLOBAL lib.newline
PCALL 0
!   print_string("Count = "); print_num(count(p)); newline()
CONST 8
GLOBAL g1
CONST 0
GLOBAL lib.print_string
PCALL 2
LDGW _p
CONST 0
GLOBAL _count
PCALLW 1
CONST 0
GLOBAL lib.print_num
PCALL 1
CONST 0
GLOBAL lib.newline
PCALL 0
RETURN
END

GLOVAR _p 4
! String "Count = "
DEFINE g1
STRING 436F756E74203D2000

! End
