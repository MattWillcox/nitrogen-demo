%% -*- mode: nitrogen -*-
-module (login).
-compile(export_all).
-include_lib("nitrogen_core/include/wf.hrl").
-include("records.hrl").

main() -> #template { file="./site/templates/bare.html" }.

title() -> "Login Page".

body() -> 
	#container_12 { body=[
        #grid_8 { alpha=true, prefix=2, suffix=2, omega=true, body=inner_body() }
    ]}.

inner_body() -> 
	Event = #event {target=theDiv, type=click},
	wf:wire(okButton, userTB, #validate { validators=[#is_required { text="Required, at least make up some name."} ]}),
	wf:wire(okButton, passTB, #validate { validators=[#is_required { text="Required, Read the Hint for instructions"},
		#custom {text ="Please read the Hint for instructions", function=fun check_password/2}]}),
    [
	#h1 {text="Login Page"},
	#p{},
	#panel { class=effects_target, id=theDiv, actions=#hide{}, body=[
            "Enter a username and the password \"pass\" to log in."]},
	#p{},
	#link {text="Click Here To Reveal Hint", actions=Event#event{
		actions=#appear{}
	}},
	#p{},
	#label {text="Username"},
	#textbox {id=userTB, next=passTB},
	#p{},
	#label {text="Password"},
	#password {id=passTB, next=okButton},
	#p{},
	#button {id=okButton, text="Submit", postback=ok}	
    ].

	check_password(_Tag, Value)->
		Value == "pass".	
event(ok) ->
    	User = wf:q(userTB),
	wf:user(User),
	wf:redirect("/index").
