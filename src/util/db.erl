%% Copyright 2012 by Jesse Gumm, Released under MIT License
-module(db).
-include("db.hrl").
-compile(export_all).

-define(WARNING(QueryText,Msg), error_logger:info_msg("QUERY WARNING: ~p~n~nQuery:~n~p~n~n",[Msg,QueryText])).

% only include the next line if we need to use mnesia
%-include_lib("stdlib/include/qlc.hrl").


%% This is a bit of a mess, since finding out the default Db requires reading host header
%% TODO: find out if there's a better way to do this, either by specifying the database at the beginning of every request or what
db() ->
	case erlang:get(db) of
		undefined -> default();
		DB -> DB
	end.

db(DB) ->
	erlang:put(db,DB),
	DB.

default() ->
	test.

%% connect to the mysql database

log(_Module,_Line,debug,Params) ->
	{Msg,Args} = Params(),
	io:format(Msg,Args),
	io:format("~n~n");
log(_Module,_Line,Other,Params) ->
	sigma:log({Other,Params()}).
	

start() ->
	mysql:start(default(),?DBHOST,3306,?DBUSER,?DBPW,atom_to_list(default()),fun ?MODULE:log/4).

connect() ->
	connect(db()).

connect(Db) when is_atom(Db) ->
	mysql:connect(Db,?DBHOST,undefined,?DBUSER,?DBPW,atom_to_list(Db),undefined,false),
	Db.



pl(Table,PropList) when is_list(Table) ->
	pl(list_to_atom(Table),PropList);
pl(Table,PropList) ->
	KeyField = list_to_atom(atom_to_list(Table) ++ "id"),
	KeyValue = proplists:get_value(KeyField,PropList,0),
	case KeyValue of
		Zero when Zero==0;Zero=="0"-> 
			pli(Table,pl:delete(PropList,KeyField));
		_ -> 
			plu(Table,PropList)
	end.


%% Inserts a proplist into the table
pli(Table,PropList) when is_atom(Table) ->
	pli(atom_to_list(Table),PropList);
pli(Table,PropList) ->
	Sets = [atom_to_list(F) ++ "=" ++ mysql:encode(V) || {F,V} <- PropList],
	Set = string:join(Sets,","),
	SQL = "insert into " ++ Table ++ " set " ++ Set,
	qi(SQL).

%% Updates a row from the proplist based on the key `Table ++ "id"` in the Table
plu(Table,PropList) when is_atom(Table) ->
	plu(atom_to_list(Table),PropList);
plu(Table,PropList) ->
	KeyField = list_to_atom(Table ++ "id"),
	KeyValue = proplists:get_value(KeyField,PropList),
	Sets = [atom_to_list(F) ++ "=" ++ mysql:encode(V) || {F,V} <- PropList,F /= KeyField],
	Set = string:join(Sets,","),
	SQL = "update " ++ Table ++ " set " ++ Set ++ " where " ++ atom_to_list(KeyField) ++ "=" ++ mysql:encode(KeyValue),
	q(SQL),
	KeyValue.

%% proplist query
plq(Q) ->
	Db = db(),
	db_q(proplist,Db,Q).

plq(Q,ParamList) ->
	Db = db(),
	db_q(proplist,Db,Q,ParamList).

%% dict query
dq(Q) ->
	Db = db(),
	db_q(dict,Db,Q).

dq(Q,ParamList) ->
	Db = db(),
	db_q(dict,Db,Q,ParamList).

%% tuple query
tq(Q) ->
	Db = db(),
	db_q(tuple,Db,Q).

tq(Q,ParamList) ->
	Db = db(),
	db_q(tuple,Db,Q,ParamList).


format_result(Type,Res) ->
	Res1 = sigma:deep_unbinary(mysql:get_result_rows(Res)),
	case Type of
		list ->
			Res1;
		tuple ->
			[list_to_tuple(R) || R<-Res1];
		Other when Other==proplist;Other==dict -> 
			Fields = mysql:get_result_field_info(Res),
			Proplists = [format_proplist_result(R,Fields) || R<-Res1],
			case Other of
				proplist -> Proplists;
				dict -> [dict:from_list(PL) || PL <- Proplists]
			end	
	end.

format_proplist_result(Row,Fields) ->
	FieldNames = [list_to_atom(binary_to_list(F)) || {_,F,_,_} <- Fields],
	lists:zip(FieldNames,Row).

%% Query from the specified Database pool (Db)
%% This will connect to the specified Database Pool
%% Type must be atoms: proplist, dict, list, or tuple
%% Type can also be atom 'insert' in which case, it'll return the insert value

db_q(Type,Db,Q) ->
	case mysql:fetch(Db,Q) of
		{data, Res} ->
			format_result(Type,Res);
		{updated, Res} ->
			case Type of
				insert -> mysql:get_result_insert_id(Res);
				_ -> mysql:get_result_affected_rows(Res)
			end;
		{error, {no_connection_in_pool,_}} ->
			NewDB = connect(),
			db_q(Type,NewDB,Q);
		{error, Res} ->
			{error, mysql:get_result_reason(Res)}
	end.

db_q(Type,Db,Q,ParamList) ->
	NewQ = q_prep(Q,ParamList),
	db_q(Type,Db,NewQ).

%%  A special Query function just for inserting.
%%  Inserts the record(s) and returns the insert_id
qi(Q) ->
	Db = db(),
	db_q(insert,Db,Q).

