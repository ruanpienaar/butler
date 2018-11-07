-module(butler_app).

-behaviour(application).

%% Application callbacks
-export([start/2, stop/1]).

-include("butler.hrl").

%% ===================================================================
%% Application callbacks
%% ===================================================================

start(_StartType, _StartArgs) ->
    butler_sup:start_link().

stop(_State) ->
    ok.
