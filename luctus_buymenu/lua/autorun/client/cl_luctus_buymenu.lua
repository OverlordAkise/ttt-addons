--Luctus TTT Buymenu
--Made by OverlordAkise

local accent_col = Color(0, 195, 165)
local wcFrame = nil
local ownedWeapons = {}

local function LuctusPrettifyScrollbar(el)
  function el:Paint() return end
	function el.btnGrip:Paint(w, h)
        draw.RoundedBox(0,0,0,w,h,accent_col)
		draw.RoundedBox(0, 1, 1, w-2, h-2, Color(32, 34, 37))

	end
	function el.btnUp:Paint(w, h)
		draw.RoundedBox(0,0,0,w,h,accent_col)
		draw.RoundedBox(0, 1, 1, w-2, h-2, Color(32, 34, 37))
	end
	function el.btnDown:Paint(w, h)
		draw.RoundedBox(0,0,0,w,h,accent_col)
		draw.RoundedBox(0, 1, 1, w-2, h-2, Color(32, 34, 37))
	end
end

net.Receive("luctus_buymenu_equip",function()
    if IsValid(wcFrame) then return end
    
    ownedWeapons = net.ReadTable()
    PrintTable(ownedWeapons)

    local availableCategories = LUCTUS_BUYMENU_EQUIPMENT
    currentCat = ""
    for k,v in pairs(LUCTUS_BUYMENU_EQUIPMENT) do
        firstCat = k
        break
    end
    
    wcFrame = vgui.Create("DFrame")
    wcFrame:SetSize(700, 500)
    wcFrame:Center()
    wcFrame:SetTitle("Luctus' Pointshop | Points: "..LocalPlayer():GetPoints())
    wcFrame:SetDraggable(true)
    wcFrame:ShowCloseButton(false)
    wcFrame:MakePopup()
    function wcFrame:Paint(w,h)
        draw.RoundedBox(0, 0, 0, w, h, Color(32, 34, 37))
        draw.RoundedBox(0, 1, 1, w - 2, h - 2, Color(54, 57, 62))
    end

    local parent_x, parent_y = wcFrame:GetSize()
    local CloseButton = vgui.Create( "DButton", wcFrame )
    CloseButton:SetPos( parent_x-30, 0 )
    CloseButton:SetSize( 30, 30 )
    CloseButton:SetText("X")
    CloseButton:SetTextColor(Color(255,0,0))
    CloseButton.DoClick = function()
        wcFrame:Close()
    end
    CloseButton.Paint = function(self, w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(47, 49, 54))
        if (self.Hovered) then
            draw.RoundedBox(0, 0, 0, w, h, Color(66, 70, 77))
        end
    end
    
    local categoryButtons = vgui.Create("DScrollPanel", wcFrame)
    categoryButtons:Dock(LEFT)
    categoryButtons:SetWide(150)
    categoryButtons:DockMargin(5,5,5,5)
    LuctusPrettifyScrollbar(categoryButtons:GetVBar())
    
    local iconScroller = vgui.Create("DScrollPanel", wcFrame)
    iconScroller:Dock(FILL)
    LuctusPrettifyScrollbar(iconScroller:GetVBar())
    
    local iconList = vgui.Create("DIconLayout", iconScroller)
    iconList:Dock(FILL)
    iconList:SetSpaceY(5)
    iconList:SetSpaceX(5)
    
    LuctusWCAddWeaponIcons(iconList, LUCTUS_BUYMENU_EQUIPMENT[firstCat],firstCat)
    --^ This needs to stay or the DIconLayout doesn't work
    --aka. without initially having icons it wont work
    currentCat = firstCat
    
    for catName,_ in pairs(LUCTUS_BUYMENU_EQUIPMENT) do
        local weps = LUCTUS_BUYMENU_EQUIPMENT[catName]
        local catBut = vgui.Create("DButton",categoryButtons)
        catBut.weps = weps
        catBut.catName = catName
        catBut:Dock(TOP)
        catBut:SetSize(CategoryWidth, 30)
        catBut:SetCursor("hand")
        catBut:SetText("")
        catBut.Paint = function(self, w, h)
            --if k % 2 == 0 then
            draw.RoundedBox(0, 0, 0, w, h, Color(44, 47, 52))
            if (self.Hovered) then
                draw.RoundedBox(0, 0, 0, w, h, Color(66, 70, 77))
            end
            if currentCat == self.catName then
                DrawHighlightBorder(self,w,h)
            end
            draw.DrawText(catName, "Trebuchet18", 10, 7, Color(255,255,255))
        end
        catBut.DoClick = function(self)
            currentCat = self.catName
            iconList:Clear()
            LuctusWCAddWeaponIcons(iconList, self.weps, self.catName)
        end
    end--]]
