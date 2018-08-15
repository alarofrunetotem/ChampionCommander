local me,addon=...
if addon.die then return end
local C=addon:GetColorTable()
local module=addon:GetWidgetsModule()
local Type,Version,unique="BFAMissionDetails",2,0
local AceGUI = LibStub and LibStub("AceGUI-3.0", true)
if not AceGUI or (AceGUI:GetWidgetVersion(Type) or 0) >= Version then return end
local C=addon:GetColorTable()
local G=C_Garrison
local GARRISON_FOLLOWER_XP_ADDED_ZONE_SUPPORT=GARRISON_FOLLOWER_XP_ADDED_ZONE_SUPPORT:gsub('%%d',C('%%d','Yellow'))
local GARRISON_FOLLOWER_XP_ADDED_ZONE_SUPPORT_LEVEL_UP=GARRISON_FOLLOWER_XP_ADDED_ZONE_SUPPORT_LEVEL_UP:gsub('%%d',C('%%d','Green'))
local GARRISON_FOLLOWER_XP_LEFT=GARRISON_FOLLOWER_XP_LEFT:gsub('%%d',C('%%d','Orange'))
local COMBATLOG_XPGAIN_FIRSTPERSON_UNNAMED=COMBATLOG_XPGAIN_FIRSTPERSON_UNNAMED:gsub('%%d',C('%%d','Green'))
local GARRISON_FOLLOWER_XP_UPGRADE_STRING=GARRISON_FOLLOWER_XP_UPGRADE_STRING
local GARRISON_FOLLOWER_XP_STRING=GARRISON_FOLLOWER_XP_STRING
local GARRISON_FOLLOWER_DISBANDED=GARRISON_FOLLOWER_DISBANDED
local BONUS_LOOT_LABEL=C(" (".. BONUS_LOOT_LABEL .. ")","Green")
local GetItemInfo,GetItemIcon=GetItemInfo,GetItemIcon
local m={} --#Widget
function m:Show()
  self.frame:Show()
end
function m:Hide()
  self.frame:Hide()
  self:Release()
end
function m:LoadMission(missionID)
  local parties=addon:GetMissionParties(missionID)
  if not parties then addon:Print("Non trovo la missione",missionID) return end
  local obj=self.scroll
  local b=AceGUI:Create("BFAMiniMissionButton")
  b:SetMission("Prova titolo","Prova reason")
  --b:SetScale(0.7)
  --b:SetFullWidth(true)
  --self.missions[mission.missionID]=b
  obj:AddChild(b)

end
function m._Constructor()
  local widget=AceGUI:Create("Window")
  widget.type=Type
  widget:SetLayout("Fill")
  widget.missions={}
  local scroll = AceGUI:Create("ScrollFrame")
  scroll:SetLayout("List") -- probably?
  scroll:SetFullWidth(true)
  scroll:SetFullHeight(true)
  widget:AddChild(scroll)
  for k,v in pairs(m) do widget[k]=v end
  widget._Constructor=nil
  widget:Show()
  widget.scroll=scroll
  widget.type=Type
  return widget
end
AceGUI:RegisterWidgetType(Type,m._Constructor,Version)