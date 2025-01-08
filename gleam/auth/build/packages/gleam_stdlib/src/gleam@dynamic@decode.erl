-module(gleam@dynamic@decode).
-compile([no_auto_import, nowarn_unused_vars, nowarn_unused_function, nowarn_nomatch]).

-export([run/2, success/1, decode_dynamic/1, map/2, map_errors/2, then/2, one_of/2, recursive/1, decode_error/2, optional/1, collapse_errors/2, failure/2, new_primitive_decoder/2, dict/2, list/1, subfield/3, at/2, field/3, optional_field/4, optionally_at/3, decode_string/1, decode_bool/1, decode_int/1, decode_float/1, decode_bit_array/1]).
-export_type([decode_error/0, decoder/1]).

-type decode_error() :: {decode_error, binary(), binary(), list(binary())}.

-opaque decoder(DPT) :: {decoder,
        fun((gleam@dynamic:dynamic_()) -> {DPT, list(decode_error())})}.

-file("/Users/louis/src/gleam/stdlib/src/gleam/dynamic/decode.gleam", 348).
-spec run(gleam@dynamic:dynamic_(), decoder(DQB)) -> {ok, DQB} |
    {error, list(decode_error())}.
run(Data, Decoder) ->
    {Maybe_invalid_data, Errors} = (erlang:element(2, Decoder))(Data),
    case Errors of
        [] ->
            {ok, Maybe_invalid_data};

        _ ->
            {error, Errors}
    end.

-file("/Users/louis/src/gleam/stdlib/src/gleam/dynamic/decode.gleam", 474).
-spec success(DRC) -> decoder(DRC).
success(Data) ->
    {decoder, fun(_) -> {Data, []} end}.

-file("/Users/louis/src/gleam/stdlib/src/gleam/dynamic/decode.gleam", 689).
-spec decode_dynamic(gleam@dynamic:dynamic_()) -> {gleam@dynamic:dynamic_(),
    list(decode_error())}.
decode_dynamic(Data) ->
    {Data, []}.

-file("/Users/louis/src/gleam/stdlib/src/gleam/dynamic/decode.gleam", 843).
-spec map(decoder(DTQ), fun((DTQ) -> DTS)) -> decoder(DTS).
map(Decoder, Transformer) ->
    {decoder,
        fun(D) ->
            {Data, Errors} = (erlang:element(2, Decoder))(D),
            {Transformer(Data), Errors}
        end}.

-file("/Users/louis/src/gleam/stdlib/src/gleam/dynamic/decode.gleam", 852).
-spec map_errors(
    decoder(DTU),
    fun((list(decode_error())) -> list(decode_error()))
) -> decoder(DTU).
map_errors(Decoder, Transformer) ->
    {decoder,
        fun(D) ->
            {Data, Errors} = (erlang:element(2, Decoder))(D),
            {Data, Transformer(Errors)}
        end}.

-file("/Users/louis/src/gleam/stdlib/src/gleam/dynamic/decode.gleam", 890).
-spec then(decoder(DUC), fun((DUC) -> decoder(DUE))) -> decoder(DUE).
then(Decoder, Next) ->
    {decoder,
        fun(Dynamic_data) ->
            {Data, Errors} = (erlang:element(2, Decoder))(Dynamic_data),
            Decoder@1 = Next(Data),
            {Data@1, _} = Layer = (erlang:element(2, Decoder@1))(Dynamic_data),
            case Errors of
                [] ->
                    Layer;

                _ ->
                    {Data@1, Errors}
            end
        end}.

-file("/Users/louis/src/gleam/stdlib/src/gleam/dynamic/decode.gleam", 933).
-spec run_decoders(
    gleam@dynamic:dynamic_(),
    {DUM, list(decode_error())},
    list(decoder(DUM))
) -> {DUM, list(decode_error())}.
run_decoders(Data, Failure, Decoders) ->
    case Decoders of
        [] ->
            Failure;

        [Decoder | Decoders@1] ->
            {_, Errors} = Layer = (erlang:element(2, Decoder))(Data),
            case Errors of
                [] ->
                    Layer;

                _ ->
                    run_decoders(Data, Failure, Decoders@1)
            end
    end.

-file("/Users/louis/src/gleam/stdlib/src/gleam/dynamic/decode.gleam", 920).
-spec one_of(decoder(DUH), list(decoder(DUH))) -> decoder(DUH).
one_of(First, Alternatives) ->
    {decoder,
        fun(Dynamic_data) ->
            {_, Errors} = Layer = (erlang:element(2, First))(Dynamic_data),
            case Errors of
                [] ->
                    Layer;

                _ ->
                    run_decoders(Dynamic_data, Layer, Alternatives)
            end
        end}.

