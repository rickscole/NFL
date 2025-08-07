insert into nfapi.nfl_game
select 
sysdatetime()
, external_id 
, season
, home_team  = case 
when charindex('@', matchup) > 0 then substring(matchup, charindex('@', matchup) + 2, len(matchup)) -- away
when charindex('VS', matchup) > 0 then substring(matchup, charindex('VS', matchup) + 3, len(matchup)) -- home
else 'other'
end
, away_team  = case 
when charindex('@', matchup) > 0 then substring(matchup, 1, charindex('@', matchup) - 1) -- away
when charindex('VS', matchup) > 0 then substring(matchup, 1, charindex('VS', matchup) - 2) -- home
else 'other'
end
from temp.nfl_game

