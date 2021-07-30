! Test program -- pointers with garbage collection
MODULE Main 0 0
IMPORT Lib 0
ENDHDR

! Bitmap for _build -- one local pointer variable
!! pppp pppp ppph hhhw wwww wwww wwww wwwb
!! 0000 0000 0000 0001 0000 0000 0000 0001

PROC _build 4 0 0x00010001
!   if n <= 1 then
LDLW 16
CONST 1
JGT L3
!     return nil
CONST 0
RETURNW
LABEL L3
!     new(t);
CONST 12
CONST desc
CONST 0
GLOBAL lib.newgc
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
STNW 4
!     t^.right := build(n-1);
LDLW 16
CONST 1
MINUS
CONST 0
GLOBAL _build
PCALLW 1
LDLW -4
STNW 8
!     return t
LDLW -4
RETURNW
END

!! print and count should have GC maps too, but omitting them
!! does no harm because they do no allocation

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
LDNW 4
CONST 0
GLOBAL _print
PCALL 1
!     print(t^.right);
LDLW 16
LDNW 8
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
LDNW 4
CONST 0
GLOBAL _count
PCALLW 1
LDLW 16
LDNW 8
CONST 0
GLOBAL _count
PCALLW 1
PLUS
RETURNW
END

PROC MAIN 0 0 0
!!! Make the GC collect on each allocation and scribble on freed storage
!!! Ludicrously inefficient, but good for debugging
!   gc_debug("sz");
CONST g2
CONST 0
GLOBAL lib.gc_debug
PCALL 1
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

! String "sz"
DEFINE g2
STRING 737a00

! Descriptor for blobs
DEFINE desc
WORD 0x7

! Global GC map
DEFINE GCMAP
WORD GC_POINTER
WORD _p
WORD GC_END

! End
