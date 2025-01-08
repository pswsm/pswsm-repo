-module(gleam@list).
-compile([no_auto_import, nowarn_unused_vars, nowarn_unused_function, nowarn_nomatch]).

-export([length/1, reverse/1, is_empty/1, contains/2, first/1, rest/1, filter/2, filter_map/2, map/2, map2/3, index_map/2, try_map/2, drop/2, take/2, new/0, wrap/1, append/2, prepend/2, flatten/1, flat_map/2, fold/3, count/2, group/2, map_fold/3, fold_right/3, index_fold/3, try_fold/3, fold_until/3, find/2, find_map/2, all/2, any/2, zip/2, strict_zip/2, unzip/1, intersperse/2, unique/1, sort/2, range/2, repeat/2, split/2, split_while/2, key_find/2, key_filter/2, pop/2, pop_map/2, key_pop/2, key_set/3, each/2, try_each/2, partition/2, permutations/1, window/2, window_by_2/1, drop_while/2, take_while/2, chunk/2, sized_chunk/2, reduce/2, scan/3, last/1, combinations/2, combination_pairs/1, transpose/1, interleave/1, shuffle/1, max/2, sample/2]).
-export_type([continue_or_stop/1, sorting/0]).

-type continue_or_stop(YG) :: {continue, YG} | {stop, YG}.

-type sorting() :: ascending | descending.

-file("/Users/louis/src/gleam/stdlib/src/gleam/list.gleam", 61).
-spec length_loop(list(any()), integer()) -> integer().
length_loop(List, Count) ->
    case List of
        [_ | List@1] ->
            length_loop(List@1, Count + 1);

        _ ->
            Count
    end.

-file("/Users/louis/src/gleam/stdlib/src/gleam/list.gleam", 57).
-spec length(list(any())) -> integer().
length(List) ->
    erlang:length(List).

-file("/Users/louis/src/gleam/stdlib/src/gleam/list.gleam", 130).
-spec reverse_loop(list(YQ), list(YQ)) -> list(YQ).
reverse_loop(Remaining, Accumulator) ->
    case Remaining of
        [] ->
            Accumulator;

        [Item | Rest] ->
            reverse_loop(Rest, [Item | Accumulator])
    end.

-file("/Users/louis/src/gleam/stdlib/src/gleam/list.gleam", 126).
-spec reverse(list(YN)) -> list(YN).
reverse(List) ->
    lists:reverse(List).

-file("/Users/louis/src/gleam/stdlib/src/gleam/list.gleam", 158).
-spec is_empty(list(any())) -> boolean().
is_empty(List) ->
    List =:= [].

-file("/Users/louis/src/gleam/stdlib/src/gleam/list.gleam", 194).
-spec contains(list(YW), YW) -> boolean().
contains(List, Elem) ->
    case List of
        [] ->
            false;

        [First | _] when First =:= Elem ->
            true;

        [_ | Rest] ->
            contains(Rest, Elem)
    end.

-file("/Users/louis/src/gleam/stdlib/src/gleam/list.gleam", 221).
-spec first(list(YY)) -> {ok, YY} | {error, nil}.
first(List) ->
    case List of
        [] ->
            {error, nil};

        [X | _] ->
            {ok, X}
    end.

-file("/Users/louis/src/gleam/stdlib/src/gleam/list.gleam", 250).
-spec rest(list(AAC)) -> {ok, list(AAC)} | {error, nil}.
rest(List) ->
    case List of
        [] ->
            {error, nil};

        [_ | Rest] ->
            {ok, Rest}
    end.

-file("/Users/louis/src/gleam/stdlib/src/gleam/list.gleam", 292).
-spec update_group(fun((AAN) -> AAO)) -> fun((gleam@dict:dict(AAO, list(AAN)), AAN) -> gleam@dict:dict(AAO, list(AAN))).
update_group(F) ->
    fun(Groups, Elem) -> case gleam_stdlib:map_get(Groups, F(Elem)) of
            {ok, Existing} ->
                gleam@dict:insert(Groups, F(Elem), [Elem | Existing]);

            {error, _} ->
                gleam@dict:insert(Groups, F(Elem), [Elem])
        end end.

-file("/Users/louis/src/gleam/stdlib/src/gleam/list.gleam", 320).
-spec filter_loop(list(AAY), fun((AAY) -> boolean()), list(AAY)) -> list(AAY).
filter_loop(List, Fun, Acc) ->
    case List of
        [] ->
            lists:reverse(Acc);

        [First | Rest] ->
            New_acc = case Fun(First) of
                true ->
                    [First | Acc];

                false ->
                    Acc
            end,
            filter_loop(Rest, Fun, New_acc)
    end.

-file("/Users/louis/src/gleam/stdlib/src/gleam/list.gleam", 316).
-spec filter(list(AAV), fun((AAV) -> boolean())) -> list(AAV).
filter(List, Predicate) ->
    filter_loop(List, Predicate, []).

-file("/Users/louis/src/gleam/stdlib/src/gleam/list.gleam", 352).
-spec filter_map_loop(
    list(ABJ),
    fun((ABJ) -> {ok, ABL} | {error, any()}),
    list(ABL)
) -> list(ABL).
filter_map_loop(List, Fun, Acc) ->
    case List of
        [] ->
            lists:reverse(Acc);

        [First | Rest] ->
            New_acc = case Fun(First) of
                {ok, First@1} ->
                    [First@1 | Acc];

                {error, _} ->
                    Acc
            end,
            filter_map_loop(Rest, Fun, New_acc)
    end.

-file("/Users/louis/src/gleam/stdlib/src/gleam/list.gleam", 348).
-spec filter_map(list(ABC), fun((ABC) -> {ok, ABE} | {error, any()})) -> list(ABE).
filter_map(List, Fun) ->
    filter_map_loop(List, Fun, []).

-file("/Users/louis/src/gleam/stdlib/src/gleam/list.gleam", 383).
-spec map_loop(list(ABV), fun((ABV) -> ABX), list(ABX)) -> list(ABX).
map_loop(List, Fun, Acc) ->
    case List of
        [] ->
            lists:reverse(Acc);

        [First | Rest] ->
            map_loop(Rest, Fun, [Fun(First) | Acc])
    end.

-file("/Users/louis/src/gleam/stdlib/src/gleam/list.gleam", 379).
-spec map(list(ABR), fun((ABR) -> ABT)) -> list(ABT).
map(List, Fun) ->
    map_loop(List, Fun, []).

