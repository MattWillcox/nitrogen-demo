%% Creating new account
-module (register).
-compile(export_all).
-include_lib("nitrogen_core/include/wf.hrl").

main() -> #template { file="./site/templates/beta.html" }.

title() -> "href Tetris".


body() ->
    wf:wire(registerButton, idTextbox, #validate {validators=[
        #is_required { text="Required." },
        #is_email { text="Invalid Email Address" },
        #custom { text="Email is already in use!", function= fun emailIsInUse/2, tag=in_use }
    ]}),
	wf:wire(registerButton, pwTextbox, #validate { validators=[
	    #is_required { text="Required." },
	    #min_length { length=6, text="Password must be at least 6 characters long." }
	]}),

	wf:wire(registerButton, pwConfirmTextbox, #validate { validators=[
	    #is_required { text="Required." },
	    #confirm_password { password=pwTextbox, text="Passwords must match." }
	]}),
	wf:wire(registerButton, displayNameBox, #validate { validators=[
	    #is_required { text="Required." },
	    #custom { text="User name is already in use!", function= fun nameIsInUse/2, tag=in_use }
	]}),
	wf:wire(registerButton, secretAnswerTextbox, #validate { validators=[
	    #is_required { text="Required." },
	    #is_integer { text ="Invalid input, it must be a number!"},
	    #min_length { length=8, text="Invalid input, it must be at 8 digits!" },
	    #max_length { length=8, text="Invalid input, it must be at 8 digits!" }
	]}),

	Body = [
		#container_12 {
			body = [
		        #grid_12 {
		        	style = "border: 10px solid grey; text-align: center;",
		        	body = [ 
		                #singlerow {
		                	style="width: 920px;",
		                	cells=[
		           				#tablecell { align=center, body=#link { text="Home", url = "/beta" }},
					            #tablecell { align=center, body=#link { text="Leaderboard", url = "/leaderboard" }},
					            #tablecell { align=center, body=#link { text="Profile", url = "/profile"}},
					            #tablecell { align=center, body=#link { text="Friends", url = "/friends" }},
					            #tablecell { align=center, body=#link { text="Chat", url = "/chat" }},
					            #tablecell { align=center, body=#link { text="Logout", postback = logout}}
		        			]
		        		}
		        	]
		        },


	 			#grid_clear{},
	        	#grid_12 {
		        	body = [
			        #h1 {text = "Create New Account"},
			        #label {text = "Please enter your Email address"},
			        #textbox { id=idTextbox, class=idTextbox, text="", next=displayNameBox},
			        #label {text = "Please enter your display name"},
			        #textbox { id=displayNameBox, class=displayNameBox, text="", next=pwTextbox},
			        #label {text= "Please enter new password"},
			        #password { id=pwTextbox, class=pwTextbox, text="", next=pwConfirmTextbox},
			        #label {text= "Please enter password again to confirm"},
			        #password { id=pwConfirmTextbox, class=pwConfirmTextbox, text="", next=secretAnswerTextbox},
			        #br{},
			        #label {text= "Security Question: When is your birthday (yyyyMMdd)? This will be used to reset your password."},
			        #textbox { id=secretAnswerTextbox, class=secretAnswerTextbox, text="", next=registerButton},
			        #br{},
			        #button { id=registerButton, text = "Create New Account", postback=register},
			        #br{}
					]
				}
			]
		}
	],

    Body.

event(register) ->
	Email = wf:q(idTextbox),
	DisplayName = wf:q(displayNameBox),
	Password = wf:q(pwTextbox),
	SecretAnswer = wf:q(secretAnswerTextbox),

	case usr:register(Email,DisplayName,Password,SecretAnswer) of
		%%{error, Reason} -> wf:wire(#alert{text=Reason});
		ID when is_integer(ID) -> 
			wf:wire(#alert{text="Registered! Please Log In"}),
			wf:redirect("/beta")
	end.

nameIsInUse(_Tag, Value) ->
	case db:qexists("select username from user where username=?",[Value]) of
		false-> true;
		true -> false
	end.

emailIsInUse(_Tag, Value) ->
	case db:qexists("select email from user where email=?",[Value]) of
		false-> true;
		true -> false
	end.