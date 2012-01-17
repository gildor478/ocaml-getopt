all: getopt.cmo sample

getopt.cmo: getopt.cmi
	ocamlc -c getopt.ml

getopt.cmi: getopt.mli
	ocamlc -c getopt.mli

sample.cmo: getopt.cmi sample.ml
	ocamlc -c sample.ml

sample: getopt.cmo sample.cmo
	ocamlc -o sample unix.cma getopt.cmo sample.cmo

clean:
	rm *.cm[io] sample *~
