--Luctus TTT Whitelist
--Made by OverlordAkise

util.AddNetworkString("luctus_whitelist") 
util.AddNetworkString("luctus_whitelist_chat") 

ALLOWED_STEAMIDS = {}

if file.Exists("luctus_whitelist.txt","DATA") then
    ALLOWED_STEAMIDS = util.JSONToTable(file.Read("luctus_whitelist.txt","DATA"))
    print("[luctus_whitelist] Whitelist found, loaded!")
end

hook.Add("PlayerSay","luctus_ttt_whitelist",function(ply,text)
    if text == "!whitelist" and ply:IsAdmin() then
        net.Start("luctus_whitelist")
            net.WriteTable(ALLOWED_STEAMIDS)
        net.Send(ply)
    end
end)

net.Receive("luctus_whitelist",function(len,ply)
    if not ply:IsAdmin() then return end
    local newtab = net.ReadTable()
    ALLOWED_STEAMIDS = newtab
    file.Write("luctus_whitelist.txt",util.TableToJSON(ALLOWED_STEAMIDS))
    net.Start("luctus_whitelist_chat")
        net.WriteString("Successfully saved whitelist!")
    net.Send(ply)
end)

hook.Add("CheckPassword", "luctus_ttt_whitelist", function(steamID64, ipAddress, svPass, clPass, name)
    local steamid = util.SteamIDFrom64(steamID64)
    if not table.HasValue(ALLOWED_STEAMIDS,steamid) then
        print(name.."("..steamid..") is not on the whitelist, kicking...")
        return false, "Sorry, you are not on the whitelist!"
    end
end)

print("[luctus_ttt_whitelist] sv loaded!")
