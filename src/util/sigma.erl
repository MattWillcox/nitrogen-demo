%% Copyright 2012 by Jesse Gumm, Released under MIT License
-module(sigma).
-compile(export_all).


%% General purpose functions for Sigma Star Systems stuff

%% random number between Min and Max
random(Min,Min) ->
	Min;
random(Min,Max) when Min > Max ->
	random(Max,Min);
random(Min,Max) ->
	crypto:rand_uniform(Min,Max+1).

random_chance(0) ->
	false;
random_chance(Ratio) when is_float(Ratio), Ratio>=0, Ratio=<1  ->
	Percent = round(Ratio*100),
	random_chance(Percent);
random_chance(Percent) when is_integer(Percent),Percent>=0, Percent=<100 ->
	random(0,99) < Percent.



%% Random string with length between Min and Max (inclusive)
random_string(Min,Max) ->
	Temp = lists:duplicate(random(Min,Max),1),
	[random_char() || _X <- Temp].

%% generates a random alphanumeric character
random_char() ->
	Zero = 48,
	CapA = 65,
	LowerA = 97,
	X = random(0,61),
	if
		X < 10 ->
			Zero + X;
		X >= 10, X <36 ->
			CapA + X - 10;
		X >= 36 ->
			LowerA + X - 36;
		true ->
			Zero
	end.


random_list_item(L) ->
	Index = random(1,length(L)),
	lists:nth(Index,L).


re(Subject,RE) ->
	re:run(Subject,RE,[{capture,all_but_first,list}]).

split(Subject,RE) ->
	re:split(Subject,RE,[{return, list}]).

chomp(Text) ->
	case re(Text,"^(.*?)[\\r\\n\\0]*$") of
		{match, [Arg | _]} ->
			Arg;
		_ ->
			Text
	end.

to_string(Term) when is_atom(Term) ->
	atom_to_list(Term);
to_string(Term) when is_integer(Term) ->
	integer_to_list(Term);
to_string(Term) when is_list(Term) ->
	lists:flatten(Term);
to_string(Term) ->
	lists:flatten(io_lib:format("~p", [Term])).


%% Join a list of strings on a delimiter to create a single string
%% join(",",["a","bc","def"])
%% returns "a,bc,def"
join(_Delim,[]) -> [];
join(Delim,LoL) ->
	lists:append([X++Delim || X <- butlast(LoL)])++lists:last(LoL).


first_line(S) ->
	case re:run(S,"^(.*?)[\r\n]") of
		nomatch -> "";
		{match,FL} -> FL
	end.


deep_unbinary(List) when is_list(List) ->
	[deep_unbinary(X) || X <- List];
deep_unbinary(Bin) when is_binary(Bin) ->
	binary_to_list(Bin);
deep_unbinary(Var) ->
	Var.


%% Returns all but the last elements of List
butlast(List) ->
	lists:sublist(List,length(List)-1).


undef_is(V,U) ->
	case V of
		undefined -> U;
		_ -> V
	end.

undef_is_zero(V) ->
	undef_is(V,0).

log2(N) ->
	math:log(N)/math:log(2).


log(Msg) ->
	io:format("~p:~p~n",[self(),Msg]),
	Msg.

% Joe Armstrong's pmap implementation
%pmap is a parallel map
pmap(F, L) ->
	S = self(),
	Pids = lists:map(fun(I) ->
		spawn(fun() -> do_f(S, F, I) end)
	end, L),
	gather(Pids).

gather([H|T]) ->
	receive
		{H, Ret} -> [Ret|gather(T)]
	end;
gather([]) ->
	[]. 

do_f(Parent, F, I) ->    
	Parent ! {self(), (catch F(I))}. 

unixtime() ->
	{MegaSec,Sec,_Micro} = now(),
	MegaSec*1000000 + Sec.

unixtime_micro() ->
	{MegaSec,Sec,MicroSec} = now(),
	MegaSec*1000000 + Sec + MicroSec/1000000.

unixtime_to_date(T) ->
	MegaSec = floor(T/1000000),
	Secs = T - MegaSec*1000000,
	{MegaSec,Secs,0}.

format_shortdate({_Year,Month,Day}) ->
	lists:flatten(io_lib:format("~2..0B/~2..0B",[Month,Day])).

format_date({Year,Month,Day}) ->
	lists:flatten(io_lib:format("~4..0B-~2..0B-~2..0B",[Year,Month,Day])).

