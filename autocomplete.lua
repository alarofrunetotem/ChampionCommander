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
local module=addon:NewSubModule('Autocomplete',"AceHook-3.0","AceEvent-3.0","AceTimer-3.0")  --#Module
function addon:GetAutocompleteModule() return module end
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
local type=type --as
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
local LE_FOLLOWER_TYPE_GARRISON_6_0=Enum.GarrisonFollowerType.FollowerType_6_0_GarrisonFollower
local LE_FOLLOWER_TYPE_SHIPYARD_6_2=Enum.GarrisonFollowerType.FollowerType_6_0_Boat
local LE_FOLLOWER_TYPE_GARRISON_7_0=Enum.GarrisonFollowerType.FollowerType_7_0_GarrisonFollower
local LE_FOLLOWER_TYPE_GARRISON_8_0=Enum.GarrisonFollowerType.FollowerType_8_0_GarrisonFollower
local LE_GARRISON_TYPE_6_0=Enum.GarrisonType.Type_6_0_Garrison
local LE_GARRISON_TYPE_6_2=Enum.GarrisonType.Type_6_2_Garrison
local LE_GARRISON_TYPE_7_0=Enum.GarrisonType.Type_7_0_Garrison
local LE_GARRISON_TYPE_8_0=Enum.GarrisonType.Type_8_0_Garrison
local followerType=Enum.GarrisonFollowerType.FollowerType_8_0_GarrisonFollower
local garrisonType=Enum.GarrisonType.Type_8_0_Garrison
local FAKE_FOLLOWERID="0x0000000000000000"
local MAX_LEVEL=110

local ShowTT=ChampionCommanderMixin.ShowTT
local HideTT=ChampionCommanderMixin.HideTT

local dprint=print
local ddump
--@debug@
C_AddOns.LoadAddOn("Blizzard_DebugTools")
ddump=DevTools_Dump
C_AddOns.LoadAddOn("LibDebug")

if LibDebug then LibDebug() dprint=print end
local safeG=addon.safeG

--@end-debug@
--[===[@non-debug@
dprint=function() end
ddump=function() end
local print=function() end
--@end-non-debug@]===]
local GARRISON_FOLLOWER_COMBAT_ALLY=GARRISON_FOLLOWER_COMBAT_ALLY
local GARRISON_FOLLOWER_ON_MISSION=GARRISON_FOLLOWER_ON_MISSION
local GARRISON_FOLLOWER_INACTIVE=GARRISON_FOLLOWER_INACTIVE
local GARRISON_FOLLOWER_IN_PARTY=GARRISON_FOLLOWER_IN_PARTY
local GARRISON_FOLLOWER_AVAILABLE=AVAILABLE
---@diagnostic disable-next-line: undefined-field
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
local CompleteButton=OHFMissions.CompleteDialog.BorderFrame.ViewButton
local followerType=LE_FOLLOWER_TYPE_GARRISON_8_0
local pairs=pairs
local format=format
local strsplit=strsplit
local mebefore={level=0,xp=0,xpMax=0}
local meafter={level=0,xp=0,xpMax=0}
---------------------------------------------------------------------------
function module:OnInitialized()
	local ref=OHFMissions.CompleteDialog.BorderFrame.ViewButton
	local bt = CreateFrame('BUTTON',nil, ref, 'UIPanelButtonTemplate')
	bt:SetText(L["ChampionComander Quick Mission Completion"])
	bt:SetWidth(bt:GetTextWidth()+10)
	bt:SetPoint("CENTER",0,-50)
	addon:ActivateButton(bt,"MissionComplete",L["Complete all missions without confirmation"])
	self:RegisterEvent("GARRISON_MISSION_NPC_CLOSED","AutoClose")
end

function module:GenerateMissionCompleteList(title,anchor)
---@diagnostic disable-next-line: param-type-mismatch
	local w=AceGUI:Create("BFAMissionsList")
--@debug@
---@diagnostic disable-next-line: undefined-field
	title=format("%s %s %s",title,w.frame:GetName(),GetTime()*1000)
--@end-debug@
---@diagnostic disable-next-line: undefined-field
	w:SetTitle(title)
	w:SetCallback("OnClose",function(widget) return module:MissionsCleanup() end)
	--report:SetPoint("TOPLEFT",GMFMissions.CompleteDialog.BorderFrame)
	--report:SetPoint("BOTTOMRIGHT",GMFMissions.CompleteDialog.BorderFrame)
	w:ClearAllPoints()
	w:SetPoint("TOP",anchor,0,25)
	w:SetPoint("BOTTOM",anchor,0,-25)
	w:SetPoint("LEFT",anchor,-2,0)
  w:SetPoint("RIGHT",anchor,2,0)
	w:SetWidth(700)
	w:SetParent(anchor)
