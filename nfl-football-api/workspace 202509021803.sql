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


select 
pgss.*
from nfapi.nfl_player_game_stats_stacked pgss 
left join nfapi.nfl_game gm on pgss.game_id = gm.external_id 
where 1 = 1
and gm.season = 2024
and gm.season_type = 2 -- only regular season
and pgss.stat_category = 'receiving'
and pgss.stat_type = 'REC'

select * from nfapi.nfl_game

select * from nfapi.nfl_team
