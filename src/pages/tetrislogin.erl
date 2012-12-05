%% -*- mode: nitrogen -*-
-module (tetrislogin).
-compile(export_all).
-include_lib("nitrogen_core/include/wf.hrl").
-include("records.hrl").

main() -> #template { file="./site/templates/beta.html" }.

title() -> "Login Page".


body() ->
	wf:wire(loginButton, idTextbox, #validate {validators=[
    #is_required { text="Required." },
    #is_email { text="Invalid Email Address" }
		]}),

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
				class=redirectLoginboxWrapper,
				id=loginbox,
	        	body = [

						#p {text = "You need to be logged in to see this page."},
						#label{text="Email"},
						#textbox{ id=idTextbox, class=idTextbox, next=pwTextbox},
						#label{text="Password"},
						#password{ id=pwTextbox, class=pwTextbox, next=loginButton },
						#br{},
						#button{id=loginButton, text="Login", postback=login},
						#p{},
						#link {text = "Don't have account yet?", url = "/register"},
						" or ",
						#link {text = "Forgot password?", url = "/password"},
						#p{}

				]
			}
		]}],

    Body.


event(logout) ->
    wf:user("Guest"),
    wf:clear_session(),
    wf:redirect("/beta");

event(login) ->
        Usr = wf:q(idTextbox),
        Password = wf:q(pwTextbox),
        Salt = mochihex:to_hex(erlang:md5(Usr)),
        HashedPassword = mochihex:to_hex(erlang:md5(Salt ++ Password)),
        case usr:login(Usr,HashedPassword) of
            {error, Reason} -> wf:wire(#alert{text=Reason});
            ok -> 
                wf:user(Usr),
                wf:set(currentUser, Usr),
                wf:redirect_from_login("/beta")
            end;

event(_) -> ok.

	