-file("/Users/louis/src/gleam/stdlib/src/gleam/dynamic/decode.gleam", 1022).
-spec recursive(fun(() -> decoder(DUX))) -> decoder(DUX).
recursive(Inner) ->
    {decoder,
        fun(Data) ->
            Decoder = Inner(),
            (erlang:element(2, Decoder))(Data)
        end}.

-file("/Users/louis/src/gleam/stdlib/src/gleam/dynamic/decode.gleam", 480).
-spec decode_error(binary(), gleam@dynamic:dynamic_()) -> list(decode_error()).
decode_error(Expected, Found) ->
    [{decode_error, Expected, gleam_stdlib:classify_dynamic(Found), []}].

-file("/Users/louis/src/gleam/stdlib/src/gleam/dynamic/decode.gleam", 817).
-spec optional(decoder(DTM)) -> decoder(gleam@option:option(DTM)).
optional(Inner) ->
    {decoder,
        fun(Data) ->
            case (gleam@dynamic:optional(fun(Field@0) -> {ok, Field@0} end))(
                Data
            ) of
                {ok, none} ->
                    {none, []};

                {ok, {some, Data@1}} ->
                    {Data@2, Errors} = (erlang:element(2, Inner))(Data@1),
                    {{some, Data@2}, Errors};

                {error, _} ->
                    {Data@3, Errors@1} = (erlang:element(2, Inner))(Data),
                    {{some, Data@3}, Errors@1}
            end
        end}.

-file("/Users/louis/src/gleam/stdlib/src/gleam/dynamic/decode.gleam", 876).
-spec collapse_errors(decoder(DTZ), binary()) -> decoder(DTZ).
collapse_errors(Decoder, Name) ->
    {decoder,
        fun(Dynamic_data) ->
            {Data, Errors} = Layer = (erlang:element(2, Decoder))(Dynamic_data),
            case Errors of
                [] ->
                    Layer;

                _ ->
                    {Data, decode_error(Name, Dynamic_data)}
            end
        end}.

-file("/Users/louis/src/gleam/stdlib/src/gleam/dynamic/decode.gleam", 954).
-spec failure(DUR, binary()) -> decoder(DUR).
failure(Zero, Expected) ->
    {decoder, fun(D) -> {Zero, decode_error(Expected, D)} end}.

-file("/Users/louis/src/gleam/stdlib/src/gleam/dynamic/decode.gleam", 986).
-spec new_primitive_decoder(
    binary(),
    fun((gleam@dynamic:dynamic_()) -> {ok, DUT} | {error, DUT})
) -> decoder(DUT).
new_primitive_decoder(Name, Decoding_function) ->
    {decoder, fun(D) -> case Decoding_function(D) of
                {ok, T} ->
                    {T, []};

                {error, Zero} ->
                    {Zero,
                        [{decode_error,
                                Name,
                                gleam_stdlib:classify_dynamic(D),
                                []}]}
            end end}.

-file("/Users/louis/src/gleam/stdlib/src/gleam/dynamic/decode.gleam", 771).
-spec fold_dict(
    {gleam@dict:dict(DSY, DSZ), list(decode_error())},
    gleam@dynamic:dynamic_(),
    gleam@dynamic:dynamic_(),
    fun((gleam@dynamic:dynamic_()) -> {DSY, list(decode_error())}),
    fun((gleam@dynamic:dynamic_()) -> {DSZ, list(decode_error())})
) -> {gleam@dict:dict(DSY, DSZ), list(decode_error())}.
fold_dict(Acc, Key, Value, Key_decoder, Value_decoder) ->
    case Key_decoder(Key) of
        {Key@1, []} ->
            case Value_decoder(Value) of
                {Value@1, []} ->
                    Dict = gleam@dict:insert(
                        erlang:element(1, Acc),
                        Key@1,
                        Value@1
                    ),
                    {Dict, erlang:element(2, Acc)};

                {_, Errors} ->
                    push_path({maps:new(), Errors}, [<<"values"/utf8>>])
            end;

        {_, Errors@1} ->
            push_path({maps:new(), Errors@1}, [<<"keys"/utf8>>])
    end.

