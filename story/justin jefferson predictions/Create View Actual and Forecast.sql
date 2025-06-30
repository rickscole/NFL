create view jjprx.nfl_actual_and_forecast as 
select 
    a.player_game_id
    , a.forecast_value
    , a.forecast_type
    , b.actual 
    , b.instant_trend
    , b.short_trend
    , b.medium_trend
    , b.intermediate_trend
    , b.long_trend
from jjprx.nfl_forecast a 
inner join jjprx.nfl_actual_and_trend b on a.player_game_id = b.player_game_id

