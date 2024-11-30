--Made by OverlordAkise

hook.Add("TTTPrepareRound","luctus_prepare_godmode",function()
    timer.Simple(0.1,function()
        for k,v in ipairs(player.GetAll()) do
            v:GodEnable()
        end
    end)
end)

hook.Add("TTTBeginRound","luctus_prepare_godmode",function()
    for k,v in ipairs(player.GetAll()) do
        v:GodDisable()
    end
end)

print("[luctus_godmodeinprepare] sv loaded!")
