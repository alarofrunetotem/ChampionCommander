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
local module=addon:NewSubModule('Autopilot',"AceHook-3.0","AceEvent-3.0","AceTimer-3.0")  --#Module
function addon:GetAutopilotModule() return module end
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
local OHFMissions=BFAMissionFrame.MissionTab.MissionList -- same as OrderHallMissionFrameMissions Call Update on this to refresh Mission Listing
local OHFFollowerTab=BFAMissionFrame.FollowerTab -- Contains model view
local OHFFollowerList=BFAMissionFrame.FollowerList -- Contains follower list (visible in both follower and mission mode)
local OHFFollowers=BFAMissionFrameFollowers -- Contains scroll list
local OHFMissionPage=BFAMissionFrame.MissionTab.MissionPage -- Contains mission description and party setup
local OHFMapTab=BFAMissionFrame.MapTab -- Contains quest map
local OHFCompleteDialog=BFAMissionFrameMissions.CompleteDialog
local OHFMissionScroll=BFAMissionFrameMissionsListScrollFrame
local OHFMissionScrollChild=BFAMissionFrameMissionsListScrollFrameScrollChild
local followerType=LE_FOLLOWER_TYPE_GARRISON_8_0
local garrisonType=LE_GARRISON_TYPE_8_0
local FAKE_FOLLOWERID="0x0000000000000000"
local MAX_LEVEL=110

local ShowTT=OrderHallCommanderMixin.ShowTT
local HideTT=OrderHallCommanderMixin.HideTT

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
local LE_FOLLOWER_TYPE_GARRISON_7_0=LE_FOLLOWER_TYPE_GARRISON_7_0
local LE_GARRISON_TYPE_7_0=LE_GARRISON_TYPE_7_0
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
local wipe,pcall,pairs,IsShiftKeyDown,IsControlKeyDown=wipe,pcall,pairs,IsShiftKeyDown,IsControlKeyDown
local PlaySound,SOUNDKIT=PlaySound,SOUNDKIT
local OHFButtons=OHFMissions.listScroll.buttons

local safeguard={}
function module:Cleanup()
	for followerID,missionID in pairs(safeguard) do
		pcall(G.RemoveFollowerFromMission,missionID,followerID)
	end
	wipe(safeguard)
end
function module:GARRISON_MISSION_STARTED(event,missionType,missionID)
	if missionType == LE_FOLLOWER_TYPE_GARRISON_7_0 then
		self:UnregisterEvent("GARRISON_MISSION_STARTED")
		local mission=G.GetBasicMissionInfo(missionID)
		addon:UnReserveMission(missionID)
		-- Remove used followers from safeguad
		for i=1,#mission.followers do
			safeguard[mission.followers[i]]=nil
		end
		-- safeguard should be empty now
		self:Cleanup()
	end
end
local truerun
local multiple
function module:RunMission()
	truerun=IsShiftKeyDown() or IsControlKeyDown()
	multiple=IsControlKeyDown()
	return self:DoRunMissions()