-file("/Users/louis/src/gleam/stdlib/src/gleam/list.gleam", 410).
-spec map2_loop(list(ACG), list(ACI), fun((ACG, ACI) -> ACK), list(ACK)) -> list(ACK).
map2_loop(List1, List2, Fun, Acc) ->
    case {List1, List2} of
        {[], _} ->
            lists:reverse(Acc);

        {_, []} ->
            lists:reverse(Acc);

        {[A | As_], [B | Bs]} ->
            map2_loop(As_, Bs, Fun, [Fun(A, B) | Acc])
    end.

-file("/Users/louis/src/gleam/stdlib/src/gleam/list.gleam", 406).
-spec map2(list(ACA), list(ACC), fun((ACA, ACC) -> ACE)) -> list(ACE).
map2(List1, List2, Fun) ->
    map2_loop(List1, List2, Fun, []).

-file("/Users/louis/src/gleam/stdlib/src/gleam/list.gleam", 465).
-spec index_map_loop(
    list(ACW),
    fun((ACW, integer()) -> ACY),
    integer(),
    list(ACY)
) -> list(ACY).
index_map_loop(List, Fun, Index, Acc) ->
    case List of
        [] ->
            lists:reverse(Acc);

        [First | Rest] ->
            Acc@1 = [Fun(First, Index) | Acc],
            index_map_loop(Rest, Fun, Index + 1, Acc@1)
    end.

-file("/Users/louis/src/gleam/stdlib/src/gleam/list.gleam", 461).
-spec index_map(list(ACS), fun((ACS, integer()) -> ACU)) -> list(ACU).
index_map(List, Fun) ->
    index_map_loop(List, Fun, 0, []).

-file("/Users/louis/src/gleam/stdlib/src/gleam/list.gleam", 519).
-spec try_map_loop(list(ADK), fun((ADK) -> {ok, ADM} | {error, ADN}), list(ADM)) -> {ok,
        list(ADM)} |
    {error, ADN}.
try_map_loop(List, Fun, Acc) ->
    case List of
        [] ->
            {ok, lists:reverse(Acc)};

        [First | Rest] ->
            case Fun(First) of
                {ok, First@1} ->
                    try_map_loop(Rest, Fun, [First@1 | Acc]);

                {error, Error} ->
                    {error, Error}
            end
    end.

-file("/Users/louis/src/gleam/stdlib/src/gleam/list.gleam", 512).
-spec try_map(list(ADB), fun((ADB) -> {ok, ADD} | {error, ADE})) -> {ok,
        list(ADD)} |
    {error, ADE}.
try_map(List, Fun) ->
    try_map_loop(List, Fun, []).

-file("/Users/louis/src/gleam/stdlib/src/gleam/list.gleam", 554).
-spec drop(list(ADU), integer()) -> list(ADU).
drop(List, N) ->
    case N =< 0 of
        true ->
            List;

        false ->
            case List of
                [] ->
                    [];

                [_ | Rest] ->
                    drop(Rest, N - 1)
            end
    end.

-file("/Users/louis/src/gleam/stdlib/src/gleam/list.gleam", 589).
-spec take_loop(list(AEA), integer(), list(AEA)) -> list(AEA).
take_loop(List, N, Acc) ->
    case N =< 0 of
        true ->
            lists:reverse(Acc);

        false ->
            case List of
                [] ->
                    lists:reverse(Acc);

                [First | Rest] ->
                    take_loop(Rest, N - 1, [First | Acc])
            end
    end.

-file("/Users/louis/src/gleam/stdlib/src/gleam/list.gleam", 585).
-spec take(list(ADX), integer()) -> list(ADX).
take(List, N) ->
    take_loop(List, N, []).

-file("/Users/louis/src/gleam/stdlib/src/gleam/list.gleam", 609).
-spec new() -> list(any()).
new() ->
    [].

-file("/Users/louis/src/gleam/stdlib/src/gleam/list.gleam", 629).
-spec wrap(AEG) -> list(AEG).
wrap(Item) ->
    [Item].

-file("/Users/louis/src/gleam/stdlib/src/gleam/list.gleam", 650).
-spec append_loop(list(AEM), list(AEM)) -> list(AEM).
append_loop(First, Second) ->
    case First of
        [] ->
            Second;

        [Item | Rest] ->
            append_loop(Rest, [Item | Second])
    end.

-file("/Users/louis/src/gleam/stdlib/src/gleam/list.gleam", 646).
-spec append(list(AEI), list(AEI)) -> list(AEI).
append(First, Second) ->
    lists:append(First, Second).

-file("/Users/louis/src/gleam/stdlib/src/gleam/list.gleam", 670).
-spec prepend(list(AEQ), AEQ) -> list(AEQ).
prepend(List, Item) ->
    [Item | List].

-file("/Users/louis/src/gleam/stdlib/src/gleam/list.gleam", 675).
-spec reverse_and_prepend(list(AET), list(AET)) -> list(AET).
reverse_and_prepend(Prefix, Suffix) ->
    case Prefix of
        [] ->
            Suffix;

        [First | Rest] ->
            reverse_and_prepend(Rest, [First | Suffix])
    end.

-file("/Users/louis/src/gleam/stdlib/src/gleam/list.gleam", 682).
-spec flatten_loop(list(list(AEX)), list(AEX)) -> list(AEX).
flatten_loop(Lists, Acc) ->
    case Lists of
        [] ->
            lists:reverse(Acc);

        [List | Further_lists] ->
            flatten_loop(Further_lists, reverse_and_prepend(List, Acc))
    end.

-file("/Users/louis/src/gleam/stdlib/src/gleam/list.gleam", 702).
-spec flatten(list(list(AFC))) -> list(AFC).
flatten(Lists) ->
    flatten_loop(Lists, []).

-file("/Users/louis/src/gleam/stdlib/src/gleam/list.gleam", 715).
-spec flat_map(list(AFG), fun((AFG) -> list(AFI))) -> list(AFI).
flat_map(List, Fun) ->
    _pipe = map(List, Fun),
    flatten(_pipe).

-file("/Users/louis/src/gleam/stdlib/src/gleam/list.gleam", 728).
-spec fold(list(AFL), AFN, fun((AFN, AFL) -> AFN)) -> AFN.
fold(List, Initial, Fun) ->
    case List of
        [] ->
            Initial;

        [X | Rest] ->
            fold(Rest, Fun(Initial, X), Fun)
    end.

-file("/Users/louis/src/gleam/stdlib/src/gleam/list.gleam", 90).
-spec count(list(YL), fun((YL) -> boolean())) -> integer().
count(List, Predicate) ->
    fold(List, 0, fun(Acc, Value) -> case Predicate(Value) of
                true ->
                    Acc + 1;

                false ->
                    Acc
            end end).

