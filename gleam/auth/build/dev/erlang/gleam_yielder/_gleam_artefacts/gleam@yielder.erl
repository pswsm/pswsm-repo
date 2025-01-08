-module(gleam@yielder).
-compile([no_auto_import, nowarn_unused_vars, nowarn_unused_function, nowarn_nomatch]).

-export([unfold/2, repeatedly/1, repeat/1, from_list/1, transform/3, fold/3, run/1, to_list/1, step/1, take/2, drop/2, map/2, map2/3, append/2, flatten/1, concat/1, flat_map/2, filter/2, filter_map/2, cycle/1, find/2, find_map/2, index/1, iterate/2, take_while/2, drop_while/2, scan/3, zip/2, chunk/2, sized_chunk/2, intersperse/2, any/2, all/2, group/2, reduce/2, last/1, empty/0, once/1, range/2, single/1, interleave/2, fold_until/3, try_fold/3, first/1, at/2, length/1, each/2, yield/2, prepend/2]).
-export_type([action/1, yielder/1, step/2, chunk/2, sized_chunk/1]).

-type action(VA) :: stop | {continue, VA, fun(() -> action(VA))}.

-opaque yielder(VB) :: {yielder, fun(() -> action(VB))}.

-type step(VC, VD) :: {next, VC, VD} | done.

-type chunk(VE, VF) :: {another_by, list(VE), VF, VE, fun(() -> action(VE))} |
    {last_by, list(VE)}.

-type sized_chunk(VG) :: {another, list(VG), fun(() -> action(VG))} |
    {last, list(VG)} |
    no_more.

-file("/home/pswsm/code/pswsm-repo/gleam/auth/build/packages/gleam_yielder/src/gleam/yielder.gleam", 37).
-spec stop() -> action(any()).
stop() ->
    stop.

-file("/home/pswsm/code/pswsm-repo/gleam/auth/build/packages/gleam_yielder/src/gleam/yielder.gleam", 72).
-spec unfold_loop(VO, fun((VO) -> step(VP, VO))) -> fun(() -> action(VP)).
unfold_loop(Initial, F) ->
    fun() -> case F(Initial) of
            {next, X, Acc} ->
                {continue, X, unfold_loop(Acc, F)};

            done ->
                stop
        end end.

-file("/home/pswsm/code/pswsm-repo/gleam/auth/build/packages/gleam_yielder/src/gleam/yielder.gleam", 62).
-spec unfold(VJ, fun((VJ) -> step(VK, VJ))) -> yielder(VK).
unfold(Initial, F) ->
    _pipe = Initial,
    _pipe@1 = unfold_loop(_pipe, F),
    {yielder, _pipe@1}.

-file("/home/pswsm/code/pswsm-repo/gleam/auth/build/packages/gleam_yielder/src/gleam/yielder.gleam", 94).
-spec repeatedly(fun(() -> VT)) -> yielder(VT).
repeatedly(F) ->
    unfold(nil, fun(_) -> {next, F(), nil} end).

-file("/home/pswsm/code/pswsm-repo/gleam/auth/build/packages/gleam_yielder/src/gleam/yielder.gleam", 109).
-spec repeat(VV) -> yielder(VV).
repeat(X) ->
    repeatedly(fun() -> X end).

-file("/home/pswsm/code/pswsm-repo/gleam/auth/build/packages/gleam_yielder/src/gleam/yielder.gleam", 123).
-spec from_list(list(VX)) -> yielder(VX).
from_list(List) ->
    Yield = fun(Acc) -> case Acc of
            [] ->
                done;

            [Head | Tail] ->
                {next, Head, Tail}
        end end,
    unfold(List, Yield).

-file("/home/pswsm/code/pswsm-repo/gleam/auth/build/packages/gleam_yielder/src/gleam/yielder.gleam", 134).
-spec transform_loop(fun(() -> action(WA)), WC, fun((WC, WA) -> step(WD, WC))) -> fun(() -> action(WD)).
transform_loop(Continuation, State, F) ->
    fun() -> case Continuation() of
            stop ->
                stop;

            {continue, El, Next} ->
                case F(State, El) of
                    done ->
                        stop;

                    {next, Yield, Next_state} ->
                        {continue, Yield, transform_loop(Next, Next_state, F)}
                end
        end end.

-file("/home/pswsm/code/pswsm-repo/gleam/auth/build/packages/gleam_yielder/src/gleam/yielder.gleam", 169).
-spec transform(yielder(WH), WJ, fun((WJ, WH) -> step(WK, WJ))) -> yielder(WK).
transform(Yielder, Initial, F) ->
    _pipe = transform_loop(erlang:element(2, Yielder), Initial, F),
    {yielder, _pipe}.

