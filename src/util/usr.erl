-module (usr).
-compile(export_all).
-include_lib("nitrogen_core/include/wf.hrl").

login(Email,Password) ->
 	Salt = mochihex:to_hex(erlang:md5(Email)),
    HashedPassword = mochihex:to_hex(erlang:md5(Salt ++ Password)),
	case db:qexists("select * from user where email =? and password=?",[Email,HashedPassword]) of
		true -> wf:user(Email); %% we have a match, set session
		false -> {error, "Email and Password do not match"}
	end.

register(Email,DisplayName,Password,SecretAnswer) ->
	Salt = mochihex:to_hex(erlang:md5(Email)),
	HashedPassword = mochihex:to_hex(erlang:md5(Salt ++ Password)),
	HashedAnswer = mochihex:to_hex(erlang:md5(Salt ++ SecretAnswer)),
	case db:qexists("select email from user where email=?",[Email]) of
		true -> {error, "Email Exists"}; %% it already exists, error
		false -> 
			case db:qexists("select username from user where username=?",[DisplayName]) of 
				true-> {error,"Display name is already in use"};
				false -> db:qi("insert into user(email,username,password,wins,losses,elo,SecretQuestionAnswer) values(?,?,?,0,0,1200,?)",[Email,DisplayName,HashedPassword,HashedAnswer])
			end
	end.

changePassword(Email,Password,NewPassword) ->
	Salt = mochihex:to_hex(erlang:md5(Email)),
	HashedPassword = mochihex:to_hex(erlang:md5(Salt ++ Password)),
	HashedNewPassword = mochihex:to_hex(erlang:md5(Salt ++ NewPassword)),
	case db:qexists("select * from user where email =? and password=?",[Email,HashedPassword]) of
		true -> db:q("update user SET password=? where email =?",[HashedNewPassword,Email]);
		false -> {error, "Ooops, you may have made mistakes typing in your id or password. Please try again."}
	end.

random_string(Len) ->
    Chrs = list_to_tuple("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"),
    F = fun(_, R) -> [element(random:uniform(size(Chrs)), Chrs) | R] end,
    lists:foldl(F, "", lists:seq(1, Len)).

resetPassword(Email, Answer) ->
	Salt = mochihex:to_hex(erlang:md5(Email)),
	NewRandomPassword = random_string(10),
	HashedNewPassword = mochihex:to_hex(erlang:md5(Salt ++ NewRandomPassword)),
	HashedAnswer = mochihex:to_hex(erlang:md5(Salt ++ Answer)),
	case db:qexists("select * from user where email=? and SecretQuestionAnswer=?",[Email,HashedAnswer]) of
		true -> db:q("update user SET password=? where email =?",[HashedNewPassword,Email]),
				{success, NewRandomPassword};
		false -> {error, "User name does not exist or you typed wrong security question answer."}
	end.

updateVisit(Email) ->
	db:q("update user set lastivist=now() where email =?",[Email]).

friendsOnline(Email) ->
	db:q("select friend.user2 from user join friend on friend.user1 =? where unix_timestamp(lastvisit) > (unix_timestamp() - 60*10);",[Email]).






