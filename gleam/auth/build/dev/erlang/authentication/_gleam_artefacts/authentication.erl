-module(authentication).
-compile([no_auto_import, nowarn_unused_vars, nowarn_unused_function, nowarn_nomatch]).

-export([main/0]).

-file("/home/pswsm/code/pswsm-repo/gleam/auth/src/authentication.gleam", 4).
-spec main() -> gleam@erlang@process:selector(any()).
main() ->
    _ = gleam_erlang_ffi:new_selector().
