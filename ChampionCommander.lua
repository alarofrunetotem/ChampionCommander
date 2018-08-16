local __FILE__=tostring(debugstack(1,2,0):match("(.*):1:")) -- Always check line number in regexp and file, must be 1
--@debug@
print('Loaded',__FILE__)
--@end-debug@
local function pp(...) print(GetTime(),"|cff009900",__FILE__:sub(-15),strjoin(",",tostringall(...)),"|r") end
--*TYPE addon
--*CONFIG noswitch=false,profile=true,enhancedProfile=true
--*MIXINS "AceHook-3.0","AceEvent-3.0","AceTimer-3.0"
--*MINOR 41
-- Auto Generated
local me,ns=...
ns.die=true
local LibInit,minor=LibStub("LibInit",true)
assert(LibInit,me .. ": Missing LibInit, please reinstall")
local requiredVersion=41
assert(minor>=requiredVersion,me ..': Need at least Libinit version ' .. requiredVersion)
ns.die=false
local addon=LibInit:NewAddon(ns,me,{noswitch=false,profile=true,enhancedProfile=true},"AceHook-3.0","AceEvent-3.0","AceTimer-3.0") --#Addon
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
local dprint=print
local ddump
--@debug@
LoadAddOn("Blizzard_DebugTools")
ddump=DevTools_Dump
LoadAddOn("LibDebug")
-- Addon Build, we need to create globals the easy way
local function encapsulate()
if LibDebug then LibDebug() dprint=print end
end
encapsulate()
local pcall=pcall
local function parse(default,rc,...)
	if rc then return default else return ... end
end
addon.safeG=setmetatable({},{
	__index=function(table,key)
		rawset(table,key,
			function(default,...)
				return parse(default,pcall(G[key],...))
			end
		)
		return table[key]
	end
})

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

-- Dependency check

if not LibStub("AceSerializer-3.0",true) then
   ns.die=true
end
if ns.die then
  addon:Popup(L["You need to close and restart World of Warcraft in order to update this version of ChampionCommander.\nSimply reloading UI is not enough"])
  ns.die=true
  return
end
local MISSING=ITEM_MISSING:format(""):gsub(' ','')
local IGNORED=IGNORED
local UNUSED=UNUSED
MISSING=C(MISSING:sub(1,1):upper() .. MISSING:sub(2),"Red")
local ctr=0
-- Sometimes matchmakimng starts before these are defined, so I put here a sensible default (actually, this values are constans)
function addon:MAXLEVEL()
	return OHF.followerMaxLevel or 110
end
function addon:MAXQUALITY()
	return OHF.followerMaxQuality or 6
end
function addon:MAXQLEVEL()
	return addon:MAXLEVEL()+addon:MAXQUALITY()
end
function addon.colors(c1,c2)
	return C[c1].r,C[c1].g,C[c1].b,C[c2].r,C[c2].g,C[c2].b
end
function addon:ColorFromBias(followerBias)
		if ( followerBias == -1 ) then
			--return 1, 0.1, 0.1
			return C:Red()
		elseif ( followerBias < 0 ) then
			--return 1, 0.5, 0.25
			return C:Orange()
		else
			--return 1, 1, 1
			return C:Green()
		end
end
-- todefault with default
function addon:todefault(value,default)
	if value~=value then return default
	elseif value==math.huge then return default
	else return tonumber(value) or default
	end
end

function addon:SetDbDefaults(default)
	default.profile=default.profile or {}
	default.profile.blacklist={}
	default.global.tutorialStep=1
end
do
local banned={}
local byFollowers={}
local byMissions=setmetatable({},{__index=function(t,k) rawset(t,k,{}) return rawget(t,k) end})
local function refreshByMissions(missionID)
	wipe(byMissions[missionID])
	for f,m in pairs(byFollowers) do
		if m==missionID then
			tinsert(byMissions[missionID],f)
		end
	end
end
function addon:GetReservedFollowers(missionID)
	if not missionID then return byMissions end
	return byMissions[missionID]
end
function addon:HasReservedFollowers(missionID)
	return #byMissions[missionID] > 0
end
function addon:UnReserveMission(missionID)
	wipe(byMissions[missionID])
	for followerID,mid in pairs(byFollowers) do
		if mid==missionID then
			byFollowers[followerID]=nil
		end
	end
