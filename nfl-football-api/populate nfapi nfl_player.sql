insert into [nfapi].[nfl_player]
select sysdatetime(), * from [temp].[nfl_player]
