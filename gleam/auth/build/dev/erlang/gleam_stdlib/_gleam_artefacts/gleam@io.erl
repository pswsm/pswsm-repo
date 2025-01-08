-module(gleam@io).
-compile([no_auto_import, nowarn_unused_vars, nowarn_unused_function, nowarn_nomatch]).

-export([print/1, print_error/1, println/1, println_error/1, debug/1]).

-file("/home/pswsm/code/pswsm-repo/gleam/auth/build/packages/gleam_stdlib/src/gleam/io.gleam", 17).
-spec print(binary()) -> nil.
print(String) ->
    gleam_stdlib:print(String).

-file("/home/pswsm/code/pswsm-repo/gleam/auth/build/packages/gleam_stdlib/src/gleam/io.gleam", 33).
-spec print_error(binary()) -> nil.
print_error(String) ->
    gleam_stdlib:print_error(String).

-file("/home/pswsm/code/pswsm-repo/gleam/auth/build/packages/gleam_stdlib/src/gleam/io.gleam", 47).
-spec println(binary()) -> nil.
println(String) ->
    gleam_stdlib:println(String).

-file("/home/pswsm/code/pswsm-repo/gleam/auth/build/packages/gleam_stdlib/src/gleam/io.gleam", 61).
-spec println_error(binary()) -> nil.
println_error(String) ->
    gleam_stdlib:println_error(String).

-file("/home/pswsm/code/pswsm-repo/gleam/auth/build/packages/gleam_stdlib/src/gleam/io.gleam", 96).
-spec debug(EFX) -> EFX.
debug(Term) ->
    _pipe = Term,
    _pipe@1 = gleam@string:inspect(_pipe),
    gleam_stdlib:println_error(_pipe@1),
    Term.
