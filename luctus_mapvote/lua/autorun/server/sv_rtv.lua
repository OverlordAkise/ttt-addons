RTV = RTV or {}

RTV.ChatCommands = {
	"!rtv",
	"/rtv",
	"rtv"
}

RTV.TotalVotes = 0
RTV.WaitAfterMapChange = 60
RTV._ActualWait = CurTime() + RTV.WaitAfterMapChange
RTV.PlayerCount = MapVote.Config.RTVPlayerCount or 3

function RTV.ShouldChange()
	return RTV.TotalVotes >= math.Round(#player.GetAll()*0.66)
end

function RTV.RemoveVote()
	RTV.TotalVotes = math.Clamp( RTV.TotalVotes - 1, 0, math.huge )
end

function RTV.Start()
    net.Start("RTV_Delay")
    net.Broadcast()

    hook.Add("TTTEndRound", "MapvoteDelayed", function()
        MapVote.Start(nil)
    end)
end


function RTV.AddVote(ply)
	if RTV.CanVote(ply) then
		RTV.TotalVotes = RTV.TotalVotes + 1
		ply.RTVoted = true
		MsgN(ply:Nick().." has voted to Rock the Vote.")
		PrintMessage( HUD_PRINTTALK, ply:Nick().." has voted to Rock the Vote. ("..RTV.TotalVotes.."/"..math.Round(#player.GetAll()*0.66)..")")

		if RTV.ShouldChange() then
			RTV.Start()
		end
	end
end

hook.Add("PlayerDisconnected", "Remove RTV", function(ply)
	if ply.RTVoted then
		RTV.RemoveVote()
	end
	timer.Simple(0.1, function()
		if RTV.ShouldChange() then
			RTV.Start()
		end
	end)
end)

function RTV.CanVote(ply)
	local plyCount = table.Count(player.GetAll())
	
	if RTV._ActualWait >= CurTime() then
		return false, "You must wait a bit before voting!"
	end

	if GetGlobalBool("In_Voting") then
		return false, "There is currently a vote in progress!"
	end

	if ply.RTVoted then
		return false, "You have already voted to Rock the Vote!"
	end

	if RTV.ChangingMaps then
		return false, "There has already been a vote, the map is going to change!"
	end
	if plyCount < RTV.PlayerCount then
        return false, "You need more players before you can rock the vote!"
    end

	return true

end

function RTV.StartVote(ply)
	local can, err = RTV.CanVote(ply)
	if not can then
		ply:PrintMessage(HUD_PRINTTALK, err)
		return
	end
	RTV.AddVote(ply)
end

concommand.Add("rtv_start", RTV.StartVote)

hook.Add("PlayerSay", "RTV Chat Commands", function(ply, text)
	if table.HasValue(RTV.ChatCommands, string.lower(text)) then
		RTV.StartVote(ply)
		return ""
	end
end)
