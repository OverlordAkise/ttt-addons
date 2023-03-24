surface.CreateFont( "WpnInfoHead", {
    font = "Roboto",
    size = 130,
    weight = 500,
    antialias = true
})

surface.CreateFont( "WpnInfoBody", {
    font = "Roboto",
    size = 80,
    weight = 500,
    antialias = true
})

local tttweaponnames = {
    [ "pistol_name" ] = "Pistol",
    [ "knife_name" ] = "Knife",
    [ "rifle_name" ] = "Rifle",
    [ "shotgun_name" ] = "Shotgun",
    [ "sipistol_name" ] = "Silenced Pistol",
    [ "flare_name" ] = "Flare Gun",
    [ "newton_name" ] = "Newton Launcher",
    [ "grenade_smoke" ] = "Smoke Grenade",
    [ "confgrenade_name" ] = "Discombulator",
    [ "grenade_fire" ] = "Incendiary Grenade",
    [ "c4" ] = "C4 Explosive",
    [ "tele_name" ] = "Teleporter"
}

local weaponinfos = {}
local weaponname = "N/A"

local color_white = Color(255,255,255,255)
local color_bg = Color( 25, 25, 25, 240 )

hook.Add( "PostDrawOpaqueRenderables", "luctus_weaponinfo", function()

    local ply = LocalPlayer()
    local ent = util.TraceLine({
        start = ply:GetShootPos(),
        endpos = ply:GetShootPos() + ( ply:GetAimVector() * 250 ),
        filter = ply,
        mask = MASK_SHOT_HULL
    }).Entity

    if not IsValid(ent) then return end

    local wpn = ply:GetActiveWeapon()
    local padding = 50

    local angle = Angle(0, ply:EyeAngles().y - 90, 90)
    local scale = 0.04

    --ammo later
    if ent:IsWeapon() and ent:IsScripted() then
        table.Empty(weaponinfos)
        if tttweaponnames[ent:GetPrintName()] then
            weaponname = tttweaponnames[ent:GetPrintName()]
        else
            weaponname = ent:GetPrintName()
        end
        if ent.Primary.Damage > 1 then
            table.insert(weaponinfos,{"Damage",ent.Primary.Damage})
        end
        if ent.Primary.ClipSize > 0 then
            table.insert(weaponinfos,{"Clip",ent.Primary.ClipSize})
        end
        if ent.Primary.Automatic then
            table.insert(weaponinfos,{"Automatic","Yes"})
        else
            table.insert(weaponinfos,{"Automatic","No"})
        end
        table.insert(weaponinfos,{"Spread",ent.Primary.Cone})
        table.insert(weaponinfos,{"Recoil",ent.Primary.Recoil})
        table.insert(weaponinfos,{"Ammo",ent.Primary.Ammo})
        table.insert(weaponinfos,{"Firerate",ent.Primary.Delay})
        table.insert(weaponinfos,{"#Bullets",ent.Primary.NumShots})
        
        local panelwidth = 600 + string.len(weaponname) * 20
        local panelheight = 790
        
        local x = -panelwidth / 2
        local y = 0

        local position = ent:GetPos() + Vector(0,0,40)
        position = position + angle:Up()*10

        cam.Start3D2D(position, angle, scale)
            draw.RoundedBox(30, x, y, panelwidth, panelheight, color_bg)
            --Header
            draw.DrawText(weaponname, "WpnInfoHead", 0, y + 10, color_white, TEXT_ALIGN_CENTER )
            y = y + 50
            for k,v in pairs(weaponinfos) do
                draw.DrawText(v[1], "WpnInfoBody", x + padding, y+k*80, color_white, TEXT_ALIGN_LEFT)
                draw.DrawText(v[2], "WpnInfoBody", x + panelwidth - padding, y+k*80, color_white, TEXT_ALIGN_RIGHT)
            end
        cam.End3D2D()

    -- Display information about ammunitions
    elseif ent.Type and ent.AmmoType and ent.Type == "anim" then
        
        local width, height = surface.GetTextSize(ent.AmmoType)

        panelwidth = width + padding > 500 and width + padding * 4 or 500
        panelheight = 200
        local x = -panelwidth / 2
        local y = 0

        local position = ent:GetPos() + Vector( 0, 0, 25 )
        
        cam.Start3D2D( position, angle, scale )
            draw.RoundedBox(30, x, y, panelwidth, panelheight, color_bg)
            draw.DrawText(ent.AmmoType, "WpnInfoBody", 0, y + padding, color_white, TEXT_ALIGN_CENTER)
        cam.End3D2D()

    end
    
end)

print("[luctus_weaponinfo] cl loaded!")