format_time({Hour,Min,_Sec}) ->
	lists:flatten(io_lib:format("~2..0B:~2..0B",[Hour,Min])).

format_datetime({Date,Time}) ->
	format_date(Date) ++ " " ++ format_time(Time).

format_unixtime(U) ->
	format_unixtime(U,datetime).

format_unixtime("",_) ->
	"";
format_unixtime(0,_) ->
	"";
format_unixtime(U,Type) when is_atom(Type) ->
	{Date,Time} = calendar:now_to_datetime(unixtime_to_date(U)),
	case Type of
		datetime ->
			format_datetime({Date,Time});
		date ->
			format_date(Date);
		shortdate ->
			format_shortdate(Date);
		time ->
			format_time(Time)
	end.

pluralize(Word,Num) ->
	case Num of
		1 -> Word;
		_ -> Word ++ "s"
	end.

unixtime_relative(Time) ->
	Units = [{31536000,"year"},{2678400,"month"},{86400,"day"},{3600,"hour"},{60,"minute"}],
	unixtime_relative(Units,unixtime()-Time).

unixtime_relative(_,0) ->
	"just now";
unixtime_relative(_,1) ->
	"1 second ago";
unixtime_relative([],Time) ->
	integer_to_list(Time) ++ " seconds ago";
unixtime_relative([{Secs,Unit} | Next],Time) ->
	case (Secs+Secs) > Time of
		false ->
			Num = Time div Secs,
			Word = pluralize(Unit,Num),
			lists:flatten([integer_to_list(Num)," ",Word," ago"]);
		true ->
			unixtime_relative(Next,Time)
	end.

find_duplicates([],Found) ->
	Found;
find_duplicates([H | Rest],Found) ->
	case lists:member(H,Rest) of
		true -> 
			case lists:member(H,Found) of
				true -> find_duplicates(Rest,Found);
				false -> find_duplicates(Rest,[H | Found])
			end;
		false -> find_duplicates(Rest,Found)
	end.

find_duplicates(List) ->
	find_duplicates(List,[]).

file_exists(F) ->
	{error,enoent} /= file:read_file_info(F).

floor(X) when X < 0 ->
	T = trunc(X),
	case X - T == 0 of
		true -> T;
		false -> T - 1
	end;
floor(X) -> 
	trunc(X).


ceiling(X) when X < 0 ->
	trunc(X);
ceiling(X) ->
	T = trunc(X),
	case X - T == 0 of
		true -> T;
		false -> T + 1
	end.


trim(undefined) ->
	"";
trim(X) -> 
	X1 = re:replace(X,"^[\r\n\s]+","",[{return,list}]),
	re:replace(X1,"[\r\n\s]+$","",[{return,list}]).

format_num(undefined) ->
	"";
format_num(N) when is_float(N) ->
	mochinum:digits(N);
format_num(N) when is_integer(N) ->
	integer_to_list(N);
format_num(N) ->
	N.

anyany([],_) ->
	false;
anyany(_,[]) ->
	false;
anyany([H|T],L2) ->
	case lists:member(H,L2) of
		true -> true;
		false -> anyany(T,L2)
	end.

safe_nth(Num,List,Default) when Num > length(List) ->
	Default;
safe_nth(Num,List,_Default) ->
	lists:nth(Num,List).

safe_nth(Num,List) ->
	safe_nth(Num,List,undefined).

%% Fun must be arity 2. first arg = Index (1...X), second arg=Value
nmap(Fun,List) when is_function(Fun,2) ->
	Len = length(List),
	lists:map(fun({N,V}) ->
		Fun(N,V)
	end,lists:zip(lists:seq(1,Len),List)).

safe_to_float(S) when is_integer(S) ->
	S + 0.0;
safe_to_float(S) when is_float(S) ->
	S;
safe_to_float(S) when is_list(S) ->
	try
		list_to_float(S)
	catch
		error:badarg ->
			try 
				list_to_integer(S) + 0.0
			catch
				_:_ -> 0.0
			end
	end.

safe_date_to_unixtime(D) when is_integer(D) ->
	D;
safe_date_to_unixtime(D) ->
	sigma:log({parsing,D}),
	case parse:date_to_unixtime(D) of
		{error,_} ->
			0;
		T -> 
			T
	end.

%% Break 'List' into Num number of equal sized parts, or similar sized parts
break_into_parts(List,Num) ->
	Len = length(List),
	PartLen = ceiling(Len/Num),
	break_into_parts_helper(List,PartLen).


