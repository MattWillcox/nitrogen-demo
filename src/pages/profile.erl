%% Profile Page
-module (profile).
-compile(export_all).
-include_lib("nitrogen_core/include/wf.hrl").
-include_lib ("nitrogen_core/include/google_chart.hrl").

main() -> 
	case wf:user() /= undefined of
		true -> main_authorized();
		false -> wf:redirect_to_login("/tetrislogin")
	end.

main_authorized() -> #template{file="site/templates/beta.html"}.


title() -> "href Tetris".


body() ->
Usr = wf:user(),
LastElos = elo:lastelos(Usr),
MyRecord = elo:myElo(Usr),
WinLoss = lists:map(fun([Win, Loss, _]) -> integer_to_list(Win) ++ " - " ++ integer_to_list(Loss) end, MyRecord),
ELO = lists:map(fun([_, _, Elo]) -> integer_to_list(Elo) end, MyRecord),


Body = [
	#container_12 { body = [
        #grid_12 { style = "border: 10px solid grey; text-align: center;", body = [ 
                #singlerow {style="width: 920px;", cells=[
            #tablecell { align=center, body=#link { text="Home", url = "/beta" }},
            #tablecell { align=center, body=#link { text="Leaderboard", url = "/leaderboard" }},
            #tablecell { align=center, body=#link { text="Profile", url = "/profile"}},
            #tablecell { align=center, body=#link { text="Friends", url = "/beta" }},
            #tablecell { align=center, body=#link { text="Chat", url = "/chat" }},
            #tablecell { align=center, body=#link { text="Logout", postback = logout}}
        ]}]},


 		#grid_clear{},
        #grid_12 {
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
						#panel{body=[
								#label{text="email: " ++ Usr},
								#label{text="win-loss: " ++  WinLoss},
								#label{text="rating: " ++ ELO}
						]}
					]
				},
				#link{text = "Want to change password?", url = "/changepassword"},
				#br{},

				#h4 { text="ELO History Chart" },
				#google_chart {
					type=line,
			        title="Line Chart", width=400, height=400, grid_x=25, grid_y=33,
			        data=[
			            #chart_data { legend="Data 1", color="2768A9", line_width=5, 
			                values= lists:map(fun([Elo,_]) -> lists:append([], Elo) end, LastElos)
			       		}
			        ]
			    },

				#h4 {text = "Win/Loss Rate"},
				#google_chart {
					type=pie3d,
			        title="Pie Chart", width=400, height=400,
			        axes=[
            			#chart_axis { position=bottom, labels=["Win", "Loss"] }
        			],
			        data=[
			            #chart_data { legend="Data 1", color="2768A9", line_width=5, 
			                values= lists:map(fun([Win, Loss,_]) ->
			                	[Win,Loss]
			                	
			                	end, MyRecord)
			       		}
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