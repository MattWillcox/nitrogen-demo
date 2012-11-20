%% Tetris main page
-module (main).
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
					#h1 {text = "href Tetris!"}
				]
			},
			#panel{
				class=logoWrapper,
				style="
					position:absolute;
    				width:40%;
    				height:80%;
    				border-style:solid;
    				border-width:1px;
    				border-color:black;
    				margin:10px;
    				left:0px;
    				",
				body=[
					"logo comes here!"
				]
			},
			#panel{
				class=loginboxWrapper,
				id=loginbox,
				style="
					position:absolute;
    				width:40%;
    				margin:10px;
    				left:50%;
    				",
				body=[
					#label{text="Email"},
					#textbox{},
					#label{text="Password"},
					#password{},
					#br{},
					#button{text="login"},
					#p{},
					#link {text = "Don't have account yet?", url = "/register"},
					" or ",
					#link {text = "Forgot password?", url = "/password"},
					#p{}
				]
			}
		]}.
	

