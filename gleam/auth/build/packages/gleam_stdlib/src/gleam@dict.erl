-module(gleam@dict).
-compile([no_auto_import, nowarn_unused_vars, nowarn_unused_function, nowarn_nomatch]).

-export([size/1, to_list/1, new/0, is_empty/1, get/2, has_key/2, insert/3, from_list/1, keys/1, values/1, take/2, merge/2, delete/2, drop/2, upsert/3, fold/3, map_values/2, filter/2, each/2, combine/3]).
-export_type([dict/2]).

-type dict(KR, KS) :: any() | {gleam_phantom, KR, KS}.

-file("/Users/louis/src/gleam/stdlib/src/gleam/dict.gleam", 36).
-spec size(dict(any(), any())) -> integer().
size(Dict) ->
    maps:size(Dict).

-file("/Users/louis/src/gleam/stdlib/src/gleam/dict.gleam", 80).
-spec to_list(dict(LB, LC)) -> list({LB, LC}).
to_list(Dict) ->
    maps:to_list(Dict).

-file("/Users/louis/src/gleam/stdlib/src/gleam/dict.gleam", 129).
-spec new() -> dict(any(), any()).
new() ->
    maps:new().

-file("/Users/louis/src/gleam/stdlib/src/gleam/dict.gleam", 52).
-spec is_empty(dict(any(), any())) -> boolean().
is_empty(Dict) ->
    Dict =:= maps:new().

-file("/Users/louis/src/gleam/stdlib/src/gleam/dict.gleam", 150).
-spec get(dict(ME, MF), ME) -> {ok, MF} | {error, nil}.
get(From, Get) ->
    gleam_stdlib:map_get(From, Get).

-file("/Users/louis/src/gleam/stdlib/src/gleam/dict.gleam", 116).
-spec has_key(dict(LS, any()), LS) -> boolean().
has_key(Dict, Key) ->
    maps:is_key(Key, Dict).

-file("/Users/louis/src/gleam/stdlib/src/gleam/dict.gleam", 169).
-spec insert(dict(MK, ML), MK, ML) -> dict(MK, ML).
insert(Dict, Key, Value) ->
    maps:put(Key, Value, Dict).

-file("/Users/louis/src/gleam/stdlib/src/gleam/dict.gleam", 92).
-spec from_list_loop(list({LL, LM}), dict(LL, LM)) -> dict(LL, LM).
from_list_loop(List, Initial) ->
    case List of
        [] ->
            Initial;

        [X | Rest] ->
            from_list_loop(
                Rest,
                insert(Initial, erlang:element(1, X), erlang:element(2, X))
            )
    end.

-file("/Users/louis/src/gleam/stdlib/src/gleam/dict.gleam", 88).
-spec from_list(list({LG, LH})) -> dict(LG, LH).
from_list(List) ->
    maps:from_list(List).

-file("/Users/louis/src/gleam/stdlib/src/gleam/dict.gleam", 217).
-spec reverse_and_concat(list(NP), list(NP)) -> list(NP).
reverse_and_concat(Remaining, Accumulator) ->
    case Remaining of
        [] ->
            Accumulator;

        [Item | Rest] ->
            reverse_and_concat(Rest, [Item | Accumulator])
    end.

-file("/Users/louis/src/gleam/stdlib/src/gleam/dict.gleam", 224).
-spec do_keys_loop(list({NT, any()}), list(NT)) -> list(NT).
do_keys_loop(List, Acc) ->
    case List of
        [] ->
            reverse_and_concat(Acc, []);

        [First | Rest] ->
            do_keys_loop(Rest, [erlang:element(1, First) | Acc])
    end.

-file("/Users/louis/src/gleam/stdlib/src/gleam/dict.gleam", 212).
-spec keys(dict(NK, any())) -> list(NK).
keys(Dict) ->
    maps:keys(Dict).

-file("/Users/louis/src/gleam/stdlib/src/gleam/dict.gleam", 250).
-spec do_values_loop(list({any(), OE}), list(OE)) -> list(OE).
do_values_loop(List, Acc) ->
    case List of
        [] ->
            reverse_and_concat(Acc, []);

        [First | Rest] ->
            do_values_loop(Rest, [erlang:element(2, First) | Acc])
    end.

-file("/Users/louis/src/gleam/stdlib/src/gleam/dict.gleam", 245).
-spec values(dict(any(), NZ)) -> list(NZ).
values(Dict) ->
    maps:values(Dict).

-file("/Users/louis/src/gleam/stdlib/src/gleam/dict.gleam", 319).
-spec do_take_loop(dict(PI, PJ), list(PI), dict(PI, PJ)) -> dict(PI, PJ).
do_take_loop(Dict, Desired_keys, Acc) ->
    Insert = fun(Taken, Key) -> case gleam_stdlib:map_get(Dict, Key) of
            {ok, Value} ->
                insert(Taken, Key, Value);

            _ ->
                Taken
        end end,
    case Desired_keys of
        [] ->
            Acc;

        [First | Rest] ->
            do_take_loop(Dict, Rest, Insert(Acc, First))
    end.

