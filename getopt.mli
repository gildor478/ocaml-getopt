(* Module [Getopt]: parsing of command line arguments *)

(*
Copyright (C) 2000 Alain Frisch     
email: Alain.Frisch@ens.fr
web:   http://www.eleves.ens.fr:8080/home/frisch

   This library is free software; you can redistribute it and/or
   modify it under the terms of the GNU Lesser General Public
   License as published by the Free Software Foundation; either
   version 2 of the License, or (at your option) any later version.

   This library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   Lesser General Public License for more details.
*)

(* This module provides a general mechanism for extracting options and
   arguments from the command line to the program. It is an alternative
   to the module Arg from the standard OCaml distribution.

   The syntax is close to GNU getopt and getop_long (man 3 getopt).


   * Layout of the command line:
   There are two types of argument on the command line: options and
   anonymous arguments. Options may have two forms: a short one introduced 
   by a single dash character (-) and a long one introduced by a double
   dash (--).

   Options may have an argument attached. For the long form, the syntax
   is "--option=argument". For the short form, there are two possible syntaxes:
   "-o argument" (argument doesn't start with a dash) and "-oargument"

   Short options that refuse arguments may be concatenated, as in
   "-opq".

   The special argument -- interrupts the parsing of options: all the
   remaining arguments are arguments even they start with a dash.


   * Command line specification:
   A specification lists the possible options and describe what to do
   when they are found; it also gives the action for anonymous arguments
   and for the special option - (a single dash alone).
   
   The specification for a single option is a 5-uple
   (short_form, long_form, action, handler)
   where:

   - short_form is a character corresponding to the short form of the option
     (or noshort='\000' if the option does not jave a short form)

   - long_form is a string giving the long form of the option
     (or nolong = "" if no long form)

   - (action : (unit -> unit) option) gives the action to be executed
     when the option is found without an argument

   - (handler : (string -> unit) option) specifies how to handle the
     argument when option is found with the argument


   According to the couple (action, handler), the corresponding option
   may, must or mustn't have an argument :

   (Some _, Some _) : the option may have an argument; the short form can't be
     concatenated with other options (even if the user does not want to provide
     an argument). The behaviour (handler/action) is determined by the 
     presence of the argument.

   (Some _, None) : the option must not have an argument; the short form, if
     it exists, may be concatenated

   (None, Some _) : the option must have an argument; the short form can't
     be concatenated

   (None, None) : not allowed (but not tested)

*)


(* for parsing errors (unknown options, unexpected argument, ...) *)
exception Error of string

val noshort : char
val nolong  : string

type opt = 
    char * string *                (* short and long form (without leading -) *)
    ((unit -> unit) option) *      (* action when no argument *)
    ((string -> unit) option)      (* handling of the argument *)
(* the concrete type describing an option *)

val parse : opt list -> (string -> unit) -> string array -> int -> int -> unit
(*
    [parse opts others args first last] parse the arguments from
    [args.(first)] .. [args.(last)];
    [others] is called on anonymous arguments (and the special - argument);
    [opts] is a list of option specification (there must be no ambiguities)
*)

val parse_cmdline : opt list -> (string -> unit) -> unit
(*
    parse the command line using [parse]
*)


(* Useful actions and handlers *)

val set : 'a ref -> 'a -> ((unit -> unit) option)
(* returns an action that gives a reference a given value *)

val incr : int ref -> ((unit -> unit) option)
(* returns an action that increment an int reference *)

val append : string list ref -> ((string -> unit) option)
(* returns an handler appending the argument at the end of a string list
   reference *)

val atmost_once : string ref -> exn -> ((string -> unit) option)
(* returns an handler that stores the argument in a string reference if
   it is empty, raises an exception otherwise *)


