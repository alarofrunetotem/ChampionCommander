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
local module=addon:NewSubModule('Missionlist',"AceHook-3.0","AceEvent-3.0","AceTimer-3.0")  --#Module
function addon:GetMissionlistModule() return module end
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
local LE_FOLLOWER_TYPE_GARRISON_6_0=Enum.GarrisonFollowerType.FollowerType_6_0
local LE_FOLLOWER_TYPE_SHIPYARD_6_2=Enum.GarrisonFollowerType.FollowerType_6_2
local LE_FOLLOWER_TYPE_GARRISON_7_0=Enum.GarrisonFollowerType.FollowerType_7_0
local LE_FOLLOWER_TYPE_GARRISON_8_0=Enum.GarrisonFollowerType.FollowerType_8_0
local LE_GARRISON_TYPE_6_0=Enum.GarrisonType.Type_6_0
local LE_GARRISON_TYPE_6_2=Enum.GarrisonType.Type_6_2
local LE_GARRISON_TYPE_7_0=Enum.GarrisonType.Type_7_0
local LE_GARRISON_TYPE_8_0=Enum.GarrisonType.Type_8_0
local followerType=Enum.GarrisonFollowerType.FollowerType_8_0
local garrisonType=Enum.GarrisonType.Type_8_0
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
local _G=_G
local XP_GAIN= XP_GAIN .. ' x %d'
local pairs,wipe,tinsert,unpack=pairs,wipe,tinsert,unpack
local UNCAPPED_PERC=PERCENTAGE_STRING
local CAPPED_PERC=PERCENTAGE_STRING .. "**"
local Dialog = LibStub("LibDialog-1.0")
local missionNonFilled=true
local wipe=wipe
local GetTime=GetTime
local ENCOUNTER_JOURNAL_SECTION_FLAG4=ENCOUNTER_JOURNAL_SECTION_FLAG4
local RESURRECT=RESURRECT
local LOOT=LOOT
local IGNORED=IGNORED
local UNUSED=UNUSED
local GARRISON_FOLLOWER_COMBAT_ALLY=GARRISON_FOLLOWER_COMBAT_ALLY
local nobonusloot=G.GetFollowerAbilityDescription(471)
local increasedcost=G.GetFollowerAbilityDescription(472)
local increasedduration=G.GetFollowerAbilityDescription(428)
local killtroops=G.GetFollowerAbilityDescription(437)
local killtroopsnodie=killtroops:gsub('%.',' ') ..  L['but using troops with just one durability left']
local GARRISON_MISSION_AVAILABILITY2=GARRISON_MISSION_AVAILABILITY .. " %s"
local GARRISON_MISSION_ID="MissionID: %d"
local weak={__mode="v"}
local missionstats=setmetatable({},weak)
local missionmembers=setmetatable({},weak)
local missionthreats=setmetatable({},weak)
local spinners=setmetatable({},weak)
local missionIDS=setmetatable({},weak)
local missionKEYS=setmetatable({},weak)
local function nop() return 0 end
local Current_Sorter
local Second_Sorter
local sortKeys={}
local MAX=999999999
local OHFButtons=OHFMissions.listScroll.buttons
local clean
local displayClean
local function factionLevelColor(level)
  level=level or 4
  if level < 4 then
    return "ORANGE"
  elseif level >= MAX_REPUTATION_REACTION then
    return "CYAN"
  elseif level ==4 then
    return "YELLOW"
  else
    return "GREEN"
  end
end
local function getFactionInfoFromCurrency(id)
    local factionId=C_CurrencyInfo.GetFactionGrantedByCurrency(id)
    if not factionId then return nil,nil end
    local faction,_,level=GetFactionInfoByID(factionId)
    return faction,level
end
local function GetPerc(mission,realvalue)
	local p=addon:GetSelectedParty(mission.missionID,missionKEYS[mission.missionID])
	if not p then addon:SetDirtyFlags("FORCED")return 0 end
	local perc=p.perc or 0
	if realvalue then
		return perc
	else
		return addon:GetBoolean("IGNORELOW") and perc or 1
	end
end
local function IsLow(mission)
    if addon:IsBlacklisted(mission.missionID) then return "0" end
		if addon:GetBoolean("ELITEMODE") and not mission.elite then return "1" end
		if addon:GetBoolean("IGNORELOW") then
      local p=addon:GetSelectedParty(mission.missionID,missionKEYS[mission.missionID])
      if not p or #p==0 then return "2" end
    end
		return "3"
end
local function IsIgnored(mission)
	--return addon:GetBoolean("ELITEMODE") and mission.class=="0"
	return addon:GetBoolean("ELITEMODE") and not addon:GetMissionData(mission.missionID,'elite')
end
local sorters={
    Garrison_SortMissions_Original=function(mission)
      return IsLow(mission)
    end,
    Garrison_SortMissions_Chance=function(mission)
      return IsLow(mission)  .. format("%010d",MAX + GetPerc(mission,true))
    end,
    Garrison_SortMissions_Level=function(mission)
      return IsLow(mission) ..format("%010d",  (mission.level * 1000 + (mission.iLevel or 0)))
    end,
    Garrison_SortMissions_Age=function(mission)
      return IsLow(mission) .. format("%010d", MAX - mission.offerEndTime)
    end,
    Garrison_SortMissions_Xp=function(mission)
      local p=addon:GetSelectedParty(mission.missionID,missionKEYS[mission.missionID])
      return IsLow(mission)..  format("%010d",(p.totalXP or 0))
    end,
    Garrison_SortMissions_HourlyXp=function(mission)
      local p=addon:GetSelectedParty(mission.missionID,missionKEYS[mission.missionID])
      return IsLow(mission) .. format("%010d", MAX -(-p.totalXP or 0) * 60 /  (p.timeseconds or  mission.durationSeconds or 36000))
    end,
    Garrison_SortMissions_Duration=function(mission)
      local p=addon:GetSelectedParty(mission.missionID,missionKEYS[mission.missionID])
      return IsLow(mission) .. format("%010d",MAX - (p.timeseconds or  mission.durationSeconds or 0))
    end,
    Garrison_SortMissions_Class=function(mission)
      local factor=100000
      return IsLow(mission) .. format("%010d",MAX -tonumber(format("%7d.%07d",todefault(mission.classOrder,factor), factor - math.min(factor,todefault(mission.classValue,0)))))
    end,
}
local function InProgress(mission,frame)
	return (mission and mission.inProgress) or OHFMissions.showInProgress or (frame and frame.IsCustom)
end
function module:OnInitialized()

-- Dunno why but every attempt of changing sort starts a memory leak
	local sorters={
		Garrison_SortMissions_Original=L["Original method"],
		Garrison_SortMissions_Chance=L["Success Chance"],
		Garrison_SortMissions_Level=L["Level"],
		Garrison_SortMissions_Age=L["Expiration Time"],
		Garrison_SortMissions_Xp=L["Global approx. xp reward"],
		Garrison_SortMissions_HourlyXp=L["Global approx. xp reward per hour"],
		Garrison_SortMissions_Duration=L["Duration Time"],
		Garrison_SortMissions_Class=L["Reward type"],
	}

--@debug@
	addon:AddBoolean("ELITEMODE",false,L["Elites mission mode"],L["Only consider elite missions"])
  addon:AddBoolean("EXTENDEDTIP",false,L["Extended mission tooltip"],L["Shows a VERY verbose mission toolitpi"])
