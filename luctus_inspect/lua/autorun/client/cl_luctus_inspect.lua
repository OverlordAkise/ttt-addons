--Luctus Inspect Weapons
--Made by OverlordAkise

local m9k_group_reverse_pos = Vector(-10,0,2)
local m9k_group_reverse_ang = Vector(0,-50,0)
local m9k_group_farright_pos = Vector(5, 0, 0)
local m9k_group_farright_ang = Vector(-0.7, 32, 0)

local InspectPos = {}
InspectPos["weapon_zm_"] = Vector(10, -6, 4)
InspectPos["weapon_ttt_"] = Vector(10, -6, 4)
InspectPos["m9k_"] = Vector(10, -6, 4)
local InspectAng = {}
InspectAng["weapon_zm_"] = Vector(5, 39, 9)
InspectAng["weapon_ttt_"] = Vector(5, 39, 9)
InspectAng["m9k_"] = Vector(5, 39, 9)

function LuctusGetInspectData(class)
    if InspectPos[class] then
        return InspectPos[class], InspectAng[class]
    end
    if string.StartWith(class,"weapon_zm_") then
        return InspectPos["weapon_zm_"], InspectAng["weapon_zm_"]
    end
    if string.StartWith(class,"weapon_ttt_") then
        return InspectPos["weapon_ttt_"], InspectAng["weapon_ttt_"]
    end
    if string.StartWith(class,"m9k_") then
        return InspectPos["m9k_"], InspectAng["m9k_"]
    end
    
    return nil, nil
end

local TempAng = Vector(0,0,0)
local TempPos = Vector(0,0,0)
hook.Add("CalcViewModelView","luctus_ttt_inspect",function(wep, vm, oldPos, oldAng, pos, ang)
    if LocalPlayer():KeyDown(IN_WALK)then
        local ipos, iang = LuctusGetInspectData(wep:GetClass())
        if not ipos then return pos, ang end
        
        local speed = 3
        TempAng.x = Lerp(speed * FrameTime(), TempAng.x, iang.x)
        TempAng.y = Lerp(speed * FrameTime(), TempAng.y, iang.y)
        TempAng.z = Lerp(speed * FrameTime(), TempAng.z, iang.z)
        TempPos.x = Lerp(speed * FrameTime(), TempPos.x, ipos.x)
        TempPos.y = Lerp(speed * FrameTime(), TempPos.y, ipos.y)
        TempPos.z = Lerp(speed * FrameTime(), TempPos.z, ipos.z)
        if iang then
            ang:RotateAroundAxis(ang:Right(), TempAng.x)
            ang:RotateAroundAxis(ang:Up(), TempAng.y)
            ang:RotateAroundAxis(ang:Forward(), TempAng.z)
        end
        pos = pos + TempPos.x * ang:Right()
        pos = pos + TempPos.y * ang:Forward()
        pos = pos + TempPos.z * ang:Up()
        return pos, ang
	end
    if LocalPlayer():KeyReleased(IN_WALK) then
        TempAng = Vector(0,0,0)
        TempPos = Vector(0,0,0)
    end
end)

-- All M9k weapons
-- Those are, compared to default TTT weapons, either:
--  Reverse, showing the wrong side of the gun
--  Too far right, showing only the barrel

