-module (elo).
-compile(export_all).
-include_lib("nitrogen_core/include/wf.hrl").

top10() ->
	db:q("select username,wins,losses,elo from user ORDER BY elo DESC LIMIT 0,10").

adjustElo() ->
	ok.