-file("/home/pswsm/code/pswsm-repo/gleam/auth/build/packages/gleam_yielder/src/gleam/yielder.gleam", 204).
-spec fold_loop(fun(() -> action(WR)), fun((WT, WR) -> WT), WT) -> WT.
fold_loop(Continuation, F, Accumulator) ->
    case Continuation() of
        {continue, Elem, Next} ->
            fold_loop(Next, F, F(Accumulator, Elem));

        stop ->
            Accumulator
    end.

-file("/home/pswsm/code/pswsm-repo/gleam/auth/build/packages/gleam_yielder/src/gleam/yielder.gleam", 195).
-spec fold(yielder(WO), WQ, fun((WQ, WO) -> WQ)) -> WQ.
fold(Yielder, Initial, F) ->
    _pipe = erlang:element(2, Yielder),
    fold_loop(_pipe, F, Initial).

-file("/home/pswsm/code/pswsm-repo/gleam/auth/build/packages/gleam_yielder/src/gleam/yielder.gleam", 220).
-spec run(yielder(any())) -> nil.
run(Yielder) ->
    fold(Yielder, nil, fun(_, _) -> nil end).

-file("/home/pswsm/code/pswsm-repo/gleam/auth/build/packages/gleam_yielder/src/gleam/yielder.gleam", 238).
-spec to_list(yielder(WW)) -> list(WW).
to_list(Yielder) ->
    _pipe = Yielder,
    _pipe@1 = fold(_pipe, [], fun(Acc, E) -> [E | Acc] end),
    lists:reverse(_pipe@1).

-file("/home/pswsm/code/pswsm-repo/gleam/auth/build/packages/gleam_yielder/src/gleam/yielder.gleam", 266).
-spec step(yielder(WZ)) -> step(WZ, yielder(WZ)).
step(Yielder) ->
    case (erlang:element(2, Yielder))() of
        stop ->
            done;

        {continue, E, A} ->
            {next, E, {yielder, A}}
    end.

-file("/home/pswsm/code/pswsm-repo/gleam/auth/build/packages/gleam_yielder/src/gleam/yielder.gleam", 299).
-spec take_loop(fun(() -> action(XH)), integer()) -> fun(() -> action(XH)).
take_loop(Continuation, Desired) ->
    fun() -> case Desired > 0 of
            false ->
                stop;

            true ->
                case Continuation() of
                    stop ->
                        stop;

                    {continue, E, Next} ->
                        {continue, E, take_loop(Next, Desired - 1)}
                end
        end end.

-file("/home/pswsm/code/pswsm-repo/gleam/auth/build/packages/gleam_yielder/src/gleam/yielder.gleam", 293).
-spec take(yielder(XE), integer()) -> yielder(XE).
take(Yielder, Desired) ->
    _pipe = erlang:element(2, Yielder),
    _pipe@1 = take_loop(_pipe, Desired),
    {yielder, _pipe@1}.

-file("/home/pswsm/code/pswsm-repo/gleam/auth/build/packages/gleam_yielder/src/gleam/yielder.gleam", 342).
-spec drop_loop(fun(() -> action(XN)), integer()) -> action(XN).
drop_loop(Continuation, Desired) ->
    case Continuation() of
        stop ->
            stop;

        {continue, E, Next} ->
            case Desired > 0 of
                true ->
                    drop_loop(Next, Desired - 1);

                false ->
                    {continue, E, Next}
            end
    end.

-file("/home/pswsm/code/pswsm-repo/gleam/auth/build/packages/gleam_yielder/src/gleam/yielder.gleam", 337).
-spec drop(yielder(XK), integer()) -> yielder(XK).
drop(Yielder, Desired) ->
    _pipe = fun() -> drop_loop(erlang:element(2, Yielder), Desired) end,
    {yielder, _pipe}.

-file("/home/pswsm/code/pswsm-repo/gleam/auth/build/packages/gleam_yielder/src/gleam/yielder.gleam", 376).
-spec map_loop(fun(() -> action(XU)), fun((XU) -> XW)) -> fun(() -> action(XW)).
map_loop(Continuation, F) ->
    fun() -> case Continuation() of
            stop ->
                stop;

            {continue, E, Continuation@1} ->
                {continue, F(E), map_loop(Continuation@1, F)}
        end end.

-file("/home/pswsm/code/pswsm-repo/gleam/auth/build/packages/gleam_yielder/src/gleam/yielder.gleam", 370).
-spec map(yielder(XQ), fun((XQ) -> XS)) -> yielder(XS).
map(Yielder, F) ->
    _pipe = erlang:element(2, Yielder),
    _pipe@1 = map_loop(_pipe, F),
    {yielder, _pipe@1}.

-file("/home/pswsm/code/pswsm-repo/gleam/auth/build/packages/gleam_yielder/src/gleam/yielder.gleam", 417).
-spec map2_loop(
    fun(() -> action(YE)),
    fun(() -> action(YG)),
    fun((YE, YG) -> YI)
) -> fun(() -> action(YI)).
map2_loop(Continuation1, Continuation2, Fun) ->
    fun() -> case Continuation1() of
            stop ->
                stop;

            {continue, A, Next_a} ->
                case Continuation2() of
                    stop ->
                        stop;

                    {continue, B, Next_b} ->
                        {continue, Fun(A, B), map2_loop(Next_a, Next_b, Fun)}
                end
        end end.