-file("/Users/louis/src/gleam/stdlib/src/gleam/list.gleam", 288).
-spec group(list(AAH), fun((AAH) -> AAJ)) -> gleam@dict:dict(AAJ, list(AAH)).
group(List, Key) ->
    fold(List, maps:new(), update_group(Key)).

-file("/Users/louis/src/gleam/stdlib/src/gleam/list.gleam", 435).
-spec map_fold(list(ACN), ACP, fun((ACP, ACN) -> {ACP, ACQ})) -> {ACP,
    list(ACQ)}.
map_fold(List, Initial, Fun) ->
    _pipe = fold(
        List,
        {Initial, []},
        fun(Acc, Item) ->
            {Current_acc, Items} = Acc,
            {Next_acc, Next_item} = Fun(Current_acc, Item),
            {Next_acc, [Next_item | Items]}
        end
    ),
    gleam@pair:map_second(_pipe, fun lists:reverse/1).

-file("/Users/louis/src/gleam/stdlib/src/gleam/list.gleam", 750).
-spec fold_right(list(AFO), AFQ, fun((AFQ, AFO) -> AFQ)) -> AFQ.
fold_right(List, Initial, Fun) ->
    case List of
        [] ->
            Initial;

        [X | Rest] ->
            Fun(fold_right(Rest, Initial, Fun), X)
    end.

-file("/Users/louis/src/gleam/stdlib/src/gleam/list.gleam", 778).
-spec index_fold_loop(
    list(AFU),
    AFW,
    fun((AFW, AFU, integer()) -> AFW),
    integer()
) -> AFW.
index_fold_loop(Over, Acc, With, Index) ->
    case Over of
        [] ->
            Acc;

        [First | Rest] ->
            index_fold_loop(Rest, With(Acc, First, Index), With, Index + 1)
    end.

-file("/Users/louis/src/gleam/stdlib/src/gleam/list.gleam", 770).
-spec index_fold(list(AFR), AFT, fun((AFT, AFR, integer()) -> AFT)) -> AFT.
index_fold(List, Initial, Fun) ->
    index_fold_loop(List, Initial, Fun, 0).

-file("/Users/louis/src/gleam/stdlib/src/gleam/list.gleam", 810).
-spec try_fold(list(AFX), AFZ, fun((AFZ, AFX) -> {ok, AFZ} | {error, AGA})) -> {ok,
        AFZ} |
    {error, AGA}.
try_fold(List, Initial, Fun) ->
    case List of
        [] ->
            {ok, Initial};

        [First | Rest] ->
            case Fun(Initial, First) of
                {ok, Result} ->
                    try_fold(Rest, Result, Fun);

                {error, _} = Error ->
                    Error
            end
    end.

-file("/Users/louis/src/gleam/stdlib/src/gleam/list.gleam", 849).
-spec fold_until(list(AGF), AGH, fun((AGH, AGF) -> continue_or_stop(AGH))) -> AGH.
fold_until(List, Initial, Fun) ->
    case List of
        [] ->
            Initial;

        [First | Rest] ->
            case Fun(Initial, First) of
                {continue, Next_accumulator} ->
                    fold_until(Rest, Next_accumulator, Fun);

                {stop, B} ->
                    B
            end
    end.

-file("/Users/louis/src/gleam/stdlib/src/gleam/list.gleam", 886).
-spec find(list(AGJ), fun((AGJ) -> boolean())) -> {ok, AGJ} | {error, nil}.
find(List, Is_desired) ->
    case List of
        [] ->
            {error, nil};

        [X | Rest] ->
            case Is_desired(X) of
                true ->
                    {ok, X};

                _ ->
                    find(Rest, Is_desired)
            end
    end.

-file("/Users/louis/src/gleam/stdlib/src/gleam/list.gleam", 922).
-spec find_map(list(AGN), fun((AGN) -> {ok, AGP} | {error, any()})) -> {ok, AGP} |
    {error, nil}.
find_map(List, Fun) ->
    case List of
        [] ->
            {error, nil};

        [X | Rest] ->
            case Fun(X) of
                {ok, X@1} ->
                    {ok, X@1};

                _ ->
                    find_map(Rest, Fun)
            end
    end.

-file("/Users/louis/src/gleam/stdlib/src/gleam/list.gleam", 957).
-spec all(list(AGV), fun((AGV) -> boolean())) -> boolean().
all(List, Predicate) ->
    case List of
        [] ->
            true;

        [First | Rest] ->
            case Predicate(First) of
                true ->
                    all(Rest, Predicate);

                false ->
                    false
            end
    end.

-file("/Users/louis/src/gleam/stdlib/src/gleam/list.gleam", 994).
-spec any(list(AGX), fun((AGX) -> boolean())) -> boolean().
any(List, Predicate) ->
    case List of
        [] ->
            false;

        [First | Rest] ->
            case Predicate(First) of
                true ->
                    true;

                false ->
                    any(Rest, Predicate)
            end
    end.

-file("/Users/louis/src/gleam/stdlib/src/gleam/list.gleam", 1036).
-spec zip_loop(list(AHE), list(AHG), list({AHE, AHG})) -> list({AHE, AHG}).
zip_loop(One, Other, Acc) ->
    case {One, Other} of
        {[First_one | Rest_one], [First_other | Rest_other]} ->
            zip_loop(Rest_one, Rest_other, [{First_one, First_other} | Acc]);

        {_, _} ->
            lists:reverse(Acc)
    end.

-file("/Users/louis/src/gleam/stdlib/src/gleam/list.gleam", 1032).
-spec zip(list(AGZ), list(AHB)) -> list({AGZ, AHB}).
zip(List, Other) ->
    zip_loop(List, Other, []).

-file("/Users/louis/src/gleam/stdlib/src/gleam/list.gleam", 1077).
-spec strict_zip_loop(list(AHR), list(AHT), list({AHR, AHT})) -> {ok,
        list({AHR, AHT})} |
    {error, nil}.
strict_zip_loop(One, Other, Acc) ->
    case {One, Other} of
        {[], []} ->
            {ok, lists:reverse(Acc)};

        {[], _} ->
            {error, nil};

        {_, []} ->
            {error, nil};

        {[First_one | Rest_one], [First_other | Rest_other]} ->
            strict_zip_loop(
                Rest_one,
                Rest_other,
                [{First_one, First_other} | Acc]
            )
    end.

