SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [jjprx].[nfl_forecast](
    id int primary key identity(1,1),
    ts datetime2(7),
	[player_game_id] [tinyint] NULL,
	[forecast_value] [float] NULL,
	[forecast_type] [nvarchar](50) NULL
) ON [PRIMARY]
GO