InspectPos["m9k_winchester73"] = m9k_group_reverse_pos
InspectPos["m9k_acr"] = m9k_group_reverse_pos
InspectPos["m9k_acr_light_rust"] = m9k_group_reverse_pos
InspectPos["m9k_ak47"] = m9k_group_reverse_pos
InspectPos["m9k_ak74"] = m9k_group_reverse_pos
InspectPos["m9k_amd65"] = m9k_group_reverse_pos
InspectPos["m9k_an94"] = m9k_group_reverse_pos
InspectPos["m9k_val"] = m9k_group_reverse_pos
InspectPos["m9k_f2000"] = m9k_group_reverse_pos
InspectPos["m9k_g36"] = m9k_group_reverse_pos
InspectPos["m9k_l85"] = m9k_group_reverse_pos
InspectPos["m9k_m16a4_acog"] = m9k_group_reverse_pos
InspectPos["m9k_m4a1"] = m9k_group_reverse_pos
InspectPos["m9k_auga3"] = m9k_group_reverse_pos
InspectPos["m9k_fg42"] = m9k_group_reverse_pos
InspectPos["m9k_m1918bar"] = m9k_group_reverse_pos
InspectPos["m9k_luger"] = m9k_group_reverse_pos
InspectPos["m9k_ragingbull"] = m9k_group_reverse_pos
InspectPos["m9k_scoped_taurus"] = m9k_group_reverse_pos
InspectPos["m9k_remington1858"] = m9k_group_reverse_pos
InspectPos["m9k_model3russian"] = m9k_group_reverse_pos
InspectPos["m9k_model627"] = m9k_group_reverse_pos
InspectPos["m9k_m3"] = m9k_group_reverse_pos
InspectPos["m9k_browningauto5"] = m9k_group_reverse_pos
InspectPos["m9k_ithacam37"] = m9k_group_reverse_pos
InspectPos["m9k_jackhammer"] = m9k_group_reverse_pos
InspectPos["m9k_spas12"] = m9k_group_reverse_pos
InspectPos["m9k_striker12"] = m9k_group_reverse_pos
InspectPos["m9k_usas"] = m9k_group_reverse_pos
InspectPos["m9k_1897winchester"] = m9k_group_reverse_pos
InspectPos["m9k_1887winchester"] = m9k_group_reverse_pos
InspectPos["m9k_aw50"] = m9k_group_reverse_pos
InspectPos["m9k_barret_m82"] = m9k_group_reverse_pos
InspectPos["m9k_sl8"] = m9k_group_reverse_pos
InspectPos["m9k_intervention"] = m9k_group_reverse_pos
InspectPos["m9k_m24"] = m9k_group_reverse_pos
InspectPos["m9k_psg1"] = m9k_group_reverse_pos
InspectPos["m9k_remington7615p"] = m9k_group_reverse_pos
InspectPos["m9k_bizonp19"] = m9k_group_reverse_pos
InspectPos["m9k_smgp90"] = m9k_group_reverse_pos
InspectPos["m9k_mp5"] = m9k_group_reverse_pos
InspectPos["m9k_mp7"] = m9k_group_reverse_pos
InspectPos["m9k_ump45"] = m9k_group_reverse_pos
InspectPos["m9k_usc"] = m9k_group_reverse_pos
InspectPos["m9k_kac_pdw"] = m9k_group_reverse_pos
InspectPos["m9k_vector"] = m9k_group_reverse_pos
InspectPos["m9k_magpulpdr"] = m9k_group_reverse_pos
InspectPos["m9k_mp40"] = m9k_group_reverse_pos
InspectPos["m9k_mp9"] = m9k_group_reverse_pos
InspectPos["m9k_sten"] = m9k_group_reverse_pos
InspectPos["m9k_tec9"] = m9k_group_reverse_pos
InspectPos["m9k_thompson"] = m9k_group_reverse_pos
InspectAng["m9k_winchester73"] = m9k_group_reverse_ang
InspectAng["m9k_acr"] = m9k_group_reverse_ang
InspectAng["m9k_acr_light_rust"] = m9k_group_reverse_ang
InspectAng["m9k_ak47"] = m9k_group_reverse_ang
InspectAng["m9k_ak74"] = m9k_group_reverse_ang
InspectAng["m9k_amd65"] = m9k_group_reverse_ang
InspectAng["m9k_an94"] = m9k_group_reverse_ang
InspectAng["m9k_val"] = m9k_group_reverse_ang
InspectAng["m9k_f2000"] = m9k_group_reverse_ang
InspectAng["m9k_g36"] = m9k_group_reverse_ang
InspectAng["m9k_l85"] = m9k_group_reverse_ang
InspectAng["m9k_m16a4_acog"] = m9k_group_reverse_ang
InspectAng["m9k_m4a1"] = m9k_group_reverse_ang
InspectAng["m9k_auga3"] = m9k_group_reverse_ang
InspectAng["m9k_fg42"] = m9k_group_reverse_ang
InspectAng["m9k_m1918bar"] = m9k_group_reverse_ang
InspectAng["m9k_luger"] = m9k_group_reverse_ang
InspectAng["m9k_ragingbull"] = m9k_group_reverse_ang
InspectAng["m9k_scoped_taurus"] = m9k_group_reverse_ang
InspectAng["m9k_remington1858"] = m9k_group_reverse_ang
InspectAng["m9k_model3russian"] = m9k_group_reverse_ang
InspectAng["m9k_model627"] = m9k_group_reverse_ang
InspectAng["m9k_m3"] = m9k_group_reverse_ang
InspectAng["m9k_browningauto5"] = m9k_group_reverse_ang
InspectAng["m9k_ithacam37"] = m9k_group_reverse_ang
InspectAng["m9k_jackhammer"] = m9k_group_reverse_ang
InspectAng["m9k_spas12"] = m9k_group_reverse_ang
InspectAng["m9k_striker12"] = m9k_group_reverse_ang
InspectAng["m9k_usas"] = m9k_group_reverse_ang
InspectAng["m9k_1897winchester"] = m9k_group_reverse_ang
InspectAng["m9k_1887winchester"] = m9k_group_reverse_ang
InspectAng["m9k_aw50"] = m9k_group_reverse_ang
InspectAng["m9k_barret_m82"] = m9k_group_reverse_ang
InspectAng["m9k_sl8"] = m9k_group_reverse_ang
InspectAng["m9k_intervention"] = m9k_group_reverse_ang
InspectAng["m9k_m24"] = m9k_group_reverse_ang
InspectAng["m9k_psg1"] = m9k_group_reverse_ang
InspectAng["m9k_remington7615p"] = m9k_group_reverse_ang
InspectAng["m9k_bizonp19"] = m9k_group_reverse_ang
InspectAng["m9k_smgp90"] = m9k_group_reverse_ang
InspectAng["m9k_mp5"] = m9k_group_reverse_ang
InspectAng["m9k_mp7"] = m9k_group_reverse_ang
InspectAng["m9k_ump45"] = m9k_group_reverse_ang
InspectAng["m9k_usc"] = m9k_group_reverse_ang
InspectAng["m9k_kac_pdw"] = m9k_group_reverse_ang
InspectAng["m9k_vector"] = m9k_group_reverse_ang
InspectAng["m9k_magpulpdr"] = m9k_group_reverse_ang
InspectAng["m9k_mp40"] = m9k_group_reverse_ang
InspectAng["m9k_mp9"] = m9k_group_reverse_ang
InspectAng["m9k_sten"] = m9k_group_reverse_ang
InspectAng["m9k_tec9"] = m9k_group_reverse_ang
InspectAng["m9k_thompson"] = m9k_group_reverse_ang

