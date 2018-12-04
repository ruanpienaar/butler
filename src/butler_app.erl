-module(butler_app).

-behaviour(application).

%% Application callbacks
-export([
    start/0,
    start/2, 
    stop/1
]).

-include("butler.hrl").

%% ===================================================================
%% Application callbacks
%% ===================================================================

start() ->
    {ok, _} = application:ensure_all_started(butler).

start(_StartType, _StartArgs) ->
    Port = butler:get_port(),
    DocRoot = butler:get_doc_root(),
    Dispatch = cowboy_router:compile([
        %% TODO: read entries from sys.config for routing data
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
    {ok, _} = cowboy:start_clear(http, [{port, Port}], #{
        env => #{dispatch => Dispatch},
        middlewares => [cowboy_router, directory_lister, cowboy_handler]
    }),
    {ok, SupPid} = butler_sup:start_link(),
        S=
"
 ____  _    _ _ ______ _      ______ _____  
|  _ \\ | |  | | __   __| |    |  ____|  __ \\ 
| |_)  | |  | |  | |   | |    | |__  | |__) |
|  _ < | |  | |  | |   | |    |  __| |  _  / 
| |_)  | |__| |  | |   | |____| |____| | \\ \\ 
|____/ \\______/  |_|   |______|______|_|  \\_\\
                                           
   Started on port ~p                      
   DocRoot ~p                              \n
",
    io:format(S, [Port, DocRoot]),
    {ok, SupPid}.

stop(_State) ->
    ok.