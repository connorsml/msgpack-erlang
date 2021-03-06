%%
%% MessagePack for Erlang
%%
%% Copyright (C) 2009-2013 UENISHI Kota
%%
%%    Licensed under the Apache License, Version 2.0 (the "License");
%%    you may not use this file except in compliance with the License.
%%    You may obtain a copy of the License at
%%
%%        http://www.apache.org/licenses/LICENSE-2.0
%%
%%    Unless required by applicable law or agreed to in writing, software
%%    distributed under the License is distributed on an "AS IS" BASIS,
%%    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
%%    See the License for the specific language governing permissions and
%%    limitations under the License.
%%


-type msgpack_map_jsx() :: [{msgpack_term(), msgpack_term()}] | [{}].

-type msgpack_map_jiffy() :: {[{msgpack_term(), msgpack_term()}]}.

-type msgpack_map() :: msgpack_map_jsx() | msgpack_map_jiffy().

-type msgpack_map_unpacker() ::
        fun((binary(), non_neg_integer(), msgpack_map(), msgpack_option()) ->
                   {msgpack_map(), binary()} | no_return() ).

%% Erlang representation of msgpack data.
-type msgpack_term() :: [msgpack_term()] | msgpack_map_jsx() | msgpack_map_jiffy() | integer() | float() | binary().

-type msgpack_ext_packer() ::  fun((msgpack_term()) -> {ok, binary()} | {error, any()}).
-type msgpack_ext_unpacker() :: fun((byte(), binary()) -> {ok, msgpack_term()} | {error, any()}).

-type option() :: [jsx | jiffy | nif].

-record(options_v1, {
          interface = jiffy :: jiffy | jsx,
          map_unpack_fun = fun msgpack_unpacker:unpack_map_jiffy/4 ::
                                 msgpack_map_unpacker(),
          impl = erlang     :: erlang | nif
         }).

-record(options_v2, {
          interface = jiffy :: jiffy | jsx,
          map_unpack_fun = fun msgpack_unpacker:unpack_map_jiffy/4 ::
                                 msgpack_map_unpacker(),
          impl = erlang     :: erlang | nif,
          allow_atom = none :: none | pack, %% allows atom when packing
          enable_str = true :: boolean(), %% false for old spec
          ext_packer = undefined :: msgpack_ext_packer(),
          ext_unpacker = undefined :: msgpack_ext_unpacker()
         }).
-define(OPTION, #options_v2).
-type msgpack_option() :: #options_v2{}.

-type msgpack_list_options() :: [
                                 jsx | jiffy |
                                 {allow_atom, none|pack} |
                                 {enable_str, boolean()}
                                ].
