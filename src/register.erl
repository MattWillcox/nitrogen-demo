%% Creating new account
-module (register).
-compile(export_all).
-include_lib("nitrogen_core/include/wf.hrl").

main() -> #template { file="./site/templates/register.html" }.

title() -> "href Tetris".


body() ->
    wf:wire(registerButton, idTextbox, #validate {validators=[
        #is_required { text="Required." },
        #is_email { text="Invalid Email Address" }
    ]}),
	wf:wire(registerButton, pwTextbox, #validate { validators=[
	    #is_required { text="Required." },
	    #min_length { length=6, text="Password must be at least 6 characters long." }
	]}),

	wf:wire(registerButton, pwConfirmTextbox, #validate { validators=[
	    #is_required { text="Required." },
	    #confirm_password { password=pwTextbox, text="Passwords must match." }
	]}),

    [
	    #panel{
	        body=[
	        #h1 {text = "Create New Account"},
	        #label {text = "Please enter your Email address"},
	        #textbox { id=idTextbox, class=idTextbox, text="", next=pwTextbox},
	        #label {text= "Please enter new password"},
	        #password { id=pwTextbox, class=pwTextbox, text="", next=pwConfirmTextbox},
	        #label {text= "Please enter password again to confirm"},
	        #password { id=pwConfirmTextbox, class=pwConfirmTextbox, text="", next=registerButton},
	        #br{},
	        #button { id=registerButton, text = "Create New Account", postback=register},
	        #br{}
	        ]
	    },
	    #flash{}
    ].

event(register) ->
	Usr = wf:q(idTextbox),
	Password = wf:q(pwTextbox),
	Salt = mochihex:to_hex(erlang:md5(Usr)),
	HashedPassword = mochihex:to_hex(erlang:md5(Salt ++ Password)),
	case usr:register(Usr,HashedPassword) of
		{error, Reason} -> wf:wire(#alert{text=Reason});
		ID when is_integer(ID) -> 
			wf:wire(#alert{text="Registered! Please Log In"}),
			wf:redirect("/main")
	end.