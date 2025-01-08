-module(gleam@pair).
-compile([no_auto_import, nowarn_unused_vars, nowarn_unused_function, nowarn_nomatch]).

-export([first/1, second/1, swap/1, map_first/2, map_second/2, new/2]).

-file("/home/pswsm/code/pswsm-repo/gleam/auth/build/packages/gleam_stdlib/src/gleam/pair.gleam", 10).
-spec first({XR, any()}) -> XR.
first(Pair) ->
    {A, _} = Pair,
    A.

-file("/home/pswsm/code/pswsm-repo/gleam/auth/build/packages/gleam_stdlib/src/gleam/pair.gleam", 24).
-spec second({any(), XU}) -> XU.
second(Pair) ->
    {_, A} = Pair,
    A.

-file("/home/pswsm/code/pswsm-repo/gleam/auth/build/packages/gleam_stdlib/src/gleam/pair.gleam", 38).
-spec swap({XV, XW}) -> {XW, XV}.
swap(Pair) ->
    {A, B} = Pair,
    {B, A}.

-file("/home/pswsm/code/pswsm-repo/gleam/auth/build/packages/gleam_stdlib/src/gleam/pair.gleam", 53).
-spec map_first({XX, XY}, fun((XX) -> XZ)) -> {XZ, XY}.
map_first(Pair, Fun) ->
    {A, B} = Pair,
    {Fun(A), B}.

-file("/home/pswsm/code/pswsm-repo/gleam/auth/build/packages/gleam_stdlib/src/gleam/pair.gleam", 68).
-spec map_second({YA, YB}, fun((YB) -> YC)) -> {YA, YC}.
map_second(Pair, Fun) ->
    {A, B} = Pair,
    {A, Fun(B)}.

-file("/home/pswsm/code/pswsm-repo/gleam/auth/build/packages/gleam_stdlib/src/gleam/pair.gleam", 83).
-spec new(YD, YE) -> {YD, YE}.
new(First, Second) ->
    {First, Second}.
