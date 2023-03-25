--Luctus TTT Whitelist
--Made by OverlordAkise

net.Receive("luctus_whitelist",function()
    local tab = net.ReadTable()
    LuctusOpenWhitelist(tab)
end)

local wlFrame = nil
function LuctusOpenWhitelist(tab)
    local steamids = ""
    for k,v in pairs(tab) do
        steamids = steamids..v.."\n"
    end

    wlFrame = vgui.Create("DFrame")
    wlFrame:SetSize(300,400)
    wlFrame:SetTitle("Luctus' TTT Whitelist")
    wlFrame:Center()
    wlFrame:ShowCloseButton(true)
    wlFrame:MakePopup()
    
    local submit = vgui.Create("DButton",wlFrame)
    submit:Dock(BOTTOM)
    submit:SetText("SAVE WHITELIST")
    
    
    local textentry = vgui.Create("DTextEntry",wlFrame)
    textentry:Dock(FILL)
    textentry:SetDrawLanguageID(false)
    textentry:SetEditable(true)
    textentry:SetMultiline(true)
    textentry:SetValue(steamids)
    if steamids == "" then
        textentry:SetValue("STEAM_0:0:55735858\nSTEAM_0:0:55735858\nSTEAM_0:0:55735858")
    end
    
    function submit:DoClick()
        local newtab = string.Split(textentry:GetValue(),"\n")
        net.Start("luctus_whitelist")
            net.WriteTable(newtab)
        net.SendToServer()
    end
end


local acccent = Color(0, 195, 165)
local color_white = Color(255,255,255)
net.Receive("luctus_whitelist_chat",function()
    local text = net.ReadString()
    chat.AddText(accent,"| ",color_white,text)
    surface.PlaySound("resource/warning.wav")
end)

print("[luctus_ttt_whitelist] cl loaded!")
