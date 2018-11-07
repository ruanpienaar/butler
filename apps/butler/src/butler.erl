-module(butler).

-export([main/1]).
-export([
    get_doc_root/0,
    set_doc_root/1
]).

-mode(compile).

main(loop) ->
    timer:sleep(250),
    main(loop);
main([]) ->
    % {ok, _} = dbg:tracer(),
    % {ok, _} = dbg:p(all, call),
    % {ok, _} = dbg:tpl(directory_h, cx),
    {ok, DocRoot} = file:get_cwd(),
    ok = application:load(sasl),    
    ok = application:load(butler),
    ok = set_doc_root(DocRoot),
    {ok, _} = application:ensure_all_started(butler),
    main(loop);
main([DocRoot]) when is_list(DocRoot) ->
    ok = application:load(sasl),
    ok = application:load(butler),
    ok = set_doc_root(DocRoot),
    {ok, _} = application:ensure_all_started(butler),
    main(loop).
    
get_doc_root() ->
    {ok, DocRoot} = application:get_env(butler, doc_root),
    DocRoot.

set_doc_root(DocRoot) ->
    io:format(standard_io, "Set butler DocRoot to ~p\n", [DocRoot]),
    application:set_env(butler, doc_root, DocRoot).