end)

function DrawHighlightBorder(el,w,h)
    surface.SetDrawColor(accent_col)
    surface.DrawLine(0,0,w,0)
    surface.DrawLine(w-1,0,w-1,h-1)
    surface.DrawLine(w-1,h-1,0,h-1)
    surface.DrawLine(0,h-1,0,0)
end

function LuctusWCAddWeaponIcons(iconList, weplist, catName)
    for wepClass,v in pairs(weplist) do
        local cost = v[1]
        local levelRequire = v[2]
        local wep = weapons.Get(wepClass)
        local panel = iconList:Add("DPanel")
        panel:SetSize(510,120)
        panel.wepname = wep and wep.PrintName or wepClass
        function panel:Paint(w,h)
            draw.SimpleTextOutlined(self.wepname, "DermaLarge", 130, 20, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0, 255 ) )
            DrawHighlightBorder(self,w,h)
        end
        local icon = vgui.Create("DModelPanel",panel)
        icon:SetModel(wep and wep.WorldModel or "models/error.mdl")
        icon:SetSize(120, 120)
        icon:Dock(LEFT)
        icon:SetLookAt(icon.Entity:GetPos()+Vector(0,0,0))
        icon:SetFOV(30)
        function icon:LayoutEntity(Entity) return end --disables rotation
        
        if LocalPlayer():GetLevel() < levelRequire then
            local hide = vgui.Create("DPanel",panel)
            hide:SetPos(0,0)
            hide:SetSize(510,120)
            function hide:Paint(w,h)
                draw.RoundedBox(0, 0, 0, w, h, Color(166, 70, 77, 20))
                draw.SimpleTextOutlined("Unlocked at Lv."..levelRequire, "DermaLarge",260,60,color_white,TEXT_ALIGN_LEFT,TEXT_ALIGN_TOP,1,Color(0,0,0,255))
            end
            
            continue
        end
        
        local bg = vgui.Create("DButton",panel)
        bg:SetSize(370, 40)
        bg:SetPos(130,70)
        bg.wep = wepClass
        bg.wepvalid = wep and true or false
        bg.catName = catName
        bg.cost = LUCTUS_BUYMENU_EQUIPMENT[catName][wepClass][1]
        bg.owned = ownedWeapons[bg.wep]
        if bg.owned then
            bg:SetText("Equip")
        else
            bg:SetText("Buy for "..bg.cost.." points")
        end
        bg:SetTextColor(accent_col)
        bg.Paint = function(self,w,h)
            DrawHighlightBorder(self,w,h)
            if self.Hovered then
                draw.RoundedBox(0, 0, 0, w, h, Color(66, 70, 77))
            end
        end
        bg.DoClick = function(self)
            if not self.wepvalid then return end
            if not self.owned then
                --buy
                if LocalPlayer():GetPoints() < self.cost then
                    chat.AddText(accent,"| ",color_white,"You can't afford this weapon yet!")
                    surface.PlaySound("buttons/combine_button_locked.wav")
                    return
                end
                net.Start("luctus_buymenu_buy")
                    net.WriteString(self.catName)
                    net.WriteString(self.wep)
                net.SendToServer()
                surface.PlaySound("ambient/levels/labs/coinslot1.wav")
                self:SetText("Equip")
                self.owned = true
            else
                --equip
                net.Start("luctus_buymenu_equip")
                    net.WriteString(self.catName)
                    net.WriteString(self.wep)
                net.SendToServer()
                surface.PlaySound("npc/combine_soldier/gear5.wav")
            end
        end
    end
end


local acccent = Color(0, 195, 165)
local color_white = Color(255,255,255)
local color_level = Color(255,0,255)
net.Receive("luctus_buymenu_notify",function()
    local text = net.ReadString()
    chat.AddText(accent,"| ",color_white,text)
end)

print("[luctus_buymenu] cl loaded!")