-file("/home/pswsm/code/pswsm-repo/gleam/auth/build/packages/gleam_yielder/src/gleam/yielder.gleam", 408).
-spec map2(yielder(XY), yielder(YA), fun((XY, YA) -> YC)) -> yielder(YC).
map2(Yielder1, Yielder2, Fun) ->
    _pipe = map2_loop(
        erlang:element(2, Yielder1),
        erlang:element(2, Yielder2),
        Fun
    ),
    {yielder, _pipe}.

-file("/home/pswsm/code/pswsm-repo/gleam/auth/build/packages/gleam_yielder/src/gleam/yielder.gleam", 454).
-spec append_loop(fun(() -> action(YO)), fun(() -> action(YO))) -> action(YO).
append_loop(First, Second) ->
    case First() of
        {continue, E, First@1} ->
            {continue, E, fun() -> append_loop(First@1, Second) end};

        stop ->
            Second()
    end.

-file("/home/pswsm/code/pswsm-repo/gleam/auth/build/packages/gleam_yielder/src/gleam/yielder.gleam", 449).
-spec append(yielder(YK), yielder(YK)) -> yielder(YK).
append(First, Second) ->
    _pipe = fun() ->
        append_loop(erlang:element(2, First), erlang:element(2, Second))
    end,
    {yielder, _pipe}.

-file("/home/pswsm/code/pswsm-repo/gleam/auth/build/packages/gleam_yielder/src/gleam/yielder.gleam", 481).
-spec flatten_loop(fun(() -> action(yielder(YW)))) -> action(YW).
flatten_loop(Flattened) ->
    case Flattened() of
        stop ->
            stop;

        {continue, It, Next_yielder} ->
            append_loop(
                erlang:element(2, It),
                fun() -> flatten_loop(Next_yielder) end
            )
    end.

-file("/home/pswsm/code/pswsm-repo/gleam/auth/build/packages/gleam_yielder/src/gleam/yielder.gleam", 476).
-spec flatten(yielder(yielder(YS))) -> yielder(YS).
flatten(Yielder) ->
    _pipe = fun() -> flatten_loop(erlang:element(2, Yielder)) end,
    {yielder, _pipe}.

-file("/home/pswsm/code/pswsm-repo/gleam/auth/build/packages/gleam_yielder/src/gleam/yielder.gleam", 504).
-spec concat(list(yielder(AAA))) -> yielder(AAA).
concat(Yielders) ->
    flatten(from_list(Yielders)).

-file("/home/pswsm/code/pswsm-repo/gleam/auth/build/packages/gleam_yielder/src/gleam/yielder.gleam", 526).
-spec flat_map(yielder(AAE), fun((AAE) -> yielder(AAG))) -> yielder(AAG).
flat_map(Yielder, F) ->
    _pipe = Yielder,
    _pipe@1 = map(_pipe, F),
    flatten(_pipe@1).

-file("/home/pswsm/code/pswsm-repo/gleam/auth/build/packages/gleam_yielder/src/gleam/yielder.gleam", 562).
-spec filter_loop(fun(() -> action(AAM)), fun((AAM) -> boolean())) -> action(AAM).
filter_loop(Continuation, Predicate) ->
    case Continuation() of
        stop ->
            stop;

        {continue, E, Yielder} ->
            case Predicate(E) of
                true ->
                    {continue, E, fun() -> filter_loop(Yielder, Predicate) end};

                false ->
                    filter_loop(Yielder, Predicate)
            end
    end.

-file("/home/pswsm/code/pswsm-repo/gleam/auth/build/packages/gleam_yielder/src/gleam/yielder.gleam", 554).
-spec filter(yielder(AAJ), fun((AAJ) -> boolean())) -> yielder(AAJ).
filter(Yielder, Predicate) ->
    _pipe = fun() -> filter_loop(erlang:element(2, Yielder), Predicate) end,
    {yielder, _pipe}.

-file("/home/pswsm/code/pswsm-repo/gleam/auth/build/packages/gleam_yielder/src/gleam/yielder.gleam", 606).
-spec filter_map_loop(
    fun(() -> action(AAW)),
    fun((AAW) -> {ok, AAY} | {error, any()})
) -> action(AAY).
filter_map_loop(Continuation, F) ->
    case Continuation() of
        stop ->
            stop;

        {continue, E, Next} ->
            case F(E) of
                {ok, E@1} ->
                    {continue, E@1, fun() -> filter_map_loop(Next, F) end};

                {error, _} ->
                    filter_map_loop(Next, F)
            end
    end.

