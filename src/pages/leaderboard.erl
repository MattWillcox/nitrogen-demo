%% Leaderboard Page
-module (leaderboard).
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
Top10 = elo:top10(),
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
				#panel{
					class=title,
					body=[
						#h1 {text = "Leaderboard"},
						#table { rows=[
						  #tablerow { cells=[
						    #tableheader { text="Name" },
						    #tableheader { text="Wins" },
						    #tableheader { text="Losses" },
						    #tableheader { text="Win Rate" },
						    #tableheader { text="ELO" }
						  ]},
						lists:map(fun([User,Wins,Losses,Elo]) ->
	                        [
		                    	#tablerow { cells=[
		                    	#tablecell { text= User},
		                    	#tablecell { text= Wins},
		                    	#tablecell { text= Losses},
		                    	case Wins+Losses>0 of 
		                    		true -> #tablecell { text= Wins/(Wins+Losses)};
		                    		false -> #tablecell { text= " - "}
		                    	end,
		                    	#tablecell { text= Elo}
		                    	]}
	                        ] end,Top10)
	                    ]}
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