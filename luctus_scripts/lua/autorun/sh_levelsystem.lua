


function levelReqExp(lvl)
    return math.Min(5+(lvl*5),50)
end

local plymeta = FindMetaTable("Player")

function plymeta:GetLevel()
	return self:GetNWInt("level",1)
end

function plymeta:GetXP()
    return self:GetNWInt("xp",0)
end

function plymeta:GetPoints()
    return self:GetNWInt("pts",0)
end

function plymeta:HasLevel(level)
    return self:GetNWInt("level",1) >= level
end

if SERVER then
    LUCTUS_XP_WIN = 5
    LUCTUS_XP_ROUND = 5
    LUCTUS_XP_KILL = 2
    
    util.AddNetworkString("luctus_levelsystem")
    hook.Add("PostGamemodeLoaded","luctus_scpnames",function()
        local res = sql.Query("CREATE TABLE IF NOT EXISTS luctus_level( steamid TEXT, exp INT, lvl INT, pts INT )")
        if res == false then
            error(sql.LastError())
        end
    end)
    function plymeta:SetLevel(level)
        self:SetNWInt("level",level)
    end

    function plymeta:SetXP(xp)
        self:SetNWInt("xp",xp)
    end
    
    function plymeta:SetPoints(pts)
        return self:SetNWInt("pts",pts)
    end
    
    function plymeta:AddXP(amount)
        local curXP = self:GetXP() + amount
        local curLevel = self:GetLevel()
        local curPoints = self:GetPoints()
        Luctus_Notify(self,amount,2)
        while curXP >= levelReqExp(curLevel)  do
            curXP = curXP - levelReqExp(curLevel)
            curLevel = curLevel + 1
            Luctus_Notify(self,curLevel,1)
            curPoints = curPoints + 1
        end
        self:SetXP(curXP)
        self:SetLevel(curLevel)
        self:SetPoints(curPoints)
        Luctus_savexp(self)
    end
    
    function plymeta:SubPoints(amount)
        self:SetPoints(math.max(self:GetPoints()-amount,0))
        Luctus_savexp(self)
    end
    
        
    function Luctus_savexp(ply)
        local res = sql.Query("UPDATE luctus_level SET exp = "..ply:GetXP()..", lvl = "..ply:GetLevel()..", pts = "..ply:GetPoints().." WHERE steamid = "..sql.SQLStr(ply:SteamID()))
        if res == false then
            ErrorNoHaltWithStack(sql.LastError())
        end
    end
    
    function Luctus_Notify(ply,value,typ)
        net.Start("luctus_levelsystem")
            net.WriteInt(value,32)
            net.WriteInt(typ,2)
        net.Send(ply)
    end

    function Luctus_loadxp(ply)
        ply:SetLevel(1)
        ply:SetXP(0)
        ply:SetPoints(0)
        local res = sql.QueryRow("SELECT * FROM luctus_level WHERE steamid = "..sql.SQLStr(ply:SteamID()))
        if res == false then
            error(sql.LastError())
        end
        if res then
            ply:SetLevel(tonumber(res.lvl))
            ply:SetXP(tonumber(res.exp))
            ply:SetPoints(tonumber(res.pts))
            print("[DEBUG]","Loaded:",ply,"Points:",res.pts,util.TableToJSON(res))
            PrintTable(res)
            print("[luctus_levelsystem] User successfully loaded!")
        else
            local res = sql.Query("INSERT INTO luctus_level(steamid,exp,lvl,pts) VALUES("..sql.SQLStr(ply:SteamID())..",0,1,0)")
            if res == false then
                error(sql.LastError())
            end
            print("[luctus_levelsystem] New user successfully inserted!")
        end
    end

    hook.Add("PlayerDisconnected", "LVL_SaveOnDisconnect", function(ply)
        Luctus_savexp(ply)
    end)
     
    hook.Add("ShutDown", "LVL_SaveOnShutdown", function()
        for k,v in pairs(player.GetAll()) do
            Luctus_savexp(v)
        end
    end)

    hook.Add("PlayerInitialSpawn","LVL_InitialLevel",function(ply)
        Luctus_loadxp(ply)
        ply.laddxp = 0
    end)

    hook.Add("PlayerDeath","LVL_SetLevel",function(ply,inflictor,attacker)
        if attacker:IsPlayer() && IsValid(attacker) then
            attacker.laddxp = attacker.laddxp + LUCTUS_XP_KILL
        end
    end)
    
    hook.Add("TTTEndRound","luctus_level_reward",function(result)
        local tab = { [ROLE_INNOCENT] = true, [ROLE_DETECTIVE] = true }
        for k,v in pairs(player.GetAll()) do
            v.laddxp = v.laddxp + LUCTUS_XP_ROUND
            if result == WIN_TRAITOR and v:GetRole() == ROLE_TRAITOR then
                v.laddxp = v.laddxp + LUCTUS_XP_WIN
            end
            if result ~= WIN_TRAITOR and tab[v:GetRole()] then
                v.laddxp = v.laddxp + LUCTUS_XP_WIN
            end
            v:AddXP(v.laddxp)
            v.laddxp = 0
        end
    end)

end

if CLIENT then
    --hook.Add("InitPostEntity","luctus_levelsys_hud_load",function()
        hook.Add("HUDPaint","luctus_levelsystem_hud", function()
            local ply = LocalPlayer()
            local xpNeeded = (ply:GetXP()*ScrW())/levelReqExp(ply:GetLevel())
            draw.RoundedBox(0, 0, 0, ScrW(), 12, Color(0, 0, 0, 180))
            draw.RoundedBox(0, 0, 0, xpNeeded, 12, Color(0, 0, 0, 200))
            draw.DrawText(ply:GetXP(),"Default",50,0,Color(255,255,255))
            draw.DrawText(levelReqExp(ply:GetLevel()),"Default",ScrW()-10,0,Color(255,255,255),TEXT_ALIGN_RIGHT)
            draw.DrawText("Level: "..ply:GetLevel(),"Default",ScrW()/2,0,Color(255,255,255),TEXT_ALIGN_CENTER)
        end)
    --end)
    
    local acccent = Color(0, 195, 165)
    local color_white = Color(255,255,255)
    local color_level = Color(255,0,255)
    net.Receive("luctus_levelsystem",function()
        local level = net.ReadInt(32)..""
        local typ = net.ReadInt(2)
        if typ == 1 then
            chat.AddText(accent,"| ",color_white,"Congratz! You reached ",color_level,"Lv.",level)
            surface.PlaySound("vo/npc/female01/fantastic01.wav")
        else
            chat.AddText(accent,"| ",color_white,"You got ",color_level,level,"XP",color_white," for this round")
        end
    end)
    
end


print("[luctus_higherjump] sh loaded!")