-file("/Users/louis/src/gleam/stdlib/src/gleam/list.gleam", 1070).
-spec strict_zip(list(AHK), list(AHM)) -> {ok, list({AHK, AHM})} | {error, nil}.
strict_zip(List, Other) ->
    strict_zip_loop(List, Other, []).

-file("/Users/louis/src/gleam/stdlib/src/gleam/list.gleam", 1108).
-spec unzip_loop(list({AIE, AIF}), list(AIE), list(AIF)) -> {list(AIE),
    list(AIF)}.
unzip_loop(Input, One, Other) ->
    case Input of
        [] ->
            {lists:reverse(One), lists:reverse(Other)};

        [{First_one, First_other} | Rest] ->
            unzip_loop(Rest, [First_one | One], [First_other | Other])
    end.

-file("/Users/louis/src/gleam/stdlib/src/gleam/list.gleam", 1104).
-spec unzip(list({AHZ, AIA})) -> {list(AHZ), list(AIA)}.
unzip(Input) ->
    unzip_loop(Input, [], []).

-file("/Users/louis/src/gleam/stdlib/src/gleam/list.gleam", 1143).
-spec intersperse_loop(list(AIO), AIO, list(AIO)) -> list(AIO).
intersperse_loop(List, Separator, Acc) ->
    case List of
        [] ->
            lists:reverse(Acc);

        [X | Rest] ->
            intersperse_loop(Rest, Separator, [X, Separator | Acc])
    end.

-file("/Users/louis/src/gleam/stdlib/src/gleam/list.gleam", 1136).
-spec intersperse(list(AIL), AIL) -> list(AIL).
intersperse(List, Elem) ->
    case List of
        [] ->
            List;

        [_] ->
            List;

        [X | Rest] ->
            intersperse_loop(Rest, Elem, [X])
    end.

-file("/Users/louis/src/gleam/stdlib/src/gleam/list.gleam", 1161).
-spec unique(list(AIS)) -> list(AIS).
unique(List) ->
    case List of
        [] ->
            [];

        [X | Rest] ->
            [X | unique(filter(Rest, fun(Y) -> Y /= X end))]
    end.

-file("/Users/louis/src/gleam/stdlib/src/gleam/list.gleam", 1242).
-spec sequences(
    list(AIY),
    fun((AIY, AIY) -> gleam@order:order()),
    list(AIY),
    sorting(),
    AIY,
    list(list(AIY))
) -> list(list(AIY)).
sequences(List, Compare, Growing, Direction, Prev, Acc) ->
    Growing@1 = [Prev | Growing],
    case List of
        [] ->
            case Direction of
                ascending ->
                    [reverse_loop(Growing@1, []) | Acc];

                descending ->
                    [Growing@1 | Acc]
            end;

        [New | Rest] ->
            case {Compare(Prev, New), Direction} of
                {gt, descending} ->
                    sequences(Rest, Compare, Growing@1, Direction, New, Acc);

                {lt, ascending} ->
                    sequences(Rest, Compare, Growing@1, Direction, New, Acc);

                {eq, ascending} ->
                    sequences(Rest, Compare, Growing@1, Direction, New, Acc);

                {gt, ascending} ->
                    Acc@1 = case Direction of
                        ascending ->
                            [reverse_loop(Growing@1, []) | Acc];

                        descending ->
                            [Growing@1 | Acc]
                    end,
                    case Rest of
                        [] ->
                            [[New] | Acc@1];

                        [Next | Rest@1] ->
                            Direction@1 = case Compare(New, Next) of
                                lt ->
                                    ascending;

                                eq ->
                                    ascending;

                                gt ->
                                    descending
                            end,
                            sequences(
                                Rest@1,
                                Compare,
                                [New],
                                Direction@1,
                                Next,
                                Acc@1
                            )
                    end;

                {lt, descending} ->
                    Acc@1 = case Direction of
                        ascending ->
                            [reverse_loop(Growing@1, []) | Acc];

                        descending ->
                            [Growing@1 | Acc]
                    end,
                    case Rest of
                        [] ->
                            [[New] | Acc@1];

                        [Next | Rest@1] ->
                            Direction@1 = case Compare(New, Next) of
                                lt ->
                                    ascending;

                                eq ->
                                    ascending;

                                gt ->
                                    descending
                            end,
                            sequences(
                                Rest@1,
                                Compare,
                                [New],
                                Direction@1,
                                Next,
                                Acc@1
                            )
                    end;

                {eq, descending} ->
                    Acc@1 = case Direction of
                        ascending ->
                            [reverse_loop(Growing@1, []) | Acc];

                        descending ->
                            [Growing@1 | Acc]
                    end,
                    case Rest of
                        [] ->
                            [[New] | Acc@1];

                        [Next | Rest@1] ->
                            Direction@1 = case Compare(New, Next) of
                                lt ->
                                    ascending;

                                eq ->
                                    ascending;

                                gt ->
                                    descending
                            end,
                            sequences(
                                Rest@1,
                                Compare,
                                [New],
                                Direction@1,
                                Next,
                                Acc@1
                            )
                    end
            end
    end.

-file("/Users/louis/src/gleam/stdlib/src/gleam/list.gleam", 1390).
-spec merge_ascendings(
    list(AJV),
    list(AJV),
    fun((AJV, AJV) -> gleam@order:order()),
    list(AJV)
) -> list(AJV).
merge_ascendings(List1, List2, Compare, Acc) ->
    case {List1, List2} of
        {[], List} ->
            reverse_loop(List, Acc);

        {List, []} ->
            reverse_loop(List, Acc);

        {[First1 | Rest1], [First2 | Rest2]} ->
            case Compare(First1, First2) of
                lt ->
                    merge_ascendings(Rest1, List2, Compare, [First1 | Acc]);

                gt ->
                    merge_ascendings(List1, Rest2, Compare, [First2 | Acc]);

                eq ->
                    merge_ascendings(List1, Rest2, Compare, [First2 | Acc])
            end
    end.

-file("/Users/louis/src/gleam/stdlib/src/gleam/list.gleam", 1343).
-spec merge_ascending_pairs(
    list(list(AJJ)),
    fun((AJJ, AJJ) -> gleam@order:order()),
    list(list(AJJ))
) -> list(list(AJJ)).
merge_ascending_pairs(Sequences, Compare, Acc) ->
    case Sequences of
        [] ->
            reverse_loop(Acc, []);

        [Sequence] ->
            reverse_loop([reverse_loop(Sequence, []) | Acc], []);

        [Ascending1, Ascending2 | Rest] ->
            Descending = merge_ascendings(Ascending1, Ascending2, Compare, []),
            merge_ascending_pairs(Rest, Compare, [Descending | Acc])
    end.

