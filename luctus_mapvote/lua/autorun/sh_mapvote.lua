--Luctus MapVote
--Refactored by OverlordAkise

MapVote = {}
MapVote.Config = {
    MapLimit = 24,
    TimeLimit = 28,
    RTVPlayerCount = 3,
    MapPrefixes = {"ttt_"}
}

MapVote.CurrentMaps = {}
MapVote.Votes = {}

MapVote.Allow = false

MapVote.UPDATE_VOTE = 1
MapVote.UPDATE_WIN = 3
