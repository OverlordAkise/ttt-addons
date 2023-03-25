util.AddNetworkString("RAM_MapVoteStart")
util.AddNetworkString("RAM_MapVoteUpdate")
util.AddNetworkString("RAM_MapVoteCancel")
util.AddNetworkString("LuctusReopenMapvote")
util.AddNetworkString("RTV_Delay")

MapVote.Continued = false

net.Receive("RAM_MapVoteUpdate", function(len, ply)
    if not MapVote.Allow then return end
    if not IsValid(ply) then return end
    
    local update_type = net.ReadUInt(3)
    if update_type ~= MapVote.UPDATE_VOTE then return end
    
    local map_id = net.ReadUInt(32)
    if not MapVote.CurrentMaps[map_id] then return end
    
    MapVote.Votes[ply:SteamID()] = map_id
    
    net.Start("RAM_MapVoteUpdate")
        net.WriteUInt(MapVote.UPDATE_VOTE, 3)
        net.WriteEntity(ply)
        net.WriteUInt(map_id, 32)
    net.Broadcast()
end)

function MapVote.Start(length)
    length = length or MapVote.Config.TimeLimit or 28
    limit = MapVote.Config.MapLimit or 24
    prefix = MapVote.Config.MapPrefixes

    local maps = file.Find("maps/*.bsp", "GAME")
    
    local vote_maps = {}
    
    local amt = 0

    for k, map in RandomPairs(maps) do
        if game.GetMap():lower()..".bsp" == map then continue end

        for k, v in pairs(prefix) do
            if string.find(map, "^"..v) then
                vote_maps[#vote_maps + 1] = map:sub(1, -5)
                amt = amt + 1
                break
            end
        end

        
        if limit and amt >= limit then break end
    end
    
    net.Start("RAM_MapVoteStart")
        net.WriteUInt(#vote_maps, 32)
        
        for i = 1, #vote_maps do
            net.WriteString(vote_maps[i])
        end
        
        net.WriteUInt(length, 32)
    net.Broadcast()
    
    MapVote.Allow = true
    MapVote.CurrentMaps = vote_maps
    MapVote.Votes = {}
    
    timer.Create("RAM_MapVote", length, 1, function()
        MapVote.Allow = false
        local map_results = {}
        
        for k, v in pairs(MapVote.Votes) do
            if not map_results[v] then
                map_results[v] = 0
            end
            
            for k2, v2 in pairs(player.GetAll()) do
                if v2:SteamID() == k then
                    map_results[v] = map_results[v] + 1
                end
            end
            
        end

        local winner = table.GetWinningKey(map_results) or 1
        
        net.Start("RAM_MapVoteUpdate")
            net.WriteUInt(MapVote.UPDATE_WIN, 3)
            
            net.WriteUInt(winner, 32)
        net.Broadcast()
        
        local map = MapVote.CurrentMaps[winner]

        timer.Simple(4, function()
            if hook.Run("MapVoteChange", map) ~= false then
                RunConsoleCommand("changelevel", map)
            end
        end)
    end)
end

function MapVote.Cancel()
    if not MapVote.Allow then return end
    MapVote.Allow = false
    net.Start("RAM_MapVoteCancel")
    net.Broadcast()
    timer.Destroy("RAM_MapVote")
end

hook.Add("ShowSpare2","luctus_reopen_mapvote",function(ply)
    net.Start("LuctusReopenMapvote")
    net.Send(ply)
end)

hook.Add( "Initialize", "AutoTTTMapVote", function()
    function CheckForMapSwitch()
       local rounds_left = math.max(0, GetGlobalInt("ttt_rounds_left", 6) - 1)
       SetGlobalInt("ttt_rounds_left", rounds_left)
       local time_left = math.max(0, (GetConVar("ttt_time_limit_minutes"):GetInt() * 60) - CurTime())
       local switchmap = false
       local nextmap = string.upper(game.GetMapNext())
        if rounds_left <= 0 then
            LANG.Msg("limit_round", {mapname = nextmap})
            switchmap = true
        elseif time_left <= 0 then
            LANG.Msg("limit_time", {mapname = nextmap})
            switchmap = true
        end
        if switchmap then
            timer.Stop("end2prep")
            MapVote.Start(nil)
        end
    end
end)
