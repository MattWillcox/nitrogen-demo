%% -*- mode: nitrogen -*-
-module (chat).
-compile(export_all).
-include_lib("nitrogen_core/include/wf.hrl").
-include("records.hrl").

main() -> 
	case wf:user() /= undefined of
		true -> main_authorized();
		false -> wf:redirect_to_login("/tetrislogin")
	end.
	

main_authorized() -> #template { file="./site/templates/beta.html" }.


title() -> "Chat Room".
headline() -> "Chat Room - Comet".

body() -> 
	#container_12 { body=[
        #grid_12 { style = "border: 10px solid grey; text-align: center;", body = [ 
                #singlerow {style="width: 920px;", cells=[
            #tablecell { align=center, body=#link { text="Home", url = "/beta" }},
            #tablecell { align=center, body=#link { text="Leaderboard", url = "/beta" }},
            #tablecell { align=center, body=#link { text="Profile", url = "/profile"}},
            #tablecell { align=center, body=#link { text="Friends", url = "/beta" }},
            #tablecell { align=center, body=#link { text="Chat", url = "/chat" }},
            #tablecell { align=center, body=#link { text="Logout", postback = logout }}
        ]}]},
        #grid_clear{},
        #grid_4 {alpha=true, body = [#image { style = "width: 90%; margin-top: 34px", 
        image = "/images/logo.jpg"}] },
        #grid_8 {omega=true, body=inner_body() }
    ]}.
inner_body() -> 
    Username = db:q("select username from user where email =?", [wf:user()]),
	wf:comet_global(fun() -> chat_loop() end, chatroom),
    [
        #span { text="Your chatroom name: " }, 
        #span { text = Username },
        #panel { id=chatHistory, class=chat_history },

        #p{},
        #textbox { id=messageTextBox, style="width: 350px; height: 20px; word-wrap: break-word;", next=sendButton },
        #button { id=sendButton, style="width: 75px; margin-left: 10px;", text="Send", postback={chat, Username}}
    ].
		

event({chat, Username}) ->
    Message = wf:q(messageTextBox),
    wf:send_global(chatroom, {message, Username, Message}),
    wf:wire("obj('messageTextBox').focus(); obj('messageTextBox').select();");

event(_) -> ok.

chat_loop() ->
    receive 
        'INIT' ->
            wf:flush();

        {message, Username, Message} ->
            Terms = [
                #p{},
                #span { text=Username, class=username }, ": ",
                #span { text=Message, class=message }
            ],
            wf:insert_bottom(chatHistory, Terms),
            wf:wire("obj('chatHistory').scrollTop = obj('chatHistory').scrollHeight;"),
            wf:flush()
    end,
    chat_loop().  
