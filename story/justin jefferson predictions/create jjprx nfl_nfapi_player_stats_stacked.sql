SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [jjprx].[nfl_nfapi_player_stats_stacked](
    id int primary key identity (1,1),
    ts datetime2(7),
	[player_id] [int] NULL,
	[game_id] [int] NULL,
	[stat_type] [nvarchar](50) NULL,
	[stat_value] float NULL
) ON [PRIMARY]
GO
