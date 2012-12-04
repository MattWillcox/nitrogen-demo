%% -*- mode: nitrogen -*-
-module (tetris).
-compile(export_all).
-include_lib("nitrogen_core/include/wf.hrl").
-include("records.hrl").

main() -> #template { file="./site/templates/tetris.html" }.


title() -> "Href Tetris".
headline() -> "Href Tetris-Comet test".


body() -> 

	wf:comet_global(fun() -> comet_loop() end, my_pool),

    [
	#p{},
        #button{id=action,postback=some_event,text="Test"},
	#button{id=action,postback=comet_event,text="Send"},
	#button{id=action,postback=test_event,text="COMET"},
	#panel{ id=placeholder,class=placeholder},
	#p{}
        
    ].
	

event(some_event) ->
	wf:wire("test++"), %%Increatment test
	wf:wire("textfield.textContent = test");


event(comet_event) ->

    wf:send_global(my_pool, {message, "Clicked"});

event(test_event) ->
%% trying to reference var test in the Template file 
    %%message = wf:q(test),
	message = test,
    wf:send_global(my_pool, {message, "CometT"}); 

event(_) -> ok.

comet_loop() ->
    receive 
	{message, "CometT"} -> 
	    wf:wire("textfield.textContent = obj('message')"),
	    wf:insert_bottom(placeholder, "Comet"),
	wf:wire("obj('placeholder').scrollTop = obj('placeholder').scrollHeight;"),

	wf:flush();

	{message, "Clicked"} ->
            wf:wire("test = test+10"),
	    wf:wire("textfield.textContent = test"),
	    wf:insert_bottom(placeholder, "Clicked"),
	wf:wire("obj('placeholder').scrollTop = obj('placeholder').scrollHeight;"),

	wf:flush()
    end,
comet_loop().  


