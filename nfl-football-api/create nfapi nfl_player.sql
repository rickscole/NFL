SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [nfapi].[nfl_player](
    id int primary key identity(1,1),
    ts datetime2(7),
	[external_id] [int] NULL,
	[first_name] [nvarchar](50) NULL,
	[last_name] [nvarchar](50) NULL,
	[full_name] [nvarchar](50) NULL,
	[display_name] [nvarchar](50) NULL,
	[short_name] [nvarchar](50) NULL,
	[team_id] [tinyint] NULL
) ON [PRIMARY]
GO
