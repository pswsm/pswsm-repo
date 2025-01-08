-module(timestamps).
-compile([no_auto_import, nowarn_unused_vars, nowarn_unused_function, nowarn_nomatch]).

-export([new/0, from_millis/1, add_hours/2, value_of/1, is_after/2, is_future/1, to_string/1]).
-export_type([timestamp/0]).

-opaque timestamp() :: {timestamp, integer()}.

-file("/home/pswsm/code/timestamps/src/timestamps.gleam", 18).
-spec new() -> timestamp().
new() ->
    {timestamp, os:system_time(millisecond)}.

-file("/home/pswsm/code/timestamps/src/timestamps.gleam", 29).
-spec from_millis(integer()) -> timestamp().
from_millis(Millis) ->
    {timestamp, Millis}.

-file("/home/pswsm/code/timestamps/src/timestamps.gleam", 41).
-spec add_hours(timestamp(), integer()) -> timestamp().
add_hours(Timestamp, Hours) ->
    {timestamp, erlang:element(2, Timestamp) + (((Hours * 60) * 60) * 1000)}.

-file("/home/pswsm/code/timestamps/src/timestamps.gleam", 69).
-spec value_of(timestamp()) -> integer().
value_of(T) ->
    erlang:element(2, T).

-file("/home/pswsm/code/timestamps/src/timestamps.gleam", 53).
-spec is_after(timestamp(), timestamp()) -> boolean().
is_after(T1, T2) ->
    value_of(T1) > value_of(T2).

-file("/home/pswsm/code/timestamps/src/timestamps.gleam", 64).
-spec is_future(timestamp()) -> boolean().
is_future(T) ->
    _pipe = T,
    is_after(_pipe, new()).

-file("/home/pswsm/code/timestamps/src/timestamps.gleam", 74).
-spec to_string(timestamp()) -> binary().
to_string(T) ->
    gleam@int:to_string(erlang:element(2, T)).
