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