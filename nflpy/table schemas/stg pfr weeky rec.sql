SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [stg].[nfl_pfr_weekly_rec](
	[game_id] [nvarchar](50) NULL,
	[pfr_game_id] [nvarchar](50) NULL,
	[season] [smallint] NULL,
	[week] [tinyint] NULL,
	[game_type] [nvarchar](50) NULL,
	[team] [nvarchar](50) NULL,
	[opponent] [nvarchar](50) NULL,
	[pfr_player_name] [nvarchar](50) NULL,
	[pfr_player_id] [nvarchar](50) NULL,
	[rushing_broken_tackles] [nvarchar](1) NULL,
	[receiving_broken_tackles] [float] NULL,
	[passing_drops] [nvarchar](1) NULL,
	[passing_drop_pct] [nvarchar](1) NULL,
	[receiving_drop] [float] NULL,
	[receiving_drop_pct] [float] NULL,
	[receiving_int] [float] NULL,
	[receiving_rat] [float] NULL
) ON [PRIMARY]
GO
