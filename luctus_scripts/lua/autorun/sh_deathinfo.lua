--Made by OverlordAkise

if SERVER then

    util.AddNetworkString("luctus_deathinfo")
    hook.Add("PlayerDeath", "luctus_deathinfo", function(victim, weapon, attacker)
        if attacker:IsPlayer() and attacker ~= victim then
            net.Start("luctus_deathinfo")
                net.WriteString(attacker:GetRoleString())
                net.WriteString(attacker:Nick())
            net.Send(victim)
        end
    end)

else
    local colors = {
        ["traitor"] = Color(200, 25, 25),
        ["detective"] = Color(25, 25, 200),
        ["innocent"] = Color(25, 200, 25)
    }
    local color_white = Color(255,255,255)
    local acccent = Color(0, 195, 165)

    net.Receive("luctus_deathinfo", function()
        local role = net.ReadString()
        local name = net.ReadString()
        local color = colors[role]
        if not color then return end
        local a = ""
        if role != "innocent" then a = "a " end
        chat.AddText(accent,"| ",color_white, "You were killed by ", color, name, color_white, " he was "..a, color, role)
    end)
end

print("[luctus_deathinfo] sh loaded!")
