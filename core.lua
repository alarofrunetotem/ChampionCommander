local __FILE__=tostring(debugstack(1,2,0):match("(.*):1:")) -- Always check line number in regexp and file, must be 1
--@debug@
print('Loaded',__FILE__)
--@end-debug@
local function pp(...) print(GetTime(),"|cff009900",__FILE__:sub(-15),strjoin(",",tostringall(...)),"|r") end
--*TYPE module
--*CONFIG noswitch=false,profile=true,enhancedProfile=true
--*MIXINS "AceHook-3.0","AceEvent-3.0","AceTimer-3.0"
--*MINOR 35
-- Auto Generated
local me,ns=...
if ns.die then return end
local addon=ns --#Addon (to keep eclipse happy)
ns=nil
local module=addon:NewSubModule('Core',"AceHook-3.0","AceEvent-3.0","AceTimer-3.0")  --#Module
function addon:GetCoreModule() return module end
-- Template
local G=C_Garrison
local _
local AceGUI=LibStub("AceGUI-3.0")
local C=addon:GetColorTable()
local L=addon:GetLocale()
local new=addon:Wrap("NewTable")
local del=addon:Wrap("DelTable")
local kpairs=addon:Wrap("Kpairs")
local empty=addon:Wrap("Empty")

local todefault=addon:Wrap("todefault")

local tonumber=tonumber
local type=type
local OHF=BFAMissionFrame
local OHFMissionTab=BFAMissionFrame.MissionTab --Container for mission list and single mission
local OHFMissions=BFAMissionFrame.MissionTab.MissionList -- same as BFAMissionFrameMissions Call Update on this to refresh Mission Listing
local OHFFollowerTab=BFAMissionFrame.FollowerTab -- Contains model view
local OHFFollowerList=BFAMissionFrame.FollowerList -- Contains follower list (visible in both follower and mission mode)
local OHFFollowers=BFAMissionFrameFollowers -- Contains scroll list
local OHFMissionPage=BFAMissionFrame.MissionTab.MissionPage -- Contains mission description and party setup
local OHFMapTab=BFAMissionFrame.MapTab -- Contains quest map
local OHFMissionFrameMissions=BFAMissionFrameMissions
local OHFCompleteDialog=BFAMissionFrameMissions.CompleteDialog
local OHFMissionScroll=BFAMissionFrameMissionsListScrollFrame
local OHFMissionScrollChild=BFAMissionFrameMissionsListScrollFrameScrollChild
local OHFTOPLEFT=OHF.GarrCorners.TopLeftGarrCorner
local OHFTOPRIGHT=OHF.GarrCorners.TopRightGarrCorner
local OHFBOTTOMLEFT=OHF.GarrCorners.BottomTopLeftGarrCorner
local OHFBOTTOMRIGHT=OHF.GarrCorners.BottomRightGarrCorner
local followerType=LE_FOLLOWER_TYPE_GARRISON_8_0
local garrisonType=LE_GARRISON_TYPE_8_0
local FAKE_FOLLOWERID="0x0000000000000000"
local MAX_LEVEL=110

local ShowTT=ChampionCommanderMixin.ShowTT
local HideTT=ChampionCommanderMixin.HideTT

local dprint=print
local ddump
--@debug@
LoadAddOn("Blizzard_DebugTools")
ddump=DevTools_Dump
LoadAddOn("LibDebug")

if LibDebug then LibDebug() dprint=print end
local safeG=addon.safeG

