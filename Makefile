all: getopt.cmi getopt.cmx sample

getopt.cmo: getopt.cmi getopt.ml
	ocamlc -c getopt.ml

getopt.cmi: getopt.mli
	ocamlc -c getopt.mli

getopt.cmx: getopt.cmi getopt.ml
	ocamlopt -c getopt.ml

sample.cmo: getopt.cmi sample.ml
	ocamlc -c sample.ml

sample: getopt.cmo sample.cmo
	ocamlc -o sample unix.cma getopt.cmo sample.cmo

install: getopt.cmi getopt.cmo getopt.cmx
	ocamlfind install getopt META getopt.cmi getopt.cmo getopt.cmx getopt.o

clean:
	rm -f *.cm[iox] *.o sample *~
