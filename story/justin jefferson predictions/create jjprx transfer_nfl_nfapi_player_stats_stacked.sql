
create procedure jjprx.transfer_nfl_nfapi_player_stats_stacked as 

delete from [jjprx].[nfl_nfapi_player_stats_stacked]

insert into [jjprx].[nfl_nfapi_player_stats_stacked]
select 
ts = sysdatetime()
, a.player_id 
, a.game_id 
, a.stat_type 
, stat_value = try_convert(float, a.stat_value)
from [stg].[nfl_nfapi_player_stats_stacked] a 

delete from [stg].[nfl_nfapi_player_stats_stacked]

