--Made by OverlordAkise

hook.Add("SetupMove","luctus_higherjump",function(ply,mv,cmd)
    if cmd:KeyDown(IN_DUCK) and cmd:KeyDown(IN_JUMP) and mv:GetVelocity()[3] > 0 then
        ply:SetVelocity(Vector(0, 0, 400))
    end
end)

print("[luctus_higherjump] sh loaded!")
