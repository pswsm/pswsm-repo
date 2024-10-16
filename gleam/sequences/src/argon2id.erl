-module(argon2id).

-export([hash/1, verify/2]).

-nifs([{hash, 1}, {verify, 2}]).

-on_load init/0.

init() ->
    ok = erlang:load_nif("priv/libargon2id_ffi", 0).

hash(string) ->
    exit(nif_library_not_loaded).

verify(string, string) ->
    exit(nif_library_not_loaded).