-file("/home/pswsm/code/pswsm-repo/gleam/auth/build/packages/gleam_yielder/src/gleam/yielder.gleam", 598).
-spec filter_map(yielder(AAP), fun((AAP) -> {ok, AAR} | {error, any()})) -> yielder(AAR).
filter_map(Yielder, F) ->
    _pipe = fun() -> filter_map_loop(erlang:element(2, Yielder), F) end,
    {yielder, _pipe}.

-file("/home/pswsm/code/pswsm-repo/gleam/auth/build/packages/gleam_yielder/src/gleam/yielder.gleam", 632).
-spec cycle(yielder(ABD)) -> yielder(ABD).
cycle(Yielder) ->
    _pipe = repeat(Yielder),
    flatten(_pipe).

-file("/home/pswsm/code/pswsm-repo/gleam/auth/build/packages/gleam_yielder/src/gleam/yielder.gleam", 709).
-spec find_loop(fun(() -> action(ABL)), fun((ABL) -> boolean())) -> {ok, ABL} |
    {error, nil}.
find_loop(Continuation, F) ->
    case Continuation() of
        stop ->
            {error, nil};

        {continue, E, Next} ->
            case F(E) of
                true ->
                    {ok, E};

                false ->
                    find_loop(Next, F)
            end
    end.

-file("/home/pswsm/code/pswsm-repo/gleam/auth/build/packages/gleam_yielder/src/gleam/yielder.gleam", 701).
-spec find(yielder(ABH), fun((ABH) -> boolean())) -> {ok, ABH} | {error, nil}.
find(Haystack, Is_desired) ->
    _pipe = erlang:element(2, Haystack),
    find_loop(_pipe, Is_desired).

-file("/home/pswsm/code/pswsm-repo/gleam/auth/build/packages/gleam_yielder/src/gleam/yielder.gleam", 754).
-spec find_map_loop(
    fun(() -> action(ABX)),
    fun((ABX) -> {ok, ABZ} | {error, any()})
) -> {ok, ABZ} | {error, nil}.
find_map_loop(Continuation, F) ->
    case Continuation() of
        stop ->
            {error, nil};

        {continue, E, Next} ->
            case F(E) of
                {ok, E@1} ->
                    {ok, E@1};

                {error, _} ->
                    find_map_loop(Next, F)
            end
    end.

-file("/home/pswsm/code/pswsm-repo/gleam/auth/build/packages/gleam_yielder/src/gleam/yielder.gleam", 746).
-spec find_map(yielder(ABP), fun((ABP) -> {ok, ABR} | {error, any()})) -> {ok,
        ABR} |
    {error, nil}.
find_map(Haystack, Is_desired) ->
    _pipe = erlang:element(2, Haystack),
    find_map_loop(_pipe, Is_desired).

-file("/home/pswsm/code/pswsm-repo/gleam/auth/build/packages/gleam_yielder/src/gleam/yielder.gleam", 783).
-spec index_loop(fun(() -> action(ACI)), integer()) -> fun(() -> action({ACI,
    integer()})).
index_loop(Continuation, Next) ->
    fun() -> case Continuation() of
            stop ->
                stop;

            {continue, E, Continuation@1} ->
                {continue, {E, Next}, index_loop(Continuation@1, Next + 1)}
        end end.

-file("/home/pswsm/code/pswsm-repo/gleam/auth/build/packages/gleam_yielder/src/gleam/yielder.gleam", 777).
-spec index(yielder(ACF)) -> yielder({ACF, integer()}).
index(Yielder) ->
    _pipe = erlang:element(2, Yielder),
    _pipe@1 = index_loop(_pipe, 0),
    {yielder, _pipe@1}.

-file("/home/pswsm/code/pswsm-repo/gleam/auth/build/packages/gleam_yielder/src/gleam/yielder.gleam", 805).
-spec iterate(ACL, fun((ACL) -> ACL)) -> yielder(ACL).
iterate(Initial, F) ->
    unfold(Initial, fun(Element) -> {next, Element, F(Element)} end).

-file("/home/pswsm/code/pswsm-repo/gleam/auth/build/packages/gleam_yielder/src/gleam/yielder.gleam", 832).
-spec take_while_loop(fun(() -> action(ACQ)), fun((ACQ) -> boolean())) -> fun(() -> action(ACQ)).
take_while_loop(Continuation, Predicate) ->
    fun() -> case Continuation() of
            stop ->
                stop;

            {continue, E, Next} ->
                case Predicate(E) of
                    false ->
                        stop;

                    true ->
                        {continue, E, take_while_loop(Next, Predicate)}
                end
        end end.

-file("/home/pswsm/code/pswsm-repo/gleam/auth/build/packages/gleam_yielder/src/gleam/yielder.gleam", 823).
-spec take_while(yielder(ACN), fun((ACN) -> boolean())) -> yielder(ACN).
take_while(Yielder, Predicate) ->
    _pipe = erlang:element(2, Yielder),
    _pipe@1 = take_while_loop(_pipe, Predicate),
    {yielder, _pipe@1}.

