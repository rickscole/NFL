select 
    a.player_id 
    , a.name_display 
    , the_count = count(*)
from nflpy.nfl_qbr_week a
where a.player_id in (8416, 5536, 112, 4459, 3636, 1753, 2580, 5526, 2026, 1682, 5615, 2549, 1428, 2330
, 1575, 8520, 3609, 1693, 1383, 2149, 4480, 734, 2299, 5547, 733, 3531, 1398, 3529)
group by 
     a.player_id 
    , a.name_display
