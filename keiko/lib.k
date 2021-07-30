! keiko/lib.k

MODULE Lib 0 0
ENDHDR

! Primitives for labs 1--3
PROC lib.print 0 0 0
CONST 32
CONST 0
GLOBAL lib.print_char
PCALL 1
LDLW 16
CONST 0
GLOBAL lib.print_num
PCALL 1
RETURN
END

PROC lib.newline 0 0 0
CONST 10
CONST 0
GLOBAL lib.print_char
PCALL 1
RETURN
END

! Primitives for ppc
PRIMDEF lib.new =scratch_alloc P@I
PRIMDEF lib.open_in lib_open_in I@P
PRIMDEF lib.close_in lib_close_in V@
PRIMDEF lib.read_char lib_read_char V@P
PRIMDEF lib.print_num lib_print_num V@I
PRIMDEF lib.print_string lib_print_string V@P
PRIMDEF lib.print_char lib_print_char V@C
PRIMDEF lib.argc lib_argc I@
PRIMDEF lib.argv lib_argv V@IP
PRIMDEF lib.exit exit V@I
PRIMDEF lib.gc_alloc lib_gc_alloc *
PRIMDEF lib.gc_debug gc_debug V@P

! GC-based NEW -- call as newgc(desc, size)
PROC lib.newgc 0 0 0
LDLW 20
CONST 0
GLOBAL lib.gc_alloc
PCALLW 1
LDLW 16
DUP 1
STOREW
RETURNW
END