end
function addon:UnReserve(followerID)
	if not followerID then
		wipe(byFollowers)
		wipe(byMissions)
	else
		local missionID=byFollowers[followerID]
		byFollowers[followerID]=nil
		if missionID then
			refreshByMissions(missionID)
		end
	end
end
function addon:Reserve(followerID,missionID)
	byFollowers[followerID]=missionID
	refreshByMissions(missionID)
end
function addon:IsUsable(missionID,followerID)
	local ID=self:IsReserved(followerID)
	return not ID or ID == missionID
end
function addon:IsReserved(followerID)
	if not followerID then return byFollowers end
	return byFollowers[followerID]
end
function addon:Ban(slot,missionID)
	banned[slot..':'..missionID]=true
end
function addon:Unban(slot,missionID)
	if not slot then
		wipe(banned)
	else
		banned[slot..':'..missionID]=nil
	end
end
function addon:IsBanned(slot,missionID)
	if not slot then return banned end
	if not missionID then return false end
	return banned[slot..':'.. missionID]
end
end -- DO closed
local colors=addon.colors
_G.ChampionCommanderMixin={}
_G.ChampionCommanderMixinThreats={}
_G.ChampionCommanderMixinFollowerIcon={}
_G.ChampionCommanderMixinMenu={}
_G.ChampionCommanderMixinMembers={}
_G.ChampionCommanderMixinTooltip={}

local Mixin=ChampionCommanderMixin --#Mixin
local MixinThreats=ChampionCommanderMixinThreats --#MixinThreats
local MixinMenu=ChampionCommanderMixinMenu --#MixinMenu
local MixinFollowerIcon= ChampionCommanderMixinFollowerIcon --#MixinFollowerIcon
local MixinMembers=ChampionCommanderMixinMembers --#MixinMembers
local MixinTooltip=ChampionCommanderMixinTooltip --#MixinTooltip

function Mixin:CounterTooltip()
	local tip=self:AnchorTT()
	tip:AddLine(self.Ability)
	tip:AddLine(self.Description)
	tip:Show()

end
function Mixin:DebugOnLoad()
	self:RegisterForDrag("LeftButton")
end
function Mixin:Bump(tipo,value)
	value = value or 1
	local riga=tipo..'Refresh'
	self[tipo]=self[tipo]+value
	self[riga]:SetFormattedText("%s: %d",tipo,self[tipo])
end
function Mixin:Set(tipo,value)
	value = value or 0
	local riga=tipo..'Refresh'
	self[tipo]=value
	self[riga]:SetFormattedText("%s: %d",tipo,self[tipo])
end
function Mixin:DragStart()
	self:StartMoving()
end
function Mixin:DragStop()
	self:StopMovingOrSizing()
end
function Mixin:AnchorTT(anchor)
	anchor=anchor or "ANCHOR_TOPRIGHT"
	GameTooltip:SetOwner(self,anchor)
	return GameTooltip
end
function Mixin:ShowTT()
	if not self.tooltip then return end
	local tip=Mixin.AnchorTT(self)
	tip:SetText(self.tooltip)
	tip:Show()
end
function Mixin:HideTT()
	GameTooltip:Hide()
end
function Mixin:Dump(data)
	local	tip=self:AnchorTT("ANCHOR_CURSOR")
	if type(data)~="table" then
		data=self
	end
	tip:AddLine(data:GetName(),C:Green())
	self.DumpData(tip,data)
	tip:Show()
end
function Mixin.DumpData(tip,data)
  if type(data)== "table" then
  	for k,v in kpairs(data) do
  		local color="Silver"
  		if type(v)=="number" then color="Cyan"
  		elseif type(v)=="string" then color="Yellow" v=v:sub(1,30)
  		elseif type(v)=="boolean" then v=v and 'True' or 'False' color="White"
  		elseif type(v)=="table" then color="Green" if v.GetObjectType then v=v:GetObjectType() else v=tostring(v) end
  		else v=type(v) color="Blue"
  		end
  		if k=="description" then v =v:sub(1,10) end
  		tip:AddDoubleLine(k,v,colors("Orange",color))
  	end
	else
      tip:AddDoubleLine(tostring(data),type(data))
	end

end
function MixinThreats:OnLoad()
	if not self.threatPool then self.threatPool=CreateFramePool("Frame",UIParent,"BFAThreatsCounters") end
	self.usedPool={}
