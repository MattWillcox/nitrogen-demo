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
	        #h1 {text = "Password Reset (not implemented!)"},
	        #label {text = "Please enter your Email address"},
	        #textbox { id=idTextbox, class=idTextbox, text="", next = secretAnswerTextbox},
	        #br{},
	        #label {text= "Security Question: When is your birthday (yyyyMMdd)?"},
	        #textbox { id=secretAnswerTextbox, text="", next=resetButton},
	        #button { id=resetPassword, text = "Reset Password", postback=reset},
	        #br{},
			#flash{},
	        #link { id=linkToMain, text="Back to main page", postback=toMain }
	        ]
	    }

    ].

event(reset) ->
	Email = wf:q(idTextbox),
	Answer = wf:q(secretAnswerTextbox),
    case usr:resetPassword(Email,Answer) of
		{error, Reason} -> wf:wire(#alert{text=Reason});
		{success, NewPassword} -> 
		    wf:wire(resetPassword, #hide{} ),
		    wf:wire(linkToMain, #show{} ),
		    Message = "Your password has been reset! Your new password is :" ++ NewPassword,
		    wf:flash( Message )
	end;


event(toMain) ->
    wf:redirect("/main");

event(_) -> ok.

