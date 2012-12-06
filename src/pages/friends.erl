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
usr:updateVisit(wf:user()),
UserName = db:q("select username from user where email = ?", [wf:user()]),

Friends = case db:qexists("select user2 from friend where user1 = ?", [wf:user()]) of
    true -> db:q("select user2 from friend where user1 = ?", [wf:user()]);
    false -> []
    end,

Online = usr:friendsOnline(wf:user()),

Body = [

    #container_12 { body = [

        #grid_12 { style = "border: 10px solid grey; text-align: center;", body = [ 

                #singlerow {style="width: 920px;", cells=[
                    #tablecell { align=center, body=#link { text="Home", url = "/beta" }},
                    #tablecell { align=center, body=#link { text="Leaderboard", url = "/leaderboard" }},
                    #tablecell { align=center, body=#link { text="Profile", url = "/profile"}},
                    #tablecell { align=center, body=#link { text="Friends", url = "/friends" }},
                    #tablecell { align=center, body=#link { text="Chat", url = "/chat" }},
                    #tablecell { align=center, body=#link { text="Logout", postback = logout }}
                    ]
                }
            ]
        },

        #grid_clear{},

        #grid_6 { style = "margin-top: 20px;", body = [
            #span { class = friendTitle, style = "font-size: 30px;", text = UserName ++ "'s Friends!"},
            #p{},
            #span { class = friendAdd, style = "font-size: 14px;", 
            text = "Add a friend by email address: "},
            #textbox { id = searchFriend, class = searchFriend, next = searchButton},
            #button { id = searchButton, text = "Add", postback = add}
           ]},

        #grid_6 { style = "margin-top: 75px; margin-bottom:", body = [
            #span { class = friendRemove, style = "font-size: 14px;", 
            text = "Remove a friend by username: "},
            #textbox { id = removeFriend, class = searchFriend, next = removeButton},
            #button { id = removeButton, text = "Remove", postback = remove}
           ]},

        #grid_clear{},
        
        #grid_4 { style="margin-top:20px;", body = [#span { style = "font-size:20px;", text = "Online Friends:"},
                        lists:map(fun([Online1]) -> [ #br{}, #span{ text = db:q("select username from user where email = ?", [Online1])}
                                                    ] end, Online)
                        ]},

        #grid_4 { style="margin-top:20px;", body = [#span { style = "font-size:20px;", text = "All Friends:"},
                        lists:map(fun([Friend1]) -> [ #br{}, #span{ text = db:q("select username from user where email = ?", [Friend1])}
                                                    ] end, Friends),
                        #span {id=allFriends}
                        ]}

    ]}],

    Body.

event(add) -> 
    Email = wf:q(searchFriend),
    case db:qexists("select user1 from friend where user1 =? and user2 =?", [wf:user(), Email]) of 
        true -> wf:wire(#alert{text="Already your friend"});
        false -> 
            case db:qexists("select username from user where email=?", [Email]) of
               true -> db:qi("insert into friend (user1, user2, status) values(?,?,false)", [wf:user(), Email]),
                        wf:redirect("/friends");
               false -> wf:wire(#alert{text="User does not exist"})
            end
        end;

event(remove) -> 
    Username = wf:q(removeFriend),
        case db:qexists("select username from user where username = ?", [Username]) of
            true -> Email = db:q("select email from user where username = ?", [Username]),
                    db:q("delete from friend where user1=? and user2=?", [wf:user(), Email]),
                    wf:redirect("/friends");
            false -> wf:wire(#alert{text="User does not exist"})
        end.    
