--Luctus Levelsystem (TTT)
--Made by OverlordAkise

hook.Add("InitPostEntity","luctus_levelsys_hud_load",function()
    hook.Add("HUDPaint","luctus_levelsystem_hud", function()
        local ply = LocalPlayer()
        local xpNeeded = (ply:GetXP()*ScrW())/levelReqExp(ply:GetLevel())
        draw.RoundedBox(0, 0, 0, ScrW(), 12, Color(0, 0, 0, 180))
        draw.RoundedBox(0, 0, 0, xpNeeded, 12, Color(0, 0, 0, 200))
        draw.DrawText(ply:GetXP(),"Default",50,0,Color(255,255,255))
        draw.DrawText(levelReqExp(ply:GetLevel()),"Default",ScrW()-10,0,Color(255,255,255),TEXT_ALIGN_RIGHT)
        draw.DrawText("Level: "..ply:GetLevel(),"Default",ScrW()/2,0,Color(255,255,255),TEXT_ALIGN_CENTER)
    end)
end)

local acccent = Color(0, 195, 165)
local color_white = Color(255,255,255)
local color_level = Color(255,0,255)
net.Receive("luctus_levelsystem",function()
    local level = net.ReadInt(32)..""
    local typ = net.ReadInt(2)
    if typ == 1 then
        chat.AddText(accent,"| ",color_white,"Congratz! You reached ",color_level,"Lv.",level)
        surface.PlaySound("vo/npc/female01/fantastic01.wav")
    else
        chat.AddText(accent,"| ",color_white,"You got ",color_level,level,"XP",color_white," for this round")
    end
end)

print("[luctus_levels] cl loaded!")