break_into_parts_helper(List,PartLen) ->
	Start = lists:sublist(List,PartLen),
	case length(Start) == length(List) of
		true -> [Start];
		false ->
			Rest = lists:nthtail(PartLen,List),
			[Start | break_into_parts_helper(Rest,PartLen)]
	end.
 
randomize_list(L) ->
	Num = length(L),
	Rands = [crypto:rand_uniform(1,10000) || _ <- lists:seq(1,Num)],
	Zipped = lists:zip(L,Rands),
	Shuffled = lists:sort(fun({_,A},{_,B}) ->
		A < B
	end,Zipped),
	[V || {V,_} <- Shuffled].

zipn(List) ->
	zipn([],List).

zipn(Acc,[]) ->
	lists:map(fun lists:reverse/1,Acc);
zipn([],[A|Rest]) ->
	AccStart = [[V] || V<-A],
	zipn(AccStart,Rest);
zipn(Acc,[A|Rest]) ->
	NewAcc = zipn_helper(Acc,A),
	zipn(NewAcc,Rest).

zipn_helper(Acc,A) ->
	zipn_helper([],Acc,A).

zipn_helper(Acc,[],[]) ->
	lists:reverse(Acc);
zipn_helper(Acc,[AccHd|AccRest],[VHd|VRest]) ->
	NewAccHd = [VHd|AccHd],
	NewAcc = [NewAccHd|Acc],
	zipn_helper(NewAcc,AccRest,VRest).

%% TODO: Break base24 ibnto it's own app

%% for user-readable invoice generation stuff. Excludes I and 0 for 
%% simplicity's sake and always returns upper case
int_to_base24(Num) ->
	lists:reverse(base24_h(Num)).

base24_h(Num) when Num < 24 andalso Num >= 0 ->
	[base24_itoc(Num)];
base24_h(Num) when Num >= 24 ->
	Rem = Num rem 24,
	NewNum = round((Num-Rem)/24),
	[base24_itoc(Rem) | base24_h(NewNum)].

base24_to_int(List) when length(List) > 11 ->
	{error,too_long_will_get_rounding_errors};	
base24_to_int([]) ->
	0;
base24_to_int([H]) ->
	base24_ctoi(H);
base24_to_int([H | R]) ->
	Digit = base24_ctoi(H),
	Exp = length(R),
	Num = round(Digit * math:pow(24,Exp)),
	Num + base24_to_int(R).


base24_itoc(0) -> $A;
base24_itoc(1) -> $B;
base24_itoc(2) -> $C;
base24_itoc(3) -> $D;
base24_itoc(4) -> $E;
base24_itoc(5) -> $F;
base24_itoc(6) -> $G;
base24_itoc(7) -> $H;
base24_itoc(8) -> $J;
base24_itoc(9) -> $K;
base24_itoc(10) -> $L;
base24_itoc(11) -> $M;
base24_itoc(12) -> $N;
base24_itoc(13) -> $P;
base24_itoc(14) -> $Q;
base24_itoc(15) -> $R;
base24_itoc(16) -> $S;
base24_itoc(17) -> $T;
base24_itoc(18) -> $U;
base24_itoc(19) -> $V;
base24_itoc(20) -> $W;
base24_itoc(21) -> $X;
base24_itoc(22) -> $Y;
base24_itoc(23) -> $Z.

base24_ctoi($A) -> 0;
base24_ctoi($B) -> 1;
base24_ctoi($C) -> 2;
base24_ctoi($D) -> 3;
base24_ctoi($E) -> 4;
base24_ctoi($F) -> 5;
base24_ctoi($G) -> 6;
base24_ctoi($H) -> 7;
base24_ctoi($J) -> 8;
base24_ctoi($K) -> 9;
base24_ctoi($L) -> 10;
base24_ctoi($M) -> 11;
base24_ctoi($N) -> 12;
base24_ctoi($P) -> 13;
base24_ctoi($Q) -> 14;
base24_ctoi($R) -> 15;
base24_ctoi($S) -> 16;
base24_ctoi($T) -> 17;
base24_ctoi($U) -> 18;
base24_ctoi($V) -> 19;
base24_ctoi($W) -> 20;
base24_ctoi($X) -> 21;
base24_ctoi($Y) -> 22;
base24_ctoi($Z) -> 23.