--@end-debug@
--[===[@non-debug@
dprint=function() end
ddump=function() end
local print=function() end
--@end-non-debug@]===]
local LE_FOLLOWER_TYPE_GARRISON_8_0=LE_FOLLOWER_TYPE_GARRISON_8_0
local LE_GARRISON_TYPE_8_0=LE_GARRISON_TYPE_8_0
local GARRISON_FOLLOWER_COMBAT_ALLY=GARRISON_FOLLOWER_COMBAT_ALLY
local GARRISON_FOLLOWER_ON_MISSION=GARRISON_FOLLOWER_ON_MISSION
local GARRISON_FOLLOWER_INACTIVE=GARRISON_FOLLOWER_INACTIVE
local GARRISON_FOLLOWER_IN_PARTY=GARRISON_FOLLOWER_IN_PARTY
local GARRISON_FOLLOWER_AVAILABLE=AVAILABLE
local ViragDevTool_AddData=_G.ViragDevTool_AddData
if not ViragDevTool_AddData then ViragDevTool_AddData=function() end end
local KEY_BUTTON1 = "\124TInterface\\TutorialFrame\\UI-Tutorial-Frame:12:12:0:0:512:512:10:65:228:283\124t" -- left mouse button
local KEY_BUTTON2 = "\124TInterface\\TutorialFrame\\UI-Tutorial-Frame:12:12:0:0:512:512:10:65:330:385\124t" -- right mouse button
local CTRL_KEY_TEXT,SHIFT_KEY_TEXT=CTRL_KEY_TEXT,SHIFT_KEY_TEXT
local CTRL_KEY_TEXT,SHIFT_KEY_TEXT=CTRL_KEY_TEXT,SHIFT_KEY_TEXT
local CTRL_SHIFT_KEY_TEXT=CTRL_KEY_TEXT .. '-' ..SHIFT_KEY_TEXT
local format,pcall=format,pcall
local function safeformat(mask,...)
  local rc,result=pcall(format,mask,...)
  if not rc then
    for k,v in pairs(L) do
      if v==mask then
        mask=k
        break
      end
    end
 end
  rc,result=pcall(format,mask,...)
  return rc and result or mask
end

-- End Template - DO NOT MODIFY ANYTHING BEFORE THIS LINE
--*BEGIN

--local missionPanelMissionList=OrderHallMissionFrameMissions
--[[
Su OrderHallMissionFrameMissions viene chiamato Update() per aggiornare le missioni
.listScroll = padre della scrolllist delle missioni
<code>
	local scrollFrame = self.listScroll;
	local offset = HybridScrollFrame_GetOffset(scrollFrame);
</code>
--]]
--[[
BFA- OrderHallMissionFrame.FollowerTab.DurabilityFrame : OnShow :  table: 0000000033557BD0
BFA- OrderHallMissionFrame.FollowerTab.QualityFrame : OnShow :  table: 0000000033557C20
BFA- OrderHallMissionFrame.FollowerTab.PortraitFrame : OnShow :  table: 0000000033557D60
BFA- OrderHallMissionFrame.FollowerTab.ModelCluster : OnShow :  table: 0000000033557F40
BFA- OrderHallMissionFrame.FollowerTab.XPBar : OnShow :  table: 00000000335585D0
--]]
-- Upvalued functions
local GetItemInfo=GetItemInfo
--if I then GetItemInfo=I:GetCachingGetItemInfo() end
local GetCurrencyInfo=GetCurrencyInfo
local tostring=tostring
local tostringall=tostringall
local strjoin=strjoin
local select,CreateFrame,pairs,type,todefault,math=select,CreateFrame,pairs,type,todefault,math
local QuestDifficultyColors,GameTooltip=QuestDifficultyColors,GameTooltip
local tinsert,tremove,tContains=tinsert,tremove,tContains
local format=format
local resolve=addon.resolve
local colors=addon.colors
local menu
local menuType="BFAMenu"
local menuOptions={mission={},follower={}}
local _G=_G
function addon:ApplyMOVEPANEL(value)
	OHF:EnableMouse(value)
	OHF:SetMovable(value)
end

function addon:OnInitialized()
  _G.dbBFAperChar=_G.dbBFAperChar or {}
  if type(self.db.global.tutorialStep)~="number" then
    self.db.global.tutorialStep=1
  end
	menu=CreateFrame("Frame")
--@debug@
--[[
	local f=menu
	f:RegisterAllEvents()
	self:RawHookScript(f,"OnEvent","ShowGarrisonEvents")
]]--
--@end-debug@
	self:AddLabel(L["General"])
	self:AddBoolean("MOVEPANEL",true,L["Make Order Hall Mission Panel movable"],L["Position is not saved on logout"])
	self:AddBoolean("TROOPALERT",true,L["Troop ready alert"],L["Notifies you when you have troops ready to be collected"])
  self:AddBoolean("QUICKSTART",nil,L["Unsafe mission start"],safeformat(L["Only need %s instead of %s to start a mission from mission list"],SHIFT_KEY_TEXT,CTRL_SHIFT_KEY_TEXT))
	self:loadHelp()
	OHF:RegisterForDrag("LeftButton")
	OHF:SetScript("OnDragStart",function(frame) if self:GetBoolean('MOVEPANEL') then frame:StartMoving() end end)
	OHF:SetScript("OnDragStop",function(frame) frame:StopMovingOrSizing() end)
	self:ApplyMOVEPANEL(self:GetBoolean('MOVEPANEL'))