-file("/Users/louis/src/gleam/stdlib/src/gleam/list.gleam", 1417).
-spec merge_descendings(
    list(AKA),
    list(AKA),
    fun((AKA, AKA) -> gleam@order:order()),
    list(AKA)
) -> list(AKA).
merge_descendings(List1, List2, Compare, Acc) ->
    case {List1, List2} of
        {[], List} ->
            reverse_loop(List, Acc);

        {List, []} ->
            reverse_loop(List, Acc);

        {[First1 | Rest1], [First2 | Rest2]} ->
            case Compare(First1, First2) of
                lt ->
                    merge_descendings(List1, Rest2, Compare, [First2 | Acc]);

                gt ->
                    merge_descendings(Rest1, List2, Compare, [First1 | Acc]);

                eq ->
                    merge_descendings(Rest1, List2, Compare, [First1 | Acc])
            end
    end.

-file("/Users/louis/src/gleam/stdlib/src/gleam/list.gleam", 1365).
-spec merge_descending_pairs(
    list(list(AJP)),
    fun((AJP, AJP) -> gleam@order:order()),
    list(list(AJP))
) -> list(list(AJP)).
merge_descending_pairs(Sequences, Compare, Acc) ->
    case Sequences of
        [] ->
            reverse_loop(Acc, []);

        [Sequence] ->
            reverse_loop([reverse_loop(Sequence, []) | Acc], []);

        [Descending1, Descending2 | Rest] ->
            Ascending = merge_descendings(Descending1, Descending2, Compare, []),
            merge_descending_pairs(Rest, Compare, [Ascending | Acc])
    end.

-file("/Users/louis/src/gleam/stdlib/src/gleam/list.gleam", 1309).
-spec merge_all(
    list(list(AJF)),
    sorting(),
    fun((AJF, AJF) -> gleam@order:order())
) -> list(AJF).
merge_all(Sequences, Direction, Compare) ->
    case {Sequences, Direction} of
        {[], _} ->
            [];

        {[Sequence], ascending} ->
            Sequence;

        {[Sequence@1], descending} ->
            reverse_loop(Sequence@1, []);

        {_, ascending} ->
            Sequences@1 = merge_ascending_pairs(Sequences, Compare, []),
            merge_all(Sequences@1, descending, Compare);

        {_, descending} ->
            Sequences@2 = merge_descending_pairs(Sequences, Compare, []),
            merge_all(Sequences@2, ascending, Compare)
    end.

-file("/Users/louis/src/gleam/stdlib/src/gleam/list.gleam", 1180).
-spec sort(list(AIV), fun((AIV, AIV) -> gleam@order:order())) -> list(AIV).
sort(List, Compare) ->
    case List of
        [] ->
            [];

        [X] ->
            [X];

        [X@1, Y | Rest] ->
            Direction = case Compare(X@1, Y) of
                lt ->
                    ascending;

                eq ->
                    ascending;

                gt ->
                    descending
            end,
            Sequences = sequences(Rest, Compare, [X@1], Direction, Y, []),
            merge_all(Sequences, ascending, Compare)
    end.

-file("/Users/louis/src/gleam/stdlib/src/gleam/list.gleam", 1457).
-spec range_loop(integer(), integer(), list(integer())) -> list(integer()).
range_loop(Start, Stop, Acc) ->
    case gleam@int:compare(Start, Stop) of
        eq ->
            [Stop | Acc];

        gt ->
            range_loop(Start, Stop + 1, [Stop | Acc]);

        lt ->
            range_loop(Start, Stop - 1, [Stop | Acc])
    end.

-file("/Users/louis/src/gleam/stdlib/src/gleam/list.gleam", 1453).
-spec range(integer(), integer()) -> list(integer()).
range(Start, Stop) ->
    range_loop(Start, Stop, []).

-file("/Users/louis/src/gleam/stdlib/src/gleam/list.gleam", 1483).
-spec repeat_loop(AKK, integer(), list(AKK)) -> list(AKK).
repeat_loop(Item, Times, Acc) ->
    case Times =< 0 of
        true ->
            Acc;

        false ->
            repeat_loop(Item, Times - 1, [Item | Acc])
    end.

-file("/Users/louis/src/gleam/stdlib/src/gleam/list.gleam", 1479).
-spec repeat(AKI, integer()) -> list(AKI).
repeat(A, Times) ->
    repeat_loop(A, Times, []).

-file("/Users/louis/src/gleam/stdlib/src/gleam/list.gleam", 1516).
-spec split_loop(list(AKR), integer(), list(AKR)) -> {list(AKR), list(AKR)}.
split_loop(List, N, Taken) ->
    case N =< 0 of
        true ->
            {lists:reverse(Taken), List};

        false ->
            case List of
                [] ->
                    {lists:reverse(Taken), []};

                [First | Rest] ->
                    split_loop(Rest, N - 1, [First | Taken])
            end
    end.

-file("/Users/louis/src/gleam/stdlib/src/gleam/list.gleam", 1512).
-spec split(list(AKN), integer()) -> {list(AKN), list(AKN)}.
split(List, Index) ->
    split_loop(List, Index, []).

-file("/Users/louis/src/gleam/stdlib/src/gleam/list.gleam", 1552).
-spec split_while_loop(list(ALA), fun((ALA) -> boolean()), list(ALA)) -> {list(ALA),
    list(ALA)}.
split_while_loop(List, F, Acc) ->
    case List of
        [] ->
            {lists:reverse(Acc), []};

        [First | Rest] ->
            case F(First) of
                false ->
                    {lists:reverse(Acc), List};

                _ ->
                    split_while_loop(Rest, F, [First | Acc])
            end
    end.

-file("/Users/louis/src/gleam/stdlib/src/gleam/list.gleam", 1545).
-spec split_while(list(AKW), fun((AKW) -> boolean())) -> {list(AKW), list(AKW)}.
split_while(List, Predicate) ->
    split_while_loop(List, Predicate, []).

-file("/Users/louis/src/gleam/stdlib/src/gleam/list.gleam", 1592).
-spec key_find(list({ALF, ALG}), ALF) -> {ok, ALG} | {error, nil}.
key_find(Keyword_list, Desired_key) ->
    find_map(
        Keyword_list,
        fun(Keyword) ->
            {Key, Value} = Keyword,
            case Key =:= Desired_key of
                true ->
                    {ok, Value};

                false ->
                    {error, nil}
            end
        end
    ).

