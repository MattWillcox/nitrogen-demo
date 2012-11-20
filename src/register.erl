%% Creating new account
-module (register).
-compile(export_all).
-include_lib("nitrogen_core/include/wf.hrl").

main() -> #template { file="./site/templates/register.html" }.

title() -> "href Tetris".


body() ->
    wf:wire(registerButton, idTextbox, #validate {validators=[
        #is_required { text="Required." },
        #is_email { text="Invalie Email Address" }
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
	        #textbox { id=idTextbox, class=idTextbox, text=""},
	        #p{},
	        #label {text= "Please enter new password"},
	        #password { id=pwTextbox, class=pwTextbox, text=""},
	        #p{},
	        #label {text= "Please enter password again to confirm"},
	        #password { id=pwConfirmTextbox, class=pwConfirmTextbox, text=""},
	        #p{},
	        #br{},
	        #button { id=registerButton, text = "Create New Account", postback=register},
	        #br{}
	        ]
	    },
	    #flash{}
    ].

event(register) ->
    wf:wire(registerButton, #hide{} ),
    wf:flash( "Thank you for creating new account!" ),
    timer:sleep(1000),
    wf:redirect("/main");

event(_) -> ok.

