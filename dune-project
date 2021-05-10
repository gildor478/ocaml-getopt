(lang dune 2.0)
(name getopt)

(version 20210510)

(generate_opam_files true)

(source (github gildor478/ocaml-getopt))
(license MIT)
(authors "Sylvain Le Gall" "pveber")
(maintainers "Alain.Frisch@ens.fr")

(package
 (name getopt)
 (synopsis "Command line parsing à la GNU getopt")
 (description "Parsing of command line arguments (similar to GNU GetOpt) for OCaml")
 (depends
  (dune (> 2.0))
  stdlib-shims))
