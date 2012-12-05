%% -*- mode: nitrogen -*-
-module (friends).
-compile(export_all).
-include_lib("nitrogen_core/include/wf.hrl").
-include("records.hrl").

main() -> 
    case wf:user() /= undefined of
        true -> main_authorized();
        false -> wf:redirect_to_login("/tetrislogin")
    end.
    
main_authorized() -> #template { file="./site/templates/beta.html" }.

title() -> "HREF Tetris - Friends".

body() ->

UserName = db:q("select username from user where email = ?", [wf:user()]),

Friends = case db:qexists("select user2 from friends where user1 = ?", [wf:user()]) of
    true -> db:q("select user2 from friends where user1 = ?", [wf:user()]);
    false -> []
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

        #grid_12 { style = "margin-top: 20px;", body = [
            #span { class = friendTitle, style = "font-size: 30px;", text = UserName ++ "'s Friends!"},
            #p{},
            #span { class = friendAdd, style = "font-size: 14px;", 
            text = "Add a friend by email address: "},
            #textbox { id = searchFriend, next = searchButton},
            #button { id = searchButton, text = "Add", postback = add}        
        ]},

        #grid_clear{},
        
        #grid_6 { body = [#h2 { text = "Online Friends:"}
                        ]},

        #grid_6 { body = [#h2 { text = "All Friends:"},
                        lists:map(fun([Friend1]) -> [ #span {text = Friend1},
                                                    #br{}] end, Friends)
                        ]}

    ]}],

    Body.

event(add) -> 
    Email = wf:q(searchFriend),
    case db:qexists("select * from friends where user1 =? and user2 =?", [wf:user(), Email]) of 
        true -> wf:wire(#alert{text="Already your friend"});
        false -> 
            case db:qexists("select * from user where email=?", [Email]) of
               true ->  Friend = db:q("select username from user where email=?", [Email]),
                        db:qi("insert into friends(user1, user2, status) values(?,?,false)", [wf:user(), Email]),
                        Term = [#br{}, Friend],
                    wf:insert_bottom(allFriends, Term);
               false ->  wf:wire(#alert{text="User does not exist"})
            end
        end.

   
