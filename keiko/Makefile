# keiko/Makefile

all: pplink ppx sanity

# Config stuff
AR = ar
RANLIB = ranlib
CFLAGS = -g -O2 -Wall
GC_PAGESIZE = 4096
TCLSH = tclsh
# End

include config.mk

xmain-t.o oblink.o: CFLAGS += -DREVID=\"labkit\"

%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@


### LINKER

PPLINK = oblink.o linker.o symtab.o template.o util.o
pplink: $(PPLINK)
	$(CC) $(CFLAGS) $^ -o $@

$(PPLINK): %.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@


### BYTECODE INTERPRETER

# We just build the tracing version

COMMON = interp-t.o xmain-t.o trace.o support.o loader.o dynlink.o \
	stubs.o lib.o

ppx: $(COMMON) gc-t.o
	$(CC) $(CFLAGS) $^ -ldl -rdynamic -o $@

$(COMMON) gc-t.o: CFLAGS += $(HOST_DEFINES) -fno-strict-aliasing

%-t.o: %.c
	$(CC) $(CFLAGS) -DTRACE -c $< -o $@

interp-t.o: action.c

stubs.c: lib.k pplink
	./pplink -nostdlib -C lib.k -o /dev/null >$@


### GENERATED FILES

# Include the following rules only if keiko.iset present
KFILE := $(wildcard keiko.iset)

ifdef KFILE

GEN = keiko.h template.c action.c jitrules.c

keiko.h: keiko.iset iset.tcl util.tcl iparse.tcl config.tcl
	$(TCLSH) iset.tcl keiko.iset $(GEN)

template.c action.c jitrules.c: keiko.h
	touch $@

realclean: clean
	rm -f $(GEN)

endif


### SANITY

sanity: force
	./pplink -nostdlib lib.k fac.k -o fac.x
	./ppx fac.x
	./pplink -nostdlib lib.k ptr.k -o ptr.x
	./ppx ptr.x
	./pplink -nostdlib lib.k ptr2.k -o ptr2.x
	./ppx ptr2.x


### CLEANUP

clean: force
	rm -f pplink ppx *.o stubs.c fac.x ptr.x ptr2.x

force:


### DEPENDENCIES

$(PPLINK): oblink.h obcommon.h exec.h config.h util.h keiko.h
$(COMMON) gc.o: obx.h obcommon.h exec.h config.h keiko.h
stubs.o: primtab.h
