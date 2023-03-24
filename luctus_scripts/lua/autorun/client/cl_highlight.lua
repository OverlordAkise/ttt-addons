--Made by OverlordAkise

local wave = Material("models/props_combine/portalball001_sheet")
local weapons = {}
local color_white = Color(255,255,255)
hook.Add("PostDrawTranslucentRenderables","luctus_highlight",function()
    for k,v in pairs(weapons) do
        if not IsValid(v) then continue end
        local pos1 = v:GetPos()
        render.SetMaterial( wave )
        render.DrawBeam(pos1,pos1 + Vector(0,0,90),3, 0, 0.9,color_white)
    end  
end)

timer.Create("luctus_highlight",1,0,function()
    weapons = {}
    if not IsValid(LocalPlayer()) then return end
    for k,v in pairs(ents.FindInSphere(LocalPlayer():GetPos(),1024)) do
        if v.GetOwner and IsValid(v:GetOwner()) then continue end
        if string.StartWith(v:GetClass(),"weapon_") then
            table.insert(weapons,v)
        end
        if string.StartWith(v:GetClass(),"m9k_") then
            table.insert(weapons,v)
        end
    end
end)

print("[luctus_highlight] cl loaded!")
