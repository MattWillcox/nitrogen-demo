%% Change password
-module (changepassword).
-compile(export_all).
-include_lib("nitrogen_core/include/wf.hrl").

main() -> #template { file="./site/templates/beta.html" }.

title() -> "href Tetris".

body() ->

usr:updateVisit(wf:user()),

    wf:wire(pwChangeButton, idTextbox, #validate {validators=[
        #is_required { text="Required." },
        #is_email { text="Invalid Email Address" }
    ]}),
	wf:wire(pwChangeButton, passwordBox, #validate { validators=[
	    #is_required { text="Required." },
	    #min_length { length=6, text="Password must be at least 6 characters long." }
	]}),
	wf:wire(pwChangeButton, passwordConfirmBox, #validate { validators=[
	    #is_required { text="Required." },
	    #confirm_password { password=passwordBox, text="Passwords must match." }
	]}),

    Body = [
		#container_12 { body = [
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
	        	body = [
					    	#h1 {text = "Change your password"},
						    #panel{
						    	class=profileWrapper,
						        body=[
						        #label {text = "Please enter your Email address"},
						        #textbox { id=idTextbox, class=idTextbox, text="", next=currentPWBox},
						        #label {text = "Please enter current password"},
						        #password { id=currentPWBox, class=currentPWTextbox, text="", next=passwordBox},
						        #label {text= "Please enter new password"},
						        #password { id=passwordBox, class=pwTextbox, text="", next=passwordConfirmBox },
						        #label {text= "Please enter password again to confirm"},
						        #password { id=passwordConfirmBox, class=pwConfirmTextbox, text="", next=pwChangeButton},
						        #br{},
						        #button { id=pwChangeButton, text = "Change Password!", postback=changePW}
						        ]
						    },
						    #flash{}
				]
			}
		]}],
    Body.

event(changePW) ->
	Usr = wf:q(idTextbox),
	Password = wf:q(currentPWBox),
	NewPassword = wf:q(passwordBox),
	case usr:changePassword(Usr,Password,NewPassword) of
		{error, Reason} -> wf:wire(#alert{text=Reason});
		ID when is_integer(ID) -> 
			wf:wire(#alert{text="Password Changed!"}),
			wf:redirect("/profile")
	end.