--@end-debug@
	addon:AddSelect("SORTMISSION","Garrison_SortMissions_Original",sorters,	L["Sort missions by:"],L["Changes the sort order of missions in Mission panel"])
  addon:AddSelect("SORTMISSION2","Garrison_SortMissions_Original",sorters, L["and then by:"],L["Changes the second sort order of missions in Mission panel"])
	addon:AddBoolean("IGNORELOW",false,L["Empty missions sorted as last"],L["Empty or 0% success mission are sorted as last. Does not apply to \"original\" method"])
	addon:AddBoolean("NOWARN",false,L["Remove no champions warning"],L["Disables warning: "] .. GARRISON_PARTY_NOT_ENOUGH_CHAMPIONS)
	addon:AddBoolean("NOBLACKLIST",false,L["Disable blacklisting"],format(L["%s no longer blacklist missions"],KEY_BUTTON2))
	addon:RegisterForMenu("mission",
--@debug@
		"ELITEMODE",
--@end-debug@
		"SORTMISSION",
    "SORTMISSION2",
		"IGNORELOW",
		"NOWARN")
	self:LoadButtons()
	Current_Sorter=addon:GetString("SORTMISSION")
  Second_Sorter=addon:GetString("SORTMISSION2")
	self:SecureHookScript(OHF,"OnShow","InitialSetup")
		Dialog:Register("BFAUrlCopy", {
			text = L["URL Copy"],
			width = 500,
			editboxes = {
				{ width = 484,
					on_escape_pressed = function(self, data) self:GetParent():Hide() end,
				},
			},
			on_show = function(self, data)
				self.editboxes[1]:SetText(data.url)
				self.editboxes[1]:HighlightText()
				self.editboxes[1]:SetFocus()
			end,
			buttons = {
				{ text = CLOSE, },
			},
			show_while_dead = true,
			hide_on_escape = true,
		})
		self:SecureHook("GarrisonMissionButtonRewards_OnEnter")
end
function module:Print(...)
	print(...)
end
function module:Events()
	addon:RegisterEvent("GARRISON_MISSION_LIST_UPDATE","SetDirtyFlags")
	addon:RegisterEvent("GARRISON_MISSION_STARTED","SetDirtyFlags")
	addon:RegisterEvent("GARRISON_FOLLOWER_CATEGORIES_UPDATED","SetDirtyFlags")
	addon:RegisterEvent("GARRISON_FOLLOWER_ADDED","SetDirtyFlags")
	addon:RegisterEvent("GARRISON_FOLLOWER_REMOVED","SetDirtyFlags")
	addon:RegisterEvent("GARRISON_FOLLOWER_LIST_UPDATE","SetDirtyFlags")
	addon:RegisterEvent("GARRISON_UPDATE","SetDirtyFlags")
	addon:RegisterEvent("GARRISON_UPGRADEABLE_RESULT","SetDirtyFlags")
	addon:RegisterEvent("GARRISON_MISSION_COMPLETE_RESPONSE","SetDirtyFlags")
	addon:RegisterEvent("GARRISON_FOLLOWER_XP_CHANGED","SetDirtyFlags")
	addon:RegisterEvent("GARRISON_FOLLOWER_UPGRADED","SetDirtyFlags")
	addon:RegisterEvent("GARRISON_FOLLOWER_DURABILITY_CHANGED","SetDirtyFlags")
	addon:RegisterEvent("SHIPMENT_CRAFTER_CLOSED","SetDirtyFlags")
end
function module:LoadButtons(...)
	local buttonlist=OHFMissions.listScroll.buttons
	for i=1,#buttonlist do
		local b=buttonlist[i]
		self:SecureHookScript(b,"OnEnter","AdjustMissionTooltip")
		self:SecureHookScript(b,"OnLeave","SafeAddMembers")
		self:RawHookScript(b,"OnClick","RawMissionClick")
		b:RegisterForClicks("AnyDown")
		local scale=0.8
		local f,h,s=b.Title:GetFont()
		b.Title:SetFont(f,h*scale,s)
		local f,h,s=b.Summary:GetFont()
		b.Summary:SetFont(f,h*scale,s)
		self:SecureHookScript(b.Rewards[1],"OnMouseUp","PrintLink")
	end
end
function addon:SetDirtyFlags(event,missionType,missionID,...)
	if event=="GARRISON_MISSION_LIST_UPDATE"
    or event=="GARRISON_FOLLOWER_LIST_UPDATE"
		or event=="GARRISON_MISSION_STARTED"
    or event=="GARRISON_FOLLOWER_UPGRADED"
    or event=="GARRISON_FOLLOWER_XP_CHANGED" then
		if missionType ~= LE_FOLLOWER_TYPE_GARRISON_8_0 then return end
	end
	if event=="GARRISON_FOLLOWER_CATEGORIES_UPDATED"
		or event=="GARRISON_FOLLOWER_ADDED"
    or event=="GARRISON_FOLLOWER_REMOVED"
    or event=="GARRISON_FOLLOWER_LIST_UPDATE"
		or event=="GARRISON_FOLLOWER_REMOVED"
		or event=="GARRISON_FOLLOWER_XP_CHANGED"
		or event=="GARRISON_FOLLOWER_UPGRADED"
		or event=="GARRISON_FOLLOWER_DURABILITY_CHANGED"
		or event=="FORCED"
	then
		addon:PushRefresher("RefillParties")
		addon:PushRefresher("RefreshEquipments")
	end
	addon:PushRefresher("CleanMissionsCache")
--@debug@
	print("Set Dirty state ",event,addon:ListRefreshers())
--@end-debug@
end
local tb={url=""}
local artinfo='*' .. L["Artifact shown value is the base value without considering knowledge multiplier"]
local tipinvocation=0
function module:GarrisonMissionButtonRewards_OnEnter(this)
  local tip=GameTooltip
  local frame,anchor =tip:GetOwner()
  if (frame ~= this) then return end
  local lines={}
  if (this.currencyID) then
    local id,qt=this.currencyID,this.currencyQuantity
    local faction,level = getFactionInfoFromCurrency(id)
    if not faction then return end
    if level then
      local levelLabel=_G['FACTION_STANDING_LABEL' .. level]
      lines[FACTION_STANDING_CHANGED:format(C(levelLabel,factionLevelColor(level)),C(faction,"GREEN"))]=false
    end
    for k,v in pairs(lines) do
      if (v) then
        tip:AddDoubleLine(k,v)
      else
        tip:AddLine(k,v)
      end
    end
    do
      local lines=lines
      local numLines=tip:NumLines()
      module:SecureHookScript(tip,"OnUpdate",
          function(panel)
            if panel:NumLines() < numLines then
              for k,v in pairs(lines) do
                panel:AddDoubleLine(k,v)
              end
              panel:Show()
            end
          end
          )
      module:SecureHookScript(tip,"OnHide",function(panel) module:Unhook(panel,"OnUpdate") module:Unhook(panel,"OnHide") end)
    end
  end
	if this.itemID  then
		local factionID=addon.allReputationGain[this.itemID]
		if factionID then
		  local faction,_,level=GetFactionInfoByID(factionID)
		  if level then
		    level=_G['FACTION_STANDING_LABEL' .. level]
		    tip:AddLine(FACTION_STANDING_CHANGED:format(C(level,"GREEN"),C(faction,"GREEN")),C.Orange())
		  end
    end
		tip:AddLine(safeformat(L["%s for a wowhead link popup"],SHIFT_KEY_TEXT .. KEY_BUTTON1))
	end
  tip:Show()
  --module:Unhook(this,"OnUpdate")
end
function module:PrintLink(this,button)
--@debug@
  if (button=="MiddleButton") then
    DevTools_Dump(this)
  end
