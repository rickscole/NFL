create procedure jjprx.nfl_create_mart as 

-- predrop tables
if object_id('temp.nfl_jj_rating_prediction_01', 'U') is not null
drop table temp.nfl_jj_rating_prediction_01; 
if object_id('temp.nfl_jj_rating_prediction_02', 'U') is not null
drop table temp.nfl_jj_rating_prediction_02; 
if object_id('jjprx.nfl_actual_and_trend', 'U') is not null
drop table jjprx.nfl_jj_actual_and_trend; 


-- add player game id
select 
a.pfr_player_id
, player_game_id = row_number() over(partition by a.pfr_player_id order by a.season asc, a.week asc)
, a.receiving_rat
into temp.nfl_jj_rating_prediction_01
from [nflpy].[nfl_pfr_weekly_rec] a 
where a.pfr_player_id = 'JeffJu00'


-- add in the trend exception definition parameters
select 
a.* 
, b.instant
, b.short
, b.medium 
, b.intermediate
, b.long
into temp.nfl_jj_rating_prediction_02
from temp.nfl_jj_rating_prediction_01 a 
left join nfl_trend_horizon_exception b on a.player_game_id = b.number_of_games


-- gather and aggregate
select 
    /*
    t_00.*
    , t_01.player_game_id
    , t_01.receiving_rat
    */
    t_00.player_game_id
    , actual = max(t_00.receiving_rat)
    , instant_trend = avg(t_01.receiving_rat)
    , short_trend = avg(t_02.receiving_rat)
    , medium_trend = avg(t_03.receiving_rat)
    , intermediate_trend = avg(t_04.receiving_rat)
    , long_trend = avg(t_05.receiving_rat)
into jjprx.nfl_jj_actual_and_trend
from (select distinct pfr_player_id, player_game_id, receiving_rat, instant, short, medium, intermediate, long from temp.nfl_jj_rating_prediction_02) t_00 
left join temp.nfl_jj_rating_prediction_02 t_01 on t_00.player_game_id < (t_01.player_game_id + coalesce(t_00.instant, 2) + 1) and t_00.player_game_id >= (t_01.player_game_id + 1)
left join temp.nfl_jj_rating_prediction_02 t_02 on t_00.player_game_id < (t_02.player_game_id + coalesce(t_00.short, 4) + 1) and t_00.player_game_id >= (t_02.player_game_id + 1)
left join temp.nfl_jj_rating_prediction_02 t_03 on t_00.player_game_id < (t_03.player_game_id + coalesce(t_00.medium, 8) + 1) and t_00.player_game_id >= (t_03.player_game_id + 1)
left join temp.nfl_jj_rating_prediction_02 t_04 on t_00.player_game_id < (t_04.player_game_id + coalesce(t_00.intermediate, 16) + 1) and t_00.player_game_id >= (t_04.player_game_id + 1)
left join temp.nfl_jj_rating_prediction_02 t_05 on t_00.player_game_id < (t_05.player_game_id + coalesce(t_00.long, 32) + 1) and t_00.player_game_id >= (t_05.player_game_id + 1)
    -- on t_00.player_game_id > (t_01.player_game_id + coalesce(t_01.instant, 5)) -- and t_00.player_game_id < (t_01.player_game_id + coalesce(t_01.short, 10))
where 1 = 1
    and t_00.player_game_id > 5
    -- and t_00.player_game_id = 24
group by 
    t_00.player_game_id


-- postdrop tables
if object_id('temp.nfl_jj_rating_prediction_01', 'U') is not null
drop table temp.nfl_jj_rating_prediction_01; 
if object_id('temp.nfl_jj_rating_prediction_02', 'U') is not null
drop table temp.nfl_jj_rating_prediction_02; 
-- if object_id('jjprx.nfl_actual_and_trend', 'U') is not null
-- drop table jjprx.nfl_jj_actual_and_trend; 
