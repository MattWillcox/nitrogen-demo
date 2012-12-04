%% -*- mode: nitrogen -*-
-module (beta).
-compile(export_all).
-include_lib("nitrogen_core/include/wf.hrl").
-include("records.hrl").

main() -> #template { file="./site/templates/beta.html" }.


title() -> "Hello from beta.erl!".

body() -> 

CurrentUser = case wf:cookie(pastUser) of
    undefined -> "Guest";
    Other -> Other
end,

Body = [

#container_12 { body = [
        #grid_12 { style = "border: 10px solid grey; text-align: center;", body = [ 
                #singlerow {style="width: 920px;", cells=[
            #tablecell { align=center, body=#link { text="Home", url = "/beta" }},
            #tablecell { align=center, body=#link { text="Leaderboard", url = "/beta" }},
            #tablecell { align=center, body=#link { text="Profile", url = "/profile"}},
            #tablecell { align=center, body=#link { text="Friends", url = "/beta" }},
            #tablecell { align=center, body=#link { text="Chat", url = "/chat" }},
            #tablecell { align=center, body=#link { text="Logout", postback = logout }}
            ]}
            ]},
        #grid_clear{},
        #grid_12 { body = [
            #panel { style = "text-align:right;", body = [#span{ text = "Currently logged in as: "},
            #span { id = currentUser, text  = CurrentUser}]}]},
        #grid_clear{},    
        #grid_4 { style = "font-size: small;", alpha= true, omega = true, body = [
        #image { style = "width: 90%", image = "/images/logo.jpg"},
        
        [
        "Instructions:
        Create an account to the right of the game screen.
        Once you are logged in, hit start to beging searching
        for an opponent. Your statistics are stored under the
        'Profile' link at the top. 
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
        #grid_4 { id = game2, body = [
        #label { id = label1, class=temp, text="User Name" },
        #textbox { id=nameTextBox, next=passwordTextBox },

        #label { id = label3, class=temp, text="Password" },
        #password { id=passwordTextBox, next=confirmButton },
        #br{},
        #button { id=continueButton, text="Continue", postback=continue },
        #br{},
        #link { id=regLink, text = "New player? Register here.", url = "/register"} ]}
    ]}], 

    wf:wire(continueButton, nameTextBox, #validate { validators=[
        #is_required { text="Required." }
    ]}),

    wf:wire(continueButton, passwordTextBox, #validate { validators=[
        #is_required { text="Required." },
        #min_length { length=6, text="Password must be at least 6 characters long." }
    ]}),

Body.

event(continue) ->
        User = wf:q(nameTextBox),
        Password = wf:q(pwTextbox),
        Salt = mochihex:to_hex(erlang:md5(User)),
       %%HashedPassword = mochihex:to_hex(erlang:md5(Salt ++ Password)),
            wf:user(User),
            wf:set(currentUser, User),
            wf:cookie(pastUser, User),
            wf:replace(game2, #grid_4 { body = [#span{ text = "Search for opponent"},
                                                #br{},
                                                #button { id=searchButton, text="Search" }]}),
            wf:wire(nameTextBox, #hide{}),
            wf:wire(passwordTextBox, #hide{}),
            wf:wire(confirmTextBox, #hide{}),
            wf:wire(continueButton, #hide{}),
            wf:wire(label1, #hide{}),
            wf:wire(label3, #hide{}),
            wf:wire(regLink, #hide{});

event(logout) ->
    wf:delete_cookie(pastUser),
    wf:user("Guest"),
    wf:clear_session(),
    wf:redirect("/beta");

event(_) -> ok.
