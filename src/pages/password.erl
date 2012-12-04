%% Reset password
-module (password).
-compile(export_all).
-include_lib("nitrogen_core/include/wf.hrl").

main() -> #template { file="./site/templates/beta.html" }.

title() -> "href Tetris".


body() ->
    Body = [
    	#container_12 {
    		body = [
		        #grid_12 { style = "border: 10px solid grey; text-align: center;", body = [ 
		                #singlerow {style="width: 920px;", cells=[
		            #tablecell { align=center, body=#link { text="Home", url = "/beta" }},
		            #tablecell { align=center, body=#link { text="Leaderboard", url = "/leaderboard" }},
		            #tablecell { align=center, body=#link { text="Profile", url = "/profile"}},
		            #tablecell { align=center, body=#link { text="Friends", url = "/beta" }},
		            #tablecell { align=center, body=#link { text="Chat", url = "/beta" }},
		            #tablecell { align=center, body=#link { text="Logout", postback = logout}}
		        ]}]},


		 		#grid_clear{},
		        #grid_12 {
			        body=[
				        #h1 {text = "Password Reset"},
				        #label {text = "Please enter your Email address"},
				        #textbox { id=idTextbox, class=idTextbox, text="", next = secretAnswerTextbox},
				        #br{},
				        #label {text= "Security Question: When is your birthday (yyyyMMdd)?"},
				        #textbox { id=secretAnswerTextbox, text="", next=resetButton},
				        #button { id=resetPassword, text = "Reset Password", postback=reset},
				        #br{},
						#flash{}
			        ]
			    }
		    ]
	    }

    ],

    Body.

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

event(_) -> ok.

