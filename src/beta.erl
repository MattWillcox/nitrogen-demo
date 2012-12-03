%% -*- mode: nitrogen -*-
-module (beta).
-compile(export_all).
-include_lib("nitrogen_core/include/wf.hrl").
-include("records.hrl").

main() -> #template { file="./site/templates/beta.html" }.


title() -> "Hello from beta.erl!".

body() -> 

User = case wf:user() of
undef -> "Guest";
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
            #tablecell { align=center, body=#link { text="Chat", url = "/beta" }},
            #tablecell { align=center, body=#link { text="Logout", url = "/beta" }}
        ]}]},
        #panel { style = "text-align:right;", body = [#span{ text = "Currently logged in as: "},
                        #span { id = currentUser, text = User}]},

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
        #textbox { id=nameTextBox, next=emailTextBox },

        #label { id = label2, class=temp, text="Email Address" },
        #textbox { id=emailTextBox, next=passwordTextBox },

        #label { id = label3, class=temp, text="Password" },
        #password { id=passwordTextBox, next=confirmTextBox },

        #label { id = label4, class=temp, text="Confirm" },
        #password { id=confirmTextBox, next=continueButton },
        #br{},
        #button { id=continueButton, text="Continue", postback=continue } ]}
    ]}
    ],

    wf:wire(continueButton, nameTextBox, #validate { validators=[
        #is_required { text="Required." }
    ]}),

    wf:wire(continueButton, emailTextBox, #validate { validators=[
        #is_required { text="Required." },
        #is_email { text="Enter a valid email address." }
    ]}),

    wf:wire(continueButton, passwordTextBox, #validate { validators=[
        #is_required { text="Required." },
        #min_length { length=6, text="Password must be at least 6 characters long." }
    ]}),

    wf:wire(continueButton, confirmTextBox, #validate { validators=[
        #is_required { text="Required." },
        #confirm_password { password=passwordTextBox, text="Passwords must match." }
    ]}),  

    Body.


event(continue) ->
        User = wf:q(nameTextBox),
        wf:user(User),
        Name = wf:q(nameTextBox),
        Message = wf:f("Welcome ~s! Your information is valid.", [Name]),
        wf:set(currentUser, User),
        wf:replace(game2, #grid_4 {style="border: 10px solid black; color: white; 
            background-color: black; padding-bottom:470px;", body = "Searching for Opponent"}),
        wf:flash(Message),
        wf:remove(nameTextBox),
        wf:remove(emailTextBox),
        wf:remove(passwordTextBox),
        wf:remove(confirmTextBox),
        wf:remove(continueButton),
        wf:remove(label1),
        wf:remove(label2),
        wf:remove(label3),
        wf:remove(label4);

event(_) -> ok.
