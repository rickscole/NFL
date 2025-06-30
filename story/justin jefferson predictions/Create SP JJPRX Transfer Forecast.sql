

create procedure jjprx.nfl_transfer_forecast as

delete from jjprx.nfl_forecast

insert into jjprx.nfl_forecast
select sysdatetime()
, a.*
from stg.nfl_jjprx_forecast a
inner join jjprx.nfl_actual_and_trend b on a.id = b.player_game_id


drop table stg.nfl_jjprx_forecast