InspectPos["m9k_val"] = m9k_group_farright_pos
InspectPos["m9k_famas"] = m9k_group_farright_pos
InspectPos["m9k_fal"] = m9k_group_farright_pos
InspectPos["m9k_m416"] = m9k_group_farright_pos
InspectPos["m9k_m416_golden_fire"] = m9k_group_farright_pos
InspectPos["m9k_g3a3"] = m9k_group_farright_pos
InspectPos["m9k_m14sp"] = m9k_group_farright_pos
InspectPos["m9k_scar"] = m9k_group_farright_pos
InspectPos["m9k_vikhr"] = m9k_group_farright_pos
InspectPos["m9k_tar21"] = m9k_group_farright_pos
InspectPos["m9k_ares_shrike"] = m9k_group_farright_pos
InspectPos["m9k_m249lmg"] = m9k_group_farright_pos
InspectPos["m9k_m60"] = m9k_group_farright_pos
InspectPos["m9k_pkm"] = m9k_group_farright_pos
InspectPos["m9k_deagle"] = m9k_group_farright_pos
InspectPos["m9k_usp"] = m9k_group_farright_pos
InspectPos["m9k_hk45"] = m9k_group_farright_pos
InspectPos["m9k_m29satan"] = m9k_group_farright_pos
InspectPos["m9k_m92beretta"] = m9k_group_farright_pos
InspectPos["m9k_model500"] = m9k_group_farright_pos
InspectPos["m9k_sig_p229r"] = m9k_group_farright_pos
InspectPos["m9k_mossberg590"] = m9k_group_farright_pos
InspectPos["m9k_remington870"] = m9k_group_farright_pos
InspectPos["m9k_m98b"] = m9k_group_farright_pos
InspectPos["m9k_svu"] = m9k_group_farright_pos
InspectPos["m9k_dragunov"] = m9k_group_farright_pos
InspectPos["m9k_svt40"] = m9k_group_farright_pos
InspectPos["m9k_svt40_golden_lightning"] = m9k_group_farright_pos
InspectPos["m9k_contender"] = m9k_group_farright_pos
InspectPos["m9k_honeybadger"] = m9k_group_farright_pos
InspectPos["m9k_mp5sd"] = m9k_group_farright_pos
InspectPos["m9k_uzi"] = m9k_group_farright_pos
InspectAng["m9k_val"] = m9k_group_farright_ang
InspectAng["m9k_famas"] = m9k_group_farright_ang
InspectAng["m9k_fal"] = m9k_group_farright_ang
InspectAng["m9k_m416"] = m9k_group_farright_ang
InspectAng["m9k_m416_golden_fire"] = m9k_group_farright_ang
InspectAng["m9k_g3a3"] = m9k_group_farright_ang
InspectAng["m9k_m14sp"] = m9k_group_farright_ang
InspectAng["m9k_scar"] = m9k_group_farright_ang
InspectAng["m9k_vikhr"] = m9k_group_farright_ang
InspectAng["m9k_tar21"] = m9k_group_farright_ang
InspectAng["m9k_ares_shrike"] = m9k_group_farright_ang
InspectAng["m9k_m249lmg"] = m9k_group_farright_ang
InspectAng["m9k_m60"] = m9k_group_farright_ang
InspectAng["m9k_pkm"] = m9k_group_farright_ang
InspectAng["m9k_deagle"] = m9k_group_farright_ang
InspectAng["m9k_usp"] = m9k_group_farright_ang
InspectAng["m9k_hk45"] = m9k_group_farright_ang
InspectAng["m9k_m29satan"] = m9k_group_farright_ang
InspectAng["m9k_m92beretta"] = m9k_group_farright_ang
InspectAng["m9k_model500"] = m9k_group_farright_ang
InspectAng["m9k_sig_p229r"] = m9k_group_farright_ang
InspectAng["m9k_mossberg590"] = m9k_group_farright_ang
InspectAng["m9k_remington870"] = m9k_group_farright_ang
InspectAng["m9k_m98b"] = m9k_group_farright_ang
InspectAng["m9k_svu"] = m9k_group_farright_ang
InspectAng["m9k_dragunov"] = m9k_group_farright_ang
InspectAng["m9k_svt40"] = m9k_group_farright_ang
InspectAng["m9k_svt40_golden_lightning"] = m9k_group_farright_ang
InspectAng["m9k_contender"] = m9k_group_farright_ang
InspectAng["m9k_honeybadger"] = m9k_group_farright_ang
InspectAng["m9k_mp5sd"] = m9k_group_farright_ang
InspectAng["m9k_uzi"] = m9k_group_farright_ang

print("[luctus_inspect] cl loaded!")
