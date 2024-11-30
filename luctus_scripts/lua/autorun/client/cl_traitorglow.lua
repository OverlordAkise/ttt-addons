--Made by OverlordAkise

local rolestable = {}

hook.Add("TTTEndRound", "luctus_traitorglow", function()
    table.Empty(rolestable)
end)

hook.Add("TTTBeginRound", "luctus_traitorglow", function()
    for k,v in ipairs(player.GetAll()) do
        if v:GetRole() != ROLE_TRAITOR then continue end
        table.insert(rolestable, v) 
    end
end)

local color_red = Color(255,50,50)
hook.Add("PreDrawHalos", "luctus_traitorglow", function()
    if LocalPlayer():KeyDown(IN_SPEED) then
        halo.Add(rolestable, color_red, 2, 2, 2, true, true)
    end
end)


print("[luctus_traitorglow] cl loaded!")
