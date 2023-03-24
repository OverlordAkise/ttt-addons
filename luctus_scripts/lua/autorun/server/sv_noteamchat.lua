hook.Add("PlayerSay", "luctus_noteamchat", function(ply, text, team)
	if ply:GetRole() == ROLE_INNOCENT and team == true then
		ply:PrintMessage(HUD_PRINTTALK, "Please don't write in Teamchat.")
		return ""
	end
end)

print("[luctus_noteamchat] sv loaded!")