--@end-debug@
  if this.itemID and ChatEdit_TryInsertChatLink((select(2,GetItemInfo(this.itemID)))) then return end
	if button=="RightButton" then
		local missionID=this:GetParent().info.missionID
		---TODO: Manage rewards blacklisting
		--addon:Print("Mission",missionID,addon:GetMissionData(missionID,'class'))
	elseif this.itemID and IsShiftKeyDown() then
		if Dialog:ActiveDialog("BFAUrlCopy") then
			return Dialog:Dismiss("BFAUrlCopy")
		else
		  tb.url="http://www.wowhead.com/item=" ..this.itemID
		  return Dialog:Spawn("BFAUrlCopy", tb)
		end
	end
end



--- Full mission panel refresh.
-- Reloads cached mission inProgressMissions and availableMissions.
-- Updates combat ally data
-- Sorts missions
-- Updates top tabs (available/in progress)
-- calls Update
--
function module:OnUpdateMissions(frame)
--@debug@
	addon:Print("Called OnUpdateMissions with ",addon:ListRefreshers())
--@end-debug@
  if addon:EmptyPermutations() then
    addon:PushRefresher("RefillParties")
  end
  addon:RunRefreshers()
end
function module:OnUpdate(frame)
	addon:RedrawMissions()
end
function module:CheckShadow()
	if not addon:GetBoolean("NOWARN") and not OHFMissions.showInProgress and not OHFCompleteDialog:IsVisible() and missionNonFilled then
		local totChamps,maxChamps=addon:GetTotFollowers('CHAMP_' .. AVAILABLE),addon:GetNumber("MAXCHAMP")
		--@debug@
		print("Checking shadows for ",maxChamps,totChamps)
		--@end-debug@
		if totChamps==0 then
			self:NoMartiniNoParty(GARRISON_PARTY_NOT_ENOUGH_CHAMPIONS)
		elseif maxChamps  < 3 then
			self:NoMartiniNoParty(safeformat(L['Unable to fill missions, raise "%s"'],L["Max champions"]))
		else
			self:NoMartiniNoParty(L["Unable to fill missions. Check your switches"])
		end
	else
		self:NoMartiniNoParty()
	end
end
function addon:CleanMissionsCache()
	missionNonFilled=false
	wipe(missionKEYS)
	wipe(missionIDS)
end
function addon:CleanPermutations()
	return addon:GetFullpermutations(true)
end

function addon:Redraw()
	self:ApplySORTMISSION(Current_Sorter)
end
function module:OnSingleUpdate(frame)
	if OHFMissions:IsVisible() and not OHFCompleteDialog:IsVisible() and frame.info and frame:IsVisible() then
		self:AdjustPosition(frame)
		--if frame.info.missionID ~= missionIDS[frame] then
		local full= not missionIDS[frame] or missionIDS[frame]~=frame.info.missionID
		local blacklisted=addon:IsBlacklisted(frame.info.missionID)
		if not blacklisted  then -- always do a full refresh and see what happens
			self:AdjustMissionButton(frame)
		else
		  self:SafeAddMembers(frame)
		end
		missionIDS[frame]=frame.info.missionID
		local mission=addon:GetMissionData(frame.info.missionID)
		if blacklisted then
			self:Dim(frame)
		else
  		local rw=frame.Rewards[1]
  		rw.Icon:SetDesaturated(false)
  		rw.IconBorder:SetDesaturated(false)
  	  if mission.class and mission.class=="Artifact" then

  			rw.Quantity:SetText(mission.classValue =="0" and "?" or mission.classValue .. "*")
  			rw.Quantity:Show()
 			end
		end
	end
end
local pcall=pcall
local sort=table.sort
local strcmputf8i=strcmputf8i
local tostring=tostring
local function sortfuncProgress(a,b)
  if type(a.timeLeftSeconds) == "number" and type(b.timeLeftSeconds)=="number" then
    return a.timeLeftSeconds < b.timeLeftSeconds
  else
    return strcmputf8i(a.name, b.name) < 0
  end
end
local function sortfuncAvailable(a,b)
	if sortKeys[a.missionID] ~= sortKeys[b.missionID] then
		return tostring(sortKeys[a.missionID]) > tostring(sortKeys[b.missionID])
	else
		return strcmputf8i(a.name, b.name) < 0
	end
end
function module:SortMissions()
--@debug@
  addon:Print("Sort called")
--@end-debug@
  if not OHF:IsVisible() then return end
--@debug@
  addon:Print("Sort executed")
--@end-debug@
  if OHFMissions.showInProgress then
    sort(OHFMissions.inProgressMissions,sortfuncProgress)
    return
  end
	if Current_Sorter=="Garrison_SortMissions_Original" then return end
	local f=sorters[Current_Sorter]
	local f2=sorters[Second_Sorter]
	for k=#OHFMissions.availableMissions,1,-1 do
		local missionID=OHFMissions.availableMissions[k].missionID
		local mission=addon:GetMissionData(missionID) -- we need the enriched version
--@debug@
		if IsIgnored(mission) then
			tremove(OHFMissions.availableMissions,k)
		else
--@end-debug@
			local rc,result =pcall(f,mission)
      local rc2,result2 =pcall(f2,mission)
--@debug@
      if not rc then addon:Print(missionID,C(result,"Orange")) end
      if not rc2 then addon:Print(missionID,C(result2,"Orange")) end
--@end-debug@
      if not rc then result="" end
      if not rc2 then result2="" end
      sortKeys[missionID]=format("%s|%s",result,result2:sub(2))
--@debug@
      sortKeys[missionID]=sortKeys[missionID] .. G.GetMissionName(missionID)
		end
--@end-debug@
	end
--@debug@
    --DevTools_Dump(sortKeys)
--@end-debug@
	sort(OHFMissions.availableMissions,sortfuncAvailable)
--@debug@
  for i=1,#OHFMissions.availableMissions do
    local mission=OHFMissions.availableMissions[i]
    addon:Print(sortKeys[mission.missionID],mission.name)
  end
--@end-debug@
end
local timer
local suspendApply
function addon:PauseApply(pause)
  suspendApply=pause
end
function addon:Apply(flag,value)
  if suspendApply then return end
  local w=module:GetMenuItem(flag)
  addon:PushRefresher("CleanMissionsCache")
	if not timer then timer=addon:NewDelayableTimer(function() addon:ReloadMissions() end) end
	self:GetTutorialsModule():Refresh()
	if IsMouseButtonDown() then
	 timer:Start(0.5)
	else
	 timer:Start(0)
	end
end
function addon:ApplySORTMISSION(value)
  Current_Sorter=value
  return self:ReloadMissions()
end
function addon:ApplySORTMISSION2(value)
  addon:Print("SORTMISSION2")
  Second_Sorter=value
  return self:ReloadMissions()
end
local PushRefresher,RunRefreshers,ListRefreshers do
  local Refreshers={
    RefillParties=true,
    CleanMissionsCache=true
  }
  local temp={}
  function PushRefresher(refresher,obj)
    Refreshers[refresher]=obj or true
  end
  function RunRefreshers()
    if next(Refreshers) and OHF:IsVisible() then
  --@debug@
      addon:Print("Runrefresher called from",debugstack(3,2,0))
  --@end-debug@
    else
      return
    end
    for method,obj in pairs(Refreshers) do
      if type(obj)=="boolean" then
        obj=addon
      end
--@debug@
      addon:Print("Running refresher",method)
--@end-debug@
    if type(obj[method])=="function" then
    obj[method](obj)
    end
    end
    wipe(Refreshers)
  end
  function ListRefreshers()
    wipe(temp)
    for k,_ in pairs(Refreshers) do
      tinsert(temp,k)
    end
    return unpack(temp)
  end
end
function addon:PushRefresher(refresher)
  return PushRefresher(refresher)
end
function addon:RunRefreshers()
  return RunRefreshers()
end
function addon:ListRefreshers()
  return ListRefreshers()
