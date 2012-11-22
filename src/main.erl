%% Tetris main page
-module (main).
-compile(export_all).
-include_lib("nitrogen_core/include/wf.hrl").

main() -> #template { file="./site/templates/main.html" }.

title() -> "href Tetris".


body() -> 
	Game_History = db:q("select user1,user2,winner from game_history"),
	 wf:wire(loginButton, idTextbox, #validate {validators=[
        #is_required { text="Required." },
        #is_email { text="Invalid Email Address" }
    ]}),
	#panel{
		body=[
			#panel{
				class=title,
				body=[
					#h1 {text = "href Tetris!"}
				]
			},
			#panel{
				class=bodyWrapper,
				body=[
					#panel{
						class=logoWrapper,
						body=[
							#label{text="logo comes here! for now, game history..."},
							#panel{body=[
   								lists:map(fun([User1,User2,Winner]) ->
      								[
      								#span {text=[User1 ++" and " ++ User2 ++ " played, and " ++ Winner ++ " won."]},
      								#br{}
      								] end,Game_History)
   								]}	
						]
					},
					#panel{
						class=loginboxWrapper,
						id=loginbox,
						body=[
							#label{text="Email"},
							#textbox{ id=idTextbox, class=idTextbox },
							#label{text="Password"},
							#password{ id=pwTextbox, class=pwTextbox },
							#br{},
							#button{id=loginButton, text="Login", postback=login},
							#p{},
							#link {text = "Don't have account yet?", url = "/register"},
							" or ",
							#link {text = "Forgot password?", url = "/password"},
							#p{}
						]
					}
				]
			}
		]}.

event(login) ->
	Usr = wf:q(idTextbox),
	Password = wf:q(pwTextbox),
	case usr:login(Usr,Password) of
		{error, Reason} -> wf:wire(#alert{text=Reason});
		ok -> 
			wf:wire(loginbox, #hide{}),
			wf:wire(#alert{text="Yay you totally logged in but nothing else is implemented yet.  You can trust us on this!"})
	end.
	

