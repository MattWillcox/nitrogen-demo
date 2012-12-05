%% -*- mode: nitrogen -*-
-module (tetris).
-compile(export_all).
-include_lib("nitrogen_core/include/wf.hrl").
-include("records.hrl").

main() -> #template { file="./site/templates/bare.html" }.


title() -> "Href Tetris".
headline() -> "Href Tetris-Comet test".

body() ->
	wf:comet_global(fun() -> chat_loop() end, myroom),
	wf:wire(#api {name=testAPI, tag=fun1}),
	wf:wire(#api {name=testAPI2, tag=fun2}),
        wf:wire("var count = [5,6,7,8];"),
	wf:wire("var count2 = 0;"),
        #panel{
                body=[
                        #flash{},
                        #p{},
                        "<a onclick=\"page.testAPI(count);\">Count up</a><br>",
			"<a onclick=\"page.testAPI2(count);\">Send Through Comet</a><br>",
			"<p id=TT>~~</p>"
                ]
        }.


api_event(testAPI, _, [TheList]) ->
        wf:flash(wf:f("The count is ~p~n", [TheList]));

api_event(testAPI2, _,[TheList]) ->
	wf:send_global(myroom, {msg,[TheList]}).

event(_) -> ok.

chat_loop() ->
    receive 
        'INIT' ->
            wf:flush();
        {msg, Msg} ->
	    %%TD = wf:to_integer(wf:coalesce(Msg)),
	    %%TD = [wf:to_integer(wf:coalesce(Msg))+wf:to_integer(wf:coalesce(Msg))],
	    %%wf:wire("count = count + Msg;"),
	    %%wf:wire("count++;"),
	    %%wf:flash(wf:f("The count is ~p~n", TD)),
	    wf:flash(wf:f("var count2= ~p~n", Msg)),
		wf:wire(wf:f("count2= ~p~n", Msg)),
wf:wire(";"),
            %%wf:flash(wf:f("The count is ~p~n", Msg)),
            wf:flush()
    end,
chat_loop(). 


