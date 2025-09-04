-- drop table [temp].[nfl_nfapi_player_game_stats_stacked]


/*
select * into [temp].[nfl_nfapi_player_game_stats_stacked] from [temp].[nfl_nfapi_player_game_stats_stacked_2013]
union all select * from [temp].[nfl_nfapi_player_game_stats_stacked_2014]
union all select * from [temp].[nfl_nfapi_player_game_stats_stacked_2015]
union all select * from [temp].[nfl_nfapi_player_game_stats_stacked_2016]
union all select * from [temp].[nfl_nfapi_player_game_stats_stacked_2017]
union all select * from [temp].[nfl_nfapi_player_game_stats_stacked_2018]
union all select * from [temp].[nfl_nfapi_player_game_stats_stacked_2019]
union all select * from [temp].[nfl_nfapi_player_game_stats_stacked_2020]
union all select * from [temp].[nfl_nfapi_player_game_stats_stacked_2021]
union all select * from [temp].[nfl_nfapi_player_game_stats_stacked_2022]
union all select * from [temp].[nfl_nfapi_player_game_stats_stacked_2023]
union all select * from [temp].[nfl_nfapi_player_game_stats_stacked_2024]
*/

/*
drop table [temp].[nfl_nfapi_player_game_stats_stacked_2013]
drop table [temp].[nfl_nfapi_player_game_stats_stacked_2014]
drop table [temp].[nfl_nfapi_player_game_stats_stacked_2015]
drop table [temp].[nfl_nfapi_player_game_stats_stacked_2016]
drop table [temp].[nfl_nfapi_player_game_stats_stacked_2017]
drop table [temp].[nfl_nfapi_player_game_stats_stacked_2018]
drop table [temp].[nfl_nfapi_player_game_stats_stacked_2019]
drop table [temp].[nfl_nfapi_player_game_stats_stacked_2020]
drop table [temp].[nfl_nfapi_player_game_stats_stacked_2021]
drop table [temp].[nfl_nfapi_player_game_stats_stacked_2022]
drop table [temp].[nfl_nfapi_player_game_stats_stacked_2023]
drop table [temp].[nfl_nfapi_player_game_stats_stacked_2024]
*/


/*
select distinct stat_type from [temp].[nfl_nfapi_player_game_stats_stacked] a 
where try_convert(decimal(12, 6), a.stat_value) is null

select * from [temp].[nfl_nfapi_player_game_stats_stacked] a where 1 = 1
and a.stat_type in ('C/ATT', 'FG', 'SACKS', 'XP')
and try_convert(decimal(12, 6), a.stat_value) is null
*/

/*
select 
a.player_id 
, a.game_id
, a.player_name
, a.stat_type
, value_01 = case 
when a.stat_type in ('C/ATT', 'FG', 'XP') then substring(a.stat_value, 1, charindex('/', a.stat_value) - 1)
when a.stat_type  = 'SACKS' then substring(a.stat_value, 1, charindex('-', a.stat_value) - 1) 
else '' end
, value_02 = case 
when a.stat_type in ('C/ATT', 'FG', 'XP') then substring(a.stat_value, charindex('/', a.stat_value) + 1, len(a.stat_value))
when a.stat_type  = 'SACKS' then substring(a.stat_value, charindex('-', a.stat_value) + 1, len(a.stat_value)) 
else '' end
-- into temp.nfl_nfapi_player_game_stats_stacked_01
from [temp].[nfl_nfapi_player_game_stats_stacked] a
where 1 = 1 
and a.stat_type in ('C/ATT', 'FG', 'SACKS', 'XP')
and try_convert(decimal(12, 6), a.stat_value) is null
*/

/*
select a.* 
from nfapi.nfl_player_game_stats_stacked a
inner join nfapi.nfl_game b on a.game_id = b.external_id
where a.game_id = 401437954 and player_name = 'Trevor Lawrence'
*/