end
function addon:IsBlacklisted(missionID)
	return self.db.profile.blacklist[missionID]
end
function addon:ClearMenu()
	if menu.widget then
		pcall(AceGUI.Release,AceGUI,menu.widget)
		menu.widget=nil
	end
	menu:Hide()
end
function addon:RegisterForMenu(menu,...)
	for i=1,select('#',...) do
		local value=(select(i,...))
		if type(value)=="table" then
			if type(value.arg)=="string" then
				value=value.arg
			elseif type(value['function'])=="string" then
				value=value['function']
			else
				value=false
			end
		end
		if value and not tContains(menuOptions[menu],value) then
			tinsert(menuOptions[menu],value)
		end
	end
end
function addon:GetRegisteredForMenu(menu)
	return menuOptions[menu]
end
do

end

function addon:ActivateButton(button,OnClick,Tooltiptext,persistent)
	button:SetScript("OnClick",function(...) self[OnClick](self,...) end )
	if (Tooltiptext) then
		button.tooltip=Tooltiptext
		button:SetScript("OnEnter",ShowTT)
			button:SetScript("OnLeave",HideTT)
	else
		button:SetScript("OnEnter",nil)
		button:SetScript("OnLeave",nil)
	end
end
--- Helpers
--
function addon:SetBackdrop(frame,r,g,b,a)
	r=r or 1
	g=g or 0
	b=b or 0
	a=a or 1
   frame:SetBackdrop({
         bgFile = "Interface/Tooltips/UI-Tooltip-Background",
         xedgeFile = "Interface/Tooltips/UI-Tooltip-Border",
         tile = true, tileSize = 16, edgeSize = 16,
         insets = { left = 4, right = 4, top = 4, bottom =   4}
      }
   )
   frame:SetBackdropColor(r,g,b,a)
end
function addon:GetDifficultyColors(...)
	local q=self:GetDifficultyColor(...)
	return q.r,q.g,q.b
end
function addon:GetDifficultyColor(perc,usePurple)
	if perc>=100 then
		return C.Green
	elseif(perc >90) then
		return QuestDifficultyColors['standard']
	elseif (perc >74) then
		return QuestDifficultyColors['difficult']
	elseif(perc>49) then
		return QuestDifficultyColors['verydifficult']
	elseif(perc >20) then
		return QuestDifficultyColors['impossible']
	else
		return not usePurple and C.Silver or C.Epic
	end
end
function addon:GetAgeColor(age)
		age=todefault(age,0)
		if age>GetTime() then age=age-GetTime() end
		if age < 0 then age=0 end
		local hours=floor(age/3600)
		local q=self:GetDifficultyColor(hours+20,true)
		return q.r,q.g,q.b
end
local function tContains(table, item)
	local index = 1;
	while table[index] do
		if ( item == table[index] ) then
			return index;
		end
		index = index + 1;
	end
	return nil;
end
local newsframes={}
function addon:MarkAsNew(obj,key,message,method)
	local db=self.db.global
	if not db.news then db.news={} end
--@debug@
	db.news[key]=true
--@end-debug@
	if (not db.news[key]) then
		local f=CreateFrame("Button",nil,obj,"BFAWhatsNew")
		f.tooltip=message
		f.texture:ClearAllPoints()
		f.texture:SetAllPoints()
    f:GetHighlightTexture():ClearAllPoints()
    f:GetHighlightTexture():SetAllPoints()
		f:SetPoint("TOPLEFT",obj,"TOPLEFT",0,0)
		f:SetFrameStrata("TOOLTIP")
		f:Show()
		if method then
			f:SetScript("OnClick",function(frame) self[method](self,frame) self:MarkAsSeen(key) end)
		else
			f:SetScript("OnClick",function(frame) self:MarkAsSeen(key) end)
		end
		newsframes[key]=f
		return true
	end
end
function addon:MarkAsSeen(key)
	local db=self.db.global
	if not db.news then db.news={} end
	db.news[key]=true
	if newsframes[key] then newsframes[key]:Hide() end
end

--@do-not-package@

local gamu=GetAddOnMemoryUsage
local uamu=UpdateAddOnMemoryUsage
local redpattern="c|FFFF0000%dM|r"
local greenpattern="%dM"
local function wrap(obj,func)
	addon:Print("Hook func",func)
	local old=obj[func]
	obj[func] = function(...)
		local r1,r2,r3,r4,r5,r6,r7,r8,r9=old(...)
		local m2=gamu(me)
		addon:Print("Called",func,format(greenpattern,m2/1024))
		return r1,r2,r3,r4,r5,r6,r7,r8,r9
	end
