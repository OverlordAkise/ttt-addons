--Luctus Skins
--Made by OverlordAkise

SWEP.Gun                    = ("m9k_m416") 
SWEP.Category				= "M9K Assault Rifles"
SWEP.Author				    = ""
SWEP.Contact				= ""
SWEP.Purpose				= ""
SWEP.Instructions			= ""
SWEP.MuzzleAttachment		= "1" 	
SWEP.ShellEjectAttachment	= "2" 	
SWEP.PrintName				= "HK416|GoldenFire"
SWEP.Slot				    = 2				
SWEP.SlotPos				= 3			
SWEP.DrawAmmo				= true		
SWEP.DrawWeaponInfoBox		= false		
SWEP.BounceWeaponIcon   	= false	
SWEP.DrawCrosshair			= false	
SWEP.Weight				    = 30			
SWEP.AutoSwitchTo			= true		
SWEP.AutoSwitchFrom			= true		
SWEP.HoldType 				= "ar2"		

SWEP.ViewModelFOV			= 70
SWEP.ViewModelFlip			= false
SWEP.ViewModel				= "models/weapons/v_hk416rif.mdl"	
SWEP.WorldModel				= "models/weapons/w_hk_416.mdl"	
SWEP.Icon                   = "materials/vgui/ttt/m416.png"
SWEP.ShowWorldModel			= true
SWEP.Base				    = "weapon_tttbase"
SWEP.Spawnable				= true
SWEP.AdminSpawnable			= true
SWEP.AutoSpawnable          = true

SWEP.Kind     = WEAPON_HEAVY
SWEP.WeaponID = AMMO_M16

SWEP.Primary.Sound			= Sound("hk416weapon.UnsilSingle")	
SWEP.Primary.RPM			= 800			
SWEP.Primary.ClipSize		= 30		
SWEP.Primary.DefaultClip	= 30	
SWEP.Primary.ClipMax        = 60

SWEP.Primary.Delay          = 0.13
SWEP.Primary.Cone           = 0.018

SWEP.Primary.KickUp			= 0.4		
SWEP.Primary.KickDown		= 0.4		
SWEP.Primary.KickHorizontal	= 0.6		
SWEP.Primary.Automatic		= true		
SWEP.Primary.Ammo			= "smg1"
SWEP.AmmoEnt                = "item_ammo_smg1_ttt"		
SWEP.FiresUnderwater        = true

SWEP.Secondary.IronFOV		= 55		
SWEP.data 				    = {}			
SWEP.data.ironsights		= 1

SWEP.Primary.NumShots	    = 1		
SWEP.Primary.Damage		    = 24	
SWEP.Primary.Spread		    = .025	
SWEP.Primary.IronAccuracy   = .015 

SWEP.IronSightsPos = Vector(-2.892, -2.132, 0.5)
SWEP.IronSightsAng = Vector(-0.033, 0.07, 0)
SWEP.SightsPos     = Vector(-2.892, -2.132, 0.5)
SWEP.SightsAng     = Vector(-0.033, 0.07, 0)
SWEP.RunSightsPos  = Vector(2.125, -0.866, 1.496)
SWEP.RunSightsAng  = Vector(-18.08, 30.59, 0)

function SWEP:Initialize()
    if SERVER then
        self.Weapon:SetSubMaterial(3,"models/props_lab/Tank_Glass001")
        self.Weapon:SetSubMaterial(0,"models/props_lab/Tank_Glass001")
        self.Weapon:SetSubMaterial(2,"gold_tool/australium")
        self.Weapon:SetSubMaterial(1,"gold_tool/australium")
        self.Weapon:SetSubMaterial(4,"gold_tool/australium")
        self.Weapon:SetSubMaterial(5,"models/props_lab/Tank_Glass001")
        self.Weapon:SetSubMaterial(6,"models/props_lab/Tank_Glass001")
        self.Weapon:SetSubMaterial(8,"models/props_lab/Tank_Glass001")
        self.Weapon:SetSubMaterial(7,"models/props_lab/Tank_Glass001")
    end
    return self.BaseClass.Initialize(self)
end

if SERVER then return end

function SWEP:PreDrawViewModel(vm)
    vm:SetSubMaterial(3,"gold_tool/australium")
    vm:SetSubMaterial(1,"models/props_lab/Tank_Glass001")
    vm:SetSubMaterial(2,"gold_tool/australium")
    vm:SetSubMaterial(4,"models/props_lab/Tank_Glass001")
    vm:SetSubMaterial(5,"gold_tool/australium")
    vm:SetSubMaterial(6,"models/props_lab/Tank_Glass001")
    vm:SetSubMaterial(8,"models/props_lab/Tank_Glass001")
    vm:SetSubMaterial(7,"models/props_lab/Tank_Glass001")
    vm:SetSubMaterial(9,"models/props_lab/Tank_Glass001")
end

function SWEP:PostDrawViewModel(vm)
    vm:SetSubMaterial(3,"")
    vm:SetSubMaterial(1,"")
    vm:SetSubMaterial(2,"")
    vm:SetSubMaterial(4,"")
    vm:SetSubMaterial(5,"")
    vm:SetSubMaterial(6,"")
    vm:SetSubMaterial(8,"")
    vm:SetSubMaterial(7,"")
    vm:SetSubMaterial(9,"")
end
