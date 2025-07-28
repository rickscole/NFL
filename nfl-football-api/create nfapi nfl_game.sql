create table nfapi.nfl_game 
(
    id int primary key identity(1,1)
    , ts datetime2(7)
    , external_id [int] NULL
    , [season] [smallint] NULL 
)
