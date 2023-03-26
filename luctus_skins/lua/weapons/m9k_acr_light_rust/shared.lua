--Luctus Skins
--Made by OverlordAkise

SWEP.Gun                     = ("m9k_acr") 
SWEP.Category				 = "M9K Assault Rifles"
SWEP.Author				     = ""
SWEP.Contact				 = ""
SWEP.Purpose				 = ""
SWEP.Instructions			 = ""
SWEP.MuzzleAttachment		 = "1" 	
SWEP.ShellEjectAttachment	 = "2"
SWEP.PrintName				 = "ACR|LightRust"		
SWEP.Slot				     = 2				
SWEP.SlotPos				 = 3			
SWEP.DrawAmmo				 = true		
SWEP.DrawWeaponInfoBox		 = false		
SWEP.BounceWeaponIcon   	 = false	
SWEP.DrawCrosshair			 = false		
SWEP.Weight				     = 30			
SWEP.AutoSwitchTo			 = true		
SWEP.AutoSwitchFrom			 = true		
SWEP.HoldType 				 = "ar2"		

SWEP.ViewModelFOV			 = 70
SWEP.ViewModelFlip			 = true
SWEP.ViewModel				 = "models/weapons/v_rif_msda.mdl"
SWEP.WorldModel				 = "models/weapons/w_masada_acr.mdl"
SWEP.Icon                    = "materials/vgui/ttt/acr.png"
SWEP.Base				     = "weapon_tttbase"
SWEP.Spawnable				 = true
SWEP.AdminSpawnable			 = true
SWEP.AutoSpawnable           = true

SWEP.Kind                    = WEAPON_HEAVY
SWEP.WeaponID                = AMMO_MAC10

SWEP.Primary.Sound			 = Sound("Masada.Single")	
SWEP.Primary.RPM			 = 825		
SWEP.Primary.ClipSize		 = 30		
SWEP.Primary.DefaultClip	 = 30		
SWEP.Primary.ClipMax         = 60

SWEP.Primary.Delay           = 0.13
SWEP.Primary.Cone            = 0.018

SWEP.Primary.KickUp			 = 0.3		
SWEP.Primary.KickDown		 = 0.3		
SWEP.Primary.KickHorizontal  = 0.3		
SWEP.Primary.Automatic	     = true		
SWEP.Primary.Ammo			 = "smg1"
SWEP.AmmoEnt                 = "item_ammo_smg1_ttt"		
SWEP.FiresUnderwater         = true

SWEP.Secondary.IronFOV	     = 55	
SWEP.data 				     = {}			
SWEP.data.ironsights		 = 1

SWEP.Primary.NumShots	     = 1		
SWEP.Primary.Damage		     = 23	
SWEP.Primary.Spread		     = .025	
SWEP.Primary.IronAccuracy    = .015 

SWEP.IronSightsPos           = Vector(2.668, 0, 0.675)
SWEP.IronSightsAng           = Vector(0, 0, 0)
SWEP.SightsPos               = Vector(2.668, 0, 0.675)
SWEP.SightsAng               = Vector(0, 0, 0)
SWEP.RunSightsPos            = Vector (-3.0328, 0, 1.888)
SWEP.RunSightsAng            = Vector (-24.2146, -36.522, 10)


function SWEP:Initialize()
    if SERVER then
        self.Weapon:SetSubMaterial(0,"models/props_combine/metal_combinebridge001")
    end
    return self.BaseClass.Initialize(self)
end

if SERVER then return end

function SWEP:PreDrawViewModel(vm)
    vm:SetSubMaterial(0,"models/props_combine/metal_combinebridge001")
end

function SWEP:PostDrawViewModel(vm)
    vm:SetSubMaterial(0,"")
end
