%% -*- mode: nitrogen -*-
-module (webgl).
-compile(export_all).
-include_lib("nitrogen_core/include/wf.hrl").
-include("records.hrl").

main() -> #template { file="./site/templates/webgl.html" }.

title() -> "Hello from webgl.erl!".

body() -> 
	wf:comet_global(fun() -> chat_loop() end, myroom),
	wf:wire("var GameMode = 4;"),
	%%wf:wire("var Testing;"),
	wf:wire(#api {name=testAPI, tag=fun1}),
	wf:wire(#api {name=testAPI2, tag=fun2}),
	wf:wire(#api {name=testAPI3, tag=fun3}),
	wf:wire(#api {name=testAPI4, tag=fun4}),
	wf:wire(#api {name=testAPI5, tag=fun5}),
	wf:wire(#api {name=testAPI6, tag=fun6}),
	wf:wire(#api {name=testAPI7, tag=fun7}),
	wf:wire(#api {name=testAPI8, tag=fun8}),
	wf:wire(#api {name=testAPI9, tag=fun9}),
	wf:wire(#api {name=testAPI10, tag=fun10}),
	wf:wire(#api {name=testAPI11, tag=fun11}),
	wf:wire(#api {name=testAPI12, tag=fun12}),

	wf:wire(#api {name=testAPI13, tag=fun13}),%%link with attack function
	#panel{
                body=[
                        "<a onclick=\"page.testAPI(GameID);\">TTTTTT</a><br>"

                ]
        }.

api_event(testAPI, _, [TheList]) ->
        %%wf:flash(wf:f("The GameID is ~p~n", [TheList]));
	wf:wire(wf:f("Testing= ~p~n", [TheList])),
	wf:wire(";");
	%%wf:send_global(myroom, {msg,[TheList],"ID1"});

api_event(testAPI2, _,[TheList]) ->
	%%wf:wire(wf:f("Testing2= ~p~n", [TheList])),
	%%wf:wire(";").
	wf:send_global(myroom, {msg,[TheList],"ID2"});
api_event(testAPI3, _,[TheList]) ->
	
	wf:send_global(myroom, {msg,[TheList],"ID3"});
api_event(testAPI4, _,[TheList]) ->
	
	wf:send_global(myroom, {msg,[TheList],"ID4"});
api_event(testAPI5, _,[TheList]) ->
	
	wf:send_global(myroom, {msg,[TheList],"ID12"});
api_event(testAPI6, _,[TheList]) ->
	
	wf:send_global(myroom, {msg,[TheList],"ID22"});
api_event(testAPI7, _,[TheList]) ->
	
	wf:send_global(myroom, {msg,[TheList],"ID32"});
api_event(testAPI8, _,[TheList]) ->

	wf:send_global(myroom, {msg,[TheList],"ID42"});
api_event(testAPI9, _,[TheList]) ->

	wf:send_global(myroom, {msg,[TheList],"ID13"});
api_event(testAPI10, _,[TheList]) ->

	wf:send_global(myroom, {msg,[TheList],"ID23"});
api_event(testAPI11, _,[TheList]) ->

	wf:send_global(myroom, {msg,[TheList],"ID33"});

api_event(testAPI12, _,[TheList]) ->

	wf:send_global(myroom, {msg,[TheList],"ID43"});

api_event(testAPI13, _,[TheList]) ->
	wf:send_global(myroom, {msg,[TheList],"Attack"}).


event(_) -> ok.

chat_loop() ->
    receive 
        'INIT' ->
            wf:flush();
        {msg, Msg, "ID1"} ->
	    %%TD = wf:to_integer(wf:coalesce(Msg)),
	    %%TD = [wf:to_integer(wf:coalesce(Msg))+wf:to_integer(wf:coalesce(Msg))],
	    %%wf:wire("count = count + Msg;"),
	    %%wf:wire("count++;"),
	    %%wf:flash(wf:f("The count is ~p~n", TD)),
	    %%wf:flash(wf:f("var count2= ~p~n", Msg)),
		wf:wire(wf:f("Testing2= ~p~n", Msg)),
		wf:wire(";"),
            %%wf:flash(wf:f("The count is ~p~n", Msg)),
            wf:flush();
	{msg, Msg, "ID2"} ->
		wf:wire(wf:f("Testing2= ~p~n", Msg)),
		wf:wire(";"),
            wf:flush();
	{msg, Msg, "ID3"} ->
		wf:wire(wf:f("Testing2= ~p~n", Msg)),
		wf:wire(";"),
            wf:flush();
	{msg, Msg, "ID4"} ->
		wf:wire(wf:f("Testing2= ~p~n", Msg)),
		wf:wire(";"),
            wf:flush();
	{msg, Msg, "ID12"} ->
		wf:wire(wf:f("Testing2= ~p~n", Msg)),
		wf:wire(";"),
            wf:flush();
	{msg, Msg, "ID22"} ->
		wf:wire(wf:f("Testing2= ~p~n", Msg)),
		wf:wire(";"),
            wf:flush();
	{msg, Msg, "ID32"} ->
		wf:wire(wf:f("Testing2= ~p~n", Msg)),
		wf:wire(";"),
            wf:flush();
	{msg, Msg, "ID42"} ->
		wf:wire(wf:f("Testing2= ~p~n", Msg)),
		wf:wire(";"),
            wf:flush();
	{msg, Msg, "ID13"} ->
		wf:wire(wf:f("Testing2= ~p~n", Msg)),
		wf:wire(";"),
            wf:flush();
	{msg, Msg, "ID23"} ->
		wf:wire(wf:f("Testing2= ~p~n", Msg)),
		wf:wire(";"),
            wf:flush();
	{msg, Msg, "ID33"} ->
		wf:wire(wf:f("Testing2= ~p~n", Msg)),
		wf:wire(";"),
            wf:flush();
	{msg, Msg, "ID43"} ->
		wf:wire(wf:f("Testing2= ~p~n", Msg)),
		wf:wire(";"),
            wf:flush();
	{msg, Msg, "Attack"} ->
		wf:wire(wf:f("Testing2= ~p~n", Msg)),
		wf:wire(";"),
            wf:flush()
    end,
chat_loop(). 
