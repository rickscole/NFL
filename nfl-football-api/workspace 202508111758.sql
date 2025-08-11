

/*

-- predrop tables
if object_id('temp.nfl_nfapi_player_game_stats_stacked_01', 'U') is not null
drop table temp.nfl_nfapi_player_game_stats_stacked_01;
-- if object_id('nfapi.nfl_player_game_stats_stacked', 'U') is not null
-- drop table nfapi.nfl_player_game_stats_stacked;



select 
a.player_id 
, a.game_id
, a.stat_type
, value_01 = case 
when a.stat_type in ('C/ATT', 'FG', 'XP') then substring(a.stat_value, 1, charindex('/', a.stat_value) - 1)
when a.stat_type  = 'SACKS' then substring(a.stat_value, 1, charindex('-', a.stat_value) - 1) 
else '' end
, value_02 = case 
when a.stat_type in ('C/ATT', 'FG', 'XP') then substring(a.stat_value, charindex('/', a.stat_value) + 1, len(a.stat_value))
when a.stat_type  = 'SACKS' then substring(a.stat_value, charindex('-', a.stat_value) + 1, len(a.stat_value)) 
else '' end
into temp.nfl_nfapi_player_game_stats_stacked_01
from [temp].[nfl_nfapi_player_game_stats_stacked] a
where 1 = 1 
and a.stat_type in ('C/ATT', 'FG', 'SACKS', 'XP')
and try_convert(decimal(12, 6), a.stat_value) is null


insert into nfapi.nfl_player_game_stats_stacked
select e.player_id, e.game_id, e.stat_type, stat_value = try_convert(decimal(18, 6), e.stat_value) 
from [temp].[nfl_nfapi_player_game_stats_stacked] e where e.stat_type not in ('C/ATT', 'FG', 'SACKS', 'XP') union all
select d.* from (
select a.player_id, a.game_id, stat_type = case when a.stat_type = 'C/ATT' then 'COMPS' when a.stat_type = 'SACKS' then 'SCKS' when a.stat_type = 'FG' then 'FGM' when a.stat_type = 'XP' then 'XPM' else null end, value = value_01 from temp.nfl_nfapi_player_game_stats_stacked_01 a
union select b.player_id, b.game_id, stat_type = case when b.stat_type = 'C/ATT' then 'ATTS' when b.stat_type = 'SACKS' then 'YDSL' when b.stat_type = 'FG' then 'FGA' when b.stat_type = 'XP' then 'XPA' else null end, value = value_02 from temp.nfl_nfapi_player_game_stats_stacked_01 b
union select c.player_id, c.game_id, stat_type = case when c.stat_type = 'C/ATT' then 'C/ATT' when c.stat_type = 'SACKS' then 'SACKS' when c.stat_type = 'FG' then 'FG' when c.stat_type = 'XP' then 'XP' else null end, value = case when value_02 = 0 then null else cast( value_01 as decimal(18, 6)) / cast( value_02 as decimal(18, 6)) end from temp.nfl_nfapi_player_game_stats_stacked_01 c
) d where d.value is not null


-- delete from [temp].[nfl_nfapi_player_game_stats_stacked]

-- postdrop tables
if object_id('temp.nfl_nfapi_player_game_stats_stacked_01', 'U') is not null
drop table temp.nfl_nfapi_player_game_stats_stacked_01;

*/




select 
tm.external_id
, sum(pgss.stat_value)
from nfapi.nfl_player_game_stats_stacked pgss 
left join nfapi.nfl_player pl on pgss.player_id = pl.external_id
left join nfapi.nfl_game gm on pgss.game_id = gm.external_id
left join nfapi.nfl_team tm on pl.team_id = tm.external_id
where 1 = 1 
and gm.season = 2024
and gm.season_type = 2
and pgss.stat_type = 'REC'
group by
tm.external_id


select 
distinct pgss.player_id
from nfapi.nfl_player_game_stats_stacked pgss 
left join nfapi.nfl_player pl on pgss.player_id = pl.external_id
left join nfapi.nfl_game gm on pgss.game_id = gm.external_id
left join nfapi.nfl_team tm on pl.team_id = tm.external_id
where 1 = 1 
and gm.season = 2024
and gm.season_type = 2
and pgss.stat_type = 'REC'
and tm.external_id is null


select player_id, player_name, string_agg(position, ', '),  count(*) from nfapi.nfl_player_team_season_position group by player_id, player_name having count(*) > 1 
select * from nfapi.nfl_player_team_season_position where player_name = 'Anthony Gould'

with t0 as 
(
    select 
    a.*
    , b.position_row_id
    from nfapi.nfl_player_team_season_position a 
    left join (
    select 
    position
    , position_row_id = row_number() over(order by count(*) desc)
    from nfapi.nfl_player_team_season_position 
    group by position 
    ) b on a.position = b.position 
)
select a.*
from t0 a
inner join (select player_id, min(position_row_id) as min_position_row_id from t0 group by player_id) b on 1 = 1 
    and a.player_id = b.player_id 
    and a.position_row_id = b.min_position_row_id

