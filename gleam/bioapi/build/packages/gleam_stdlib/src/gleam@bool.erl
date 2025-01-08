-module(gleam@bool).
-compile([no_auto_import, nowarn_unused_vars, nowarn_unused_function, nowarn_nomatch]).

-export(['and'/2, 'or'/2, negate/1, nor/2, nand/2, exclusive_or/2, exclusive_nor/2, to_string/1, guard/3, lazy_guard/3]).

-file("/Users/louis/src/gleam/stdlib/src/gleam/bool.gleam", 31).
-spec 'and'(boolean(), boolean()) -> boolean().
'and'(A, B) ->
    A andalso B.

-file("/Users/louis/src/gleam/stdlib/src/gleam/bool.gleam", 57).
-spec 'or'(boolean(), boolean()) -> boolean().
'or'(A, B) ->
    A orelse B.

-file("/Users/louis/src/gleam/stdlib/src/gleam/bool.gleam", 77).
-spec negate(boolean()) -> boolean().
negate(Bool) ->
    not Bool.

-file("/Users/louis/src/gleam/stdlib/src/gleam/bool.gleam", 105).
-spec nor(boolean(), boolean()) -> boolean().
nor(A, B) ->
    not (A orelse B).

-file("/Users/louis/src/gleam/stdlib/src/gleam/bool.gleam", 133).
-spec nand(boolean(), boolean()) -> boolean().
nand(A, B) ->
    not (A andalso B).

-file("/Users/louis/src/gleam/stdlib/src/gleam/bool.gleam", 161).
-spec exclusive_or(boolean(), boolean()) -> boolean().
exclusive_or(A, B) ->
    A /= B.

-file("/Users/louis/src/gleam/stdlib/src/gleam/bool.gleam", 189).
-spec exclusive_nor(boolean(), boolean()) -> boolean().
exclusive_nor(A, B) ->
    A =:= B.

-file("/Users/louis/src/gleam/stdlib/src/gleam/bool.gleam", 207).
-spec to_string(boolean()) -> binary().
to_string(Bool) ->
    case Bool of
        false ->
            <<"False"/utf8>>;

        true ->
            <<"True"/utf8>>
    end.

-file("/Users/louis/src/gleam/stdlib/src/gleam/bool.gleam", 266).
-spec guard(boolean(), BVU, fun(() -> BVU)) -> BVU.
guard(Requirement, Consequence, Alternative) ->
    case Requirement of
        true ->
            Consequence;

        false ->
            Alternative()
    end.

-file("/Users/louis/src/gleam/stdlib/src/gleam/bool.gleam", 307).
-spec lazy_guard(boolean(), fun(() -> BVV), fun(() -> BVV)) -> BVV.
lazy_guard(Requirement, Consequence, Alternative) ->
    case Requirement of
        true ->
            Consequence();

        false ->
            Alternative()
    end.
