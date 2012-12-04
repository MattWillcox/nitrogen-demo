%% -*- mode: nitrogen -*-
-module (chat).
-compile(export_all).
-include_lib("nitrogen_core/include/wf.hrl").
-include("records.hrl").

main() -> 
	case wf:user() /= undefined of
		true -> main_authorized();
		false -> wf:redirect_to_login("/login")
	end.
	

main_authorized() -> #template { file="./site/templates/chat.html" }.


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
        #grid_12 { alpha=true, prefix=2, suffix=2, omega=true, body=inner_body() }
    ]}.
inner_body() -> 
	wf:comet_global(fun() -> chat_loop() end, chatroom),
	CurrentUser = wf:user(),
    [
        #span { text="Your chatroom name: " }, 
        #span {style = "font-weight: bold;", text = CurrentUser},
        #p{},
        #panel { id=chatHistory, class=chat_history },

        #p{},
        #textbox { id=messageTextBox, style="width: 500;", next=sendButton },
        #button { id=sendButton, text="Send", postback=chat }
    ].
		

event(chat) ->

    Username = wf:user(),
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
