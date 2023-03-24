hook.Add("TTTPrepareRound", "luctus_nostartlag", function()
    timer.Simple(1,function()
        local c = 1
        for k,v in pairs(ents.GetAll()) do
            --if v:IsWeapon() and (not IsValid(v:GetOwner()) or string.StartWith(v:GetClass(),"item_")) then
                local p = v:GetPhysicsObject()
                if IsValid(p) then p:Sleep() c = c + 1 end
            --end
        end
        print("[luctus_nolag]","Roundstart, slept ents: #",c)
    end)
end)

hook.Add("InitPostEntity","luctus_nolag_delay",function()
    hook.Remove("PlayerTick","TickWidgets")
end)

print("[luctus_nolag] sv loaded!")