end
function MixinThreats:AddIcons(mechanics,biases)
	local frame=self:GetParent()
	for i=1,#self.usedPool do
		self.threatPool:Release(self.usedPool[i])
	end
	wipe(self.usedPool)
	local previous
	for index,mechanic in pairs(mechanics) do
		local th=self.threatPool:Acquire()
		tinsert(self.usedPool,th)
		if mechanic and (mechanic.icon or mechanic.id) then
			th.Icon:SetTexture(mechanic.icon)
			th.Name=mechanic.name
			th.Description=mechanic.description
			th.Ability=mechanic.ability and mechanic.ability.name or mechanic.name
			if mechanic.color then
				th.Border:SetVertexColor(C[mechanic.color]())
			else
				th.Border:SetVertexColor(addon:ColorFromBias(biases[mechanic] or mechanic.bias))
			end
			th:Show()
		else
			th:Hide()
		end
		th:SetParent(self)
		th:SetFrameStrata(self:GetFrameStrata())
		th:SetFrameLevel(self:GetFrameLevel()+1)
		th:ClearAllPoints()
		if not previous then
			th:SetPoint("BOTTOMLEFT",0,0)
			previous=th
		else
			th:SetPoint("BOTTOMLEFT",previous,"BOTTOMRIGHT",5,0)
			previous=th
		end
	end
	return previous
end

function MixinFollowerIcon:GetFollower()
	return self.followerID
end
function MixinFollowerIcon:SetFollower(followerID,checkStatus,blacklisted)
	local info=addon:GetFollowerData(followerID)
	local mission=self:GetParent():GetParent().info
	local missionID=mission and mission.missionID
	if not info or not info.followerID then
		local rc
		rc,info=pcall(G.GetFollowerInfo,followerID)
		if not rc or not info then
			self.locked=false
			return self:SetEmpty(LFG_LIST_APP_TIMED_OUT)
		end
	end
	self.IsTroop=info.IsTroop
	self.followerID=followerID
	self:SetupPortrait(info)
	local status=(followerID and checkStatus) and G.GetFollowerStatus(followerID) or nil
	if info.isTroop then
		self:SetILevel(0)
		self.Level:SetText("") --FOLLOWERLIST_LABEL_TROOPS)
		self.Durability:SetDurability(info.durability, info.maxDurability)
		self.Durability:Show()
	else
		self.Durability:Hide()
		if info.isMaxLevel then
			self:SetILevel(info.iLevel)
		else
			self:SetLevel(info.level)
		end
	end
	self.locked=addon:IsReserved(followerID) and true or false
	self.banned=addon:IsBanned(self.Slot,missionID) and true or false
	if status or blacklisted then
		if not blacklisted then
			self:SetILevel(0) --CHAT_FLAG_DND
			self:GetParent():SetNotReady(true)
			self.Level:SetText(status);
		end
		self.Durability:Hide()
		self.Portrait:SetDesaturated(true)
		self:SetQuality(1)
	else
		self.Portrait:SetDesaturated(false)
	end
	self:ShowLocks()
	return self,status
end
function MixinFollowerIcon:ShowLocks()
	if self.locked then
		self.LockIcon:Show()
	else
		self.LockIcon:Hide()
	end
	if self.banned then
		self.IgnoreIcon:Show()
	else
		self.IgnoreIcon:Hide()
	end
end
function MixinFollowerIcon:SmartHide()
  if self.followerID then
    self:Show()
  else
    self:Hide()
  end
end
function MixinFollowerIcon:SetEmpty(message)
	local mission=self:GetParent():GetParent().info
	self.followerID=false
	self:SetLevel(message or MISSING)
	self:SetPortraitIcon()
	self:SetQuality(1)
	self.locked=false
	self.Durability:Hide()
	self.banned=addon:IsBanned(self.Slot,mission and mission.missionID or 0)
	if message ~=UNUSED then
		self:GetParent():SetNotReady(true)
	end
	self:ShowLocks()
	return self
end
local gft -- =GarrisonFollowerTooltip
function MixinFollowerIcon:ShowTooltip()
	local mission=self:GetParent():GetParent().info
	if not mission then return end
	local missionID=mission.missionID
	gft = mission.inProgress and GarrisonFollowerTooltip or BFAFollowerTip
	if not self.followerID then
--@debug@
		return self:Dump()
