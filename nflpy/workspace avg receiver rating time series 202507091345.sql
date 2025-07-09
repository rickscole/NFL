
/*
select 
a.opponent 
, a.season 
, avg_receiving_rat = avg(a.receiving_rat)
from nflpy.nfl_pfr_weekly_rec a
where a.game_type = 'REG'
group by 
a.opponent 
, a.season 




select
    ts.external_id
    , ts.season 
    , ts.team_name
    , ts.game_date
    , ts.points_allowed 
    , game_season_rank_id = row_number() over(partition by ts.season, ts.team_name order by ts.game_date asc) 
    , opponent_name = case when ts.team_name = sc.away_team then sc.home_team else sc.away_team end
from team_score ts
inner join bi.team tm on ts.team_name = tm.name and tm.is_nba_team = 1
inner join clean.scores sc on ts.external_id = sc.external_id
where 1 = 1
    and ts.season in (2024, 2023)
    and ts.game_type = 'Regular'
*/



if object_id('temp.nfl_pfr_weekly_rec_game_preceding_00', 'U') is not null
drop table temp.nfl_pfr_weekly_rec_game_preceding_00; 
if object_id('temp.nfl_pfr_weekly_rec_game_preceding_01', 'U') is not null
drop table temp.nfl_pfr_weekly_rec_game_preceding_01; 
if object_id('temp.nfl_pfr_weekly_rec_game_preceding_02', 'U') is not null
drop table temp.nfl_pfr_weekly_rec_game_preceding_02; 
if object_id('temp.nfl_pfr_weekly_rec_game_preceding_03', 'U') is not null
drop table temp.nfl_pfr_weekly_rec_game_preceding_03; 
if object_id('temp.nfl_pfr_weekly_rec_game_preceding_04', 'U') is not null
drop table temp.nfl_pfr_weekly_rec_game_preceding_04; 


select 
opponent
, season 
, week 
, avg_receiving_rat = avg(receiving_rat)
, opponent_game_season_id = row_number() over(partition by a.opponent order by a.season asc, a.week asc)
into temp.nfl_pfr_weekly_rec_game_preceding_00
from nflpy.nfl_pfr_weekly_rec a
group by 
opponent
, season 
, week


select 
a.* 
, instant = case when a.opponent_game_season_id < 5 then null else coalesce(b.instant, 2) end
, short = case when a.opponent_game_season_id < 5 then null else coalesce(b.short, 4) end
, medium = case when a.opponent_game_season_id < 5 then null else coalesce(b.medium, 8) end
, intermediate = case when a.opponent_game_season_id < 5 then null else coalesce(b.intermediate, 16) end
, long = case when a.opponent_game_season_id < 5 then null else coalesce(b.long, 32) end 
into temp.nfl_pfr_weekly_rec_game_preceding_01
from temp.nfl_pfr_weekly_rec_game_preceding_00 a 
left join nfl_trend_horizon_exception b on a.opponent_game_season_id = b.number_of_games


-- instant, short, and medium trend
-- I have to divide these up, because if not, performance is too long for some reason
select 
t_00.opponent
, t_00.opponent_game_season_id
, actual = max(t_00.avg_receiving_rat)
, instant_trend = avg(t_01.avg_receiving_rat)
, short_trend = avg(t_02.avg_receiving_rat)
, medium_trend = avg(t_03.avg_receiving_rat)
into temp.nfl_pfr_weekly_rec_game_preceding_02
from temp.nfl_pfr_weekly_rec_game_preceding_01 t_00 
left join temp.nfl_pfr_weekly_rec_game_preceding_01 t_01 on t_00.opponent_game_season_id < (t_01.opponent_game_season_id + t_00.instant + 1) and t_00.opponent_game_season_id >= (t_01.opponent_game_season_id + 1) and t_00.opponent = t_01.opponent
left join temp.nfl_pfr_weekly_rec_game_preceding_01 t_02 on t_00.opponent_game_season_id < (t_02.opponent_game_season_id + t_00.short + 1) and t_00.opponent_game_season_id >= (t_02.opponent_game_season_id + 1) and t_00.opponent = t_02.opponent
left join temp.nfl_pfr_weekly_rec_game_preceding_01 t_03 on t_00.opponent_game_season_id < (t_03.opponent_game_season_id + t_00.medium + 1) and t_00.opponent_game_season_id >= (t_03.opponent_game_season_id + 1) and t_00.opponent = t_03.opponent
where 1 = 1
and t_00.opponent_game_season_id > 5
group by 
t_00.opponent
, t_00.opponent_game_season_id



select 
t_00.opponent
, t_00.opponent_game_season_id
, intermediate_trend = avg(t_04.avg_receiving_rat)
into temp.nfl_pfr_weekly_rec_game_preceding_03
from temp.nfl_pfr_weekly_rec_game_preceding_01 t_00 
left join temp.nfl_pfr_weekly_rec_game_preceding_01 t_04 on t_00.opponent_game_season_id < (t_04.opponent_game_season_id + t_00.intermediate + 1) and t_00.opponent_game_season_id >= (t_04.opponent_game_season_id + 1) and t_00.opponent = t_04.opponent
where 1 = 1
and t_00.opponent_game_season_id > 5
group by 
t_00.opponent
, t_00.opponent_game_season_id



select 
t_00.opponent
, t_00.opponent_game_season_id
, long_trend = avg(t_05.avg_receiving_rat)
into temp.nfl_pfr_weekly_rec_game_preceding_04
from temp.nfl_pfr_weekly_rec_game_preceding_01 t_00 
left join temp.nfl_pfr_weekly_rec_game_preceding_01 t_05 on t_00.opponent_game_season_id < (t_05.opponent_game_season_id + coalesce(t_00.long, 32) + 1) and t_00.opponent_game_season_id >= (t_05.opponent_game_season_id + 1) and t_00.opponent = t_05.opponent
where 1 = 1
and t_00.opponent_game_season_id > 5
group by 
t_00.opponent
, t_00.opponent_game_season_id


select 
    a.* 
    , b.intermediate_trend
    , c.long_trend
from temp.nfl_pfr_weekly_rec_game_preceding_02 a
left join temp.nfl_pfr_weekly_rec_game_preceding_03 b on a.opponent_game_season_id = b.opponent_game_season_id and a.opponent = b.opponent 
left join temp.nfl_pfr_weekly_rec_game_preceding_04 c on a.opponent_game_season_id = c.opponent_game_season_id and a.opponent = c.opponent 




if object_id('temp.nfl_pfr_weekly_rec_game_preceding_00', 'U') is not null
drop table temp.nfl_pfr_weekly_rec_game_preceding_00; 
if object_id('temp.nfl_pfr_weekly_rec_game_preceding_01', 'U') is not null
drop table temp.nfl_pfr_weekly_rec_game_preceding_01; 
if object_id('temp.nfl_pfr_weekly_rec_game_preceding_02', 'U') is not null
drop table temp.nfl_pfr_weekly_rec_game_preceding_02; 
if object_id('temp.nfl_pfr_weekly_rec_game_preceding_03', 'U') is not null
drop table temp.nfl_pfr_weekly_rec_game_preceding_03; 
if object_id('temp.nfl_pfr_weekly_rec_game_preceding_04', 'U') is not null
drop table temp.nfl_pfr_weekly_rec_game_preceding_04; 


