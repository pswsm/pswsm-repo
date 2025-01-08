-module(gleam@erlang@os).
-compile([no_auto_import, nowarn_unused_vars, nowarn_unused_function, nowarn_nomatch]).

-export([family/0]).
-export_type([os_family/0]).

-type os_family() :: windows_nt | linux | darwin | free_bsd | {other, binary()}.

-file("/home/pswsm/code/pswsm-repo/gleam/auth/build/packages/gleam_erlang/src/gleam/erlang/os.gleam", 36).
-spec family() -> os_family().
family() ->
    gleam_erlang_ffi:os_family().
