%% Оказывается, в шелле эрланга можно закрывать любую скобку при помощи ^]

-compile(export_all).

io:format("Let see: c: ~c~n f: ~.2f~n e: ~e~n g: ~g~n g: ~g~n s: ~s~n s: ~s~n b: ~b~n", [$y, 2.3, 12312312.12312312, 12312.123, 2.1, "byka String", atom, 25]).
% Let see: c: y
%  f: 2.30
%  e: 1.23123e+7
%  g: 1.23121e+4
%  g: 2.10000
%  s: byka String
%  s: atom
%  b: 25
ok

%% From string to erl term
F1 = fun(S)-> {ok, T, _} = erl_scan:string(S, 0, []), erl_parse:parse_term(T) end.

-spec date_to_iso(calendar:date()) -> iolist().
date_to_iso({Y, M, D}) ->
  io_lib:format("~4..0b-~2..0b-~2..0b", [Y, M, D]).

-define(TIME(Exprs), begin
  {Time, Res} = timer:tc(fun() -> Exprs end),
  io:format(??Exprs " ~b~n", [Time]),
  Res
end).

-define(TIME(Name,Exprs), begin
  {Time, Res} = timer:tc(fun() -> Exprs end),
  PrevTime = case get(Name) of undefined -> 0; Prev-> Prev end,
  put(Name, PrevTime + Time),
  Res
end).
%Then
erase(Name).

%% Sym all binary Numbers
FF=fun F(<<W:8, Rest/binary>>, Acc0) -> Acc1 = Acc0 + W, F(Rest, Acc1);F (<<>>, Acc) -> Acc end.

monitoring() ->
  S = self(),
  spawn(
    fun() -> 
      lager:notice("monitoring for ~p ~s, STARTED", [S, ?MODULE]),
      monitor(process, S), 
      receive Some -> 
        lager:notice("monitoring for ~p ~s, Get and ENDED: ~p", [S, ?MODULE, Some]) 
      end
    end).
  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  Useful in console
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

r3:do(compile).

ReceiverFramePid = 
spawn(fun Flusher()-> receive Some -> Flusher() after 3000 -> io:fwrite("NoFrame from camera!~n", []), Flusher() end end).

ReceiverPrinterMsgPid = 
spawn(fun Flusher()-> receive Some -> io:format("Message = ~p~n", [Some]), Flusher() end end).

timer:tc(fun()-> 5 * 5 end).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  General functions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

shuffle(List) ->
  [Y||{_,Y} <- lists:sort([ {rand:uniform(), N} || N <- List])].
  
flush() -> receive _ -> flush() after 0 -> ok end.

case length(lists:ukeysort(1, List)) =:= length(List) of
  true -> true;
  false -> {error, {duplicate_forbidden, List}}
end;

is_module_loaded(Module) ->
  case (catch Module:module_info(module)) of
    Module -> true;
    _ -> false
  end.

is_nonempty_string(Expr) -> is_string(Expr) andalso Expr =/= "".

is_string(Expr) when is_list(Expr) ->
  io_lib:printable_list(Expr);
is_string(_) -> false.

-spec filterfoldlmap(ProcessFun, Acc0 :: term(), InList :: [Elem]) ->
  {error, Reason} | {ok, FilteredProcessedList, AccOut}
  when
  Elem :: term(),
  ProcessFun :: fun((Elem, AccIn) ->
    {ok, NewElemInList, AccOut} | {ok, AccOut} | {error, Reason}),
  NewElemInList :: term(),
  Reason :: term(),
  AccOut :: term(),
  AccIn :: term(),
  FilteredProcessedList :: [NewElemInList].
filterfoldlmap(Fun, Acc0, InList) ->
  filterfoldlmap(Fun, Acc0, InList, []).

filterfoldlmap(Fun, Acc, [E | T], OutList) ->
  case Fun(E, Acc) of
    {ok, NewAcc} -> filterfoldlmap(Fun, NewAcc, T, OutList);
    {ok, NewElem, NewAcc} ->
      filterfoldlmap(Fun, NewAcc, T, [NewElem | OutList]);
    {error, _} = Er -> Er
  end;
filterfoldlmap(_Fun, AccOut, [], OutList) -> {ok, OutList, AccOut}.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  EUnit
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

-ifdef(EUNIT).
-include_lib("eunit/include/eunit.hrl").

try validate_ui_spec(example_result_on_get_config())
catch Class:Reason ->
  ?debugFmt("~nStacktrace:~s~n", [lager:pr_stacktrace(erlang:get_stacktrace(), {Class, Reason})])
end,
?assert(false),

-endif. %% EUNIT