/*
with t00 as 
(
select 
pgss.team_id
, pgss.player_id
, stat_value = sum(stat_value)
, team_rank_player = row_number() over(partition by pgss.team_id order by sum(stat_value) desc)
from nfapi.nfl_player_game_stats_stacked pgss 
left join nfapi.nfl_game gm on pgss.game_id = gm.external_id 
where 1 = 1
and gm.season = 2024
and gm.season_type = 2 -- only regular season
and pgss.stat_category = 'receiving'
and pgss.stat_type = 'REC'
group by 
pgss.team_id
, pgss.player_id
),
t01 as 
(
select 
    a.*
    , cum_value = sum(a.stat_value) over(partition by a.team_id order by a.stat_value desc rows between unbounded preceding and CURRENT row)
    , the_percent = (a.stat_value) / (b.stat_value)
    , cum_percent = sum(a.stat_value) over(partition by a.team_id order by a.stat_value desc rows between unbounded preceding and CURRENT row) / b.stat_value
from t00 a
inner join (select team_id, sum(stat_value) as stat_value from t00 group by team_id) b on a.team_id = b.team_id
)
select
team_rank_player 
, avg(the_percent)
, avg(cum_percent)
from t01
group by team_rank_player
*/

/*
select 
    a.player_id
    , a.name_display
    , a.season
    , a.week_num 
    , a.qbr_total
    , season_week = concat(a.season, ', ', a.week_text)
    , player_game_id = row_number() over(partition by a.player_id, a.name_display order by a.season asc, (case when a.season_type = 'Regular' then 0 else 1 end) asc, a.week_num asc)
-- into temp.nfl_failure_to_launch_00
from nflpy.nfl_qbr_week a 
inner join (select name_display, the_count = count(*) from nflpy.nfl_qbr_week group by name_display having count(*) >= 20) b on a.name_display = b.name_display
where 1 = 1 
    -- these guys have been around for a bit too long to count (as in, pre 2006)
    and a.player_id not in (8416, 5536, 112, 4459, 3636, 1753, 2580, 5526, 2026, 1682, 5615, 2549, 1428, 2330
    , 1575, 8520, 3609, 1693, 1383, 2149, 4480, 734, 2299, 5547, 733, 3531, 1398, 3529)
*/


/*
with t00 as 
(
select  
   a.player_id 
    , player_rank_season_week = row_number() over (partition by a.player_id order by a.season asc, a.game_week)
    , a.qbr_total
from nflpy.nfl_qbr_week a 
where 1 = 1 
    -- these guys have been around for a bit too long to count (as in, pre 2006)
    and a.player_id not in (8416, 5536, 112, 4459, 3636, 1753, 2580, 5526, 2026, 1682, 5615, 2549, 1428, 2330
    , 1575, 8520, 3609, 1693, 1383, 2149, 4480, 734, 2299, 5547, 733, 3531, 1398, 3529)
-- order by 
--   a.player_id 
--    , a.season
--    , a.game_week
)
select a.*
from t00 a  
inner join (select 2 as cutoff_value) c on 1 = 1 
inner join (select player_id, the_count = count(*) from nflpy.nfl_qbr_week b group by player_id) b on a.player_id = b.player_id and b.the_count >= c.cutoff_value
-- where a.player_rank_season_week <= c.cutoff_value
order by a.player_id asc
, a.player_rank_season_week asc
*/



-- drop table if exists
if object_id('temp.qbr_prediction_josh_allen_00', 'U') is not null
drop table temp.qbr_prediction_josh_allen_00;
if object_id('temp.qbr_prediction_josh_allen_01', 'U') is not null
drop table temp.qbr_prediction_josh_allen_01; 
if object_id('temp.qbr_prediction_josh_allen_02', 'U') is not null
drop table temp.qbr_prediction_josh_allen_02; 


select
b.* 
, qbr_cumulative_avg = sum(b.qbr_total) over(partition by b.player_id order by b.player_rank_season_week asc rows between unbounded preceding and CURRENT row) / b.player_rank_season_week
into temp.qbr_prediction_josh_allen_00
from
(
select
  a.player_id 
    , player_rank_season_week = row_number() over (partition by a.player_id order by a.season asc, a.game_week)
    , a.qbr_total
from nflpy.nfl_qbr_week a
inner join (select name_display, the_count = count(*) from nflpy.nfl_qbr_week group by name_display having count(*) >= 20) b on a.name_display = b.name_display
where 1 = 1 
   -- these guys have been around for a bit too long to count (as in, pre 2006)
    and a.player_id not in (8416, 5536, 112, 4459, 3636, 1753, 2580, 5526, 2026, 1682, 5615, 2549, 1428, 2330
    , 1575, 8520, 3609, 1693, 1383, 2149, 4480, 734, 2299, 5547, 733, 3531, 1398, 3529
    , 2440, 1417, 735, 2658, 3560, 2206, 1177, 1884, 4477, 393, 4555, 445, 2704, 2343, 2655, 1490, 331, 531, 1762, 478, 4465, 649, 9635, 1493, 8439, 9, 4699, 622)
)
b
-- where player_rank_season_week <= 100

