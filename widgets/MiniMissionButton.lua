local me,addon=...
if addon.die then return end
local C=addon:GetColorTable()
local module=addon:GetWidgetsModule()
local Type,Version="BFAMiniMissionButton",1
local AceGUI = LibStub and LibStub("AceGUI-3.0", true)
if not AceGUI or (AceGUI:GetWidgetVersion(Type) or 0) >= Version then return end
local m={} --#Widget2
function m:OnAcquire()
  self.frame.Followers:GetScript("OnLoad")(self.frame.Followers)
  self.frame.Followers:SetScale(0.7)
end
function m:OnRelease()
end
function m:Show()
  return self.frame:Show()
end
function m:SetHeight(h)
  return self.frame:SetHeight(h)
end
function m:Hide()
  self.frame:SetHeight(1)
  self.frame:SetAlpha(0)
  return self.frame:Disable()
end
function m:SetScript(name,method)
  tinsert(self.scripts,name)
  return self.frame:SetScript(name,method)
end
function m:SetScale(s)
  return self.frame:SetScale(s)
end
function m:SetMission(title,reason,followers)
  local frame=self.frame
  frame.Title:SetText(title)
  frame.Status:SetText(reason)
end
function m._Constructor()
  local frame=CreateFrame("Frame",Type..AceGUI:GetNextWidgetNum(Type),nil,"BFAMiniMissionButton")
  --frame.Title:SetFontObject("QuestFont_Shadow_Small")
  --frame.Status:SetFontObject("QuestFont_Shadow_Small")
  frame.Status:ClearAllPoints()
  frame.Status:SetPoint("TOPLEFT",frame.Title,"BOTTOMLEFT",0,-5)
  frame:SetScript("OnEnter",function(self) self.obj:Fire("OnEnter") end)
  frame:SetScript("OnLeave",function(self)self.obj:Fire("OnLeave") end)
  frame.isResult=true
  local widget={type=Type}
  setmetatable(widget,{__index=frame})
  widget.frame=frame
  widget.scripts={}
  frame.obj=widget
  for k,v in pairs(m) do widget[k]=v end
  widget._Constructor=nil
  return AceGUI:RegisterAsWidget(widget)
end
AceGUI:RegisterWidgetType(Type,m._Constructor,Version)

	