end
function module:DoRunMissions()
	local baseChance=addon:GetNumber('BASECHANCE')
	wipe(safeguard)
	local nothing=true
	for i=1,#OHFButtons do
		local frame=OHFButtons[i]
		local mission=frame.info
		local missionID=mission and mission.missionID
		if missionID then
			if not addon:IsBlacklisted(missionID) and addon:HasReservedFollowers(missionID) then
				nothing=false
				local key=addon:GetMissionKey(missionID)
				local party=addon:GetMissionParties(missionID):GetSelectedParty(key)
				local members = addon:GetMembersFrame(frame)
				addon:Print(safeformat(L["Attempting %s"],C(mission.name,'orange')))
				 
				local info=""
				for i=1,#members.Champions do
					local followerID=members.Champions[i]:GetFollower()
					if followerID then
						safeguard[followerID]=missionID
						local rc,res = pcall(G.AddFollowerToMission,missionID,followerID)
						if rc then
							info=info .. G.GetFollowerLink(followerID)
						else
							addon:Print(C(L["Unable to start mission, aborting"],"red"))
							self:Cleanup()
							break
						end
					end
				end
				local timestring,timeseconds,timeImproved,chance,buffs,missionEffects,xpBonus,materials,gold=G.GetPartyMissionInfo(missionID)
        
				if party.perc < chance then
					addon:Print(C(L["Could not fulfill mission, aborting"],"red"))
					self:Cleanup()
					break
				end
        local r,n,i=addon:GetResources(true)
        if select(2,G.GetMissionCost(missionID)) > r then
          addon:Print(C(GARRISON_NOT_ENOUGH_MATERIALS_TOOLTIP,"red"))
          self:Cleanup()
          break
        end
				
				nothing=false
				if truerun then
					self:RegisterEvent("GARRISON_MISSION_STARTED")
					G.StartMission(missionID)						
					addon:Print(C(L["Started with "],"green") ..info)
					PlaySound(SOUNDKIT.UI_GARRISON_COMMAND_TABLE_MISSION_START)
					--@debug@
					dprint("Calling OHF:UpdateMissions")  
					--@end-debug@
					OHFFollowerList.dirtyList=true
					OHFFollowerList:UpdateFollowers();	
					OHFMissions:UpdateMissions()						
					--@debug@												
					if multiple then
					  addon:Print("Multiple is running")
						self:ScheduleTimer("DoRunMissions",1)
					end
					--@end-debug@
					break
				else
					addon:Print(C(L["Would start with "],"green") ..info)
					addon:Print(C(safeformat(L["%s to actually start mission"],SHIFT_KEY_TEXT .. KEY_BUTTON1),"green"))
					self:Cleanup()
				end
			end
		end
	end
	if nothing and not multiple then
		addon:Print(C(L["No suitable missions. Have you reserved at least one follower?"],"red"))
	end
	multiple=true
end
function module:FireMission(missionID,frame,truerun)
  if not addon:IsBlacklisted(missionID)  then
    local baseChance=addon:GetNumber('BASECHANCE')
    local key=addon:GetMissionKey(missionID)
    local party=addon:GetMissionParties(missionID):GetSelectedParty(key)
    local members = addon:GetMembersFrame(frame)
    if party.perc >= baseChance or addon:GetBoolean("QUICKSTART") then
      local info=""
      for i=1,#members.Champions do
        local followerID=members.Champions[i]:GetFollower()
        if followerID then
          safeguard[followerID]=missionID
          local rc,res = pcall(G.AddFollowerToMission,missionID,followerID)
          if rc then
            info=info .. G.GetFollowerLink(followerID)
          else
            addon:Print(C(L["Unable to start mission, aborting"],"red"))
            self:Cleanup()
            break
          end
        end
      end
      local timestring,timeseconds,timeImproved,chance,buffs,missionEffects,xpBonus,materials,gold=G.GetPartyMissionInfo(missionID)
      if party.perc < chance then
        addon:Print(C(L["Could not fulfill mission, aborting"],"red"))
        self:Cleanup()
        return true
      end
      local r,n,i=addon:GetResources(true)
      if select(2,G.GetMissionCost(missionID)) > r then
        addon:Print(C(GARRISON_NOT_ENOUGH_MATERIALS_TOOLTIP,"red"))
        self:Cleanup()
        return true
      end
      if truerun then
        self:RegisterEvent("GARRISON_MISSION_STARTED")
        G.StartMission(missionID)           
        addon:Print(C(L["Started with "],"green") ..info)
        PlaySound(SOUNDKIT.UI_GARRISON_COMMAND_TABLE_MISSION_START)
        --@debug@
        dprint("Calling OHF:UpdateMissions")  
        --@end-debug@
        OHFFollowerList.dirtyList=true
        OHFFollowerList:UpdateFollowers();  
        OHFMissions:UpdateMissions()            
        return
      else
        addon:Print(C(L["Would start with "],"green") ..info)
        addon:Print(C(safeformat(L["%s to actually start mission"],SHIFT_KEY_TEXT .. KEY_BUTTON1),"green"))
        self:Cleanup()
      end
    else
      addon:Print(C(safeformat(L["%1$d%% lower than %2$d%%. Lower %s"],party.perc,baseChance,L["Base Chance"]),"red"))
    end
  end
end