end
function addon:ReloadMissions()
--@debug@
  addon:Print("ReloadMissions")
--@end-debug@
  local OnMissionPage=OHF.MissionTab.MissionPage:IsVisible()
  addon:SortTroop()
  if OnMissionPage then addon:GetMissionpageModule():ClearParty() end
  addon:RunRefreshers()
  if  OnMissionPage then
    local mission=OHF.MissionTab.MissionPage.info or OHF.MissionTab.MissionPage.missionInfo
  --@debug@
    addon:Print("Refilling mission page for mission ",mission.missionID)
  --@end-debug@
    addon:GetMissionpageModule():FillParty(mission.missionID)
  else
    OHFMissions:UpdateMissions()
  end
end
function addon:RedrawMissions()
  addon:RunRefreshers()
  addon:SortTroop()
  for i=1,#OHFButtons do
    local frame=OHFButtons[i]
    module:OnSingleUpdate(frame)
  end
  return module:CheckShadow()
end
local function ToggleSet(this,value)
	return addon:ToggleSet(this.flag,this.tipo,value)
end
local function ToggleGet(this)
	return addon:ToggleGet(this.flag,this.tipo)

end
local function PreToggleSet(this)
	return ToggleSet(this,this:GetChecked())
end
local pin
local close
local menu
local button
local function OpenMenu()
	addon.db.profile.showmenu=true
	button:Hide()
	menu:Show()
  menu.Tutorial:Show()
end
local function CloseMenu()
	addon.db.profile.showmenu=false
	button:Show()
	menu:Hide()
end
local warner
function module:NoMartiniNoParty(text)
	if not warner then
		warner=CreateFrame("Frame","BFAWarner",OHFMissions , BackdropTemplateMixin and "BackdropTemplate")
		warner.label=warner:CreateFontString(nil,"OVERLAY","GameFontNormalHuge3Outline")
		warner.label:SetTextColor(C:Orange())
		warner:SetAllPoints()
		warner.label:SetHeight(100)
		warner.label:SetPoint("CENTER")
		warner:SetFrameStrata("TOOLTIP")
		addon:SetBackdrop(warner,0,0,0,0.7)
	end
	local label=warner.label
	if text then
		label:SetText(text)
		warner:Show()
	else
		warner:Hide()
	end
end
local optionlist={}
function module:GetMenuItem(flag)
  if flag then return optionlist[flag] end
end
function addon:Pulse(start)
  if start then
    menu.Pulse:Play()
  else
    menu.Pulse:Stop()
  end
end
local function tutorialTip()
  local steps=addon:NeedsTutorial() or ''

  return C(steps,"green") .. KEY_BUTTON1 .. L["Resume tutorial"] .. "\n" .. KEY_BUTTON2 .. L["Restart tutorial from beginning"]
end

function module:Menu(flag)

  menu=CreateFrame("Frame",nil,OHF,"BFAMenu")
  menu:SetPoint("TOPLEFT",OHF,"TOPRIGHT",0,30)
  menu:SetPoint("BOTTOMLEFT",OHF,"BOTTOMRIGHT",0,0)

--  menu=CreateFrame("Frame",nil,OHFMissions,"BFAMenu")
--  menu:SetPoint("TOPLEFT",OHFMissionTab,"TOPRIGHT",0,30)
--  menu:SetPoint("BOTTOMLEFT",OHFMissionTab,"BOTTOMRIGHT",0,0)
  menu.Title:SetText('BFA ' .. addon.version)
  menu.Title:SetTextColor(C:Yellow())
  menu.Close:SetScript("OnClick",CloseMenu)
  menu.Tutorial:RegisterForClicks("LeftButtonUp","RightButtonUp")
  addon:RawHookScript(menu.Tutorial,"OnClick",function(this,button)  if button=="LeftButton" then addon:ShowTutorial() else addon:GetTutorialsModule():Home() end end)
  menu.Tutorial.tooltip=tutorialTip
  button=CreateFrame("Button",nil,OHFMissionTab,"BFAPin")
  button.tooltip=L["Show/hide ChampionCommander mission menu"]
  button:SetScript("OnClick",OpenMenu)
  button:GetNormalTexture():SetRotation(math.rad(270))
  button:GetHighlightTexture():SetRotation(math.rad(270))
	local previous
	local factory=addon:GetFactory()
	for _,v in pairs(addon:GetRegisteredForMenu("mission")) do
		local flag,icon=strsplit(',',v)
		local f=factory:Option(addon,menu,flag,200)
		optionlist[flag]=f
		if type(f)=="table" and f.GetObjectType then
      addon:GetVarInfo(flag).guiHidden=true
			if previous then
				f:SetPoint("TOPLEFT",previous,"BOTTOMLEFT",0,0)
			else
				f:SetPoint("TOPLEFT",menu,"TOPLEFT",10,-30)
			end
			local w=f:GetWidth()+30
			if w >menu:GetWidth() then menu:SetWidth(w) end
			previous=f
		end
	end
	local f=factory:Button(menu,OPTIONS,L["Customization options (non mission related)"],200)
	f:SetObj(addon)
	f:SetOnChange("Gui")
	f:SetPoint("BOTTOM",0,10)
	self.Menu=function() addon:Print("Should not call this again") end
end
local stopper=addon:NewModule("stopper","AceHook-3.0")
function addon:UpdateStop(n)
	stopper:UnhookAll()
	stopper:RawHookScript(OHFMissionFrameMissions,"OnUpdate",GarrisonMissionListMixin.OnUpdate)
end
function module:OptionsButton()
  local level=OHFMissionScroll:GetFrameLevel()+5
  local h=-27
  local option1=addon:GetFactory():Button(OHFMissionScroll,
  L["Quick start first mission"],
  L["Launch the first filled mission with at least one locked follower.\nKeep SHIFT pressed to actually launch, a simple click will only print mission name with its followers list"],200)
  option1:SetPoint("BOTTOMLEFT",100,h)
  option1.obj=module
  option1:SetOnChange("RunMission")
  local option2=addon:GetFactory():Button(OHFMissionScroll,L["Unlock all"],L["Unlocks all follower and slots at once"])
  option2:SetPoint("BOTTOM",0,h)
  option2:SetOnChange(function() addon:UnReserve() addon:Unban() addon:RedrawMissions() end)
  local option3=addon:GetFactory():Button(OHFMissionScroll,RESET,L["Sets all switches to a very permissive setup. Very similar to 1.4.4"])
  option3:SetPoint("BOTTOMRIGHT",-100,h)
  option3:SetOnChange(function() addon:Reset() end ) --addon:RefreshMissions() end)
  optionlist["BUTTON1"]=option1
  optionlist["BUTTON2"]=option2
  optionlist["BUTTON3"]=option3
  for _,f in pairs(optionlist) do
    f:SetFrameLevel(level)
  end
end
function module:DisplayMenu()
  if OHF.MapTab:IsVisible() then
     if OHF.TroopsStatusInfo then OHF.TroopsStatusInfo:Hide() end
     if OHF.ChampionsStatusInfo then OHF.ChampionsStatusInfo:Hide() end
     if menu then menu:Hide() end
  else
     if OHF.TroopsStatusInfo then OHF.TroopsStatusInfo:Show() end
     if OHF.ChampionsStatusInfo then OHF.ChampionsStatusInfo:Show() end
     if addon.db.profile.showmenu then OpenMenu() else CloseMenu() end
  end
