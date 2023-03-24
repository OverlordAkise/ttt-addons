if SERVER then

    util.AddNetworkString("luctus_roundinfo_start")
    util.AddNetworkString("luctus_roundinfo_end")
    
    local traitors = {}
    hook.Add("TTTBeginRound", "luctus_roundinfo_start", function()
        local plys = {}
        traitors = {}
        plys[ROLE_INNOCENT] = 0
        plys[ROLE_DETECTIVE] = 0
        plys[ROLE_TRAITOR] = 0
        local specs = 0

        for _, ply in pairs(player.GetAll()) do
            if not ply:IsSpec() then
                plys[ply:GetRole()] = plys[ply:GetRole()] + 1
                if ply:GetRole() == ROLE_TRAITOR then
                    table.insert(traitors,ply:Nick())
                end
            else
                specs = specs + 1
            end
        end

        net.Start("luctus_roundinfo_start")
            net.WriteUInt(plys[ROLE_INNOCENT],8)
            net.WriteUInt(plys[ROLE_DETECTIVE],8)
            net.WriteUInt(plys[ROLE_TRAITOR],8)
            net.WriteUInt(specs,8)
        net.Broadcast()
    end)

    hook.Add("TTTEndRound", "luctus_roundinfo_end", function()
        net.Start("luctus_roundinfo_end")
            net.WriteString(table.concat(traitors,", "))
        net.Broadcast()
    end)

else

    local color_white = Color(255,255,255)
    local color_red = Color(255,0,0)
    local color_green = Color(0,255,0)
    local color_blue = Color(0,0,255)
    local color_spec = Color(192,192,192)
    local acccent = Color(0, 195, 165)
    
    net.Receive("luctus_roundinfo_start",function()
        local i = net.ReadUInt(8)..""
        local d = net.ReadUInt(8)..""
        local t = net.ReadUInt(8)..""
        local s = net.ReadUInt(8)..""
        local poststring = {}
        if s ~= "0" then
            poststring = {" (and ",color_spec,s..""," Spectator(s)",color_white,")"}
        end
        chat.AddText(accent,"| ",color_white,"There are ",color_green,i," Innocent(s)",color_white,", ",color_red,t," Traitor(s) ",color_white,"and ",color_blue,d," Detective(s) ",color_white,"this round.",unpack(poststring))
    end)
    
    net.Receive("luctus_roundinfo_end",function()
        local text = net.ReadString()
        chat.AddText(accent,"| ",color_white,"The traitors this round were: ",color_red,text)
    end)

end

print("[luctus_roundinfo] sh loaded!")