-file("/Users/louis/src/gleam/stdlib/src/gleam/list.gleam", 1623).
-spec key_filter(list({ALK, ALL}), ALK) -> list(ALL).
key_filter(Keyword_list, Desired_key) ->
    filter_map(
        Keyword_list,
        fun(Keyword) ->
            {Key, Value} = Keyword,
            case Key =:= Desired_key of
                true ->
                    {ok, Value};

                false ->
                    {error, nil}
            end
        end
    ).

-file("/Users/louis/src/gleam/stdlib/src/gleam/list.gleam", 1664).
-spec pop_loop(list(BEG), fun((BEG) -> boolean()), list(BEG)) -> {ok,
        {BEG, list(BEG)}} |
    {error, nil}.
pop_loop(Haystack, Predicate, Checked) ->
    case Haystack of
        [] ->
            {error, nil};

        [X | Rest] ->
            case Predicate(X) of
                true ->
                    {ok, {X, lists:append(lists:reverse(Checked), Rest)}};

                false ->
                    pop_loop(Rest, Predicate, [X | Checked])
            end
    end.

-file("/Users/louis/src/gleam/stdlib/src/gleam/list.gleam", 1657).
-spec pop(list(ALO), fun((ALO) -> boolean())) -> {ok, {ALO, list(ALO)}} |
    {error, nil}.
pop(List, Is_desired) ->
    pop_loop(List, Is_desired, []).

-file("/Users/louis/src/gleam/stdlib/src/gleam/list.gleam", 1704).
-spec pop_map_loop(
    list(AMG),
    fun((AMG) -> {ok, AMI} | {error, any()}),
    list(AMG)
) -> {ok, {AMI, list(AMG)}} | {error, nil}.
pop_map_loop(List, Mapper, Checked) ->
    case List of
        [] ->
            {error, nil};

        [X | Rest] ->
            case Mapper(X) of
                {ok, Y} ->
                    {ok, {Y, lists:append(lists:reverse(Checked), Rest)}};

                {error, _} ->
                    pop_map_loop(Rest, Mapper, [X | Checked])
            end
    end.

-file("/Users/louis/src/gleam/stdlib/src/gleam/list.gleam", 1697).
-spec pop_map(list(ALX), fun((ALX) -> {ok, ALZ} | {error, any()})) -> {ok,
        {ALZ, list(ALX)}} |
    {error, nil}.
pop_map(Haystack, Is_desired) ->
    pop_map_loop(Haystack, Is_desired, []).

-file("/Users/louis/src/gleam/stdlib/src/gleam/list.gleam", 1742).
-spec key_pop(list({AMQ, AMR}), AMQ) -> {ok, {AMR, list({AMQ, AMR})}} |
    {error, nil}.
key_pop(List, Key) ->
    pop_map(
        List,
        fun(Entry) ->
            {K, V} = Entry,
            case K of
                K@1 when K@1 =:= Key ->
                    {ok, V};

                _ ->
                    {error, nil}
            end
        end
    ).

-file("/Users/louis/src/gleam/stdlib/src/gleam/list.gleam", 1769).
-spec key_set(list({AMW, AMX}), AMW, AMX) -> list({AMW, AMX}).
key_set(List, Key, Value) ->
    case List of
        [] ->
            [{Key, Value}];

        [{K, _} | Rest] when K =:= Key ->
            [{Key, Value} | Rest];

        [First | Rest@1] ->
            [First | key_set(Rest@1, Key, Value)]
    end.

-file("/Users/louis/src/gleam/stdlib/src/gleam/list.gleam", 1791).
-spec each(list(ANA), fun((ANA) -> any())) -> nil.
each(List, F) ->
    case List of
        [] ->
            nil;

        [First | Rest] ->
            F(First),
            each(Rest, F)
    end.

-file("/Users/louis/src/gleam/stdlib/src/gleam/list.gleam", 1817).
-spec try_each(list(AND), fun((AND) -> {ok, any()} | {error, ANG})) -> {ok, nil} |
    {error, ANG}.
try_each(List, Fun) ->
    case List of
        [] ->
            {ok, nil};

        [First | Rest] ->
            case Fun(First) of
                {ok, _} ->
                    try_each(Rest, Fun);

                {error, E} ->
                    {error, E}
            end
    end.

-file("/Users/louis/src/gleam/stdlib/src/gleam/list.gleam", 1850).
-spec partition_loop(list(BGL), fun((BGL) -> boolean()), list(BGL), list(BGL)) -> {list(BGL),
    list(BGL)}.
partition_loop(List, Categorise, Trues, Falses) ->
    case List of
        [] ->
            {lists:reverse(Trues), lists:reverse(Falses)};

        [First | Rest] ->
            case Categorise(First) of
                true ->
                    partition_loop(Rest, Categorise, [First | Trues], Falses);

                false ->
                    partition_loop(Rest, Categorise, Trues, [First | Falses])
            end
    end.

-file("/Users/louis/src/gleam/stdlib/src/gleam/list.gleam", 1843).
-spec partition(list(ANL), fun((ANL) -> boolean())) -> {list(ANL), list(ANL)}.
partition(List, Categorise) ->
    partition_loop(List, Categorise, [], []).

-file("/Users/louis/src/gleam/stdlib/src/gleam/list.gleam", 1870).
-spec permutations(list(ANU)) -> list(list(ANU)).
permutations(List) ->
    case List of
        [] ->
            [[]];

        _ ->
            _pipe@3 = index_map(
                List,
                fun(I, I_idx) ->
                    _pipe = index_fold(
                        List,
                        [],
                        fun(Acc, J, J_idx) -> case I_idx =:= J_idx of
                                true ->
                                    Acc;

                                false ->
                                    [J | Acc]
                            end end
                    ),
                    _pipe@1 = lists:reverse(_pipe),
                    _pipe@2 = permutations(_pipe@1),
                    map(_pipe@2, fun(Permutation) -> [I | Permutation] end)
                end
            ),
            flatten(_pipe@3)
    end.

-file("/Users/louis/src/gleam/stdlib/src/gleam/list.gleam", 1910).
-spec window_loop(list(list(AOC)), list(AOC), integer()) -> list(list(AOC)).
window_loop(Acc, List, N) ->
    Window = take(List, N),
    case erlang:length(Window) =:= N of
        true ->
            window_loop([Window | Acc], drop(List, 1), N);

        false ->
            lists:reverse(Acc)
    end.

