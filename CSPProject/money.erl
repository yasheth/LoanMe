%%%-------------------------------------------------------------------
%%% @author Yash Sheth
%%% @copyright (C) 2019, <CONCORDIA>
%%% @doc
%%%
%%% @end
%%% Created : 15. Jun 2019 19:21
%%%-------------------------------------------------------------------
-module(money).
-author("yasheth").

%% API
-export([start/0]).

start()->
  {ok ,Customer_Strings}=file:consult("customers.txt"),
  io:fwrite("**** CUSTOMERS & LOAN OBJECTIVES ****~n"),
  Customer_Data=maps:from_list(Customer_Strings),
  maps:fold(
    fun(K,V,ok)->
      io:format("Name: ~p Loan: ~p~n",[K,V])
    end, ok,Customer_Data),
  Customer_Size=maps:size(Customer_Data),
%%  io:fwrite("Customers ~p",[Customer_Size]),
  io:fwrite("~n"),
  {ok ,Bank_Strings}=file:consult("banks.txt"),
  io:fwrite("**** BANKS & FINANCIAL RESOURCES ****~n"),
  Bank_Data=maps:from_list(Bank_Strings),
  maps:fold(
    fun(K,V,ok)->
      io:format("Name: ~p Loan: ~p~n",[K,V])
    end, ok,Bank_Data),
  Bank_List=maps:keys(Bank_Data),
  io:fwrite("----------------------------------------"),
  lists:foreach(
    fun(Tuple)->
      Values=tuple_to_list(Tuple),
      register(lists:nth(1,Values),spawn(bank,run,[lists:nth(1,Values), lists:nth(2,Values),Customer_Size])),
      timer:sleep(100)
    end,
    Bank_Strings
  ),
  lists:foreach(
    fun(Tuple)->
      Values=tuple_to_list(Tuple),
      register(lists:nth(1,Values),spawn(customer,run,[lists:nth(1,Values), lists:nth(2,Values),Bank_List,lists:nth(2,Values)])),
      timer:sleep(100)
    end,
    Customer_Strings
  ).