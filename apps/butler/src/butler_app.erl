-module(butler_app).

-behaviour(application).

%% Application callbacks
-export([start/2, stop/1]).

-include("butler.hrl").

%% ===================================================================
%% Application callbacks
%% ===================================================================

start(_StartType, _StartArgs) ->
    DocRoot = butler:get_doc_root(),
    Dispatch = cowboy_router:compile([
            {'_', [
                {"/[...]", cowboy_static, 

                    % {priv_dir, butler, "", [
                    %     {mimetypes, cow_mimetypes, all},
                    %     {dir_handler, directory_h}
                    % ]}
                    {dir, DocRoot, [
                        {dir_handler, directory_h}
                    ]}
                }
            ]}
        ]),
        {ok, _} = cowboy:start_clear(http, [{port, 8080}], #{
            env => #{dispatch => Dispatch},
            middlewares => [cowboy_router, directory_lister, cowboy_handler]
    }),
    butler_sup:start_link().

stop(_State) ->
    ok.