-file("/Users/louis/src/gleam/stdlib/src/gleam/list.gleam", 1903).
-spec window(list(ANY), integer()) -> list(list(ANY)).
window(List, N) ->
    case N =< 0 of
        true ->
            [];

        false ->
            window_loop([], List, N)
    end.

-file("/Users/louis/src/gleam/stdlib/src/gleam/list.gleam", 1933).
-spec window_by_2(list(AOI)) -> list({AOI, AOI}).
window_by_2(List) ->
    zip(List, drop(List, 1)).

-file("/Users/louis/src/gleam/stdlib/src/gleam/list.gleam", 1946).
-spec drop_while(list(AOL), fun((AOL) -> boolean())) -> list(AOL).
drop_while(List, Predicate) ->
    case List of
        [] ->
            [];

        [First | Rest] ->
            case Predicate(First) of
                true ->
                    drop_while(Rest, Predicate);

                false ->
                    [First | Rest]
            end
    end.

-file("/Users/louis/src/gleam/stdlib/src/gleam/list.gleam", 1976).
-spec take_while_loop(list(AOR), fun((AOR) -> boolean()), list(AOR)) -> list(AOR).
take_while_loop(List, Predicate, Acc) ->
    case List of
        [] ->
            lists:reverse(Acc);

        [First | Rest] ->
            case Predicate(First) of
                true ->
                    take_while_loop(Rest, Predicate, [First | Acc]);

                false ->
                    lists:reverse(Acc)
            end
    end.

-file("/Users/louis/src/gleam/stdlib/src/gleam/list.gleam", 1969).
-spec take_while(list(AOO), fun((AOO) -> boolean())) -> list(AOO).
take_while(List, Predicate) ->
    take_while_loop(List, Predicate, []).

-file("/Users/louis/src/gleam/stdlib/src/gleam/list.gleam", 2008).
-spec chunk_loop(list(APA), fun((APA) -> APC), APC, list(APA), list(list(APA))) -> list(list(APA)).
chunk_loop(List, F, Previous_key, Current_chunk, Acc) ->
    case List of
        [First | Rest] ->
            Key = F(First),
            case Key =:= Previous_key of
                false ->
                    New_acc = [lists:reverse(Current_chunk) | Acc],
                    chunk_loop(Rest, F, Key, [First], New_acc);

                _ ->
                    chunk_loop(Rest, F, Key, [First | Current_chunk], Acc)
            end;

        _ ->
            lists:reverse([lists:reverse(Current_chunk) | Acc])
    end.

-file("/Users/louis/src/gleam/stdlib/src/gleam/list.gleam", 2001).
-spec chunk(list(AOV), fun((AOV) -> any())) -> list(list(AOV)).
chunk(List, F) ->
    case List of
        [] ->
            [];

        [First | Rest] ->
            chunk_loop(Rest, F, F(First), [First], [])
    end.

-file("/Users/louis/src/gleam/stdlib/src/gleam/list.gleam", 2053).
-spec sized_chunk_loop(
    list(APM),
    integer(),
    integer(),
    list(APM),
    list(list(APM))
) -> list(list(APM)).
sized_chunk_loop(List, Count, Left, Current_chunk, Acc) ->
    case List of
        [] ->
            case Current_chunk of
                [] ->
                    lists:reverse(Acc);

                Remaining ->
                    lists:reverse([lists:reverse(Remaining) | Acc])
            end;

        [First | Rest] ->
            Chunk = [First | Current_chunk],
            case Left > 1 of
                true ->
                    sized_chunk_loop(Rest, Count, Left - 1, Chunk, Acc);

                false ->
                    sized_chunk_loop(
                        Rest,
                        Count,
                        Count,
                        [],
                        [lists:reverse(Chunk) | Acc]
                    )
            end
    end.

-file("/Users/louis/src/gleam/stdlib/src/gleam/list.gleam", 2049).
-spec sized_chunk(list(API), integer()) -> list(list(API)).
sized_chunk(List, Count) ->
    sized_chunk_loop(List, Count, Count, [], []).

-file("/Users/louis/src/gleam/stdlib/src/gleam/list.gleam", 2097).
-spec reduce(list(APT), fun((APT, APT) -> APT)) -> {ok, APT} | {error, nil}.
reduce(List, Fun) ->
    case List of
        [] ->
            {error, nil};

        [First | Rest] ->
            {ok, fold(Rest, First, Fun)}
    end.

-file("/Users/louis/src/gleam/stdlib/src/gleam/list.gleam", 2121).
-spec scan_loop(list(AQB), AQD, list(AQD), fun((AQD, AQB) -> AQD)) -> list(AQD).
scan_loop(List, Accumulator, Accumulated, Fun) ->
    case List of
        [] ->
            lists:reverse(Accumulated);

        [First | Rest] ->
            Next = Fun(Accumulator, First),
            scan_loop(Rest, Next, [Next | Accumulated], Fun)
    end.

-file("/Users/louis/src/gleam/stdlib/src/gleam/list.gleam", 2113).
-spec scan(list(APX), APZ, fun((APZ, APX) -> APZ)) -> list(APZ).
scan(List, Initial, Fun) ->
    scan_loop(List, Initial, [], Fun).

-file("/Users/louis/src/gleam/stdlib/src/gleam/list.gleam", 2154).
-spec last(list(AQG)) -> {ok, AQG} | {error, nil}.
last(List) ->
    _pipe = List,
    reduce(_pipe, fun(_, Elem) -> Elem end).

-file("/Users/louis/src/gleam/stdlib/src/gleam/list.gleam", 2173).
-spec combinations(list(AQK), integer()) -> list(list(AQK)).
combinations(Items, N) ->
    case N of
        0 ->
            [[]];

        _ ->
            case Items of
                [] ->
                    [];

                [First | Rest] ->
                    First_combinations = begin
                        _pipe = map(
                            combinations(Rest, N - 1),
                            fun(Com) -> [First | Com] end
                        ),
                        lists:reverse(_pipe)
                    end,
                    fold(
                        First_combinations,
                        combinations(Rest, N),
                        fun(Acc, C) -> [C | Acc] end
                    )
            end
    end.

-file("/Users/louis/src/gleam/stdlib/src/gleam/list.gleam", 2205).
-spec combination_pairs_loop(list(AQR)) -> list(list({AQR, AQR})).
combination_pairs_loop(Items) ->
    case Items of
        [] ->
            [];

        [First | Rest] ->
            First_combinations = map(Rest, fun(Other) -> {First, Other} end),
            [First_combinations | combination_pairs_loop(Rest)]
    end.