--@end-debug@
--[===[@non-debug@
		return
--@end-non-debug@]===]
	end
	local link = C_Garrison.GetFollowerLink(self.followerID);
  local garrisonFollowerID=select(2,strsplit(":", link))
	if link then
	 local data=GarrisonFollowerTooltipTemplate_BuildDefaultDataForID(garrisonFollowerID)
	  data.levelxp=G.GetFollowerLevelXP(self.followerID)
		data.xp=G.GetFollowerXP(self.followerID)
		GarrisonFollowerTooltipTemplate_SetGarrisonFollower(gft,data)
		gft:ClearAllPoints()
		gft:SetPoint("BOTTOM", self, "TOP")
		if gft==GarrisonFollowerTooltip then return end
		if OHFMissions.showInProgress then return end
		local ypos=gft:GetHeight()
		gft.Lines[1]:ClearAllPoints()
		gft.Lines[1]:SetPoint("TOPLEFT",gft,"TOPLEFT",5,-ypos)

		if self.locked then
			self.AddLine(gft,KEY_BUTTON1 .. ' : ' .. C(L['Unlock this follower'],"Red"))
		else
			self.AddLine(gft,KEY_BUTTON1 .. ' : ' .. C(L['Lock this follower'],"Green"))
		end
		if self.banned then
			self.AddLine(gft,KEY_BUTTON2 .. ' : ' .. C(L['Use this slot'],"Green"))
		elseif self:IsBannable() then
			self.AddLine(gft,KEY_BUTTON2 .. ' : ' .. C(L['Dont use this slot'],"Red"))
		end
		self.AddLine(gft,SHIFT_KEY_TEXT .. "  " .. KEY_BUTTON1 .. ' : ' .. L['Lock all'])
		self.AddLine(gft,SHIFT_KEY_TEXT .. "  " .. KEY_BUTTON2 .. ' : ' .. L['Unlock all'])
		self.AddLine(gft,C(L["Locked follower are only used in this mission"],"CYAN"))
--@debug@
		self.AddLine(gft,tostring(self.followerID))
		self.AddLine(gft,tostring(addon:GetFollowerData(self.followerID,'classSpec')))
--@end-debug@
		if not gft.Status then
			gft.Status=gft:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
			gft.Status:SetPoint("BOTTOM",0,5)
		end
		local status=G.GetFollowerStatus(self.followerID)
		if status then
			gft.Status:SetText(TOKEN_MARKET_PRICE_NOT_AVAILABLE.. ': ' .. status)
			gft.Status:SetTextColor(C:Orange())
			gft.Status:Show()
			gft:SetHeight(gft:GetHeight()+10)
		else
			gft.Status:Hide()
		end
		self.AdjustSize(gft)
	end
end
function MixinFollowerIcon:AdjustSize()
	for i=self.current+1,#gft.Lines do
		self.Lines[i]:Hide()
	end
	self:SetHeight(self:GetHeight()+ (5 +self.Lines[1]:GetStringHeight()) * self.current)
	self:SetWidth(self.maxWidth+5)
	self.current=0
	self:Show()

end
function MixinFollowerIcon:AddLine(message)
	self.current = (self.current or 0) +1
	local i=self.current
	if not self.Lines[i] then
		self.Lines[i]=self:CreateFontString(nil, "OVERLAY","GameFontNormal")
	end
	local line=self.Lines[i]
	if i > 1 then
		line:SetPoint("TOPLEFT",self.Lines[i-1],"BOTTOMLEFT",0,-5)
	else
		self.maxWidth=0
	end
	line:SetText(message)
	line:Show()
	self.maxWidth=math.max( line:GetStringWidth(),self.maxWidth)

end
function MixinFollowerIcon:Click(button)
	local mission=self:GetParent():GetParent().info
	if mission.InProgress then return end
	local missionID=mission.missionID
	if IsShiftKeyDown() then
		local lockIt=button=="LeftButton"
		for _,champion in	pairs(self:GetParent().Champions) do
			if champion.followerID then
				champion.locked=lockIt
				if lockIt then
					addon:Reserve(champion.followerID,missionID)
				else
					addon:UnReserve(champion.followerID)
				end
			end
		end
	elseif self.followerID then
		if button == "LeftButton" then
			if self.banned then return end
			-- we cant lock a busy follower or to a blacklisted mission
			if addon:IsReserved(self.followerID) then
				self:Unlock()
			elseif not G.GetFollowerStatus(self.followerID) and not addon.db.profile.blacklist[missionID] then
				self:Lock(missionID)
			end
		end
	end
	if button == "RightButton" then
		if self.locked then return end
		if addon:IsBanned(self.Slot,missionID) then
			self:Unban(missionID)
		elseif self:IsBannable() then
			self:Ban(missionID)
		end
	end
	self:ShowTooltip()
  addon:PushRefresher("CleanMissionsCache")
	addon:RedrawMissions()
