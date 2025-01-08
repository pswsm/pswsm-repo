-module(gleam@function).
-compile([no_auto_import, nowarn_unused_vars, nowarn_unused_function, nowarn_nomatch]).

-export([flip/1, identity/1, tap/2]).

-file("/home/pswsm/code/pswsm-repo/gleam/auth/build/packages/gleam_stdlib/src/gleam/function.gleam", 4).
-spec flip(fun((EFO, EFP) -> EFQ)) -> fun((EFP, EFO) -> EFQ).
flip(Fun) ->
    fun(B, A) -> Fun(A, B) end.

-file("/home/pswsm/code/pswsm-repo/gleam/auth/build/packages/gleam_stdlib/src/gleam/function.gleam", 10).
-spec identity(EFR) -> EFR.
identity(X) ->
    X.

-file("/home/pswsm/code/pswsm-repo/gleam/auth/build/packages/gleam_stdlib/src/gleam/function.gleam", 19).
-spec tap(EFS, fun((EFS) -> any())) -> EFS.
tap(Arg, Effect) ->
    Effect(Arg),
    Arg.
