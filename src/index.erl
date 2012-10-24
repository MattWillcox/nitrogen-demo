%% -*- mode: nitrogen -*-
-module (index).
-compile(export_all).
-include_lib("nitrogen_core/include/wf.hrl").

main() -> #template { file="./site/templates/bare.html" }.

title() -> "Home Page".

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
        #h1 {text = "Welcome to Our Demo Home Page"},
        #p{},
	#span {text = "Current User: "},
	#span {style = "font-weight: bold;", text = CurrentUser},
	#p{},
	#link {show_if = (wf:user() /= undefined), text = "Click to Logout", postback = logout},
	#p{},
	#link {text = "Click here to access our top secrets", url = "/twitter"},
	#p{},
	#link {text = "Click here to access Comparisons", url = "/written_comparison"}
        
    ].
	
event(logout) ->
	wf:clear_session(),
	wf:redirect("/index").
