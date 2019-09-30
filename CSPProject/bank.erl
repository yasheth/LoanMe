%%%-------------------------------------------------------------------
%%% @author Yash Sheth
%%% @copyright (C) 2019, <CONCORDIA>
%%% @doc
%%%
%%% @end
%%% Created : 15. Jun 2019 19:21
%%%-------------------------------------------------------------------
-module(bank).
-author("yasheth").

%% API
-export([run/3]).

run(Name,Amount,Customers)->
  if
    Customers > 0 ->
      receive
        {Sender, {CustomerName, RequestAmount}} ->
          if
            Amount-RequestAmount > 0->
              io:fwrite("~n~p APPROVES loan request of ~w dollar(s) from ~p ",[Name,RequestAmount,CustomerName]),
              NewAmount=Amount-RequestAmount,
              Sender ! {RequestAmount},
              run(Name,NewAmount,Customers);
            true ->
              io:fwrite("~n~p DENIES loan request of ~w dollar(s) from ~p ",[Name,RequestAmount,CustomerName]),
              Sender ! {0},
              run(Name,Amount,Customers-1)
          end
      after 4000 ->
        io:fwrite("~n~p has ~w dollar(s) remaining.",[Name,Amount])
      end;
    true ->
      io:fwrite("~n~p has ~w dollar(s) remaining.",[Name,Amount])
  end.
