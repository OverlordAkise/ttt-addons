--Luctus RTD
--Made by OverlordAkise

local color_white = Color(255,255,255)
local color_black = Color(0,0,0)
local color_accent = Color(0, 195, 165)
local color_dice = Color(255,0,255)

net.Receive("luctus_rtd_msg",function()
    local text = net.ReadString()
    local coloredText = net.ReadString()
    chat.AddText(color_accent,"rtd | ",color_white,text,color_dice,coloredText)
end)
net.Receive("luctus_rtd_hud",function()
    local duration = net.ReadUInt(8)
    local endTime = CurTime()+duration
    local x,y = ScrW()/2, ScrH()*0.75
    hook.Add("HUDPaint", "luctus_rtd", function()
        draw.SimpleTextOutlined(math.Round(endTime-CurTime()).."s","DermaLarge",x,y,color_dice,TEXT_ALIGN_CENTER,TEXT_ALIGN_TOP, 2, color_black)
    end)
    timer.Simple(duration,function()
        hook.Remove("HUDPaint", "luctus_rtd")
    end)
end)

print("[luctus_rtd] cl loaded")
