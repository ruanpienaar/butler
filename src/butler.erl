-module(butler).

-export([main/1]).
-export([
    get_port/0,
    get_doc_root/0,
    set_doc_root/1,
    set_port/1
]).

-mode(compile).

main(loop) ->
    timer:sleep(250),
    main(loop);
main([]) ->
    {ok, DocRoot} = file:get_cwd(),
    ok = application:load(sasl),    
    ok = application:load(butler),
    ok = set_doc_root(DocRoot),
    ok = set_port(8080),
    {ok, _} = butler_app:start(),
    main(loop);
main([DocRoot]) when is_list(DocRoot) ->
    main([DocRoot, "8080"]);
main([DocRoot, Port]) ->
    %% TODO: use a erlang getopt to solve the arg checking
    PortInt = try
        list_to_integer(Port)
    catch
        _C:_E ->
            io:format("Port ~p is not a valid Port\n", [Port]),
            timer:sleep(25),
            erlang:halt(1)
    end,
    ok = set_port(PortInt),
    case filelib:is_dir(DocRoot) of
        false ->
            io:format("DocRoot ~p is not a valid Directory\n", [DocRoot]),
            timer:sleep(25),
            erlang:halt(1);
        true ->
            ok
    end,
    ok = application:load(sasl),
    ok = application:load(butler),
    ok = set_doc_root(DocRoot),
    {ok, _} = butler_app:start(),
    main(loop).

get_port() ->
    {ok, Port} = application:get_env(butler, port),
    Port.
    
get_doc_root() ->
    {ok, DocRoot} = application:get_env(butler, doc_root),
    DocRoot.

set_doc_root(DocRoot) when is_list(DocRoot) ->
    io:format(standard_io, "Set butler DocRoot to ~p\n", [DocRoot]),
    application:set_env(butler, doc_root, DocRoot).

set_port(Port) when is_integer(Port) ->
    io:format(standard_io, "Set butler Port to ~p\n", [Port]),
    application:set_env(butler, port, Port).