-file("/home/pswsm/code/pswsm-repo/gleam/auth/build/packages/gleam_yielder/src/gleam/yielder.gleam", 868).
-spec drop_while_loop(fun(() -> action(ACW)), fun((ACW) -> boolean())) -> action(ACW).
drop_while_loop(Continuation, Predicate) ->
    case Continuation() of
        stop ->
            stop;

        {continue, E, Next} ->
            case Predicate(E) of
                false ->
                    {continue, E, Next};

                true ->
                    drop_while_loop(Next, Predicate)
            end
    end.

-file("/home/pswsm/code/pswsm-repo/gleam/auth/build/packages/gleam_yielder/src/gleam/yielder.gleam", 860).
-spec drop_while(yielder(ACT), fun((ACT) -> boolean())) -> yielder(ACT).
drop_while(Yielder, Predicate) ->
    _pipe = fun() -> drop_while_loop(erlang:element(2, Yielder), Predicate) end,
    {yielder, _pipe}.

-file("/home/pswsm/code/pswsm-repo/gleam/auth/build/packages/gleam_yielder/src/gleam/yielder.gleam", 906).
-spec scan_loop(fun(() -> action(ADD)), fun((ADF, ADD) -> ADF), ADF) -> fun(() -> action(ADF)).
scan_loop(Continuation, F, Accumulator) ->
    fun() -> case Continuation() of
            stop ->
                stop;

            {continue, El, Next} ->
                Accumulated = F(Accumulator, El),
                {continue, Accumulated, scan_loop(Next, F, Accumulated)}
        end end.

-file("/home/pswsm/code/pswsm-repo/gleam/auth/build/packages/gleam_yielder/src/gleam/yielder.gleam", 896).
-spec scan(yielder(ACZ), ADB, fun((ADB, ACZ) -> ADB)) -> yielder(ADB).
scan(Yielder, Initial, F) ->
    _pipe = erlang:element(2, Yielder),
    _pipe@1 = scan_loop(_pipe, F, Initial),
    {yielder, _pipe@1}.

-file("/home/pswsm/code/pswsm-repo/gleam/auth/build/packages/gleam_yielder/src/gleam/yielder.gleam", 939).
-spec zip_loop(fun(() -> action(ADM)), fun(() -> action(ADO))) -> fun(() -> action({ADM,
    ADO})).
zip_loop(Left, Right) ->
    fun() -> case Left() of
            stop ->
                stop;

            {continue, El_left, Next_left} ->
                case Right() of
                    stop ->
                        stop;

                    {continue, El_right, Next_right} ->
                        {continue,
                            {El_left, El_right},
                            zip_loop(Next_left, Next_right)}
                end
        end end.

-file("/home/pswsm/code/pswsm-repo/gleam/auth/build/packages/gleam_yielder/src/gleam/yielder.gleam", 934).
-spec zip(yielder(ADH), yielder(ADJ)) -> yielder({ADH, ADJ}).
zip(Left, Right) ->
    _pipe = zip_loop(erlang:element(2, Left), erlang:element(2, Right)),
    {yielder, _pipe}.

-file("/home/pswsm/code/pswsm-repo/gleam/auth/build/packages/gleam_yielder/src/gleam/yielder.gleam", 1000).
-spec next_chunk(fun(() -> action(AEB)), fun((AEB) -> AED), AED, list(AEB)) -> chunk(AEB, AED).
next_chunk(Continuation, F, Previous_key, Current_chunk) ->
    case Continuation() of
        stop ->
            {last_by, lists:reverse(Current_chunk)};

        {continue, E, Next} ->
            Key = F(E),
            case Key =:= Previous_key of
                true ->
                    next_chunk(Next, F, Key, [E | Current_chunk]);

                false ->
                    {another_by, lists:reverse(Current_chunk), Key, E, Next}
            end
    end.

-file("/home/pswsm/code/pswsm-repo/gleam/auth/build/packages/gleam_yielder/src/gleam/yielder.gleam", 987).
-spec chunk_loop(fun(() -> action(ADW)), fun((ADW) -> ADY), ADY, ADW) -> action(list(ADW)).
chunk_loop(Continuation, F, Previous_key, Previous_element) ->
    case next_chunk(Continuation, F, Previous_key, [Previous_element]) of
        {last_by, Chunk} ->
            {continue, Chunk, fun stop/0};

        {another_by, Chunk@1, Key, El, Next} ->
            {continue, Chunk@1, fun() -> chunk_loop(Next, F, Key, El) end}
    end.

-file("/home/pswsm/code/pswsm-repo/gleam/auth/build/packages/gleam_yielder/src/gleam/yielder.gleam", 974).
-spec chunk(yielder(ADR), fun((ADR) -> any())) -> yielder(list(ADR)).
chunk(Yielder, F) ->
    _pipe = fun() -> case (erlang:element(2, Yielder))() of
            stop ->
                stop;

            {continue, E, Next} ->
                chunk_loop(Next, F, F(E), E)
        end end,
    {yielder, _pipe}.

