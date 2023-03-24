--Made by OverlordAkise

local songs = {
    "https://luctus.at/fastdl/sounds/tekillya.mp3",
    "https://luctus.at/fastdl/sounds/bangarang.mp3",
    "https://luctus.at/fastdl/sounds/dansen.mp3",
    "https://luctus.at/fastdl/sounds/glockinmyrari.mp3",
    "https://luctus.at/fastdl/sounds/italy.mp3",
    "https://luctus.at/fastdl/sounds/machi.mp3",
    "https://luctus.at/fastdl/sounds/midnightcity.mp3",
    "https://luctus.at/fastdl/sounds/saul.mp3",
    "https://luctus.at/fastdl/sounds/sue.mp3",
    "https://luctus.at/fastdl/sounds/unity.mp3",
    "https://luctus.at/fastdl/sounds/wakingup.mp3",
}

if SERVER then

    util.AddNetworkString("luctus_endsong")
    hook.Add("TTTEndRound","luctus_roundendmusic",function()
        local randomSong = math.random(#songs)
        net.Start("luctus_endsong")
            net.WriteInt(randomSong,32)
        net.Broadcast()
    end)

else

    endmusicvolume = CreateClientConVar("ttt_music_volume", "100", true, false, "Set the volume of the round-end music", 0, 100)

    local acccent = Color(0, 195, 165)
    local color_white = Color(255,255,255)
    local commandSaid = false
    net.Receive("luctus_endsong",function()
        local ranSongId = net.ReadInt(32)
        local randomSong = songs[ranSongId]
        sound.PlayURL(randomSong,"noplay",function(chan,errID,errName)
            if IsValid(chan) then
                chan:SetVolume(endmusicvolume:GetInt()/100)
                chan:Play()
                print("| Round-End-Music Playing:",randomSong)
                if not commandSaid then
                    chat.AddText(accent,"| ",color_white,"You can change the volume of the round end music with '!volume 50'")
                    commandSaid = true
                end
            end
        end)
    end)

    hook.Add("OnPlayerChat","luctus_roundend_volume",function(ply, text) 
        if ply ~= LocalPlayer() then return end
        if string.StartWith(text,"!volume ") then
            local vol = string.Split(text,"!volume ")[2]
            if not tonumber(vol) then
                chat.AddText("Usage: !volume 50")
                return
            end
            RunConsoleCommand("ttt_music_volume",vol)
            chat.AddText("Changed volume successfully!")
        end
    end)

end


print("[luctus_roundendmusic] sh loaded!")