-file("/Users/louis/src/gleam/stdlib/src/gleam/dict.gleam", 310).
-spec take(dict(OU, OV), list(OU)) -> dict(OU, OV).
take(Dict, Desired_keys) ->
    maps:with(Desired_keys, Dict).

-file("/Users/louis/src/gleam/stdlib/src/gleam/dict.gleam", 357).
-spec insert_pair(dict(PZ, QA), {PZ, QA}) -> dict(PZ, QA).
insert_pair(Dict, Pair) ->
    insert(Dict, erlang:element(1, Pair), erlang:element(2, Pair)).

-file("/Users/louis/src/gleam/stdlib/src/gleam/dict.gleam", 361).
-spec fold_inserts(list({QF, QG}), dict(QF, QG)) -> dict(QF, QG).
fold_inserts(New_entries, Dict) ->
    case New_entries of
        [] ->
            Dict;

        [First | Rest] ->
            fold_inserts(Rest, insert_pair(Dict, First))
    end.

-file("/Users/louis/src/gleam/stdlib/src/gleam/dict.gleam", 351).
-spec merge(dict(PR, PS), dict(PR, PS)) -> dict(PR, PS).
merge(Dict, New_entries) ->
    maps:merge(Dict, New_entries).

-file("/Users/louis/src/gleam/stdlib/src/gleam/dict.gleam", 383).
-spec delete(dict(QM, QN), QM) -> dict(QM, QN).
delete(Dict, Key) ->
    maps:remove(Key, Dict).

-file("/Users/louis/src/gleam/stdlib/src/gleam/dict.gleam", 411).
-spec drop(dict(QY, QZ), list(QY)) -> dict(QY, QZ).
drop(Dict, Disallowed_keys) ->
    case Disallowed_keys of
        [] ->
            Dict;

        [First | Rest] ->
            drop(delete(Dict, First), Rest)
    end.

-file("/Users/louis/src/gleam/stdlib/src/gleam/dict.gleam", 441).
-spec upsert(dict(RF, RG), RF, fun((gleam@option:option(RG)) -> RG)) -> dict(RF, RG).
upsert(Dict, Key, Fun) ->
    _pipe = Dict,
    _pipe@1 = gleam_stdlib:map_get(_pipe, Key),
    _pipe@2 = gleam@option:from_result(_pipe@1),
    _pipe@3 = Fun(_pipe@2),
    insert(Dict, Key, _pipe@3).

-file("/Users/louis/src/gleam/stdlib/src/gleam/dict.gleam", 486).
-spec fold_loop(list({RR, RS}), RU, fun((RU, RR, RS) -> RU)) -> RU.
fold_loop(List, Initial, Fun) ->
    case List of
        [] ->
            Initial;

        [{K, V} | Rest] ->
            fold_loop(Rest, Fun(Initial, K, V), Fun)
    end.

-file("/Users/louis/src/gleam/stdlib/src/gleam/dict.gleam", 478).
-spec fold(dict(RM, RN), RQ, fun((RQ, RM, RN) -> RQ)) -> RQ.
fold(Dict, Initial, Fun) ->
    fold_loop(maps:to_list(Dict), Initial, Fun).

-file("/Users/louis/src/gleam/stdlib/src/gleam/dict.gleam", 188).
-spec map_values(dict(MW, MX), fun((MW, MX) -> NA)) -> dict(MW, NA).
map_values(Dict, Fun) ->
    maps:map(Fun, Dict).

-file("/Users/louis/src/gleam/stdlib/src/gleam/dict.gleam", 274).
-spec filter(dict(OI, OJ), fun((OI, OJ) -> boolean())) -> dict(OI, OJ).
filter(Dict, Predicate) ->
    maps:filter(Predicate, Dict).

-file("/Users/louis/src/gleam/stdlib/src/gleam/dict.gleam", 519).
-spec each(dict(RV, RW), fun((RV, RW) -> any())) -> nil.
each(Dict, Fun) ->
    fold(
        Dict,
        nil,
        fun(Nil, K, V) ->
            Fun(K, V),
            Nil
        end
    ).

-file("/Users/louis/src/gleam/stdlib/src/gleam/dict.gleam", 540).
-spec combine(dict(SA, SB), dict(SA, SB), fun((SB, SB) -> SB)) -> dict(SA, SB).
combine(Dict, Other, Fun) ->
    fold(
        Dict,
        Other,
        fun(Acc, Key, Value) -> case gleam_stdlib:map_get(Acc, Key) of
                {ok, Other_value} ->
                    insert(Acc, Key, Fun(Value, Other_value));

                {error, _} ->
                    insert(Acc, Key, Value)
            end end
    ).
