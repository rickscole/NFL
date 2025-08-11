select a.player_id
, pl.display_name 
, b.stat_value
, c.stat_value
, (b.stat_value) / (c.stat_value) 
from (select distinct player_id from nfapi.nfl_player_game_stats_stacked) a 
inner join (select player_id, sum(stat_value) as stat_value from nfapi.nfl_player_game_stats_stacked where stat_type = 'REC' group by player_id) b on a.player_id = b.player_id
inner join (select player_id, sum(stat_value) as stat_value from nfapi.nfl_player_game_stats_stacked where stat_type = 'TGTS' group by player_id) c on a.player_id = c.player_id
left join nfapi.nfl_player pl on a.player_id = pl.external_id
-- where pl.display_name = 'Justin Jefferson'
where (c.stat_value)  >= 100



select 
pl.display_name
, a.player_id
, sum(a.stat_value) as stat_value 
from nfapi.nfl_player_game_stats_stacked a
left join nfapi.nfl_player pl on a.player_id = pl.external_id
where a.stat_type = 'REC' -- and pl.display_name like '%Travis Kelce%'
group by pl.display_name
, a.player_id


select * from nfapi.nfl_game where season >= 2013

select season, count(*) from nfapi.nfl_game group by season


select 
a.external_id
, count(*)
from nfapi.nfl_game a 
left join nfapi.nfl_player_game_stats_stacked b on a.external_id = b.game_id
where a.season = 2023
group by a.external_id


select a.*
from nfapi.nfl_player_game_stats_stacked a
inner join nfapi.nfl_game b on a.game_id = b.external_id
where a.player_id = 15847 and b.season = 2024 and a.stat_type = 'REC'



select * from nfapi.nfl_game
where season = 2024 and (home_team = 'KC' or away_team = 'KC')

select a.* 
, b.display_name
from nfapi.nfl_player_game_stats_stacked a
left join nfapi.nfl_player b on a.player_id = b.external_id
where a.game_id = 401671651

select * from nfapi.nfl_player where display_name like '%Kelce%'

EXEC sp_spaceused 'nfapi.nfl_player_game_stats_stacked';


select external_id from nfapi.nfl_game where season = 2016

select * from nfapi.nfl_game where external_id = 400791795


select * from nfapi.nfl_player where display_name like '%Diggs%'
select * from nfapi.nfl_team

select 
pgss.*
, pl.display_name
, gm.home_team
, gm.away_team
, gm.season_type
from nfapi.nfl_player_game_stats_stacked pgss 
left join nfapi.nfl_player pl on pgss.player_id = pl.external_id
left join nfapi.nfl_game gm on pgss.game_id = gm.external_id
-- left join nfapi.nfl_team tm on pl.team_id = tm.external_id
where 1 = 1 
and pl.display_name like '%Kelce%'
and gm.season = 2024
and gm.season_type = 2


