%% Reset password
-module (password).
-compile(export_all).
-include_lib("nitrogen_core/include/wf.hrl").

main() -> #template { file="./site/templates/bare.html" }.

title() -> "href Tetris".


body() ->
    [
	    #panel{
	        body=[
	        #h1 {text = "Password Reset"},
	        #label {text = "Please enter your Email address"},
	        #textbox { id=idTextbox, class=idTextbox, text=""},
	        #p{},
	        
	        #button { id=resetPassword, text = "Reset Password", postback=reset},
	        #br{}
	        ]
	    },
	    #flash{}
    ].

event(reset) ->
    wf:wire(registerButton, #hide{} ),
    wf:flash( "Your password has been reset!" ),
    timer:sleep(1000),
    wf:redirect("/main");

event(_) -> ok.