-file("/Users/louis/src/gleam/stdlib/src/gleam/dynamic/decode.gleam", 751).
-spec dict(decoder(DSR), decoder(DST)) -> decoder(gleam@dict:dict(DSR, DST)).
dict(Key, Value) ->
    {decoder, fun(Data) -> case gleam_stdlib_decode_ffi:dict(Data) of
                {error, _} ->
                    {maps:new(), decode_error(<<"Dict"/utf8>>, Data)};

                {ok, Dict} ->
                    gleam@dict:fold(
                        Dict,
                        {maps:new(), []},
                        fun(A, K, V) -> case erlang:element(2, A) of
                                [] ->
                                    fold_dict(
                                        A,
                                        K,
                                        V,
                                        erlang:element(2, Key),
                                        erlang:element(2, Value)
                                    );

                                _ ->
                                    A
                            end end
                    )
            end end}.

-file("/Users/louis/src/gleam/stdlib/src/gleam/dynamic/decode.gleam", 719).
-spec list(decoder(DSF)) -> decoder(list(DSF)).
list(Inner) ->
    {decoder,
        fun(Data) ->
            gleam_stdlib_decode_ffi:list(
                Data,
                erlang:element(2, Inner),
                fun(P, K) -> push_path(P, [K]) end,
                0,
                []
            )
        end}.

-file("/Users/louis/src/gleam/stdlib/src/gleam/dynamic/decode.gleam", 430).
-spec push_path({DQX, list(decode_error())}, list(any())) -> {DQX,
    list(decode_error())}.
push_path(Layer, Path) ->
    Decoder = gleam@dynamic:any(
        [fun gleam@dynamic:string/1,
            fun(X) ->
                gleam@result:map(
                    gleam@dynamic:int(X),
                    fun erlang:integer_to_binary/1
                )
            end]
    ),
    Path@1 = gleam@list:map(
        Path,
        fun(Key) ->
            Key@1 = gleam_stdlib:identity(Key),
            case Decoder(Key@1) of
                {ok, Key@2} ->
                    Key@2;

                {error, _} ->
                    <<<<"<"/utf8,
                            (gleam_stdlib:classify_dynamic(Key@1))/binary>>/binary,
                        ">"/utf8>>
            end
        end
    ),
    Errors = gleam@list:map(
        erlang:element(2, Layer),
        fun(Error) -> _record = Error,
            {decode_error,
                erlang:element(2, _record),
                erlang:element(3, _record),
                lists:append(Path@1, erlang:element(4, Error))} end
    ),
    {erlang:element(1, Layer), Errors}.

-file("/Users/louis/src/gleam/stdlib/src/gleam/dynamic/decode.gleam", 395).
-spec index(
    list(DQL),
    list(DQL),
    fun((gleam@dynamic:dynamic_()) -> {DQO, list(decode_error())}),
    gleam@dynamic:dynamic_(),
    fun((gleam@dynamic:dynamic_(), list(DQL)) -> {DQO, list(decode_error())})
) -> {DQO, list(decode_error())}.
index(Path, Position, Inner, Data, Handle_miss) ->
    case Path of
        [] ->
            _pipe = Inner(Data),
            push_path(_pipe, lists:reverse(Position));

        [Key | Path@1] ->
            case gleam_stdlib_decode_ffi:strict_index(Data, Key) of
                {ok, {some, Data@1}} ->
                    index(Path@1, [Key | Position], Inner, Data@1, Handle_miss);

                {ok, none} ->
                    Handle_miss(Data, [Key | Position]);

                {error, Kind} ->
                    {Default, _} = Inner(Data),
                    _pipe@1 = {Default,
                        [{decode_error,
                                Kind,
                                gleam_stdlib:classify_dynamic(Data),
                                []}]},
                    push_path(_pipe@1, lists:reverse(Position))
            end
    end.

-file("/Users/louis/src/gleam/stdlib/src/gleam/dynamic/decode.gleam", 316).
-spec subfield(list(any()), decoder(DPW), fun((DPW) -> decoder(DPY))) -> decoder(DPY).
subfield(Field_path, Field_decoder, Next) ->
    {decoder,
        fun(Data) ->
            {Out, Errors1} = index(
                Field_path,
                [],
                erlang:element(2, Field_decoder),
                Data,
                fun(Data@1, Position) ->
                    {Default, _} = (erlang:element(2, Field_decoder))(Data@1),
                    _pipe = {Default,
                        [{decode_error,
                                <<"Field"/utf8>>,
                                <<"Nothing"/utf8>>,
                                []}]},
                    push_path(_pipe, lists:reverse(Position))
                end
            ),
            {Out@1, Errors2} = (erlang:element(2, Next(Out)))(Data),
            {Out@1, lists:append(Errors1, Errors2)}
        end}.

