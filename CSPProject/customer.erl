%%%-------------------------------------------------------------------
%%% @author Yash Sheth
%%% @copyright (C) 2019, <CONCORDIA>
%%% @doc
%%%
%%% @end
%%% Created : 15. Jun 2019 19:22
%%%-------------------------------------------------------------------
-module(customer).
-author("yasheth").

%% API
-export([run/4, for/4]).

run(Name, Amount, BankList, InitialAmount) ->
  for(Name, Amount, BankList, InitialAmount).


for(Name, Amount, BankList, InitialAmount) ->
  if
    Amount > 0 ->
      if
        length(BankList) > 0 ->
          if
            Amount > 50 ->
              RequestAmount = rand:uniform(50);
            Amount == 1 ->
              RequestAmount = 1;
            Amount > 1 ->
              RequestAmount = rand:uniform(Amount);
            true ->
              RequestAmount = 0
          end,
          TargetBank = lists:nth(rand:uniform(length(BankList)), BankList),
          io:fwrite("~n~p Requests amount ~w dollar(s) from Bank ~p.", [Name, RequestAmount, TargetBank]),
          PID = whereis(TargetBank),
          PID ! {self(), {Name, RequestAmount}},
          receive
            {Reply} ->
              if
                Reply == RequestAmount ->
                  NewBankList = BankList,
                  NewAmount = Amount - RequestAmount,
                  SleepTime = rand:uniform(100 - 10) + 10,
                  timer:sleep(SleepTime),
                  for(Name, NewAmount, NewBankList, InitialAmount);
                true ->
                  NewAmount = Amount,
                  NewBankList = lists:delete(TargetBank, BankList),
                  SleepTime = rand:uniform(100 - 10) + 10,
                  timer:sleep(SleepTime),
                  for(Name, NewAmount, NewBankList, InitialAmount)
              end
          end;
        true ->
          io:fwrite("~n~p was able to borrow only ~w dollar(s). Boo Hoo!", [Name, InitialAmount - Amount])
      end;
    Amount == 0 ->
      io:fwrite("~n~p has reached the objective of ~w dollar(s). Woo Hoo!", [Name, InitialAmount]);
    true ->
      true
  end.