end
function module:InitialSetup(this)
  if not OHF:ShouldShowMissionsAndFollowersTabs() then return end
	collectgarbage("stop")
	if type(addon.db.global.warn01_seen)~="number" then	addon.db.global.warn01_seen =0 end
	if type(addon.db.global.warn02_seen)~="number" then	addon.db.global.warn02_seen =0 end
	self:Menu()
	self:Unhook(this,"OnShow")
	self:SecureHookScript(this,"OnShow","MainOnShow")
	self:SecureHookScript(this,"OnHide","MainOnHide")

	OHF.ChampionsStatusInfo=OHF.GarrCorners:CreateFontString(nil,"OVERLAY","GameFontNormalSmall")
	OHF.ChampionsStatusInfo:SetPoint("TOPRIGHT",-45,-2)
	OHF.ChampionsStatusInfo:SetText("")

	OHF.TroopsStatusInfo=OHF.GarrCorners:CreateFontString(nil,"OVERLAY","GameFontNormalSmall")
	OHF.TroopsStatusInfo:SetPoint("TOPLEFT",80,-2)
	OHF.TroopsStatusInfo:SetText("")
	self:OptionsButton()
	self:EvOn()
	self:MainOnShow()
  addon:ReloadMissions()
	-- For some strange reason, we need this to avoid leaking memory
	addon:UpdateStop()
	collectgarbage("restart")
  addon:MarkAsNew(OHF,addon:NumericVersion(),safeformat(L["%s, please review the tutorial\n(Click the icon to dismiss this message and start the tutorial)"],me .. ' ' .. addon.version),"ShowTutorial")
--@alpha@
	--addon.version="1.6.0 Alpha"
--@end-alpha@
	local _,_,versiontype=addon.version:find("(Beta)")
	if not versiontype then _,_,versiontype=addon.version:find("(Alpha)") end
	if versiontype then
		local frame=CreateFrame("Frame",nil,OHF,"TooltipBorderedFrameTemplate")
		frame.label=frame:CreateFontString(nil,"OVERLAY","GameFontNormalHuge")
		frame:SetFrameStrata("TOOLTIP")
		frame.label:SetAllPoints(frame)
		frame:SetPoint("BOTTOM",OHF,"TOP",0,30)
		frame.label:SetWidth(OHF:GetWidth()-10)
		frame.label:SetText("You are using |cffff0000BETA VERSION|r "..addon.version ..".\nIf something doesnt work usually typing /reload will fix it.")
		if versiontype=="Alpha" then
      frame.label:SetText("You are using |cffff0000ALFA VERSION|r "..addon.version ..".\nIf something doesnt work usually typing /reload will fix it.")
    else
		  frame.label:SetText("You are using |cffff0000BETA VERSION|r "..addon.version ..".\nIf something doesnt work usually typing /reload will fix it.")
		end
		frame.label:SetJustifyV("CENTER")
		frame.label:SetJustifyH("CENTER")
		frame:SetHeight(frame.label:GetStringHeight()+15)
		frame:SetWidth(OHF:GetWidth())
		frame.label:SetPoint("CENTER")
    frame:EnableMouse(true)
    frame:RegisterForDrag("LeftButton")
    frame:SetScript("OnDragStart",function(frame) if addon:GetBoolean('MOVEPANEL') then OHF:StartMoving() end end)
    frame:SetScript("OnDragStop",function(frame) OHF:StopMovingOrSizing() end)
  end

  if addon:NeedsTutorial() then
    addon:Pulse(true)
    addon:ScheduleTimer("Pulse",5)
  end
end
function addon:ShowTutorial()
  OpenMenu()
  addon:GetTutorialsModule():Show(true)
end

function addon:Reset()
  addon:PauseApply(true)
  local w=module:GetMenuItem("BASECHANCE")
  if w then w:SetValue(0) end
  w=module:GetMenuItem("BONUSCHANCE")
  if w then w:SetValue(100) end
  w=module:GetMenuItem("IGNOREBUSY")
  if w then w:SetValue(true) end
  w=module:GetMenuItem("IGNOREINACTIVE")
  if w then w:SetValue(true) end
  for _,k in ipairs{'NEVERKILLTROOPS','SAVETROOPS','MAXIMIZEXP', "NOTROOPS", "BONUS", "SPARE", "MAKEITQUICK", "MAKEITVERYQUICK"} do
    w=module:GetMenuItem(k)
    if w then w:SetValue(false) end
  end
  addon:PauseApply(false)
  addon:Apply()
end
function addon:GetMissionKey(missionID)
	return missionID and missionKEYS[missionID] or missionKEYS
end
function addon:GetMembersFrame(frame)
	return missionmembers[frame]
end
function module:RunMission()
	return addon:GetAutopilotModule():RunMission()
end
function module:SelectTab(table,id)
  print("SELECT",id)
  self:DisplayMenu()
end
function module:EvOn()
	for _,m in addon:IterateModules() do
		if m.Events then m:Events() end
	end
	--self:RawHook(OHFMissions,"Update","OnUpdate",true)
	self:SecureHook("Garrison_SortMissions","SortMissions")
	self:Hook(OHFMissions,"UpdateMissions","OnUpdateMissions",true)
	self:SecureHook(OHFMissions,"Update","OnUpdate")	--self:RawHook(OHFMissions,"Update","OnUpdate",true)
	self:SecureHook(OHF,"SelectTab")
end
function module:EvOff()
	for _,m in addon:IterateModules() do
		if m.EventsOff then
			m:EventsOff()
		elseif m.UnregisterAllEvents then
			m:UnregisterAllEvents()
		end
	end
	self:Unhook("Garrison_SortMissions")
	self:Unhook(OHFMissions,"UpdateMissions")
	self:Unhook(OHFMissions,"Update")
  self:UnHook(OHF,"SelectTab")
end
function module:MainOnShow()
  print("OnShow")
  self:DisplayMenu()
	addon:GetResources(true)
	--self:Unhook(OHFMissions,"Update")
	addon:RefreshFollowerStatus()
	addon:GetCacheModule():GARRISON_LANDINGPAGE_SHIPMENTS()
	addon:ParseFollowers()
	addon.lastChange=GetTime()
	--module:SortMissions()
	OHF:SelectTab(OHF.selectedTab)
end
function module:MainOnHide()
	collectgarbage()
	addon:GetAutocompleteModule():AutoClose()
	addon:GetTutorialsModule():Hide()
end
function module:AdjustPosition(frame)
	local mission=frame.info
	frame.Title:ClearAllPoints()
	if  mission.isResult then
		frame.Title:SetPoint("TOPLEFT",165,15)
	elseif  mission.inProgress then
		frame.Title:SetPoint("TOPLEFT",165,-10)
	else
		frame.Title:SetPoint("TOPLEFT",165,-7)
	end
	if mission.isRare then
		frame.Title:SetTextColor(frame.RareText:GetTextColor())
	else
		frame.Title:SetTextColor(C:White())
	end
	frame.RareText:Hide()
	-- Compacting mission time and level
	frame.RareText:Hide()
	frame.Level:ClearAllPoints()
	frame.MissionType:ClearAllPoints()
	frame.ItemLevel:Hide()
	frame.Level:SetPoint("LEFT",5,0)
	frame.MissionType:SetPoint("LEFT",5,0)
	if mission.isMaxLevel then
		frame.Level:SetText(mission.iLevel)
	else
		frame.Level:SetText(mission.level)
	end
	local missionID=mission.missionID
end

function module:AdjustMissionButton(frame)
	if not OHF:IsVisible() then return end
	local mission=frame.info
	local missionID=mission and mission.missionID
	if not missionID then return end
	missionIDS[frame]=missionID
	-- Adding stats frame (expiration date and chance)
	if not missionstats[frame] then
		missionstats[frame]=CreateFrame("Frame",nil,frame,"BFAStats")
--@debug@
		self:RawHookScript(missionstats[frame],"OnEnter","MissionTip")