-file("/home/pswsm/code/pswsm-repo/gleam/auth/build/packages/gleam_yielder/src/gleam/yielder.gleam", 1071).
-spec next_sized_chunk(fun(() -> action(AEP)), integer(), list(AEP)) -> sized_chunk(AEP).
next_sized_chunk(Continuation, Left, Current_chunk) ->
    case Continuation() of
        stop ->
            case Current_chunk of
                [] ->
                    no_more;

                Remaining ->
                    {last, lists:reverse(Remaining)}
            end;

        {continue, E, Next} ->
            Chunk = [E | Current_chunk],
            case Left > 1 of
                false ->
                    {another, lists:reverse(Chunk), Next};

                true ->
                    next_sized_chunk(Next, Left - 1, Chunk)
            end
    end.

-file("/home/pswsm/code/pswsm-repo/gleam/auth/build/packages/gleam_yielder/src/gleam/yielder.gleam", 1050).
-spec sized_chunk_loop(fun(() -> action(AEL)), integer()) -> fun(() -> action(list(AEL))).
sized_chunk_loop(Continuation, Count) ->
    fun() -> case next_sized_chunk(Continuation, Count, []) of
            no_more ->
                stop;

            {last, Chunk} ->
                {continue, Chunk, fun stop/0};

            {another, Chunk@1, Next_element} ->
                {continue, Chunk@1, sized_chunk_loop(Next_element, Count)}
        end end.

-file("/home/pswsm/code/pswsm-repo/gleam/auth/build/packages/gleam_yielder/src/gleam/yielder.gleam", 1041).
-spec sized_chunk(yielder(AEH), integer()) -> yielder(list(AEH)).
sized_chunk(Yielder, Count) ->
    _pipe = erlang:element(2, Yielder),
    _pipe@1 = sized_chunk_loop(_pipe, Count),
    {yielder, _pipe@1}.

-file("/home/pswsm/code/pswsm-repo/gleam/auth/build/packages/gleam_yielder/src/gleam/yielder.gleam", 1131).
-spec intersperse_loop(fun(() -> action(AEW)), AEW) -> action(AEW).
intersperse_loop(Continuation, Separator) ->
    case Continuation() of
        stop ->
            stop;

        {continue, E, Next} ->
            Next_interspersed = fun() -> intersperse_loop(Next, Separator) end,
            {continue, Separator, fun() -> {continue, E, Next_interspersed} end}
    end.

-file("/home/pswsm/code/pswsm-repo/gleam/auth/build/packages/gleam_yielder/src/gleam/yielder.gleam", 1118).
-spec intersperse(yielder(AET), AET) -> yielder(AET).
intersperse(Yielder, Elem) ->
    _pipe = fun() -> case (erlang:element(2, Yielder))() of
            stop ->
                stop;

            {continue, E, Next} ->
                {continue, E, fun() -> intersperse_loop(Next, Elem) end}
        end end,
    {yielder, _pipe}.

-file("/home/pswsm/code/pswsm-repo/gleam/auth/build/packages/gleam_yielder/src/gleam/yielder.gleam", 1179).
-spec any_loop(fun(() -> action(AFB)), fun((AFB) -> boolean())) -> boolean().
any_loop(Continuation, Predicate) ->
    case Continuation() of
        stop ->
            false;

        {continue, E, Next} ->
            case Predicate(E) of
                true ->
                    true;

                false ->
                    any_loop(Next, Predicate)
            end
    end.

-file("/home/pswsm/code/pswsm-repo/gleam/auth/build/packages/gleam_yielder/src/gleam/yielder.gleam", 1171).
-spec any(yielder(AEZ), fun((AEZ) -> boolean())) -> boolean().
any(Yielder, Predicate) ->
    _pipe = erlang:element(2, Yielder),
    any_loop(_pipe, Predicate).

-file("/home/pswsm/code/pswsm-repo/gleam/auth/build/packages/gleam_yielder/src/gleam/yielder.gleam", 1228).
-spec all_loop(fun(() -> action(AFF)), fun((AFF) -> boolean())) -> boolean().
all_loop(Continuation, Predicate) ->
    case Continuation() of
        stop ->
            true;

        {continue, E, Next} ->
            case Predicate(E) of
                true ->
                    all_loop(Next, Predicate);

                false ->
                    false
            end
    end.

-file("/home/pswsm/code/pswsm-repo/gleam/auth/build/packages/gleam_yielder/src/gleam/yielder.gleam", 1220).
-spec all(yielder(AFD), fun((AFD) -> boolean())) -> boolean().
all(Yielder, Predicate) ->
    _pipe = erlang:element(2, Yielder),
    all_loop(_pipe, Predicate).

