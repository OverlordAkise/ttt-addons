--Made by OverlordAkise

if SERVER then
    
    util.AddNetworkString("luctus_roleleft")
    hook.Add("PlayerDisconnected", "luctus_roleleft", function(ply)
        local roles = {
            [ROLE_TRAITOR] = "Traitor",
            [ROLE_INNOCENT] = "Innocent",
            [ROLE_DETECTIVE] =  "Detective",
        }
        if ply:Alive() then
            net.Start("luctus_roleleft")
                net.WriteString(ply:Name())
                net.WriteString(roles[ply:GetRole()])
            net.Broadcast()
        end
    end)

else

    local cols = {
        ["Traitor"] = Color(255,0,0),
        ["Innocent"] = Color(0,255,0),
        ["Detective"] = Color(0,0,255),
    }
    local color_white = Color(255,255,255)
    local acccent = Color(0, 195, 165)
    net.Receive("luctus_roleleft",function()
        local name = net.ReadString()
        local role = net.ReadString()
        local a = ""
        if role ~= "Innocent" then a = "a " end
        chat.AddText(accent,"| ",color_white,name," was "..a,cols[role],role)
    end)

end

print("[luctus_roleleft] sh loaded!")
