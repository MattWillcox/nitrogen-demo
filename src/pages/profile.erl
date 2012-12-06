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
EloValues = lists:sublist(lists:map(fun([Elo,_]) -> lists:append([], Elo) end, LastElos), 20),
MaxEloValues = lists:max(EloValues),
MinEloValues = lists:min(EloValues),
MyRecord = elo:myElo(Usr),
WinLoss = lists:nth(1, lists:map(fun([Win, Loss, _]) -> [Win, Loss] end, MyRecord)),
WinLossString = lists:map(fun([Win, Loss, _]) -> integer_to_list(Win) ++ " - " ++ integer_to_list(Loss) end, MyRecord),
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
					class=profileInfoWrapper,
					body=[
						#panel{body=[
								#h1 {text = "Profile"},
								#label{text="email: " ++ Usr},
								#label{text="win-loss: " ++  WinLossString},
								#label{text="rating: " ++ ELO},
								#link{text = "Want to change password?", url = "/changepassword"}
						]}
					]
				},

				#panel {class=linechartWrapper, body= [
					#h4 { style="margin:0px;", text="ELO History" },
					#google_chart {
						type=line,
				        width=300, height=150, grid_x=25, grid_y=25,
				        axes=[
				        	#chart_axis {position=left, labels = [MinEloValues - 100, (MinEloValues + MaxEloValues) / 2, MaxEloValues + 100]}
				        ],
				        data=[
				            #chart_data { color="2768A9", line_width=5,
				                min_value = MinEloValues - 100,
				                max_value = MaxEloValues + 100,
				                values = EloValues
				       		}
			        ]
			    }]},

			    #panel {class=piechartWrapper, body =[
					#h4 {style="margin:0px;", text = "Win/Loss Rate"},
					#google_chart {
						type=pie3d,
				        width=300, height=150,
				        axes=[
	            			#chart_axis { position=bottom, labels=["Win", "Loss"] }
	        			],
				        data=[
				            #chart_data {
				                values= WinLoss
				       		}
				        ]
				    }]}
			]
		}

	]}],

    Body.

event(logout) ->
    wf:user("Guest"),
    wf:clear_session(),
    wf:redirect("/beta");


event(_) -> ok.