-file("/home/pswsm/code/pswsm-repo/gleam/auth/build/packages/gleam_yielder/src/gleam/yielder.gleam", 1273).
-spec update_group_with(AFV) -> fun((gleam@option:option(list(AFV))) -> list(AFV)).
update_group_with(El) ->
    fun(Maybe_group) -> case Maybe_group of
            {some, Group} ->
                [El | Group];

            none ->
                [El]
        end end.

-file("/home/pswsm/code/pswsm-repo/gleam/auth/build/packages/gleam_yielder/src/gleam/yielder.gleam", 1264).
-spec group_updater(fun((AFN) -> AFO)) -> fun((gleam@dict:dict(AFO, list(AFN)), AFN) -> gleam@dict:dict(AFO, list(AFN))).
group_updater(F) ->
    fun(Groups, Elem) -> _pipe = Groups,
        gleam@dict:upsert(_pipe, F(Elem), update_group_with(Elem)) end.

-file("/home/pswsm/code/pswsm-repo/gleam/auth/build/packages/gleam_yielder/src/gleam/yielder.gleam", 1255).
-spec group(yielder(AFH), fun((AFH) -> AFJ)) -> gleam@dict:dict(AFJ, list(AFH)).
group(Yielder, Key) ->
    _pipe = Yielder,
    _pipe@1 = fold(_pipe, maps:new(), group_updater(Key)),
    gleam@dict:map_values(_pipe@1, fun(_, Group) -> lists:reverse(Group) end).

-file("/home/pswsm/code/pswsm-repo/gleam/auth/build/packages/gleam_yielder/src/gleam/yielder.gleam", 1303).
-spec reduce(yielder(AFZ), fun((AFZ, AFZ) -> AFZ)) -> {ok, AFZ} | {error, nil}.
reduce(Yielder, F) ->
    case (erlang:element(2, Yielder))() of
        stop ->
            {error, nil};

        {continue, E, Next} ->
            _pipe = fold_loop(Next, F, E),
            {ok, _pipe}
    end.

-file("/home/pswsm/code/pswsm-repo/gleam/auth/build/packages/gleam_yielder/src/gleam/yielder.gleam", 1330).
-spec last(yielder(AGD)) -> {ok, AGD} | {error, nil}.
last(Yielder) ->
    _pipe = Yielder,
    reduce(_pipe, fun(_, Elem) -> Elem end).

-file("/home/pswsm/code/pswsm-repo/gleam/auth/build/packages/gleam_yielder/src/gleam/yielder.gleam", 1344).
-spec empty() -> yielder(any()).
empty() ->
    {yielder, fun stop/0}.

-file("/home/pswsm/code/pswsm-repo/gleam/auth/build/packages/gleam_yielder/src/gleam/yielder.gleam", 1357).
-spec once(fun(() -> AGJ)) -> yielder(AGJ).
once(F) ->
    _pipe = fun() -> {continue, F(), fun stop/0} end,
    {yielder, _pipe}.

-file("/home/pswsm/code/pswsm-repo/gleam/auth/build/packages/gleam_yielder/src/gleam/yielder.gleam", 657).
-spec range(integer(), integer()) -> yielder(integer()).
range(Start, Stop) ->
    case gleam@int:compare(Start, Stop) of
        eq ->
            once(fun() -> Start end);

        gt ->
            unfold(Start, fun(Current) -> case Current < Stop of
                        false ->
                            {next, Current, Current - 1};

                        true ->
                            done
                    end end);

        lt ->
            unfold(Start, fun(Current@1) -> case Current@1 > Stop of
                        false ->
                            {next, Current@1, Current@1 + 1};

                        true ->
                            done
                    end end)
    end.

-file("/home/pswsm/code/pswsm-repo/gleam/auth/build/packages/gleam_yielder/src/gleam/yielder.gleam", 1371).
-spec single(AGL) -> yielder(AGL).
single(Elem) ->
    once(fun() -> Elem end).

-file("/home/pswsm/code/pswsm-repo/gleam/auth/build/packages/gleam_yielder/src/gleam/yielder.gleam", 1402).
-spec interleave_loop(fun(() -> action(AGR)), fun(() -> action(AGR))) -> action(AGR).
interleave_loop(Current, Next) ->
    case Current() of
        stop ->
            Next();

        {continue, E, Next_other} ->
            {continue, E, fun() -> interleave_loop(Next, Next_other) end}
    end.

-file("/home/pswsm/code/pswsm-repo/gleam/auth/build/packages/gleam_yielder/src/gleam/yielder.gleam", 1394).
-spec interleave(yielder(AGN), yielder(AGN)) -> yielder(AGN).
interleave(Left, Right) ->
    _pipe = fun() ->
        interleave_loop(erlang:element(2, Left), erlang:element(2, Right))
    end,
    {yielder, _pipe}.

