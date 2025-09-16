
if object_id('temp.qbr_prediction_josh_allen_00', 'U') is not null
drop table temp.qbr_prediction_josh_allen_00;
if object_id('temp.qbr_prediction_josh_allen_01', 'U') is not null
drop table temp.qbr_prediction_josh_allen_01;
if object_id('temp.qbr_prediction_josh_allen_02', 'U') is not null
drop table temp.qbr_prediction_josh_allen_02;


select
  a.player_id 
    , player_rank_season_week = row_number() over (partition by a.player_id order by a.season asc, a.game_week)
    , a.qbr_total
into temp.qbr_prediction_josh_allen_00
from nflpy.nfl_qbr_week a
inner join (select name_display, the_count = count(*) from nflpy.nfl_qbr_week group by name_display having count(*) >= 20) b on a.name_display = b.name_display
where 1 = 1 
   -- these guys have been around for a bit too long to count (as in, pre 2006)
    and a.player_id not in (8416, 5536, 112, 4459, 3636, 1753, 2580, 5526, 2026, 1682, 5615, 2549, 1428, 2330
    , 1575, 8520, 3609, 1693, 1383, 2149, 4480, 734, 2299, 5547, 733, 3531, 1398, 3529
    , 2440, 1417, 735, 2658, 3560, 2206, 1177, 1884, 4477, 393, 4555, 445, 2704, 2343, 2655, 1490, 331, 531, 1762, 478, 4465, 649, 9635, 1493, 8439, 9, 4699, 622)


select 
    distinct 
    aa.player_id
    , aa.player_rank_season_week
    , cumulative_qbr_median = PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY qbr_total)
        OVER (PARTITION BY player_id, player_rank_season_week)
into temp.qbr_prediction_josh_allen_01
from 
( 
select  
a.player_id
, a.player_rank_season_week
, a.qbr_total
from temp.qbr_prediction_josh_allen_00 a
left join temp.qbr_prediction_josh_allen_00 b on 1 = 1 
    and a.player_id = b.player_id
    and a.player_rank_season_week >= b.player_rank_season_week
) aa


select a.*, percent_thing = a.cumulative_qbr_median/b.max_cumulative_qbr_median 
into temp.qbr_prediction_josh_allen_02
from temp.qbr_prediction_josh_allen_01 a 
inner join (select player_id, max(cumulative_qbr_median) as max_cumulative_qbr_median from temp.qbr_prediction_josh_allen_01 group by player_id) b on a.player_id = b.player_id


select 
    distinct 
    b.player_rank_season_week
    , cumulative_percent_thing = PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY percent_thing)
        OVER (PARTITION BY player_rank_season_week)
from temp.qbr_prediction_josh_allen_02 b


if object_id('temp.qbr_prediction_josh_allen_00', 'U') is not null
drop table temp.qbr_prediction_josh_allen_00;
if object_id('temp.qbr_prediction_josh_allen_01', 'U') is not null
drop table temp.qbr_prediction_josh_allen_01;
if object_id('temp.qbr_prediction_josh_allen_02', 'U') is not null
drop table temp.qbr_prediction_josh_allen_02;

/*
select
  a.player_id 
    , player_rank_season_week = row_number() over (partition by a.player_id order by a.season asc, a.game_week)
    , a.qbr_total
-- into temp.qbr_prediction_josh_allen_00
from nflpy.nfl_qbr_week a
inner join (select name_display, the_count = count(*) from nflpy.nfl_qbr_week group by name_display having count(*) >= 20) b on a.name_display = b.name_display
where 1 = 1 
   -- these guys have been around for a bit too long to count (as in, pre 2006)
    and a.player_id not in (8416, 5536, 112, 4459, 3636, 1753, 2580, 5526, 2026, 1682, 5615, 2549, 1428, 2330
    , 1575, 8520, 3609, 1693, 1383, 2149, 4480, 734, 2299, 5547, 733, 3531, 1398, 3529
    , 2440, 1417, 735, 2658, 3560, 2206, 1177, 1884, 4477, 393, 4555, 445, 2704, 2343, 2655, 1490, 331, 531, 1762, 478, 4465, 649, 9635, 1493, 8439, 9, 4699, 622)
    and a.name_display = 'Josh Allen'
*/
