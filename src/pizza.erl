%% -*- mode: nitrogen -*-
-module (pizza).
-compile(export_all).
-include_lib("nitrogen_core/include/wf.hrl").


main() -> #template { file="./site/templates/pizza.html" }.

title() -> "href Pizza: Place an order online".

body() -> 
    Body = [
        #h1 { text="Welcome to href Pizza" },
        #p{},
        "
        1. Choose the size of your pizza
        ",
        #br{},
        #dropdown { options=[
            #option { text="Personal $10.00" },
            #option { text="Small    $13.00" },
            #option { text="Medium   $15.00" },
            #option { text="Large    $18.00" }
        ]},
        #p{},
        "
        2. What kind of pizza would you like?
        ",
        #br{},
        #radiogroup { id=pizzaType, body=[
            #radio { id=pizza1, text="Pepperoni and Mushroom", value="Pepperoni and Mushroom" }, #br{},
            #radio { id=pizza2, text="Meat Lover", value="Meat Lover" }, #br{},
            #radio { id=pizza3, text="BBQ Chicken", value="BBQ Chicken" }, #br{},
            #radio { id=pizza4, text="Vegitarian", value="Vegitarian" }, #br{},
            #radio { id=pizza5, text="Hawaiian", value="Hawaiian" }
        ]},
        #p{},
        "
        3. Have something else to say?
        ",
        #br{},
        #textarea { text="", style="width: 400px; height: 100px;"}, 
        #p{},
        "
        4. How can we contact you?
        ",
        #br{},
        #label { text="Your Name:" },
        #textbox { id=nameTextBox },

        #br{},
        #label { text="Email:" },
        #textbox { id=emailTextBox },

        #br{},
        #h4 { text="Address:" },
        #label { text="Suite Number (Optional)" },
        #textbox { id=suiteNumberTextBox },
        #label { text="Street Adress" },
        #textbox { id=streetTextBox },
        #label { text="City" },
        #textbox { id=cityTextBox },
        #label { text="Province" },
        #dropdown { id=provinceDropdown, value="1", options= [
            #option { text="BC", value="1" }
        ]},
        #p{},
        #button { id=button, text="Place an order", postback=click }
    ],

    wf:wire(button, nameTextBox, #validate {validators=[
        #is_required { text="Required." }
    ]}),

    wf:wire(button, emailTextBox, #validate {validators=[
        #is_required { text="Required." },
        #is_email { text="Invalie Email Address" }
    ]}),

    wf:wire(button, streetTextBox, #validate {validators=[
        #is_required { text="Required." }
    ]}),

    wf:wire(button, cityTextBox, #validate {validators=[
        #is_required { text="Required." },
        #custom { text="We currently can only deliver in Burnaby.", tag=city_tag, function=fun city_val/2}
    ]}),


    Body.


    
event(click) ->
    Name = wf:q(nameTextBox),
    Type = wf:q(pizzaType),
    Message = "Thank you for using our online ordering service," ++ Name ++ ". You have ordered " ++ Type,
    wf:wire(#confirm { text=Message, postback=showConfirmPage });

event(showConfirmPage) ->
    Message = "Thank you for choosing href pizza! This page will be reloaded after 5 seconds",
    wf:replace(button, #flash {} ),
    wf:flash( Message ),
    wf:flush(),
    timer:sleep(5000),
    wf:redirect("/pizza");

event(_) -> ok.

city_val(_Tag, Value) ->
    Value1 = string:to_lower(Value),
    case Value1 of
        "burnaby" -> true;
        _ -> false
    end.