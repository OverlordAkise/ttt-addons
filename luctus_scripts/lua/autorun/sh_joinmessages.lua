--Made by OverlordAkise

if SERVER then

    util.AddNetworkString("luctus_joinleave")
    hook.Add("PlayerConnect","luctus_connect",function(name,ip)
        net.Start("luctus_joinleave")
            net.WriteUInt(1,2)
            net.WriteString(name)
        net.Broadcast()
    end)
    hook.Add("PlayerInitialSpawn","luctus_join",function(ply)
        net.Start("luctus_joinleave")
            net.WriteUInt(2,2)
            net.WriteString(ply:Nick())
        net.Broadcast()
    end)
    hook.Add("PlayerDisconnected","luctus_leave",function(ply)
        net.Start("luctus_joinleave")
            net.WriteUInt(3,2)
            net.WriteString(ply:Nick())
        net.Broadcast()
    end)
    
else

    hook.Add("ChatText","luctus_hidejoin",function(index,name,text,type)
        if type == "joinleave" then return true end
    end)
    
    local acccent = Color(0, 195, 165)
    local color_white = Color(255,255,255)
    local color_ply = Color(255,0,255)
    net.Receive("luctus_joinleave",function()
        local typ = net.ReadUInt(2)
        local name = net.ReadString()
        if typ == 1 then
            chat.AddText(accent,"| ",color_white,"Player ",color_ply,name,color_white," connected.")
            surface.PlaySound("friends/friend_join.wav")
        elseif typ == 2 then
            chat.AddText(accent,"| ",color_white,"Player ",color_ply,name,color_white," joined the game.")
        elseif typ == 3 then
            chat.AddText(accent,"| ",color_white,"Player ",color_ply,name,color_white," disconnected.")
            surface.PlaySound("friends/friend_join.wav")
        end
    end)
end

print("[luctus_joinmessages] sh loaded!")
