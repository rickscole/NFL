SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [trf].[nfl_transfer_pfr_weekly_rec] as 


delete from [nflpy].[nfl_pfr_weekly_rec]

insert into [nflpy].[nfl_pfr_weekly_rec]
select sysdatetime(), a.* from stg.nfl_pfr_weekly_rec a


delete from stg.nfl_pfr_weekly_rec

GO
