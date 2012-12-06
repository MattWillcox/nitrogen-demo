-module (elo).
-compile(export_all).
-include_lib("nitrogen_core/include/wf.hrl").

top10() ->
	db:q("select username,wins,losses,elo from user ORDER BY elo DESC LIMIT 0,10").

quickSum(L) -> quickSum(L, 0).
quickSum([H|T], Sum) -> quickSum(T, Sum + H);
quickSum([], Sum)    -> Sum.

calcNewElo({Player,BaseElo},Opponents,Winner) ->
	case {Player,BaseElo} of
		Winner -> Sa = 1;
		_ -> Sa = 0
	end,
	K = 15,
	Set = lists:map(fun({_Player,Elo}) ->
		K*(Sa-(1/(1+math:pow(10,(Elo-BaseElo)/400))))end, Opponents),
	BaseElo + quickSum(Set).

adjustElos(PlayerElos,Winner) ->
	lists:map(fun({Player,Elo}) ->
  		Opponents = [{P,E} || {P,E} <- PlayerElos, P=/=Player],
 		NewElo = calcNewElo({Player,Elo},Opponents,Winner),
 		{Player,NewElo} end, PlayerElos). 

lastelos(User) ->
	List1 = db:q("select elo1, time from game where user1=? order by time desc", [User]),
	List2 = db:q("select elo2, time from game where user2=? order by time desc", [User]),
	Elo = lists:merge(List1, List2),
	Elo2 = lists:sort(fun(A, B) ->
		[_, {_, A2}] = A,
		[_, {_, B2}] = B,
		case calendar:datetime_to_gregorian_seconds(A2) > calendar:datetime_to_gregorian_seconds(B2) of
			true -> true;
			false -> false
        end
    end, Elo),
	Elo2.

myElo(User) ->
	db:q("select wins,losses,elo from user where email=?", [User]).