-file("/home/pswsm/code/pswsm-repo/gleam/auth/build/packages/gleam_yielder/src/gleam/yielder.gleam", 1446).
-spec fold_until_loop(
    fun(() -> action(AGZ)),
    fun((AHB, AGZ) -> gleam@list:continue_or_stop(AHB)),
    AHB
) -> AHB.
fold_until_loop(Continuation, F, Accumulator) ->
    case Continuation() of
        stop ->
            Accumulator;

        {continue, Elem, Next} ->
            case F(Accumulator, Elem) of
                {continue, Accumulator@1} ->
                    fold_until_loop(Next, F, Accumulator@1);

                {stop, Accumulator@2} ->
                    Accumulator@2
            end
    end.

-file("/home/pswsm/code/pswsm-repo/gleam/auth/build/packages/gleam_yielder/src/gleam/yielder.gleam", 1437).
-spec fold_until(
    yielder(AGV),
    AGX,
    fun((AGX, AGV) -> gleam@list:continue_or_stop(AGX))
) -> AGX.
fold_until(Yielder, Initial, F) ->
    _pipe = erlang:element(2, Yielder),
    fold_until_loop(_pipe, F, Initial).

-file("/home/pswsm/code/pswsm-repo/gleam/auth/build/packages/gleam_yielder/src/gleam/yielder.gleam", 1489).
-spec try_fold_loop(
    fun(() -> action(AHL)),
    fun((AHN, AHL) -> {ok, AHN} | {error, AHO}),
    AHN
) -> {ok, AHN} | {error, AHO}.
try_fold_loop(Continuation, F, Accumulator) ->
    case Continuation() of
        stop ->
            {ok, Accumulator};

        {continue, Elem, Next} ->
            case F(Accumulator, Elem) of
                {ok, Result} ->
                    try_fold_loop(Next, F, Result);

                {error, _} = Error ->
                    Error
            end
    end.

-file("/home/pswsm/code/pswsm-repo/gleam/auth/build/packages/gleam_yielder/src/gleam/yielder.gleam", 1480).
-spec try_fold(yielder(AHD), AHF, fun((AHF, AHD) -> {ok, AHF} | {error, AHG})) -> {ok,
        AHF} |
    {error, AHG}.
try_fold(Yielder, Initial, F) ->
    _pipe = erlang:element(2, Yielder),
    try_fold_loop(_pipe, F, Initial).

-file("/home/pswsm/code/pswsm-repo/gleam/auth/build/packages/gleam_yielder/src/gleam/yielder.gleam", 1519).
-spec first(yielder(AHT)) -> {ok, AHT} | {error, nil}.
first(Yielder) ->
    case (erlang:element(2, Yielder))() of
        stop ->
            {error, nil};

        {continue, E, _} ->
            {ok, E}
    end.

-file("/home/pswsm/code/pswsm-repo/gleam/auth/build/packages/gleam_yielder/src/gleam/yielder.gleam", 1549).
-spec at(yielder(AHX), integer()) -> {ok, AHX} | {error, nil}.
at(Yielder, Index) ->
    _pipe = Yielder,
    _pipe@1 = drop(_pipe, Index),
    first(_pipe@1).

-file("/home/pswsm/code/pswsm-repo/gleam/auth/build/packages/gleam_yielder/src/gleam/yielder.gleam", 1577).
-spec length_loop(fun(() -> action(any())), integer()) -> integer().
length_loop(Continuation, Length) ->
    case Continuation() of
        stop ->
            Length;

        {continue, _, Next} ->
            length_loop(Next, Length + 1)
    end.

-file("/home/pswsm/code/pswsm-repo/gleam/auth/build/packages/gleam_yielder/src/gleam/yielder.gleam", 1572).
-spec length(yielder(any())) -> integer().
length(Yielder) ->
    _pipe = erlang:element(2, Yielder),
    length_loop(_pipe, 0).

-file("/home/pswsm/code/pswsm-repo/gleam/auth/build/packages/gleam_yielder/src/gleam/yielder.gleam", 1601).
-spec each(yielder(AIF), fun((AIF) -> any())) -> nil.
each(Yielder, F) ->
    _pipe = Yielder,
    _pipe@1 = map(_pipe, F),
    run(_pipe@1).

-file("/home/pswsm/code/pswsm-repo/gleam/auth/build/packages/gleam_yielder/src/gleam/yielder.gleam", 1629).
-spec yield(AII, fun(() -> yielder(AII))) -> yielder(AII).
yield(Element, Next) ->
    {yielder,
        fun() ->
            {continue, Element, fun() -> (erlang:element(2, Next()))() end}
        end}.

-file("/home/pswsm/code/pswsm-repo/gleam/auth/build/packages/gleam_yielder/src/gleam/yielder.gleam", 1644).
-spec prepend(yielder(AIL), AIL) -> yielder(AIL).
prepend(Yielder, Element) ->
    yield(Element, fun() -> Yielder end).
