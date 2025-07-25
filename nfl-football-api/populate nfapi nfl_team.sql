
insert into [nfapi].[nfl_team]
select sysdatetime(), * from temp.nfl_team
