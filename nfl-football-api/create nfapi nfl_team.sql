SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [nfapi].[nfl_team](
    id int primary key identity(1, 1),
    ts datetime2(7),
	[external_id] [tinyint] NULL,
	[abbreviation] [nvarchar](50) NULL,
	[display_name] [nvarchar](50) NULL,
	[short_display_name] [nvarchar](50) NULL,
	[name] [nvarchar](50) NULL,
	[nickname] [nvarchar](50) NULL,
	[location] [nvarchar](50) NULL
) ON [PRIMARY]
GO