--@end-debug@
	end
  if not missionmembers[frame] then
    missionmembers[frame]=CreateFrame("Frame",nil,frame,"BFAMembers")
  end
  if not missionthreats[frame] then
    missionthreats[frame]=CreateFrame("Frame",nil,frame,"BFAThreats")
  end
	local stats=missionstats[frame]
	local aLevel,aIlevel=addon:GetAverageLevels()
	if mission.isMaxLevel then
		frame.Level:SetText(mission.iLevel)
		frame.Level:SetTextColor(addon:GetDifficultyColors(math.floor((aIlevel-750)/(mission.iLevel-750)*100)))
	else
		frame.Level:SetText(mission.level)
		frame.Level:SetTextColor(addon:GetDifficultyColors(math.floor(aLevel/mission.level*100)))
	end
	if mission.inProgress then
		stats:SetPoint("LEFT",48,14)
		stats.Expire:Hide()
	else
		stats.Expire:SetFormattedText("%s\n%s",GARRISON_MISSION_AVAILABILITY or "Mission Expires",mission.offerTimeRemaining)
		stats.Expire:SetTextColor(addon:GetAgeColor(mission.offerEndTime))
		stats:SetPoint("LEFT",48,0)
		stats.Expire:Show()
	end
	stats.Chance:Show()
	if addon:IsBlacklisted(missionID) then
		return
	end
	self:SafeAddMembers(frame)
	for i=1,#frame.Rewards do
	  local reward=frame.Rewards[i]
	  if (reward.currencyID) then
      local id,qt=reward.currencyID,reward.currencyQuantity
      reward.Quantity:SetText(qt)
      local faction,level = getFactionInfoFromCurrency(id)
      if level then
        reward.Quantity:SetTextColor(C[factionLevelColor(level)]())
      else
        reward.Quantity:SetTextColor(HIGHLIGHT_FONT_COLOR:GetRGB());
      end
      reward.Quantity:Show()
   end
	end
end
function  module:SafeAddMembers(frame)
  local rc,errorMessage=pcall(self.AddMembers,self,frame)
  if not rc then
    addon:SetDirtyFlags("FORCED")
--@debug@
    _G.print(C(me,"red"),": Failed addmembers ",errorMessage)
--@end-debug@
  end
end
function module:Dim(frame)
		frame.Title:SetTextColor(0,0,0)
		frame.Overlay:Show()
		frame.Overlay:SetFrameLevel(10)
		frame.Level:SetTextColor(C.Grey())
		frame.Summary:SetTextColor(C.Grey())
		local stats=missionstats[frame]
		if stats then
			stats.Chance:SetTextColor(C.Grey())
		end
		local members=missionmembers[frame]
		if members then
			for _,champion in pairs(members.Champions) do
        if champion.followerID then
				  champion:Unlock()
				end
				champion:SetEmpty(UNUSED)
			end
		end
		local rw=frame.Rewards[1]
		if rw then
			rw.Icon:SetDesaturated(true)
			rw.IconBorder:SetDesaturated(true)
		end
end
function module:UnDim(frame)
		frame.Overlay:Hide()
		local rw=frame.Rewards[1]
		if rw then
			rw.Icon:SetDesaturated(false)
			rw.IconBorder:SetDesaturated(false)
		end
end
function module:AddMembers(frame)
  if not frame:IsVisible() then return end
  local stats=missionstats[frame]
  local members=missionmembers[frame]
  local threats=missionthreats[frame]
  if not stats or not members or not threats then
    -- Called out of sync, just ignore
    return
  end
	local start=GetTime()
	local mission=frame.info
  local missionID=mission and mission.missionID
  if not missionID then
--@debug@
    print("Missing mission or missionID for",frame:GetName(),mission)
--@end-debug@
    return
  end
	local nrewards=#mission.rewards
	local followers=mission.followers

	members:SetNotReady()
	members:SetPoint("RIGHT",frame.Rewards[nrewards],"LEFT",-5,0)
	if InProgress(frame.info,frame) then
		for i=1,3 do
		  local followerID=frame.info.followers[i]
		  if followerID then
        members.Champions[i]:SetFollower(followerID,false)
        members.Champions[i]:Show()
			else
  			members.Champions[i].followerID=nil
  			members.Champions[i]:Hide()
			end
		end
		frame.Overlay:SetFrameLevel(20)
		threats:Hide()
		local perc=select(4,G.GetPartyMissionInfo(missionID))
		stats.Chance:SetFormattedText(PERCENTAGE_STRING,perc)
		stats.Chance:SetTextColor(addon:GetDifficultyColors(perc,true))
		return
	end
	local lastkey=missionKEYS[missionID]
	local parties=addon:GetMissionParties(missionID)
	local party,key=parties:GetSelectedParty(lastkey)
	if not party then
	 party,key=parties:GetSelectedParty()
	end
	local ps=UNCAPPED_PERC
	if key ~= parties.xpkey then
		local bestchance,uncappedchance=parties:GetChanceForKey(key),parties:GetChanceForKey(parties.uncappedkey)
		ps=(bestchance==uncappedchance) and UNCAPPED_PERC or CAPPED_PERC
	end
  if type(mission.durationSeconds)~="number" then
	--@debug@
  	DevTools_Dump(mission)
	--@end-debug@
 		mission.durationSeconds=0
 	end
	if type(party.timeseconds)~="number" then
	--@debug@
		DevTools_Dump(party)
	--@end-debug@
		party.timeseconds=mission.durationSeconds
	end
	if party.timeseconds ~= mission.durationSeconds then
		local color=party.timeseconds > mission.durationSeconds and RED_FONT_COLOR_CODE or GREEN_FONT_COLOR_CODE
		frame.Summary:SetFormattedText(PARENS_TEMPLATE,color .. party.timestring .. FONT_COLOR_CODE_CLOSE)
	end
	local perc=party.perc or 0
	stats.Chance:SetFormattedText(ps,perc)
	stats.Chance:SetTextColor(addon:GetDifficultyColors(perc,true))
	missionKEYS[missionID]=key
	local emptymarker=UNUSED
	for i=1,mission.numFollowers do
		if party:Follower(i) then
		  missionNonFilled=false
      if select(2,members.Champions[i]:SetFollower(party:Follower(i),true)) then
				stats.Chance:SetTextColor(C.Grey())
			end
		else
			if i==1 then emptymarker = nil end
			members.Champions[i]:SetEmpty(emptymarker)
		end
		members.Champions[i]:Show()
	end
	for i=mission.numFollowers+1,3 do
			members.Champions[i]:Hide()
	end
	return self:AddThreats(frame,threats,party,missionID)
end
local function goodColor(good,bad)
	if type(bad)=="nil" then bad=not good end
	if good then return "green"
	elseif bad then return "red" else
	return "tear" end

