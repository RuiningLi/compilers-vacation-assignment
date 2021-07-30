all: common.cma

LIB = print.cmo source.cmo growvect.cmo

# Get OCaml version in the form 402 for ocaml 4.02.1 etc.
VER := $(shell ocamlc -v | sed -n '1s/.*\([0-9]\)\.\([0-9][0-9]\).*/\1\2/p')

# Define NEEDBYTES unless version >= 4.02
NEEDBYTES := $(shell test $(VER) -ge 402 || echo 1)

ifdef NEEDBYTES
    LIB += bytes.cmo
endif

common.cma: $(LIB)
	ocamlc -a $^ -o $@ 

%.cmi: %.mli
	ocamlc -c $< -o $@

%.cmo: %.ml
	ocamlc -c $< -o $@

clean: force
	rm -f *.cmi *.cmo common.cma

force:

###

print.cmo: print.cmi
source.cmo: source.cmi
growvect.cmo: growvect.cmi
