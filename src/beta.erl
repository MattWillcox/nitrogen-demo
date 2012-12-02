%% -*- mode: nitrogen -*-
-module (beta).
-compile(export_all).
-include_lib("nitrogen_core/include/wf.hrl").
-include("records.hrl").

main() -> #template { file="./site/templates/bare.html" }.

title() -> "Hello from beta.erl!".

body() -> 
 Body = [

#container_12 { body = [
        #grid_12 { body = [ #span { text = "NAVIGATOR BAR"}]},
        #grid_clear{},
        #grid_3 { alpha= true, omega = true, body = [
        #image { style = "width: 90%", image = "/images/logo.jpg"},
        #span { text = "Instructions"}
        ]},
        #grid_3 { body = "GAME HERE?"},
        #grid_2 { body = [
        #label { id = label1, class=temp, text="User Name" },
        #textbox { id=nameTextBox, next=emailTextBox },

        #label { id = label2, class=temp, text="Email Address" },
        #textbox { id=emailTextBox, next=passwordTextBox },

        #label { id = label3, class=temp, text="Password" },
        #password { id=passwordTextBox, next=confirmTextBox },

        #label { id = label4, class=temp, text="Confirm" },
        #password { id=confirmTextBox, next=continueButton },

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
        Name = wf:q(nameTextBox),
        Message = wf:f("Welcome ~s! Your information is valid.", [Name]),
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
