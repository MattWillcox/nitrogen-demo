%% Reset password
-module (password).
-compile(export_all).
-include_lib("nitrogen_core/include/wf.hrl").

main() -> #template { file="./site/templates/beta.html" }.

title() -> "href Tetris".


body() ->
usr:updateVisit(wf:user()),
    Body = [
    	#container_12 {
    		body = [
		        #grid_12 { style = "border: 10px solid grey; text-align: center;", body = [ 
		                #singlerow {style="width: 920px;", cells=[
		            #tablecell { align=center, body=#link { text="Home", url = "/beta" }},
		            #tablecell { align=center, body=#link { text="Leaderboard", url = "/leaderboard" }},
		            #tablecell { align=center, body=#link { text="Profile", url = "/profile"}},
		            #tablecell { align=center, body=#link { text="Friends", url = "/friends" }},
		            #tablecell { align=center, body=#link { text="Chat", url = "/chat" }},
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

event(_) -> ok.

