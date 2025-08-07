SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [nfapi].[nfl_game](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[ts] [datetime2](7) NULL,
	[external_id] [int] NULL,
	[season] [smallint] NULL,
	[home_team] [nvarchar](100) NULL,
	[away_team] [nvarchar](100) NULL
) ON [PRIMARY]
GO
ALTER TABLE [nfapi].[nfl_game] ADD PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
