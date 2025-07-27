insert into nfapi.nfl_game 
select 
sysdatetime()
, *
from temp.nfl_game
