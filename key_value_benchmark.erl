-module(key_value_benchmark).
-export([benchmark/0]).

benchmark() ->
    {ListTime, _} = timer:tc(fun list_operations/0),
    {MapTime, _} = timer:tc(fun map_operations/0),
    {EtsTime, _} = timer:tc(fun ets_operations/0),

    ListTimeMs = ListTime div 1000,
    MapTimeMs = MapTime div 1000,
    EtsTimeMs = EtsTime div 1000,

    io:format("Lists operations time: ~p microseconds (~p milliseconds)~n", [ListTime, ListTimeMs]),
    io:format("Maps operations time: ~p microseconds (~p milliseconds)~n", [MapTime, MapTimeMs]),
    io:format("ETS operations time: ~p microseconds (~p milliseconds)~n", [EtsTime, EtsTimeMs]).

list_operations() ->
    List = [],
    List1 = [{key1, value1} | List],
    List2 = lists:keyreplace(key1, 1, List1, {key1, new_value}),
    lists:keydelete(key1, 1, List2),
    lists:keyfind(key1, 1, List2).

map_operations() ->
    Map = #{},
    Map1 = Map#{key1 => value1},
    Map2 = Map1#{key1 => new_value},
    maps:remove(key1, Map2),
    maps:get(key1, Map2).

ets_operations() ->
    Tab = ets:new(test_table, [named_table, set]),
    ets:insert(Tab, {key1, value1}),
    ets:insert(Tab, {key1, new_value}),
    ets:delete(Tab, key1),
    ets:lookup(Tab, key1).