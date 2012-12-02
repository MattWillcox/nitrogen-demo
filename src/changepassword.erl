%% Change password
-module (changepassword).
-compile(export_all).
-include_lib("nitrogen_core/include/wf.hrl").

main() -> #template { file="./site/templates/main.html" }.

title() -> "href Tetris".

body() ->
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

    [
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
    ].

event(changePW) ->
	Usr = wf:q(idTextbox),
	Password = wf:q(currentPWBox),
	NewPassword = wf:q(passwordBox),
	Salt = mochihex:to_hex(erlang:md5(Usr)),
	HashedPassword = mochihex:to_hex(erlang:md5(Salt ++ Password)),
	HashedNewPassword = mochihex:to_hex(erlang:md5(Salt ++ NewPassword)),
	case usr:changePassword(Usr,HashedPassword,HashedNewPassword) of
		{error, Reason} -> wf:wire(#alert{text=Reason});
		ID when is_integer(ID) -> 
			wf:wire(#alert{text="Password Changed!"}),
			wf:redirect("/profile")
	end.


