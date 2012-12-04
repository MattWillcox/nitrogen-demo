-module (usr).
-compile(export_all).
-include_lib("nitrogen_core/include/wf.hrl").

login(Usr,Password) ->
	Exists = db:qexists("select * from players where user =? and password=?",[Usr,Password]),
	if 
		Exists 	-> wf:user(Usr); %% we have a match, set session
		true -> {error, "User and Password do not match"}
	end.

register(Usr,Password,SecretAnswer) ->
	Exists = db:qexists("select user from players where user=?",[Usr]),
	if 
		Exists -> {error, "Name Exists"}; %% it already exists, error
		true -> db:qi("insert into players(user,password,SecretQuestionAnswer) values(?,?,?)",[Usr,Password,SecretAnswer]) 
	end.

changePassword(Usr,Password,NewPassword) ->
	Exists = db:qexists("select * from players where user =? and password=?",[Usr,Password]),
	if
		Exists -> db:q("update players SET password=? where user =?",[NewPassword,Usr]);
		true -> {error, "Ooops, you may have made mistakes typing in your id or password. Please try again."}
	end.

resetPassword(Usr, Password, Answer) ->
	Exists = db:qexists("select * from players where user=? and SecretQuestionAnswer=?",[Usr,Answer]),
	if
		Exists -> db:q("update players SET password=? where user =?",[Password,Usr]);
		true -> {error, "User name does not exist or you typed wrong security question answer."}
	end.