qi(Q,ParamList) ->
	Db = db(),
	db_q(insert,Db,Q,ParamList).

%% Query the database and return the relevant information
%% If a select query, it returns all the rows
%% If an update or Insert query, it returns the number of rows affected
q(Q) ->
	Db = db(),
	db_q(list,Db,Q).

q(Q,ParamList) ->
	Db = db(),
	db_q(list,Db,Q,ParamList).


%% fr = First Record
plfr(Q,ParamList) ->
	case plq(Q,ParamList) of
		[] -> not_found;
		[[undefined]] -> not_found;
		[First|_] -> First
	end.

plfr(Q) ->
	plfr(Q,[]).

%% fr = First Record
fr(Q,ParamList) ->
	case q(Q,ParamList) of
		[] -> not_found;
		[[undefined]] -> not_found;
		[First|_] -> First
	end.

fr(Q) ->
	fr(Q,[]).

%% fffr = First Field of First record
fffr(Q,ParamList) ->
	case fr(Q,ParamList) of
		not_found -> not_found;
		[First|_] -> First
	end.

fffr(Q) ->
	fffr(Q,[]).

%% First Field List
ffl(Q,ParamList) ->
	[First || [First | _ ] <- db:q(Q,ParamList)].

ffl(Q) ->
	ffl(Q,[]).


%% Existance query, just returns true if the query returns anything other than an empty set
%% QE = "Q Exists"
%% TODO: Check for "limit" clause and add? Or rely on user.
qexists(Q) ->
	qexists(Q,[]).

qexists(Q,ParamList) ->
	case q(Q,ParamList) of
		[] -> false;
		[_] -> true;
		[_|_] -> 
			?WARNING({Q,ParamList},"qexists returned more than one record. Recommend returning one record for performance."),
			true
	end.
			
	

%% retrieves a field value from a table
%% ie: Select 'Field' from 'Table' where 'IDField'='IDValue'
%% This should only be called from the db_ modules.  Never in the page.
%% It's not a security thing, just a convention thing
field(Table,Field,IDField,IDValue) when is_atom(Table) ->
	field(atom_to_list(Table),Field,IDField,IDValue);
field(Table,Field,IDField,IDValue) when is_atom(Field) ->
	field(Table,atom_to_list(Field),IDField,IDValue);
field(Table,Field,IDField,IDValue) when is_atom(IDField) ->
	field(Table,Field,atom_to_list(IDField),IDValue);
field(Table,Field,IDField,IDValue) ->
	db:fffr("select " ++ Field ++ " from " ++ Table ++ " where " ++ IDField ++ "= ?",[IDValue]).

%% This does the same as above, but uses Table ++ "id" for the idfield
field(Table,Field,IDValue) when is_atom(Table) ->
	field(atom_to_list(Table),Field,IDValue);
field(Table,Field,IDValue) ->
	field(Table,Field,Table ++ "id",IDValue).


%%% Prepares a query with Parameters %%%%%%%%%%
q_prep(Q,[]) ->
	Q;
q_prep(Q,ParamList) ->
	QParts = re:split(Q,"\\?",[{return,list}]),
	NumParts = length(QParts)-1,
	NumParams = length(ParamList),
	if
		 NumParts == NumParams -> q_join(QParts,ParamList);
		 true -> 
			 throw({error, "Parameter Count in query is not consistent: ?'s = " ++ integer_to_list(NumParts) ++ ", Params = " ++ integer_to_list(NumParams),[{sql,Q},{params,ParamList}]})
	end.

q_join([QFirstPart|[QSecondPart|QRest]],[FirstParam|OtherParam]) when is_list(QFirstPart);is_list(QSecondPart) ->
	NewFirst = QFirstPart ++ encode(FirstParam) ++ QSecondPart,
	q_join([NewFirst|QRest],OtherParam);
q_join([QFirstPart | [QRest]],[FirstParam | [] ]) when is_list(QFirstPart);is_list(QRest) ->
	QFirstPart ++ FirstParam ++ QRest;
q_join([QFirstPart], []) ->
	QFirstPart.

%% Prelim Encoding, then does mysql encoding %%%
%% primarily for the atoms true and false
encode(true) -> "1";
encode(false) -> "0";
encode(Other) -> mysql:encode(Other).


encode64("") -> "";
encode64(undefined) -> "";
encode64(Data) ->
	base64:encode_to_string(term_to_binary(Data)).

decode64("") -> "";
decode64(undefined) -> "";
decode64(Data) ->
	binary_to_term(base64:decode(Data)).

%%%%%%%%%% Takes a list of items and encodes them for SQL then returns a comma-separated list of them
encode_list(List) ->
	NewList = [encode(X) || X<-List],
	string:join(NewList,",").


dict_to_proplist(SrcDict,AcceptableFields) ->
	DictFilterFoldFun = fun(F,Dict) ->
		case dict:is_key(F,Dict) of
			true -> Dict;
			false -> dict:erase(F,Dict)
		end
	end,
	FilteredDict = lists:foldl(DictFilterFoldFun,SrcDict,AcceptableFields),
	dict:to_list(FilteredDict).


to_bool(false) -> 	false;
to_bool(0) -> 		false;
to_bool(undefined) -> 	false;
to_bool(_) -> 		true.