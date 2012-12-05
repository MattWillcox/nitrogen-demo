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
        #p{},
    #span {text = "Current User: "},
    #span {style = "font-weight: bold;", text = CurrentUser},
    #p{},
    #link {show_if = (wf:user() /= undefined), text = "Click to Logout", postback = logout},
    #p{},
    #link {text = "Click here to access our top secrets (Twitter Page)", url = "/twitter"},
    #p{},
    #link {text = "Click here to access our top secrets (Features Page)", url = "/pizza"},
    #p{},
    #link {text = "Click here to access Comparisons (No restrictions)", url = "/written_comparison"}
        
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
        #p{},
	#span {text = "Current User: "},
	#span {style = "font-weight: bold;", text = CurrentUser},
	#p{},
	#link {show_if = (wf:user() /= undefined), text = "Click to Logout", postback = logout},
	#p{},
	#link {text = "Click here to access our top secrets (Twitter Page)", url = "/twitter"},
	#p{},
	#link {text = "Click here to access our top secrets (Features Page)", url = "/pizza"},
	#p{},
	#link {text = "Click here to access our top secrets (Chat Page)", url = "/chat"},
	#p{},
        #link {text = "Click here to access our top secrets (Tetris Test Page)", url = "/tetris"},
	#p{},
	#link {text = "Click here to access Comparisons (No restrictions)", url = "/written_comparison"}
        
    ].