end
function MixinFollowerIcon:Lock(missionID)
	addon:Reserve(self.followerID,missionID)
	self.locked=true
	self:ShowLocks()
end
function MixinFollowerIcon:Unlock()
	addon:UnReserve(self.followerID)
	self.locked=nil
	self:ShowLocks()
end
function MixinFollowerIcon:Ban(missionID)
	addon:Ban(self.Slot,missionID)
	self.banned=true
	self:ShowLocks()
end
function MixinFollowerIcon:IsBannable()
	if not self.followerID then return false end
	if self.Slot==3 then return true end
	if self.Slot==1 then return false end
	local slot3=self:GetParent().Champions[3]
	return not slot3.followerID or slot3.banned or slot3.locked
end
function MixinFollowerIcon:Unban(missionID)
	addon:Unban(self.Slot,missionID)
	self.banned=nil
	self:ShowLocks()
end
function MixinFollowerIcon:HideTooltip()
	if gft then gft:Hide() end
end
function MixinMembers:Followers()
	return
		function(t,index)
			if not index then index =0 end
			index=index+1
			return index,t[index].followerID
		end,
		self.Champions,
		nil
end
function MixinMembers:OnLoad()
	for i=1,3 do
		if self.Champions[i] then
			self.Champions[1]:SetPoint("RIGHT")
		else
			self.Champions[i]=CreateFrame("Frame",nil,self,"BFAFollowerIcon")
			self.Champions[i]:SetPoint("RIGHT",self.Champions[i-1],"LEFT",-15,0)
		end
		self.Champions[i]:SetFrameLevel(self:GetFrameLevel()+1)
		self.Champions[i]:Show()
		self.Champions[i]:SetEmpty()
		self.Champions[i].Slot=i
	end
	self:SetWidth(self.Champions[1]:GetWidth()*3+30)
	self.NotReady.Text:SetFormattedText(RAID_MEMBER_NOT_READY,STATUS_TEXT_PARTY)
	self.NotReady.Text:SetTextColor(C.Red())
end
function MixinMembers:OnShow()
	self:SetNotReady()
end
function MixinMembers:SetNotReady(show)
	if show then
		self.NotReady:Show()
	else
		self.NotReady:Hide()
	end
end
function MixinMembers:IsReady()
	return not self.NotReady:IsShown()
end
function MixinMembers:Lock()
	for i=1,3 do
		if addon:IsReserved(self.Champions[i].followerID or "") then
			self.Champions[i].LockIcon:Show()
		else
			self.Champions[i].LockIcon:Hide()
		end
	end
end
function MixinMenu:OnLoad()
	self.Close:SetScript("OnClick",function() MixinMenu.OnClick(self) end)
end
function MixinTooltip:OnEnter()
    if type(self.tooltip)=="function" then
      return self:tooltip()
    elseif self.tooltip then
      GameTooltip:SetOwner(self,"ANCHOR_TOPLEFT")
      if type(self.tooltip)=="string" then
        GameTooltip:AddLine(self.tooltip)
      elseif type(self.tooltip)=="table" then
        for left,right in pairs(self.tooltip) do
          if type(left)=="number" then
            GameTooltip:AddLine(right)
          else
            GameTooltip:AddDoubleLine(left,right)
          end
        end
      end
      GameTooltip:Show()
    end


end
function MixinTooltip:SetTitle(text)
  if self.Title then self.Title:SetText(text) end
end
function MixinTooltip:MakeMovable(button,region)
  self:EnableMouse(true)
  self:SetMovable(true)
  if self.Highlight then self.Highlight:Show() end
  if region and region.RegisterForDrag then
    region:RegisterForDrag(button or "LeftButton")
    region.useParent=true
  else
    self:RegisterForDrag(button or "LeftButton")
  end
end
function MixinTooltip:OnDragStart()
  if self.useParent then self:GetParent():StartMoving() else self:StartMoving() end
end
function MixinTooltip:OnDragStop()
  if self.useParent then self:GetParent():StopMovingOrSizing() else self:StopMovingOrSizing() end
end