end
local timeIcon="Interface/ICONS/INV_Misc_PocketWatch_01"
local killIcon="Interface/TARGETINGFRAME/UI-RaidTargetingIcon_8"
local lootIcon="Interface/TARGETINGFRAME/UI-RaidTargetingIcon_7"
local resurrectIcon="Interface/ICONS/Spell_Holy_GuardianSpirit"
local lockIcon="Interface/CHATFRAME/UI-ChatFrame-LockIcon"
local icons
function module:AddThreats(frame,threats,party,missionID)
  if not icons then icons=G.GetFollowerAbilityCountersForMechanicTypes(followerType) end
	threats:SetPoint("TOPLEFT",frame.Title,"BOTTOMLEFT",0,-5)
	threats:Show()
	local enemies=addon:GetMissionData(missionID,'enemies')
	if type(enemies)~="table" then
		enemies=G.GetMissionDeploymentInfo(missionID)['enemies']
	end
	local mechanics=new()
	local counters=new()
	local biases=new()
	for _,enemy in pairs(enemies) do
		if type(enemy.mechanics)=="table" then
			for _,mechanic in pairs(enemy.mechanics) do
			-- icon=enemy.mechanics[id].icon
			  --local mechanicID=enemy.mechanicTypeID
				mechanic.id=mechanic.mechanicTypeID
				mechanic.icon=mechanic.ability and mechanic.ability.icon or mechanic.icon
				mechanic.bias=mechanic.ability and mechanic.ability.bias or -1
				tinsert(mechanics,mechanic)
				print(mechanic.mechanicTypeID,mechanic.id,mechanic.name)
			end
		end
	end
	for i=1,#party do
    local followerID=party[i]
		if not G.GetFollowerIsTroop(followerID) then
			local followerBias = G.GetFollowerBiasForMission(missionID,followerID)
			tinsert(counters,("%04d,%s,%s,%f"):format(1000-(followerBias*100),followerID,G.GetFollowerName(followerID),followerBias))
		end
	end
	table.sort(counters)
	for _,data in pairs(counters) do
		local _,followerID,_,bias=strsplit(",",data)
		local abilities=G.GetFollowerAbilities(followerID)
		for _,ability in pairs(abilities) do
			for counter,info in pairs(ability.counters) do
				for _,mechanic in pairs(mechanics) do
					if mechanic.id==counter and not biases[mechanic] then
						biases[mechanic]=todefault(bias,0)
						break
					end
				end
			end
		end
	end
	tinsert(mechanics,false) -- separator
	local r,n,i=addon:GetResources()
	local baseCost, cost = party.baseCost or 0 ,party.cost or 0
	-- nobonusloot
	-- increasedcost
	-- increasedduration
	-- killtroops
	if cost>baseCost then
		tinsert(mechanics,new({icon=i,color="red",name=n,description=increasedcost}))
	end
	if cost<baseCost then
		tinsert(mechanics,new({icon=i,color="green",name=n,description=L["Cost reduced"]}))
	end
	if party.timeImproved then
		tinsert(mechanics,new({icon=timeIcon,color="green",name="Time",description=L["Mission duration reduced"]}))
		end
		if party.hasMissionTimeNegativeEffect then
		tinsert(mechanics,new({icon=timeIcon,color="red",name="Time",description=increasedduration}))
	end
	if party.troops > 0 and party.hasKillTroopsEffect then
		if addon:TroopsWillDieAnyway(party) then
			tinsert(mechanics,new({icon=killIcon,color="green",name=ENCOUNTER_JOURNAL_SECTION_FLAG4,description=killtroopsnodie}))
		else
			tinsert(mechanics,new({icon=killIcon,color="red",name=ENCOUNTER_JOURNAL_SECTION_FLAG4,description=killtroops}))
		end
	end
	if party.hasResurrectTroopsEffect then
		tinsert(mechanics,new({icon=resurrectIcon,color="green",name=RESURRECT,description=L["Resurrect troops effect"]}))
	end
	if party.hasBonusLootNegativeEffect then
		tinsert(mechanics,new({icon=lootIcon,color="red",name=LOOT,description=nobonusloot}))
	end
	threats:AddIcons(mechanics,biases)
	threats.Cost:Show()
	threats.Cost:SetWidth(0)
	threats.Cost:SetFormattedText(addon.resourceFormat,cost)
	local color=goodColor(cost>=r)
	if cost>r then
		threats.Cost:SetTextColor(C:Red())
	else
		threats.Cost:SetTextColor(C:Green())
	end
	threats.Cost:ClearAllPoints()
	threats.Cost:SetPoint("LEFT",frame.Summary,"RIGHT",5,0)
	local xp=party.totalXP or 0
	local gainers=party.xpGainers or 0
	if xp * gainers ~= 0 then
		threats.XP:SetFormattedText(XP_GAIN,xp/gainers,gainers)
		threats.XP:ClearAllPoints()
		threats.XP:SetPoint("LEFT",threats.Cost,"RIGHT",5,0)
		threats.XP:Show()
	else
		threats.XP:Hide()
	end
	del(mechanics)
	del(counters)
	del(biases)
end
function module:MissionTip(this)
	local tip=GameTooltip
	local info=this:GetParent().info
	local missionID=info.missionID
	tip:SetOwner(this,"ANCHOR_CURSOR")
	tip:AddLine(this:GetName())
	tip:AddDoubleLine(addon:GetAverageLevels())
	ChampionCommanderMixin.DumpData(tip,info)
	tip:AddLine("Followers")
	for i,id in ipairs(info.followers) do
		local rc,name = pcall(G.GetFollowerName,id)
		tip:AddDoubleLine(id,name)
	end
	local parties=addon:GetMissionParties(missionID)
	local key=missionKEYS[missionID]
	local party =parties:GetSelectedParty(key)
	local dataclass=addon:GetData('Troops')
	if party then
  	for i=1,#party do
      local id=party[i]
  		local rc,name = pcall(G.GetFollowerName,id)
  		tip:AddDoubleLine(id,name)
  	end
	end
	tip:AddLine("Rewards")
	for i,d in pairs(info.rewards) do
		tip:AddLine('['..i..']')
		ChampionCommanderMixin.DumpData(tip,info.rewards[i])
	end
	tip:AddLine("OverRewards")
	for i,d in pairs(info.overmaxRewards) do
		tip:AddLine('['..i..']')
		ChampionCommanderMixin.DumpData(tip,info.overmaxRewards[i])
	end
	tip:AddDoubleLine("MissionID",info.missionID)
	local mission=addon:GetMissionData(info.missionID)
	tip:AddDoubleLine("MissionClass",mission.missionClass)
	tip:AddDoubleLine("MissionValue",mission.missionValue)
	tip:AddDoubleLine("MissionSort",mission.missionSort)
	tip:Show()
end
local bestTimes={}
local bestTimesIndex={}
local emptyTable={}
function module:AdjustMissionTooltip(this,...)
	local tip=GameTooltip
	local missionID=this.info.missionID
--@debug@
	tip:AddDoubleLine("MissionID",missionID)
--@end-debug@
	if this.info.inProgress or this.info.completed then tip:Show() return end
	local parties=addon:GetMissionParties(missionID)
	local party,key=emptyTable,missionKEYS[missionID]
	if not this.info.isRare then
		tip:AddLine(GARRISON_MISSION_AVAILABILITY);
		tip:AddLine(this.info.offerTimeRemaining, 1, 1, 1);
	end
	tip:AddLine(me .. ' additions',C:Silver())
	if key ~= parties.xpkey then
		local bestchance,uncappedchance=parties:GetChanceForKey(key),parties:GetChanceForKey(parties.uncappedkey)
		if (bestchance ~= uncappedchance) then
			tip:AddDoubleLine(L["Mission was capped due to total chance less than"],addon:GetNumber("BONUSCHANCE"),C.Orange.r,C.Orange.g,C.Orange.b,C.Red())
			tip:AddDoubleLine("Maximum chance was",uncappedchance,C.Orange.r,C.Orange.g,C.Orange.b,addon:GetDifficultyColors(uncappedchance,true))
		end
	end
	if parties then
		party,key =parties:GetSelectedParty(key)
		if party then
--@debug@
			tip:AddDoubleLine("Base time",this.info.durationSeconds)
			tip:AddDoubleLine("Party time",party.timeseconds)
			tip:AddDoubleLine("Best Key",parties.bestkey)
			tip:AddDoubleLine("Xp Key",parties.xpkey)
			tip:AddDoubleLine("Uncapped Key",parties.uncappedkey)
			tip:AddDoubleLine("Selected Key",key)
