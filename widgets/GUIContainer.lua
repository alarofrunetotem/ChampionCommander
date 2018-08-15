local me,addon=...
if addon.die then return end
local C=addon:GetColorTable()
local module=addon:GetWidgetsModule()
local Type,Version="BFAGUIContainer",2
local AceGUI = LibStub and LibStub("AceGUI-3.0", true)
if not AceGUI or (AceGUI:GetWidgetVersion(Type) or 0) >= Version then return end
local m={} --#Widget
function m:Close()
	self.frame.Close:Click()
end
function m:OnAcquire()
	self.frame:EnableMouse(true)
	self:SetTitleColor(C.Yellow())
	self.frame:SetFrameStrata("HIGH")
	self.frame:SetFrameLevel(999)
end
function m:SetContentWidth(x)
	self.content:SetWidth(x)
end
function m:SetTitle(...)
	--self.frame.TitleText:SetText(...)
end
function m:SetTitleColor(...)
	--self.frame.TitleText:SetTextColor(...)
end
function m._Constructor()
	local frame=CreateFrame("Frame",Type..AceGUI:GetNextWidgetNum(Type),nil,"BFABaseFrame")
	local widget={frame=frame,missions={},type=Type}
	for k,v in pairs(m) do widget[k]=v end
	widget._Constructor=nil
	frame:SetScript("OnHide",function(self) self.obj:Fire('OnClose') end)
	frame.obj=widget
	--Container Support
	local content = CreateFrame("Frame",nil,frame)
	widget.content = content
	--addBackdrop(content,'Green')
	content.obj = widget
	content:SetPoint("TOPLEFT",25,-25)
	content:SetPoint("BOTTOMRIGHT",-25,25)
	AceGUI:RegisterAsContainer(widget)
	return widget
end
AceGUI:RegisterWidgetType(Type,m._Constructor,Version)
