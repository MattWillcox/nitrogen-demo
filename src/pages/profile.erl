%% Profile Page
-module (profile).
-compile(export_all).
-include_lib("nitrogen_core/include/wf.hrl").

main() -> 
	case wf:user() /= undefined of
		true -> main_authorized();
		false -> wf:redirect_to_login("/tetrislogin")
	end.

main_authorized() -> #template{file="site/templates/beta.html"}.


title() -> "href Tetris".


body() -> 

Body = [
	#container_12 { body = [
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
        	body = [
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
					]
				}
			]
		}
	]}],

    Body.

event(logout) ->
    wf:user("Guest"),
    wf:clear_session(),
    wf:redirect("/beta");


event(_) -> ok.