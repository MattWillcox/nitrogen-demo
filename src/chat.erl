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
        #grid_8 { alpha=true, prefix=2, suffix=2, omega=true, body=inner_body() }
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
        #textbox { id=messageTextBox, style="width: 40;", next=sendButton },
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
            Terms = [
                #p{},
                #span { text="You are the only person in the chat room.", class=message }
            ],
            wf:insert_bottom(chatHistory, Terms),
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
