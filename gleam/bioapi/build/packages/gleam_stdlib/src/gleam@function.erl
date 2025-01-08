-module(gleam@function).
-compile([no_auto_import, nowarn_unused_vars, nowarn_unused_function, nowarn_nomatch]).

-export([flip/1, identity/1, tap/2]).

-file("/Users/louis/src/gleam/stdlib/src/gleam/function.gleam", 4).
-spec flip(fun((EFO, EFP) -> EFQ)) -> fun((EFP, EFO) -> EFQ).
flip(Fun) ->
    fun(B, A) -> Fun(A, B) end.

-file("/Users/louis/src/gleam/stdlib/src/gleam/function.gleam", 10).
-spec identity(EFR) -> EFR.
identity(X) ->
    X.

-file("/Users/louis/src/gleam/stdlib/src/gleam/function.gleam", 19).
-spec tap(EFS, fun((EFS) -> any())) -> EFS.
tap(Arg, Effect) ->
    Effect(Arg),
    Arg.