-file("/Users/louis/src/gleam/stdlib/src/gleam/dynamic/decode.gleam", 385).
-spec at(list(any()), decoder(DQI)) -> decoder(DQI).
at(Path, Inner) ->
    {decoder,
        fun(Data) ->
            index(
                Path,
                [],
                erlang:element(2, Inner),
                Data,
                fun(Data@1, Position) ->
                    {Default, _} = (erlang:element(2, Inner))(Data@1),
                    _pipe = {Default,
                        [{decode_error,
                                <<"Field"/utf8>>,
                                <<"Nothing"/utf8>>,
                                []}]},
                    push_path(_pipe, lists:reverse(Position))
                end
            )
        end}.

-file("/Users/louis/src/gleam/stdlib/src/gleam/dynamic/decode.gleam", 519).
-spec field(any(), decoder(DRG), fun((DRG) -> decoder(DRI))) -> decoder(DRI).
field(Field_name, Field_decoder, Next) ->
    subfield([Field_name], Field_decoder, Next).

-file("/Users/louis/src/gleam/stdlib/src/gleam/dynamic/decode.gleam", 552).
-spec optional_field(any(), DRM, decoder(DRM), fun((DRM) -> decoder(DRO))) -> decoder(DRO).
optional_field(Key, Default, Field_decoder, Next) ->
    {decoder,
        fun(Data) ->
            {Out, Errors1} = case gleam_stdlib_decode_ffi:strict_index(
                Data,
                Key
            ) of
                {ok, {some, Data@1}} ->
                    (erlang:element(2, Field_decoder))(Data@1);

                {ok, none} ->
                    {Default, []};

                {error, Kind} ->
                    _pipe = {Default,
                        [{decode_error,
                                Kind,
                                gleam_stdlib:classify_dynamic(Data),
                                []}]},
                    push_path(_pipe, [Key])
            end,
            {Out@1, Errors2} = (erlang:element(2, Next(Out)))(Data),
            {Out@1, lists:append(Errors1, Errors2)}
        end}.

-file("/Users/louis/src/gleam/stdlib/src/gleam/dynamic/decode.gleam", 593).
-spec optionally_at(list(any()), DRT, decoder(DRT)) -> decoder(DRT).
optionally_at(Path, Default, Inner) ->
    {decoder,
        fun(Data) ->
            index(
                Path,
                [],
                erlang:element(2, Inner),
                Data,
                fun(_, _) -> {Default, []} end
            )
        end}.

-file("/Users/louis/src/gleam/stdlib/src/gleam/dynamic/decode.gleam", 603).
-spec run_dynamic_function(
    gleam@dynamic:dynamic_(),
    DRW,
    fun((gleam@dynamic:dynamic_()) -> {ok, DRW} |
        {error, list(gleam@dynamic:decode_error())})
) -> {DRW, list(decode_error())}.
run_dynamic_function(Data, Zero, F) ->
    case F(Data) of
        {ok, Data@1} ->
            {Data@1, []};

        {error, Errors} ->
            Errors@1 = gleam@list:map(
                Errors,
                fun(E) ->
                    {decode_error,
                        erlang:element(2, E),
                        erlang:element(3, E),
                        erlang:element(4, E)}
                end
            ),
            {Zero, Errors@1}
    end.

-file("/Users/louis/src/gleam/stdlib/src/gleam/dynamic/decode.gleam", 629).
-spec decode_string(gleam@dynamic:dynamic_()) -> {binary(),
    list(decode_error())}.
decode_string(Data) ->
    run_dynamic_function(Data, <<""/utf8>>, fun gleam@dynamic:string/1).

-file("/Users/louis/src/gleam/stdlib/src/gleam/dynamic/decode.gleam", 644).
-spec decode_bool(gleam@dynamic:dynamic_()) -> {boolean(), list(decode_error())}.
decode_bool(Data) ->
    run_dynamic_function(Data, false, fun gleam@dynamic:bool/1).

-file("/Users/louis/src/gleam/stdlib/src/gleam/dynamic/decode.gleam", 659).
-spec decode_int(gleam@dynamic:dynamic_()) -> {integer(), list(decode_error())}.
decode_int(Data) ->
    run_dynamic_function(Data, 0, fun gleam@dynamic:int/1).

-file("/Users/louis/src/gleam/stdlib/src/gleam/dynamic/decode.gleam", 674).
-spec decode_float(gleam@dynamic:dynamic_()) -> {float(), list(decode_error())}.
decode_float(Data) ->
    run_dynamic_function(Data, +0.0, fun gleam@dynamic:float/1).

-file("/Users/louis/src/gleam/stdlib/src/gleam/dynamic/decode.gleam", 704).
-spec decode_bit_array(gleam@dynamic:dynamic_()) -> {bitstring(),
    list(decode_error())}.
decode_bit_array(Data) ->
    run_dynamic_function(Data, <<>>, fun gleam@dynamic:bit_array/1).