--@end-debug@
			if party.hasBonusLootNegativeEffect then
				tip:AddLine(nobonusloot,C:Red())
			end
			if party.hasKillTroopsEffect then
				if addon:TroopsWillDieAnyway(party) then
					tip:AddLine(killtroopsnodie,C:Green())
				else
					tip:AddLine(killtroops,C:Red())
				end
			end
			if party.hasResurrectTroopsEffect then
				tip:AddLine(L["Resurrect troops effect"],C:Green())
			end
			if todefault(party.cost,0) > todefault(party.baseCost,0) then
				tip:AddLine(increasedcost,C:Red())
			end
			if party.hasMissionTimeNegativeEffect then
				tip:AddLine(increasedduration,C:Red())
			end
			if party.timeImproved then
				tip:AddLine(L["Duration reduced"],C:Green())
			end
			local r,n,i=addon:GetResources()
			if todefault(party.cost,0) > r then
				tip:AddLine(GARRISON_NOT_ENOUGH_MATERIALS_TOOLTIP,C:Red())
			end
			-- Not important enough to be specifically shown
			-- hasSuccessChanceNegativeEffect
			-- hasUncounterableSuccessChanceNegativeEffect
		end
	end
	if addon:IsBlacklisted(this.info.missionID) then
		tip:AddDoubleLine(L["Blacklisted"],safeformat(L["%s to remove from blacklist"],KEY_BUTTON2),1,0.125,0.125,C:Green())
		--GameTooltip:AddLine(L["Blacklisted missions are ignored in Mission Control"])
	else
		tip:AddDoubleLine(L["Not blacklisted"],safeformat(L["%s to blacklist"],KEY_BUTTON2),0.125,1.0,0.125,C:Red())
	end
	local keytext=addon:GetBoolean("QUICKSTART") and SHIFT_KEY_TEXT or CTRL_SHIFT_KEY_TEXT
	tip:AddLine(safeformat(L["%s start the mission without even opening the mission page. No question asked"],keytext .. ' ' .. KEY_BUTTON1))
	-- Mostrare per ogni tempo di attesa solo la percentuale migliore
	wipe(bestTimes)
	wipe(bestTimesIndex)
	key=key or "999999999999999999999"
	addon:BusyFor() -- with no parames resets cache
	for p=1,#parties.candidatesIndex do
	  local otherkey=parties.candidatesIndex[p]
		if otherkey < key then
		  local candidate=parties.candidates[otherkey]
			local duration=addon:BusyFor(candidate)
			if duration > 0 then
				local busy=false
				if addon:GetBoolean("USEALLY") then
					for _,c in candidate:IterateFollowers() do
						local rc,status = pcall(G.GetFollowerStatus,c)
						if rc and status and status==GARRISON_FOLLOWER_COMBAT_ALLY then
							busy=true
							break
						end
					end
				end
				if not busy then
					if not bestTimes[duration] or not bestTimes[duration].perc or bestTimes[duration].perc < candidate.perc then
						bestTimes[duration]=candidate
					end
				end
			end
		else
			break
		end
	end
  local now=GetTime()
	for t,p in pairs(bestTimes) do
  	if t > now then
  		tinsert(bestTimesIndex,t)
  	end
	end
	if #bestTimesIndex > 0 then
		tip:AddLine(L["Better parties available in next future"],C:Green())
		table.sort(bestTimesIndex)
		local bestChance=0
		for i=1,#bestTimesIndex do
			local key=bestTimesIndex[i]
			local candidate=bestTimes[key]
			if candidate.perc > bestChance and key > now then
				bestChance=candidate.perc
				tip:AddDoubleLine(SecondsToTime(key-now),GARRISON_MISSION_PERCENT_CHANCE:format(bestChance),C.Orange.r,C.Orange.g,C.Orange.b,addon:GetDifficultyColors(bestChance))
				for _,c in candidate:IterateFollowers() do
					local busy=G.GetFollowerMissionTimeLeftSeconds(c) or 0
					tip:AddDoubleLine(G.GetFollowerLink(c),SecondsToTime(busy),1,1,1,addon:GetDifficultyColors(busy/10))
				end
			end
		end
	end
--@debug@
  if addon:GetBoolean('EXTENDEDTIP') then
  	tip:AddLine("Mission Data")
  	for k,v in kpairs(parties) do
  		local color="Silver"
  		if type(v)=="number" then color="Cyan"
  		elseif type(v)=="string" then color="Yellow" v=v:sub(1,30)
  		elseif type(v)=="boolean" then v=v and 'True' or 'False' color="White"
  		elseif type(v)=="table" then color="Green" if v.GetObjectType then v=v:GetObjectType() else v=tostring(v) end
  		else v=type(v) color="Blue"
  		end
  		if k=="description" then v =v:sub(1,10) end
  		tip:AddDoubleLine(k,v,addon.colors("Orange",color))
  	end
  	tip:AddLine("Candidate Data")
  	for k,v in kpairs(party) do
  		local color="Silver"
  		if type(v)=="number" then color="Cyan"
  		elseif type(v)=="string" then color="Yellow" v=v:sub(1,30)
  		elseif type(v)=="boolean" then v=v and 'True' or 'False' color="White"
  		elseif type(v)=="table" then color="Green" if v.GetObjectType then v=v:GetObjectType() else v=tostring(v) end
  		else v=type(v) color="Blue"
  		end
  		if k=="description" then v =v:sub(1,10) end
  		tip:AddDoubleLine(k,v,addon.colors("Orange",color))
  	end
  end
--@end-debug@
	self:SafeAddMembers(this)
	tip:Show()
end
function module:RawMissionClick(this,button)
	local mission=this.info or this.missionInfo -- callable also from mission page
	local missionID = mission and mission.missionID
	if not missionID then return end
  if ChatEdit_TryInsertChatLink(G.GetMissionLink(missionID)) then return end
	local shift,ctrl=IsShiftKeyDown(),IsControlKeyDown()
	local key=missionKEYS[mission.missionID]
	if button=="LeftButton" and shift then
    if not addon:GetBoolean("QUICKSTART") and not addon.db.global.changedkeywarned then
      addon:Popup(safeformat(L["You now need to press both %s and %s to start mission"],SHIFT_KEY_TEXT,CTRL_KEY_TEXT))
      addon.db.global.changedkeywarned=true
    end
	  if ctrl or addon:GetBoolean("QUICKSTART") then
      return addon:GetAutopilotModule():FireMission(mission.missionID,this,true)
    else
      return self.hooks[this].OnClick(this,button)
    end
	end
	if button=="LeftButton" or button=="missionpage" then
		if button ~= "missionpage" then self.hooks[this].OnClick(this,button) end
		if( ctrl) then
			return self:Print("Ctrl key, ignoring mission prefill")
		else
			return addon:GetMissionpageModule():FillMissionPage(mission,key)
		end
	elseif button=="RightButton" and not addon:GetBoolean("NOBLACKLIST") then
		addon.db.profile.blacklist[mission.missionID]= not addon.db.profile.blacklist[mission.missionID]
		GameTooltip:Hide()
		missionIDS[this]=nil
		--addon:RefreshMissions()
		if addon:IsBlacklisted(mission.missionID) then
			self:Dim(this)
		else
			self:UnDim(this)
		end
--@debug@
		print("Calling OHF:UpdateMissions")
--@end-debug@
		OHF:UpdateMissions()
		this:GetScript("OnEnter")(this)
--@debug@
	elseif button=="MiddleButton" then
		if (shift) then
			DevTools_Dump(this.info)
		else
			addon:TestParty(mission.missionID)
		end

		return
--@end-debug@
	end
end


