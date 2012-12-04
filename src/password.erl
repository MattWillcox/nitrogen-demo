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

random_string(Len) ->
    Chrs = list_to_tuple("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"),
    F = fun(_, R) -> [element(random:uniform(size(Chrs)), Chrs) | R] end,
    lists:foldl(F, "", lists:seq(1, Len)).

event(reset) ->
	Usr = wf:q(idTextbox),
	Answer = wf:q(secretAnswerTextbox),
	Salt = mochihex:to_hex(erlang:md5(Usr)),
	NewRandomPassword = random_string(10),
	HashedPassword = mochihex:to_hex(erlang:md5(Salt ++ NewRandomPassword)),
	HashedAnswer = mochihex:to_hex(erlang:md5(Salt ++ Answer)),

    case usr:resetPassword(Usr,HashedPassword,HashedAnswer) of
		{error, Reason} -> wf:wire(#alert{text=Reason});
		ID when is_integer(ID) -> 
		    wf:wire(resetPassword, #hide{} ),
		    wf:wire(linkToMain, #show{} ),
		    Message = "Your password has been reset! Your new password is :" ++ NewRandomPassword,
		    wf:flash( Message )
	end;


event(toMain) ->
    wf:redirect("/main");

event(_) -> ok.

