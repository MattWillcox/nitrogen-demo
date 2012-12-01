%% Profile Page
-module (profile).
-compile(export_all).
-include_lib("nitrogen_core/include/wf.hrl").

main() -> #template { file="./site/templates/main.html" }.

title() -> "href Tetris".


body() -> 
	#panel{
		body=[
			#panel{
				class=title,
				body=[
					#h1 {text = "Profile"}
				]
			},
			#panel{
				class=profileWrapper,
				body=[
					#p{text="My profile comes here"},
					#panel{body=[
							#label{text="id: "},
							#label{text="win-loss: "},
							#label{text="rating: "},
							#label{text="rank: "}
							]}	
				]
			},
			#link{text = "Want to change password?", url = "/changepassword"}
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
	

