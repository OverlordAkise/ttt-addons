--Luctus TTT Buymenu
--Made by OverlordAkise

util.AddNetworkString("luctus_buymenu_notify")
util.AddNetworkString("luctus_buymenu_buy")
util.AddNetworkString("luctus_buymenu_equip")

function LuctusNotify(ply,text)
    net.Start("luctus_buymenu_notify")
        net.WriteString(text)
    net.Send(ply)
end

hook.Add("TTTPrepareRound","luctus_announce_buymenu",function()
    for k,v in pairs(player.GetAll()) do
        if not v.buyannounced then
            LuctusNotify(v,"You can buy weapons by pressing F3 !")
            v.buyannounced = true
        end
    end
end)

function LuctusBuyRedeemPass(ply,name,cost,levelreq)
    if ply:GetLevel() < levelreq then
        LuctusNotify(ply,"You don't have the required level for this pass!")
        return
    end
    if ply:GetPoints() < cost then
        LuctusNotify(ply,"You can't afford this pass!")
        return
    end
    if name == "traitorpass" then
        if ply.tpass then
            LuctusNotify(ply,"You already have a traitorpass active!")
            return
        end
        ply.tpass = true
        ply:SubPoints(cost)
        LuctusNotify(ply,"Successfully redeemed a traitorpass!")
    end
    if name == "detectivepass" then
        if ply.dpass then
            LuctusNotify(ply,"You already have a detectivepass active!")
            return
        end
        ply.dpass = true
        ply:SubPoints(cost)
        LuctusNotify(ply,"Successfully redeemed a detectivepass!")
    end
end


hook.Add("InitPostEntity","luctus_buymenu_sql",function()
    local res = sql.Query("CREATE TABLE IF NOT EXISTS luctus_buyweps(steamid TEXT, name TEXT)")
    if res == false then ErrorNoHaltWithStack(sql.LastError()) end
    local res = sql.Query("CREATE TABLE IF NOT EXISTS luctus_equipweps(steamid TEXT, slot TEXT, name TEXT)")
    if res == false then ErrorNoHaltWithStack(sql.LastError()) end
end)

function LuctusDoesPlayerOwnWeapon(ply,name)
    local res = sql.QueryValue("SELECT name FROM luctus_buyweps WHERE steamid = "..sql.SQLStr(ply:SteamID()).." and name = "..sql.SQLStr(name))
    if res == false then
        ErrorNoHaltWithStack(sql.LastError())
        return false
    end
    if res and res == name then
        return true
    end
    return false
end

function LuctusPlayerBuyWeapon(ply,name)
    ply.oweps[name] = true
    local res = sql.Query("INSERT INTO luctus_buyweps(steamid,name) VALUES("..sql.SQLStr(ply:SteamID())..","..sql.SQLStr(name)..")")
    if res == false then
        ErrorNoHaltWithStack(sql.LastError())
    end
end

function LuctusEquipWeapon(ply,name)
    local wep = weapons.Get(name)
    if not wep then return end
    
    local slot = wep.Kind
    if not slot then return end
    
    ply.eweps[slot] = name
    local res = sql.Query("REPLACE INTO luctus_equipweps(steamid,slot,name) VALUES("..sql.SQLStr(ply:SteamID())..","..slot..","..sql.SQLStr(name)..")")
    if res == false then
        ErrorNoHaltWithStack(sql.LastError())
    end
end

function LuctusLoadWeapons(ply)
    ply.eweps = {} --equipped weapons
    ply.oweps = {} --owned weapons
    
    local res = sql.Query("SELECT name FROM luctus_buyweps WHERE steamid = "..sql.SQLStr(ply:SteamID()))
    if res == false then
        ErrorNoHaltWithStack(sql.LastError())
        return
    end
    if res then
        for k,row in pairs(res) do
            ply.oweps[row.name] = true
        end
    end
    
    local res = sql.Query("SELECT * FROM luctus_equipweps WHERE steamid = "..sql.SQLStr(ply:SteamID()))
    if res == false then
        ErrorNoHaltWithStack(sql.LastError())
        return
    end
    if res then
        for k,row in pairs(res) do
            ply.eweps[tonumber(row.slot)] = row.name
        end
    end
end

hook.Add("PlayerInitialSpawn","luctus_buymenu_initply",function(ply)
    LuctusLoadWeapons(ply)
    for k,v in pairs(ply.eweps) do
        ply:Give(v)
    end
end)

hook.Add("PlayerSpawn","luctus_buymenu_wepgive",function(ply)
    for k,v in pairs(ply.eweps) do
        ply:Give(v)
    end
end)

net.Receive("luctus_buymenu_buy",function(len,ply)
    local cat = net.ReadString()
    local name = net.ReadString()
    print("[luctus_buymenu]",ply,"wanted to buy",cat,name)
    
    if not LUCTUS_BUYMENU_EQUIPMENT[cat] then return end
    if not LUCTUS_BUYMENU_EQUIPMENT[cat][name] then return end
    local cost = LUCTUS_BUYMENU_EQUIPMENT[cat][name][1]
    local level = LUCTUS_BUYMENU_EQUIPMENT[cat][name][2]
    
    if cat == "-Passes" then
        LuctusBuyRedeemPass(ply,name,cost,level)
        return
    end
    
    if ply:GetLevel() < level then
        LuctusNotify(ply,"You don't have the required level to buy this weapon!")
        return
    end
    if LuctusDoesPlayerOwnWeapon(ply,name) then 
        LuctusNotify(ply,"You already own that weapon!")
        return
    end
    if ply:GetPoints() < cost then
        LuctusNotify(ply,"You can't afford this weapon!")
        return
    end
    LuctusPlayerBuyWeapon(ply,name)
    ply:SubPoints(cost)
    LuctusNotify(ply,"Successfully bought "..name)
end)

net.Receive("luctus_buymenu_equip",function(len,ply)
    local cat = net.ReadString()
    local name = net.ReadString()
    if not LUCTUS_BUYMENU_EQUIPMENT[cat] then return end
    if not LUCTUS_BUYMENU_EQUIPMENT[cat][name] then return end
    
    if not LuctusDoesPlayerOwnWeapon(ply,name) then
        LuctusNotify(ply,"You don't own this weapon!")
        return
    end
    LuctusEquipWeapon(ply,name)
    LuctusNotify(ply,"Equipped "..name)
end)

hook.Add("ShowSpare1","luctus_openmenu",function(ply)
    net.Start("luctus_buymenu_equip")
        net.WriteTable(ply.oweps)
    net.Send(ply)
end)

print("[luctus_buymenu] sv loaded!")