---@diagnostic disable-next-line: undefined-field
	w.frame:SetFrameStrata("HIGH")
	return w
end
--@debug@
function addon:ShowRewards()
	return module:GenerateMissionCompleteList("Test",UIParent)
end
--@end-debug@
local cappedCurrencies={
	GARRISON_CURRENCY,
	GARRISON_SHIP_OIL_CURRENCY
}

local missions={}
local states={}
local rewards={
	items={},
	followerQLevel=setmetatable({},{__index=function() return 0 end}),
	followerXP=setmetatable({},{__index=function() return 0 end}),
	followerPortrait={},
	followerName={},
	currencies=setmetatable({},{__index=function(t,k) rawset(t,k,{icon="",qt=0}) return t[k] end}),
	bonuses={}
}
local scroller
local report
local timer
local function stopTimer()
	if (timer) then
		module:CancelTimer(timer)
		timer=nil
	end
end
local function startTimer(delay,event,...)
	delay=delay or 0.2
	event=event or "LOOP"
	stopTimer()
	timer=module:ScheduleRepeatingTimer("MissionAutoComplete",delay,event,...)
end
function module:MissionsCleanup()
	local f=OHF
	self:UnregisterAllEvents()
	stopTimer()
	f.MissionTab.MissionList.CompleteDialog:Hide()
	f.MissionComplete:Hide()
	f.MissionCompleteBackground:Hide()
	f.MissionComplete.currentIndex = nil
	f.MissionTab:Show()
	-- Re-enable "view" button
	CompleteButton:SetEnabled(true)
	f:UpdateMissions()
	f:CheckCompleteMissions()
end
--[[
Eventi correlati al completamento missione
GARRISON_MISSION_COMPLETE_RESPONSE,missionID,true,true
GARRISON_FOLLOWER_DURABILITY_CHANGED,4(followertype?),followerID,0
GARRISON_FOLLOWER_XP_CHANGED,4(followertype?)followerID,240,42,104,1
GARRISON_MISSION_BONUS_ROLL_COMPLETE,missionID,true (standard loot)
GARRISON_MISSION_LIST_UPDATE,4(followwertype)
GARRISON_MISSION_BONUS_ROLL_LOOT,139611(itemid) (bonus loot)
--]]
function module:EventsOn()
	self:RegisterEvent("GARRISON_MISSION_BONUS_ROLL_LOOT","MissionAutoComplete")
	self:RegisterEvent("GARRISON_MISSION_BONUS_ROLL_COMPLETE","MissionAutoComplete")
	self:RegisterEvent("GARRISON_MISSION_COMPLETE_RESPONSE","MissionAutoComplete")
	self:RegisterEvent("GARRISON_FOLLOWER_XP_CHANGED","MissionAutoComplete")
	self:RegisterEvent("GARRISON_FOLLOWER_REMOVED","MissionAutoComplete")
	self:RegisterEvent("GARRISON_FOLLOWER_DURABILITY_CHANGED","MissionAutoComplete")
end
function module:AutoClose()
	if report then
	 local rc,message=pcall(report.Close,report)
	 --@debug@
	 if not rc then
	   pp("Failed closing report due to",message)
	 end
	 --@end-debug@
	 report=nil
  end
	pcall(OHF.CloseMissionComplete,OHF)
end
function module:CloseReport()
	addon:ResetParties()
	self:AutoClose()
end
local UnitLevel,UnitXP,UnitXPMax=UnitLevel,UnitXP,UnitXPMax
local function fillMyStatus(tab)
	tab.level,tab.xp,tab.xpMax=UnitLevel("player") or 0,UnitXP('player') or 0,UnitXPMax('player') or 0
end
local function printMyStatus(tab)
	pp(tab.level,tab.xp,tab.xpMax)
