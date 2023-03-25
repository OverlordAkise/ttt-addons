surface.CreateFont("LuctusMapvoteMapFont", {
    font = "Arial",
    size = 20,
    weight = 700,
    antialias = true,
    shadow = true
})

surface.CreateFont("LuctusMapvoteTimerFont", {
    font = "Arial",
    size = 40,
    weight = 700,
    antialias = true,
    shadow = true
})


MapVote.EndTime = 0
MapVote.Panel = nil
local mapPanels = {}

net.Receive("RAM_MapVoteStart", function()
    mapPanels = {}
    MapVote.CurrentMaps = {}
    MapVote.Allow = true
    MapVote.Votes = {}
    
    local amt = net.ReadUInt(32)
    
    for i = 1, amt do
        local map = net.ReadString()
        
        MapVote.CurrentMaps[#MapVote.CurrentMaps + 1] = map
    end
    
    MapVote.EndTime = CurTime() + net.ReadUInt(32)
    
    if IsValid(MapVote.Panel) then
        MapVote.Panel:Remove()
    end
    
    LuctusCreateMapvoteGui(MapVote.CurrentMaps)
    LuctusStartMapvoteTimer()
end)

net.Receive("RAM_MapVoteUpdate", function()
    local update_type = net.ReadUInt(3)
    
    if update_type == MapVote.UPDATE_VOTE then
        local ply = net.ReadEntity()
        
        if IsValid(ply) then
            local map_id = net.ReadUInt(32)
            MapVote.Votes[ply:SteamID()] = map_id
        
            if IsValid(MapVote.Panel) then
                LuctusMapvoteAddVoter(ply)
            end
        end
    elseif update_type == MapVote.UPDATE_WIN then      
        if IsValid(MapVote.Panel) then
            PFlash(net.ReadUInt(32))
            LuctusStopMapvoteTimer()
        end
    end
end)

net.Receive("RAM_MapVoteCancel", function()
    if IsValid(MapVote.Panel) then
        MapVote.Panel:Remove()
    end
    LuctusStopMapvoteTimer()
end)

net.Receive("RTV_Delay", function()
    chat.AddText(Color(102,255,51),"[RTV]",Color(255,255,255)," The vote has been rocked, map vote will begin on round end")
end)


-- Timer
function LuctusStartMapvoteTimer()
    hook.Add("HUDPaint","luctus_mapvote_timer",function()
        local timeLeft = math.Round(math.max(MapVote.EndTime - CurTime(), 0))
        draw.SimpleTextOutlined((timeLeft or 0).." seconds", "LuctusMapvoteTimerFont", ScrW()/2, 70, Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 2, Color(0,0,0))
        draw.SimpleTextOutlined("Press F4 to reopen the mapvote menu", "LuctusMapvoteMapFont", ScrW()/2, 110, Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, Color(0,0,0))
    end)
end

function LuctusStopMapvoteTimer()
    hook.Remove("HUDPaint","luctus_mapvote_timer")
end

net.Receive("LuctusReopenMapvote",function()
    if IsValid(MapVote.Panel) then
        MapVote.Panel:SetVisible(true)
    end
end)

-- Window

local mapList = nil
local voters = nil
local countDown = nil

function LuctusCreateMapvoteGui(mapliste)
    
    MapVote.Panel = vgui.Create("DFrame")
    MapVote.Panel:SetSize(900,600)
    MapVote.Panel:SetTitle("Luctus' Mapvote")
    MapVote.Panel:Center()
    MapVote.Panel:ShowCloseButton(false)
    MapVote.Panel:MakePopup()
    function MapVote.Panel:Paint(w,h)
        draw.RoundedBox(0,0,0,w,h,Color(0,0,0,240))
        surface.SetDrawColor(0,195,165,255)
        surface.DrawLine(0,0,w,0)
        surface.DrawLine(w-1,0,w-1,h-1)
        surface.DrawLine(w-1,h-1,0,h-1)
        surface.DrawLine(0,h-1,0,0)
    end
    function MapVote.Panel:OnKeyCodePressed(key)
        if key == KEY_F4 then MapVote.Panel:SetVisible(false) end
    end
    
    local closebut = vgui.Create("DButton",MapVote.Panel)
    closebut:SetText("X")
    closebut:SetPos(900-22,2)
    closebut:SetSize(20,20)
    closebut:SetTextColor(Color(255,0,0))
    closebut.DoClick = function()
        MapVote.Panel:SetVisible(false)
    end
    closebut.Paint = function(self,w,h)
        draw.RoundedBox(0, 0, 0, w, h, Color(47, 49, 54))
        if self.Hovered then
            draw.RoundedBox(0, 0, 0, w, h, Color(66, 70, 77))
        end
    end
    
    mapList = vgui.Create("DScrollPanel", MapVote.Panel)
    mapList:Dock(FILL)
    mapList:SetDrawBackground(false)
    mapList:SetPadding(4)
    mapList.panelcounter = 0
    function mapList:Think() LuctusMapvoteGuiThink(self) end
    mapList.Voters = {}
    local activePanel = nil
    for k,v in pairs(mapliste) do
    
        if mapList.panelcounter % 3 == 0 then
            activePanel = mapList:Add("DButton")
            activePanel:Dock(TOP)
            activePanel:SetText("")
            activePanel:SetHeight(35)
            activePanel:DockPadding(5,5,5,5)
            --activePanel:DockMargin(0,5,0,5)
            function activePanel.Paint() end
            mapList.panelcounter = mapList.panelcounter + 1
        end
        
        local but = activePanel:Add("DButton")
        but:SetWide(435)
        but:Dock(k%2==0 and RIGHT or LEFT)
        but.ID = k
        but:SetText(v)
        mapPanels[v] = but
        but:SetTextColor(color_white)
        but:SetContentAlignment(4)
        but:SetTextInset(8, 0)
        but:SetFont("LuctusMapvoteMapFont")
        function but:DoClick()
            net.Start("RAM_MapVoteUpdate")
                net.WriteUInt(MapVote.UPDATE_VOTE, 3)
                net.WriteUInt(self.ID, 32)
            net.SendToServer()
        end
        function but:Paint(w, h)
            local col = Color(255, 255, 255, 10)
            if self.bgColor then
                col = self.bgColor
            end
            draw.RoundedBox(4, 0, 0, w, h, col)
        end
        mapList.panelcounter = mapList.panelcounter + 1
    end
end

function LuctusMapvoteAddVoter(voter)
    for k, v in pairs(mapList.Voters) do
        if v.Player and v.Player == voter then
            return false
        end
    end
    
    local icon_container = vgui.Create("Panel", mapList)
    local icon = vgui.Create("AvatarImage", icon_container)
    icon:SetSize(16, 16)
    icon:SetZPos(1000)
    icon:SetTooltip(voter:Name())
    icon_container.Player = voter
    icon_container:SetTooltip(voter:Name())
    icon:SetPlayer(voter, 16)

    icon_container:SetSize(20, 20)
    icon:SetPos(2, 2)
    
    icon_container.Paint = function(s, w, h)
        draw.RoundedBox(4, 0, 0, w, h, Color(255, 0, 0, 80))
        
        if icon_container.img then
            surface.SetMaterial(icon_container.img)
            surface.SetDrawColor(Color(255, 255, 255))
            surface.DrawTexturedRect(2, 2, 16, 16)
        end
    end
    
    table.insert(mapList.Voters, icon_container)
end

function LuctusMapvoteGuiThink(self)
    for k, v in pairs(mapPanels) do
        v.NumVotes = 0
    end
    
    for k, v in pairs(self.Voters) do
        if not IsValid(v.Player) then
            v:Remove()
            continue
        end
        if not MapVote.Votes[v.Player:SteamID()] then
            v:Remove()
            continue
        end
        local bar = PGetMapButton(MapVote.Votes[v.Player:SteamID()])
        local parent = bar:GetParent()
        
        bar.NumVotes = bar.NumVotes + 1
        
        if IsValid(bar) then
            local NewPos = Vector((bar.x + bar:GetWide()) - 21 * bar.NumVotes - 2, parent.y + (bar:GetTall() * 0.5)-5, 0)
            
            if not v.CurPos or v.CurPos ~= NewPos then
                v:MoveTo(NewPos.x, NewPos.y, 0.3)
                v.CurPos = NewPos
            end
        end
    end
end

function PGetMapButton(id)
    for map,panel in pairs(mapPanels) do
        if panel.ID == id then return panel end
    end
    return false
end

function PFlash(id)
    MapVote.Panel:SetVisible(true)

    local bar = PGetMapButton(id)
    
    if IsValid(bar) then
        timer.Simple( 0.0, function() bar.bgColor = Color( 0, 255, 255 ) surface.PlaySound( "hl1/fvox/blip.wav" ) end )
        timer.Simple( 0.2, function() bar.bgColor = nil end )
        timer.Simple( 0.4, function() bar.bgColor = Color( 0, 255, 255 ) surface.PlaySound( "hl1/fvox/blip.wav" ) end )
        timer.Simple( 0.6, function() bar.bgColor = nil end )
        timer.Simple( 0.8, function() bar.bgColor = Color( 0, 255, 255 ) surface.PlaySound( "hl1/fvox/blip.wav" ) end )
        timer.Simple( 1.0, function() bar.bgColor = Color( 100, 100, 100 ) end )
    end
end