-file("/Users/louis/src/gleam/stdlib/src/gleam/list.gleam", 2200).
-spec combination_pairs(list(AQO)) -> list({AQO, AQO}).
combination_pairs(Items) ->
    _pipe = combination_pairs_loop(Items),
    flatten(_pipe).

-file("/Users/louis/src/gleam/stdlib/src/gleam/list.gleam", 2242).
-spec transpose(list(list(AQZ))) -> list(list(AQZ)).
transpose(List_of_list) ->
    Take_first = fun(List) -> case List of
            [] ->
                [];

            [F] ->
                [F];

            [F@1 | _] ->
                [F@1]
        end end,
    case List_of_list of
        [] ->
            [];

        [[] | Rest] ->
            transpose(Rest);

        Rows ->
            Firsts = begin
                _pipe = Rows,
                _pipe@1 = map(_pipe, Take_first),
                flatten(_pipe@1)
            end,
            Rest@1 = transpose(
                map(Rows, fun(_capture) -> drop(_capture, 1) end)
            ),
            [Firsts | Rest@1]
    end.

-file("/Users/louis/src/gleam/stdlib/src/gleam/list.gleam", 2224).
-spec interleave(list(list(AQV))) -> list(AQV).
interleave(List) ->
    _pipe = transpose(List),
    flatten(_pipe).

-file("/Users/louis/src/gleam/stdlib/src/gleam/list.gleam", 2283).
-spec shuffle_pair_unwrap_loop(list({float(), ARH}), list(ARH)) -> list(ARH).
shuffle_pair_unwrap_loop(List, Acc) ->
    case List of
        [] ->
            Acc;

        [Elem_pair | Enumerable] ->
            shuffle_pair_unwrap_loop(
                Enumerable,
                [erlang:element(2, Elem_pair) | Acc]
            )
    end.

-file("/Users/louis/src/gleam/stdlib/src/gleam/list.gleam", 2291).
-spec do_shuffle_by_pair_indexes(list({float(), ARL})) -> list({float(), ARL}).
do_shuffle_by_pair_indexes(List_of_pairs) ->
    sort(
        List_of_pairs,
        fun(A_pair, B_pair) ->
            gleam@float:compare(
                erlang:element(1, A_pair),
                erlang:element(1, B_pair)
            )
        end
    ).

-file("/Users/louis/src/gleam/stdlib/src/gleam/list.gleam", 2276).
-spec shuffle(list(ARE)) -> list(ARE).
shuffle(List) ->
    _pipe = List,
    _pipe@1 = fold(_pipe, [], fun(Acc, A) -> [{rand:uniform(), A} | Acc] end),
    _pipe@2 = do_shuffle_by_pair_indexes(_pipe@1),
    shuffle_pair_unwrap_loop(_pipe@2, []).

-file("/Users/louis/src/gleam/stdlib/src/gleam/list.gleam", 2313).
-spec max(list(ARO), fun((ARO, ARO) -> gleam@order:order())) -> {ok, ARO} |
    {error, nil}.
max(List, Compare) ->
    reduce(List, fun(Acc, Other) -> case Compare(Acc, Other) of
                gt ->
                    Acc;

                _ ->
                    Other
            end end).

-file("/Users/louis/src/gleam/stdlib/src/gleam/list.gleam", 2386).
-spec log_random() -> float().
log_random() ->
    Min_positive = 2.2250738585072014e-308,
    _assert_subject = gleam@float:logarithm(rand:uniform() + Min_positive),
    {ok, Random} = case _assert_subject of
        {ok, _} -> _assert_subject;
        _assert_fail ->
            erlang:error(#{gleam_error => let_assert,
                        message => <<"Pattern match failed, no pattern matched the value."/utf8>>,
                        value => _assert_fail,
                        module => <<"gleam/list"/utf8>>,
                        function => <<"log_random"/utf8>>,
                        line => 2388})
    end,
    Random.

-file("/Users/louis/src/gleam/stdlib/src/gleam/list.gleam", 2360).
-spec sample_loop(
    list(ARW),
    gleam@dict:dict(integer(), ARW),
    integer(),
    integer(),
    float()
) -> gleam@dict:dict(integer(), ARW).
sample_loop(List, Reservoir, K, Index, W) ->
    Skip = begin
        _assert_subject = gleam@float:logarithm(1.0 - W),
        {ok, Log_result} = case _assert_subject of
            {ok, _} -> _assert_subject;
            _assert_fail ->
                erlang:error(#{gleam_error => let_assert,
                            message => <<"Pattern match failed, no pattern matched the value."/utf8>>,
                            value => _assert_fail,
                            module => <<"gleam/list"/utf8>>,
                            function => <<"sample_loop"/utf8>>,
                            line => 2368})
        end,
        _pipe = case Log_result of
            +0.0 -> +0.0;
            -0.0 -> -0.0;
            Gleam@denominator -> log_random() / Gleam@denominator
        end,
        _pipe@1 = math:floor(_pipe),
        erlang:round(_pipe@1)
    end,
    Index@1 = (Index + Skip) + 1,
    case drop(List, Skip) of
        [] ->
            Reservoir;

        [Elem | Rest] ->
            Reservoir@1 = begin
                _pipe@2 = gleam@int:random(K),
                gleam@dict:insert(Reservoir, _pipe@2, Elem)
            end,
            W@1 = W * math:exp(case erlang:float(K) of
                    +0.0 -> +0.0;
                    -0.0 -> -0.0;
                    Gleam@denominator@1 -> log_random() / Gleam@denominator@1
                end),
            sample_loop(Rest, Reservoir@1, K, Index@1, W@1)
    end.

-file("/Users/louis/src/gleam/stdlib/src/gleam/list.gleam", 2337).
-spec sample(list(ARS), integer()) -> list(ARS).
sample(List, K) ->
    case K =< 0 of
        true ->
            [];

        false ->
            {Reservoir, List@1} = split(List, K),
            case erlang:length(Reservoir) < K of
                true ->
                    Reservoir;

                false ->
                    Reservoir@1 = begin
                        _pipe = Reservoir,
                        _pipe@1 = map2(
                            range(0, K - 1),
                            _pipe,
                            fun(A, B) -> {A, B} end
                        ),
                        maps:from_list(_pipe@1)
                    end,
                    W = math:exp(case erlang:float(K) of
                            +0.0 -> +0.0;
                            -0.0 -> -0.0;
                            Gleam@denominator -> log_random() / Gleam@denominator
                        end),
                    _pipe@2 = sample_loop(List@1, Reservoir@1, K, K, W),
                    maps:values(_pipe@2)
            end
    end.