end
function module:MissionComplete(this,button,skiprescheck)
	missions=G.GetCompleteMissions(followerType)
	fillMyStatus(mebefore)
	if (missions and #missions > 0) then
		this:SetEnabled(false)
		OHFMissions.CompleteDialog.BorderFrame.ViewButton:SetEnabled(false) -- Disabling standard Blizzard Completion
		for k,v in pairs(rewards) do
			if type(v)=="table" then
				wipe(rewards[k])
			end
		end
		local message=C("WARNING",'red')
		local wasted={}
		--@debug@
---@diagnostic disable-next-line: undefined-field
		if _G.ONEONE then
		  missions={missions[1]}
		end
		--@end-debug@
		for i=1,#missions do
			for _,v in pairs(missions[i].followers) do
				rewards.followerQLevel[v]=addon:GetFollowerData(v,'qLevel',0)
				rewards.followerPortrait[v]=addon:GetFollowerData(v,'portraitIconID')
				rewards.followerName[v]=G.GetFollowerLink(v)
			end
			for k,v in pairs(missions[i].rewards) do
				if v.itemID then GetItemInfo(v.itemID) end -- tickling server
				if v.currencyID and tContains(cappedCurrencies,v.currencyID) then
					wasted[v.currencyID]=(wasted[v.currencyID] or 0) + v.quantity
				end
			end
				for k,v in pairs(missions[i].overmaxRewards) do
					if v.itemID then GetItemInfo(v.itemID) end -- tickling server
					if v.currencyID and tContains(cappedCurrencies,v.currencyID) then
						wasted[v.currencyID]=(wasted[v.currencyID] or 0) + v.quantity
					end
				end
			local m=missions[i]
--totalTimeString, totalTimeSeconds, isMissionTimeImproved, successChance, partyBuffs, isEnvMechanicCountered, xpBonus, materialMultiplier, goldMultiplier = C_Garrison.GetPartyMissionInfo(MISSION_PAGE_FRAME.missionInfo.missionID);
			_,_,m.isMissionTimeImproved,m.successChance,_,_,m.xpBonus,m.resourceMultiplier,m.goldMultiplier=G.GetPartyMissionInfo(m.missionID)
		end
		local stop
		for id,qt in pairs(wasted) do
			local name,current,_,_,_,cap=addon:GetCurrencyInfo(id)
			current=current+qt
			if current+qt > cap then
				message=message.."\n"..format(L["Capped %1$s. Spend at least %2$d of them"],name,current+qt-cap)
				stop =true
			end
		end
		if stop and not skiprescheck then
			self:Popup(message.."\n" ..format(L["If you %s, you will lose them\nClick on %s to abort"],ACCEPT,CANCEL),0,
				function()
					StaticPopup_Hide("LIBINIT_POPUP")
					module:MissionComplete(this,button,true)
				end,
				function()
					StaticPopup_Hide("LIBINIT_POPUP")
					this:SetEnabled(true)
					CompleteButton:SetEnabled(true)
					OHF:Hide()
					addon.quick=false

				end
			)
			return
		end
		report=self:GenerateMissionCompleteList("Missions' results",OHF)
		report:SetUserData('missions',missions)
		report:SetUserData('current',1)
		self:EventsOn()
		self:MissionAutoComplete("INIT")
		this:SetEnabled(true)
	end
end
function module:GetMission(missionID)
	if not report then
		return
	end
	local missions=report:GetUserData('missions')
	if missions then
		for i=1,#missions do
			if missions[i].missionID==missionID then
				return missions[i]
			end
		end
	end
end
--[[
GARRISON_MISSION_COMPLETE_RESPONSE,missionID,canComplete,success,bool(?),table(?)
GARRISON_FOLLOWER_DURABILITY_CHANGED,followerType,followerID,number(Durability left?)
GARRISON_FOLLOWER_XP_CHANGED,followerType,followerID,gainedxp,oldxp,oldlevel,oldquality (gained is 0 for maxed)
GARRISON_MISSION_BONUS_ROLL_COMPLETE,missionID,bool(Success?)
If succeeded then
GARRISON_MISSION_BONUS_ROLL_LOOT,itemId
GARRISON_MISSION_LIST_UPDATE,missionType
GARRISON_FOLLOWER_XP_CHANGED,followerType,followerID,gainedxp,oldxp,oldlevel,oldquality (gained is 0 for maxed)
If troops lost:
GARRISON_FOLLOWER_REMOVED,followerType
GARRISON_FOLLOWER_LIST_UPDATE,followerType
--]]
function module:MissionAutoComplete(event,...)
-- C_Garrison.MarkMissionComplete Mark mission as complete and prepare it for bonus roll, da chiamare solo in caso di successo
-- C_Garrison.MissionBonusRoll
	if event=="LOOT" then
		return self:MissionsPrintResults()
	end
	local current=report:GetUserData('current')
	local currentMission=report:GetUserData('missions')[current]
	local missionID=currentMission and currentMission.missionID or 0
	-- GARRISON_FOLLOWER_XP_CHANGED: followerType,followerID, xpGained, oldXp, oldLevel, oldQuality
	if (event=="GARRISON_FOLLOWER_XP_CHANGED") then
		print(event,...)
		local followerType,followerID, xpGained, oldXp, oldLevel, oldQuality=...
		print("XP CHANGE ",G.GetFollowerName(followerID),xpGained)
		xpGained=addon:todefault(xpGained,0)
		if xpGained>0 then
			rewards.followerXP[followerID]=rewards.followerXP[followerID]+xpGained
		end
		return
	-- GARRISON_MISSION_BONUS_ROLL_LOOT: itemID
	elseif (event=="GARRISON_MISSION_BONUS_ROLL_LOOT") then
		local itemID=...
		local key=format("%d:%s",missionID,itemID)
		--if not rewards.items[key] then
			--rewards.bonuses[key]=1
		--end
		startTimer(0.1)
		return
	-- GARRISON_FOLLOWER_DURABILITY_CHANGED,followerType,followerID,number(Durability left?)
	elseif event=="GARRISON_FOLLOWER_DURABILITY_CHANGED" then
		local followerType,followerID,durabilityLeft=...
		durabilityLeft=addon:todefault(durabilityLeft,1)
		if durabilityLeft<1 then
			rewards.followerXP[followerID]=-1
		end
	-- GARRISON_FOLLOWER_REMOVED
	elseif (event=="GARRISON_FOLLOWER_REMOVED") then
		-- gestire la distruzione di un follower... senza il follower
		-- Should be managed on GARRISON_FOLLOWER_DURABILITY_CHANGED event
	-- GARRISON_MISSION_COMPLETE_RESPONSE,missionID,canComplete,success,unknown_bool,unknown_table
	elseif (event=="GARRISON_MISSION_COMPLETE_RESPONSE") then
		local missionID,canComplete,success,overMaxSucceeded,follower_deaths=...
		if currentMission.completed or select('#',...) == 1 then
			canComplete=true
			success=true
		else
			currentMission.overSuccess=overMaxSucceeded
		end
		if (not canComplete) then
			-- We need to call server again
			currentMission.state=0
		elseif (success) then -- success, we need to roll
			currentMission.state=1
		else -- failure, just print results
			currentMission.state=2
		end
		startTimer(0.1)
		return
	-- GARRISON_MISSION_BONUS_ROLL_COMPLETE: missionID, requestCompleted; happens after calling C_Garrison.MissionBonusRoll
	elseif (event=="GARRISON_MISSION_BONUS_ROLL_COMPLETE") then
		currentMission.state=currentMission.overSuccess and 4 or 3
		startTimer(0.2)
		return
	else -- event == LOOP or INIT
		if (currentMission) then
			local step=currentMission.state or -1
			if (step<1) then
				step=0
				currentMission.state=0
				currentMission.goldMultiplier=currentMission.goldMultiplier or 1
				currentMission.xp=G.GetMissionDeploymentInfo(currentMission.missionID)['xp']
				report:AddMissionButton(currentMission,currentMission.followers,currentMission.successChance,"report")
			end
			if (step==0) then
				G.MarkMissionComplete(currentMission.missionID)
				startTimer(2)
			elseif (step==1) then
				G.MissionBonusRoll(currentMission.missionID)
				startTimer(2)
			elseif (step>=2) then
				self:GetMissionResults(step,currentMission)
				--addon:RefreshFollowerStatus()
				--shipyard:RefreshFollowerStatus()
				local current=report:GetUserData('current')
				report:SetUserData('current',current+1)
				startTimer()
				return
			end
			currentMission.state=step
		else
			report:AddButton(L["Building Final report"])
			startTimer(1,"LOOT")
		end
	end
end
function module:GetMissionResults(finalStatus,currentMission)
	stopTimer()
--	PlaySound("UI_Garrison_CommandTable_MissionSuccess_Stinger");
--	PlaySound("UI_Garrison_Mission_Complete_MissionFail_Stinger");
	if (finalStatus>=3) then
		report:AddMissionResult(currentMission.missionID,finalStatus)
		PlaySound(SOUNDKIT.UI_GARRISON_COMMAND_TABLE_MISSION_SUCCESS_STINGER)
	else
		report:AddMissionResult(currentMission.missionID,false)
		PlaySound(SOUNDKIT.UI_GARRISON_MISSION_COMPLETE_MISSION_FAIL_STINGER)
	end
	local resourceMultiplier=currentMission.resourceMultiplier or {}
	local goldMultiplier=currentMission.goldMultiplier or 1
	if finalStatus>2 then
		for k,v in pairs(currentMission.rewards) do
			v.quantity=v.quantity or 0
			if v.currencyID then
				rewards.currencies[v.currencyID].icon=v.icon
				local multi=resourceMultiplier[v.currencyID]
				if v.currencyID == 0 then
					rewards.currencies[v.currencyID].qt=rewards.currencies[v.currencyID].qt+v.quantity * goldMultiplier
				elseif resourceMultiplier[v.currencyID] then
					rewards.currencies[v.currencyID].qt=rewards.currencies[v.currencyID].qt+v.quantity * multi
				else
					rewards.currencies[v.currencyID].qt=rewards.currencies[v.currencyID].qt+v.quantity
				end
			elseif v.itemID then
				rewards.items[format("%d:%s",currentMission.missionID,v.itemID)]=1
			end
		end
	end
	if finalStatus>3 then
		for k,v in pairs(currentMission.overmaxRewards) do
			v.quantity=v.quantity or 0
			if v.currencyID then
				rewards.currencies[v.currencyID].icon=v.icon
				local multi=resourceMultiplier[v.currencyID]
				if v.currencyID == 0 then
					rewards.currencies[v.currencyID].qt=rewards.currencies[v.currencyID].qt+v.quantity * goldMultiplier
				elseif resourceMultiplier[v.currencyID] then
					rewards.currencies[v.currencyID].qt=rewards.currencies[v.currencyID].qt+v.quantity * multi
				else
					rewards.currencies[v.currencyID].qt=rewards.currencies[v.currencyID].qt+v.quantity
				end
			elseif v.itemID then
				rewards.bonuses[format("%d:%s",currentMission.missionID,v.itemID)]=1
			end
		end
	end
end
function module:MissionsPrintResults(success)
	stopTimer()
	local reported
	local followers
	--@debug@
	_G["BFAtestrewards"]=rewards
	--@end-debug@
	for k,v in pairs(rewards.currencies) do
		reported=true
		if k == 0 then
			-- Money reward
			report:AddIconText(v.icon,GetMoneyString(v.qt))
		else
			-- Other currency reward
			report:AddIconText(v.icon,C_CurrencyInfo.GetCurrencyLink(k,v.qt))
		end
	end
	local items=new()
	for k,v in pairs(rewards.items) do
		local missionid,itemid=strsplit(":",k)
		if (not items[itemid]) then
			items[itemid]=1
		else
			items[itemid]=items[itemid]+1
		end
	end
	for itemid,qt in pairs(items) do
		reported=true
		report:AddItem(itemid,qt)
	end
	wipe(items)
	for k,v in pairs(rewards.bonuses) do
		local missionid,itemid=strsplit(":",k)
		if (not items[itemid]) then
			items[itemid]=1
		else
			items[itemid]=items[itemid]+1
		end
	end
	for itemid,qt in pairs(items) do
		reported=true
		report:AddItem(itemid,qt,true)
	end
	del(items)
	OHFFollowerList.dirtyList=true
	OHFFollowerList:UpdateFollowers()
	for k,v in pairs(rewards.followerXP) do
		reported=true
		followers=true
		if v~=0 then
			if v>0 then
				local b=addon:GetFollowerData(k,'qLevel',0) or 0
				local c=rewards.followerQLevel[k] or 0
				report:AddFollower(k,v, b>c,rewards.followerPortrait[k],	rewards.followerName[k])
			else
				report:AddFollower(k,v, false,rewards.followerPortrait[k],	rewards.followerName[k])
			end
		end
	end
	if not reported then
		report:AddRow(L["Nothing to report"])
	end
	if not followers then
		report:AddRow(L["No follower gained xp"])
	end
	if mebefore.level < 110 then
		fillMyStatus(meafter)
		--@debug@
		--printMyStatus(mebefore)
		--printMyStatus(meafter)
		--@end-debug@
		local xpgain=0
		if meafter.level>mebefore.level then
			xpgain=mebefore.xpMax-mebefore.xp + meafter.xp
		else
			xpgain=meafter.xp-mebefore.xp
		end
		if xpgain > 0 then
			report:AddPlayerXP(xpgain)
		end
	end
	report:AddRow(DONE)
	if addon.quick then
		self:ScheduleTimer("CloseReport",0.1)
		local qm=addon:GetModule("Quick",true)
		addon.ScheduleTimer(qm,"RunQuick",0.2)
	end
end
function addon:MissionComplete(...)
	return module:MissionComplete(...)
end
function addon:CloseMissionComplete()
	return module:CloseReport()
end
function addon:GetCompletedMissionData(key)
	if missions and next(missions) then
		return missions[key]
	end
end