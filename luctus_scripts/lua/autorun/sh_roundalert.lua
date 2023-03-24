--Made by OverlordAkise

if SERVER then

    util.AddNetworkString("round_alert")
    hook.Add("PlayerSpawn", "luctus_roundalert", function(ply)
        ply:SendLua( 'if !system.HasFocus() then  end' )
        
        net.Start("round_alert")
        net.Send(ply)
    end)

else

    CreateClientConVar("roundalert_sound", "sound/common/warning.wav", true, false, "This affects the sound played when spawned while the game is minimized.")
    
    net.Receive("round_alert", function( len, pl )
        if system.HasFocus() then return end
        system.FlashWindow()
        sound.PlayFile(GetConVar("roundalert_sound"):GetString(), "", function(alert)
            if IsValid(alert) then alert:Play() end
        end)
    end)

end

print("[luctus_roundalert] sh loaded")
