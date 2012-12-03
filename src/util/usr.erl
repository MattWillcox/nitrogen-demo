-module (usr).
-compile(export_all).
-include_lib("nitrogen_core/include/wf.hrl").

login(Usr,Password) ->
	Exists = db:qexists("select * from players where user =? and password=?",[Usr,Password]),
	if 
		Exists 	-> wf:user(Usr); %% we have a match, set session
		true -> {error, "User and Password do not match"}
	end.

register(Usr,Password) ->
	Exists = db:qexists("select user from players where user=?",[Usr]),
	if 
		Exists -> {error, "Name Exists"}; %% it already exists, error
		true -> db:qi("insert into players(user,password) values(?,?)",[Usr,Password]) 
	end.

changePassword(Usr,Password,NewPassword) ->
	Exists = db:qexists("select * from players where user =? and password=?",[Usr,Password]),
	if
		Exists -> db:q("update players SET password=? where user =?",[NewPassword,Usr]);
		true -> {error, "Ooops, you may have made mistakes typing in your id or password. Please try again."}
	end.

resetPassword(Usr, Password) ->
	Exists = db:qexists("select * from players where user =?",[Usr]),
	if
		Exists -> db:q("update players SET password=? where user =?",[Password,Usr]);
		true -> {error, "User name does not exist"}
	end.