select 
    a.*
    , qbr_percent_of_max = a.qbr_cumulative_avg / b.max_qbr_cumulative_avg
into temp.qbr_prediction_josh_allen_01
from temp.qbr_prediction_josh_allen_00 a
inner join (select player_id, max(qbr_cumulative_avg) as max_qbr_cumulative_avg from temp.qbr_prediction_josh_allen_00 group by player_id) b on a.player_id = b.player_id


select 
player_rank_season_week
, avg_qbr_percent_of_max = avg(qbr_percent_of_max) 
into temp.qbr_prediction_josh_allen_02
from temp.qbr_prediction_josh_allen_01 
group by player_rank_season_week





-- drop table if exists
if object_id('temp.qbr_prediction_josh_allen_00', 'U') is not null
drop table temp.qbr_prediction_josh_allen_00;
if object_id('temp.qbr_prediction_josh_allen_01', 'U') is not null
drop table temp.qbr_prediction_josh_allen_01;
if object_id('temp.qbr_prediction_josh_allen_02', 'U') is not null
drop table temp.qbr_prediction_josh_allen_02; 


/*
select
    a.player_id 
    , how_many_games = max(b.max_player_rank_season_week)
    , when_max_occurred = max(a.player_rank_season_week)
from temp.qbr_prediction_josh_allen_01 a
left join (select player_id, max(player_rank_season_week) as max_player_rank_season_week from temp.qbr_prediction_josh_allen_01 group by player_id) b on a.player_id = b.player_id
inner join (select player_id, max_qbr_percent_of_max = max(qbr_percent_of_max) from temp.qbr_prediction_josh_allen_01 group by player_id) c on a.player_id = c.player_id and a.qbr_percent_of_max = c.max_qbr_percent_of_max
group by 
    a.player_id


select 
select player_id, thing = max(qbr_percent_of_max)
from temp.qbr_prediction_josh_allen_01 
group by player_id
*/
/*
select 
    a.*
    , b.player_rank_season_week
from temp.qbr_prediction_josh_allen_00 a
left join temp.qbr_prediction_josh_allen_00 b on a.player_id = b.player_id and a.player_rank_season_week = b.player_rank_season_week + 1








/*
select
  a.player_id 
    , max(name_display)
    , avg(a.qbr_total)
    , count(*)
    , min(season)
    , max(season)
from nflpy.nfl_qbr_week a
where 1 = 1 
    -- these guys have been around for a bit too long to count (as in, pre 2006)
    and a.player_id not in (8416, 5536, 112, 4459, 3636, 1753, 2580, 5526, 2026, 1682, 5615, 2549, 1428, 2330
    , 1575, 8520, 3609, 1693, 1383, 2149, 4480, 734, 2299, 5547, 733, 3531, 1398, 3529
    , 2440, 1417, 735, 2658, 3560, 2206, 1177, 1884, 4477, 393, 4555, 445, 2704, 2343, 2655, 1490, 331, 531, 1762, 478, 4465, 649, 9635, 1493, 8439, 9, 4699, 622)
group by a.player_id 
order by min(season) asc 
*/
-- select * from nflpy.nfl_qbr_week where player_id = 393

/*
select
  a.player_id 
    , player_rank_season_week = row_number() over (partition by a.player_id order by a.season asc, a.game_week)
    , a.qbr_total
from nflpy.nfl_qbr_week a
-- inner join (select name_display, the_count = count(*) from nflpy.nfl_qbr_week group by name_display having count(*) >= 20) b on a.name_display = b.name_display
where 1 = 1 
    and a.name_display like '%Stroud%'
*/
