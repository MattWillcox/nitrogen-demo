%% -*- mode: nitrogen -*-
-module (index).
-compile(export_all).
-include_lib("nitrogen_core/include/wf.hrl").

main() -> #template { file="./site/templates/bare.html" }.

title() -> "Home Page".

head()->"<title>TTTTT</title>".

body() ->
    #container_12 { body=[
        #grid_8 { alpha=true, prefix=2, suffix=2, omega=true, body=inner_body() }
    ]}.

inner_body() -> 
    CurrentUser = case wf:user() of
        undefined -> "(Anonymous)";
        Other -> Other
    end,
    [
        #h1 {text = "Welcome to Our Demo Home Page!"},
        #p{}   
    ].
    
event(logout) ->
    wf:clear_session(),
    wf:redirect("/index"),

	CurrentUser = case wf:user() of
		undefined -> "(Anonymous)";
		Other -> Other
	end,
    [
        #h1 {text = "Welcome to Our Demo Home Page"},
        #p{}
    ].
