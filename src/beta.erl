%% -*- mode: nitrogen -*-
-module (beta).
-compile(export_all).
-include_lib("nitrogen_core/include/wf.hrl").
-include("records.hrl").

main() -> #template { file="./site/templates/beta.html" }.


title() -> "Hello from beta.erl!".

body() -> 

Usr = case wf:user() of
    undefined -> "Guest";
    Other -> Other
    end,

Body = [

    #container_12 { body = [
        #grid_12 { style = "border: 10px solid grey; text-align: center;", body = [ 
                #singlerow {style="width: 920px;", cells=[
                    #tablecell { align=center, body=#link { text="Home", url = "/beta" }},
                    #tablecell { align=center, body=#link { text="Leaderboard", url = "/leaderboard" }},
                    #tablecell { align=center, body=#link { text="Profile", url = "/profile"}},
                    #tablecell { align=center, body=#link { text="Friends", url = "/beta" }},
                    #tablecell { align=center, body=#link { text="Chat", url = "/chat" }},
                    #tablecell { align=center, body=#link { text="Logout", postback = logout }}
                    ]
                }
            ]
        },
        #grid_clear{},
        #grid_12 { body = [
            #panel { style = "text-align:right;", body = [#span{ text = "Currently logged in as: "},
            #span { id = currentUser, text  = Usr}]}]},
        #grid_clear{},    
        #grid_4 { style = "font-size: small;", alpha= true, omega = true, body = [
            #image { style = "width: 90%", image = "/images/logo.jpg"},
        
            [
            "Instructions:
            Login to start searching for an opponent.
            Your statistics are stored under the
            'Profile' link at the top. 
            If you do not have account yet,
            create an account to the right of the game screen.
            <p>
            Controls:
            Use the arrows keys to move the pieces. 
            Left and right move the pieces sideways, 
            the Up arrow will rotate itand the down 
            arrow will move your piece down faster.
            "
            ]

        ]},
        #grid_4 { id = game1, style = "border: 10px solid black; color: white; 
        background-color: black; padding-bottom:470px;", body = "GAME HERE?"},
        #grid_4 {
            id = game2,
            show_if = (wf:user() == undefined),
            body = [
                #panel{
                    class=loginboxWrapper,
                    id=loginbox,
                    body=[
                        #label{id=label1, text="Email"},
                        #textbox{ id=idTextbox, class=idTextbox, next=pwTextbox},
                        #label{id=label2, text="Password"},
                        #password{ id=pwTextbox, class=pwTextbox, next=loginButton},
                        #br{},
                        #button{id=loginButton, text="Login", postback=login},
                        #p{},
                        #link {id=createAccountLink, text = "Don't have account yet?", url = "/register"},
                        #br{},
                        " or ",
                        #link {id=forgotPasswordLink, text = "Forgot password?", url = "/password"},
                        #p{}
                    ]
                }
            ]
        },
        #grid_4 {
            id = game2_2,
            show_if = (wf:user() /= undefined),
            body = [#panel{style="border: 10px solid black; color: white; 
                    background-color: black; padding-bottom:470px;", body = "Searching for Opponent"}]
        }
    ]}
    ],

    Body.


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
                wf:redirect("/beta")
            end;

event(logout) ->
    wf:user("Guest"),
    wf:clear_session(),
    wf:redirect("/beta");

event(_) -> ok.