end
local profile={}
local min=5
function addon:LoadProfileData(obj,objname)
	for name,func in pairs(obj) do
		if type(func)=="function" then
			local total,times=GetFunctionCPUUsage(func,true)
			if times >= min then
				local average=total/(times>0 and times or 1)
				profile[format("%06d.%s:%s",999999-average*1000,objname,name)]={total=total,times=times,average=average}
			end
		end
	end
end
function addon:ProfileStats(newmin)
	if newmin then min = newmin end
	wipe(profile)
	local profiling=GetCVarBool("scriptProfile")
	if not profiling then
		SetCVar("scriptProfile",true)
		ReloadUI()
	end
	for name,module in self:IterateModules() do
		self:LoadProfileData(module,name)
		if module.ProfileStats then
			module:ProfileStats()
		end
	end
	self:LoadProfileData(self,"MAIN")
	if ViragDevTool_AddData then
		ViragDevTool_AddData(profile,"BFA_PROFILE")
	end
end
function addon:Resolve(frame)
	local name
	if type(frame)=="table" and frame.GetName then
		name=frame:GetName()
		if not name then
			local parent=frame:GetParent()
			if not parent then return "UIParent" end
			for k,v in pairs(parent) do
				if v==frame then
					name=self:Resolve(parent) .. '.'..k
					return name
				end
			end
			return tostring(frame)
		else
			return name
		end
	end
	return "unk"
end
local events=CreateFrame("Frame")
addon.evt=setmetatable({},{__index=function(t,v) return 0 end})
addon.evtCount=setmetatable({},{__index=function(t,v) return 0 end})
events:RegisterAllEvents()
events:SetScript("OnEvent",
	function(this,event,...)
		if event:find("GARRISON") then
			addon.evtCount[event]=addon.evtCount[event] +1
			local signature=strjoin(' , ',event,tostringall(...))
			addon.evt[signature]=addon.evt[signature] +1
		end
	end
)

function addon:GetScroller(title,type,h,w)
	h=h or 800
	w=w or 400
	type=type or "Frame"
	local scrollerWindow=AceGUI:Create("Frame")
	--scrollerWindow.frame:SetAlpha(1)
	scrollerWindow:SetTitle(title)
	scrollerWindow:SetLayout("Fill")
	--local scrollcontainer = AceGUI:Create("SimpleGroup") -- "InlineGroup" is also good
	--scrollcontainer:SetFullWidth(true)
	--scrollcontainer:SetFullHeight(true) -- probably?
	--scrollcontainer:SetLayout("Fill") -- important!
	--scrollerWindow:AddChild(scrollcontainer)
	local scroll = AceGUI:Create("ScrollFrame")
	scroll:SetLayout("Flow") -- probably?
	scroll:SetFullWidth(true)
	scroll:SetFullHeight(true)
	scrollerWindow:AddChild(scroll)
	scrollerWindow:SetCallback("OnClose","Release")
	scrollerWindow:SetHeight(h)
	scrollerWindow:SetWidth(w)
	scrollerWindow:SetPoint("CENTER")
	scrollerWindow:Show()
	scroll.addRow=scroll.AddRow
	return scroll
end
function addon:cutePrint(scroll,level,k,v)
	if (type(level)=="table") then
		for k,v in kpairs(level,safesort) do
			self:cutePrint(scroll,"",k,v)
		end
		return
	end
	if (type(v)=="table") then
		if (level:len()>6) then return end
		self:AddRow(scroll,level..C(k,"Azure")..":" ..C("Table","Orange") .. " " .. tostring(#v))
		for kk,vv in pairs(v) do
			self:cutePrint(scroll,level .. "  ",kk,vv)
		end
	else
		if (type(v)=="string" and v:sub(1,2)=='0x') then
			v=v.. " " ..tostring(self:GetFollowerData(v,'name'))
		end
		self:AddRow(scroll,level..C(k,"White")..":" ..C(v,"Yellow"))
	end
end
function addon:Dump(title,data)
	if type(data)=="string" then
		data=_G[data]
	end
	if type(data) ~= "table" then
		print(data,"is not a table")
		return
	end
	local scroll=self:GetScroller(title)
	print("Dumping",title)
	self:cutePrint(scroll,data)
	return scroll
end
--@end-do-not-package@
if not _G.BFA then
_G.BFA=addon
end
