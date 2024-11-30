--Luctus RTD
--Made by OverlordAkise

util.AddNetworkString("luctus_rtd_msg")
util.AddNetworkString("luctus_rtd_hud")

function LuctusRTDSay(ply,msg,effect)
    net.Start("luctus_rtd_msg")
        net.WriteString(msg)
        net.WriteString(effect)
    net.Send(ply or player.GetAll())
end

LUCTUS_RTD_EFFECTS = {}
local function add(name,onFunc,duration,offFunc)
    table.insert(LUCTUS_RTD_EFFECTS,{name,onFunc,duration,offFunc})
end

function LuctusRTDDo(ply)
    local effect = LUCTUS_RTD_EFFECTS[math.random(#LUCTUS_RTD_EFFECTS)]
    LuctusRTDSay(not LUCTUS_RTD_BROADCAST_ROLL and ply,ply:Nick().." rolled ",effect[1])
    effect[2](ply) --start effect with onFunc
    local effectDuration = effect[3]
    local offFunc = effect[4]
    if effectDuration then
        net.Start("luctus_rtd_hud")
            net.WriteUInt(effectDuration,8)
        net.Send(ply)
        timer.Simple(effectDuration,function()
            if not ply or not IsValid(ply) then return end
            offFunc(ply)
            LuctusRTDSay(ply,"Your rtd effect wore ","off")
        end)
    end
end

hook.Add("PlayerSay","luctus_rtd",function(ply,text)
    if text ~= LUCTUS_RTD_COMMAND then return end
    if not ply.luctusRTDCD then ply.luctusRTDCD = 0 end
    if not ply:Alive() then
        LuctusRTDSay(ply,"You can not rtd while being ","dead")
        return
    end
    if ply.luctusRTDCD > CurTime() then
        LuctusRTDSay(ply,"Cooldown: ",math.Round(ply.luctusRTDCD-CurTime()).."s")
        return
    end
    ply.luctusRTDCD = CurTime()+LUCTUS_RTD_COOLDOWN
    LuctusRTDDo(ply)
    if not LUCTUS_RTD_BROADCAST_ROLL then return "" end
end)


--Effects from now on
local roleTab = {
    [ROLE_TRAITOR] = "Traitor",
    [ROLE_INNOCENT] = "Innocent",
    [ROLE_DETECTIVE] = "Detective",
}
add("double health",function(ply) ply:SetHealth(ply:Health()*2) end)
add("godmode",function(ply) ply:GodEnable() end, 15, function(ply) ply:GodDisable() end)
add("low gravity",function(ply) ply:SetGravity(0.20) end, 30, function(ply) ply:SetGravity(1) end)
add("weapons stolen",function(ply) ply:StripWeapons() end)
add("higher FOV",function(ply) ply:SetFOV(120,1) end, 30, function(ply) ply:SetFOV(0,1) end)
add("role reveal",function(ply) PrintMessage(HUD_PRINTTALK, ply:Nick().." is "..roleTab[ply:GetRole()]) end)
add("1 hp",function(ply) ply:SetHealth(1) end)
add("spontaneous combustion",function(ply) ply:Ignite(10) end)
add("nothing",function(ply) end)
add("invisibility",function(ply) ply:SetNoDraw(true) end, 10, function(ply) ply:SetNoDraw(false) end)
add("blindness",function(ply) ply:ScreenFade(SCREENFADE.IN, Color(0, 0, 0, 254), 3, 10) end)


print("[luctus_rtd] sv loaded")
