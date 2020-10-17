local __FILE__=tostring(debugstack(1,2,0):match("(.*):1:")) -- Always check line number in regexp and file, must be 1
--@debug@
print('Loaded',__FILE__)
--@end-debug@
local function pp(...) print(GetTime(),"|cff009900",__FILE__:sub(-15),strjoin(",",tostringall(...)),"|r") end
--*TYPE module
--*CONFIG noswitch=false,profile=true,enhancedProfile=true
--*MIXINS "AceHook-3.0","AceEvent-3.0","AceTimer-3.0","AceSerializer-3.0","AceConsole-3.0"
--*MINOR 35
-- Auto Generated
local me,ns=...
if ns.die then return end
local addon=ns --#Addon (to keep eclipse happy)
ns=nil
local module=addon:NewSubModule('Matchmaker',"AceHook-3.0","AceEvent-3.0","AceTimer-3.0","AceSerializer-3.0","AceConsole-3.0")  --#Module
function addon:GetMatchmakerModule() return module end
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
local function safecat(...)
  return strjoin(' ',tostringall(...))
end
addon.lastChange=GetTime()
local matchtimer={time=0,count=0}
local lethalMechanicEffectID = 437;
local cursedMechanicEffectID = 471;
local slowingMechanicEffectID = 428;
local disorientingMechanicEffectID = 472;
local debugMission=0
local function parse(default,rc,...)
	if rc then
		return ...
	else
	--@debug@
		error(message,2)
	--@end-debug@
		return default
	end
end

local meta={
__index = function(t,key)
	return function(...) return parse(nil,pcall(C_Garrison[key],...)) end end
}
--upvalues
local assert,ipairs,pairs,wipe,GetFramesRegisteredForEvent=assert,ipairs,pairs,wipe,GetFramesRegisteredForEvent
local select,tinsert,setmetatable,coroutine=select,tinsert,setmetatable,coroutine
local tostringall,strsplit,strjoin=tostringall,strsplit,strjoin
local emptyTable=setmetatable({},{__newindex=function() end})
local holdEvents
local releaseEvents
local events={stacklevel=0,frames={}} --#events
function events.hold() --#eventsholdEvents
	if events.stacklevel==0 then
		events.frames={GetFramesRegisteredForEvent('GARRISON_FOLLOWER_LIST_UPDATE')}
		for i=1,#events.frames do
			events.frames[i]:UnregisterEvent("GARRISON_FOLLOWER_LIST_UPDATE")
		end
	end
	events.stacklevel=events.stacklevel+1
end
function events.release()
	events.stacklevel=events.stacklevel-1
	assert(events.stacklevel>=0)
	if (events.stacklevel==0) then
		for i=1,#events.frames do
			events.frames[i]:RegisterEvent("GARRISON_FOLLOWER_LIST_UPDATE")
		end
		events.frames=nil
	end
end
holdEvents=events.hold
releaseEvents=events.release
local maxtime=3600*24*7
-- Candidate management
local CandidateManager={perc=0,chance=0} --#CandidateManager
local CandidateMeta={__index=CandidateManager}
local emptyCandidate=setmetatable({},CandidateMeta)
local inProgressCandidate=setmetatable({},CandidateMeta)
function CandidateManager:IterateFollowers()
	return ipairs(self)
end
function CandidateManager:Follower(index)
	return self[index]
end
local busyCache={}
function addon:BusyFor(candidate)
	if not candidate then wipe(busyCache) return end
	local busyUntil=0
	local now=GetTime()
	local never=now+7*24*3600
	for _,followerID in candidate:IterateFollowers() do
	 local rc, status = pcall(G.GetFollowerStatus,followerID)
	  if not rc or status== GARRISON_FOLLOWER_INACTIVE then
	   return never
	  end
		if not busyCache[followerID] then
			busyCache[followerID]=now + (G.GetFollowerMissionTimeLeftSeconds(followerID) or 0)
		end
		if busyCache[followerID]>busyUntil then
			busyUntil=busyCache[followerID]
		end
	end
	return busyUntil
end
function addon:TroopsWillDieAnyway(candidate)
	for i=1,#candidate do
		if candidate['f' .. i] >= "T" then
			local followerID=candidate[i]
			if self:GetFollowerData(followerID,'durability',3)>1 then
				return false
			end
		end
	end
	return true
end

-- Party management
local partyManager={} --#PartyManager
local missionParties={}
local partiesPool=CreateObjectPool(
	function(self) return setmetatable({},{__index=partyManager}) end,
	function(self,obj)
		local c=obj.candidates
		local ci=obj.candidatesIndex
		if ci then wipe(ci) else ci ={} end
		if c then wipe(c) else c={} end
		wipe(obj)
		obj.candidates=c
		obj.candidatesIndex=ci
	end

)

--	addon:RegisterForMenu("mission","SAVETROOPS","SPARE","MAKEITQUICK","MAXIMIZEXP")
function partyManager:Fail(reason,...)
  self.failed=true
	self:SetReason(safecat(reason,...))
	return false,reason
end
function partyManager:SetReason(reason)
  if not self.current.reason then
    self.current.reason=reason
  end
end

function partyManager:SatisfyCondition(candidate,index)
	local missionID=self.missionID
	if addon:IsBanned(index,missionID) then
		return self:Fail("Slot banned")
	end
	if type(candidate) ~= "table" then return self:Fail("NOTABLE") end
	local followerID=candidate[index]
	if not followerID then return self:Fail("No follower id for party slot",index) end
	local fType,troopkey,value,slot=strsplit('|',candidate['f'..index])
	if fType=="T" then
		if self.noTroops then return self:Fail("NOTROOPS") end
    local ban="BAN" .. (strsplit('@',troopkey))
    if addon:GetBoolean(ban) then return self:Fail("Troop banned") end
		if candidate.hasKillTroopsEffect and self.dontKillTroops then return self:Fail("WOULDKILLTROOPS") end
		local durability
		if self.saveTroops and candidate.hasKillTroopsEffect then durability = 1 end
		if self.dontKillTroops then durability= -2 end
		followerID=addon:GetTroop(troopkey,slot or 1,missionID,durability,self.ignoreBusy)
		if followerID then candidate[index]=followerID return true,'OK' else return false,"NOAVAILABLETROOPS" end
	else
		local reserved=addon:IsReserved(followerID)
		if reserved then
			-- Always increment because, when reserved is not equal missionID we refuse the whole party
			candidate.reservedChampions=candidate.reservedChampions +1
			return reserved==missionID
		end
		self.lastChecked=followerID
	end
	local status=G.GetFollowerStatus(followerID)
	if status then
		if addon:GetBoolean("USEALLY") and status==GARRISON_FOLLOWER_COMBAT_ALLY then
			return true
		end
		if not addon:GetBoolean('IGNOREBUSY') and status==GARRISON_FOLLOWER_ON_MISSION then
			return true
		end
		if not addon:GetBoolean('IGNOREINACTIVE') and status==GARRISON_FOLLOWER_INACTIVE then
			return true
		end
		return self:Fail("BUSY",status,G.GetFollowerName(followerID))
	end
	return true,'OK'
end
function partyManager:IterateIndex()
	--self:GenerateIndex()
	return ipairs(self.candidatesIndex)
end
local function describe(...)
	local s=''
	for i=1,select('#',...) do
		local f=addon:GetFollowerData(select(i,...))
		if f then
			if f.IsTroop then
				s=s .. tostring(f.followerID)
			else
				s=s .. tostring(f.name and f.name or f.followerID)
			end
			s=s .. ' '
		end
	end
	return s
end
function partyManager:CheckCaps(index)
	local candidate=self.candidates[self.candidatesIndex[index]]
	local chance=candidate.perc
	if chance <= self.capChance then -- Cap requisite satisfied
		if chance >= self.bonusChance then -- beats bonusChance, we take this one
			return candidate.key
		else
			self.capChance=100 -- We failed achieving bonus, so now we cap at 100
			if chance >=self.baseChance and chance <=self.capChance then
				return candidate.key
			elseif chance<self.baseChance then
				-- we are too low, so we need to go back in the chain and find someting better than baseChance even if over cap
				for k=index-1,1,-1 do
					local candidate=self.candidates[self.candidatesIndex[k]]
					if candidate and candidate.good and (self.maximizeXP or candidate.champions <= self.maxChampions) and candidate.perc >= self.baseChance then
						return candidate.key
					end
				end
				return candidate.key
			end
		end
	end
end
function partyManager:CheckParty(candidate)
	candidate.good=false
	local key,chance=candidate.key,candidate.perc
	local missionID=self.missionID
	if not self.elite and chance < self.minChance then return end
	if type(self.numFollowers) ~= "number" then
		self.numFollowers=addon:GetMissionData(missionID,"numfollowers",3)
	end
	if addon:GetBoolean("SPARE") and candidate.cost > candidate.baseCost then return self:Fail("SPARE",addon:GetBoolean("SPARE"),candidate.cost , candidate.baseCost) end
	if addon:GetBoolean("MAKEITVERYQUICK") and not candidate.timeImproved then return self:Fail("VERYQUICK") end
	if addon:GetBoolean("MAKEITQUICK") and candidate.hasMissionTimeNegativeEffect then return self:Fail("QUICK") end
	if addon:GetBoolean("BONUS") and candidate.hasBonusLootNegativeEffect then return self:Fail("BONUS") end
	local mandatoryfound=0
	for j=1,#candidate do
		if not self:SatisfyCondition(candidate,j) then return end
	end
	for _,mandatory in ipairs(self.mandatoryFollowers) do
		if not tContains(candidate,mandatory) then
			return self:Fail("NOMANDATORY")
		end
	end
	self.candidates[key].good=true -- This party is good, we now check caps
	return key
end
function partyManager:GetChanceForKey(key)
	local candidate=self.candidates[key]
	return candidate and candidate.perc or 0
end
function partyManager:Cap(perc,key)
  if perc == self.capChance then
    -- Allelujah just found a perfect match. We are done
     self.cappedkey=key
     self.bestcappedfound=true
  elseif perc >= self.bonusChance and perc < self.capChance then
     -- We didnt found a perfetc match so here we look for something which is not overcapping AND in allowable bonus
     self.cappedkey=key
     self.bestcappedfound=true
  elseif perc == 100 then
     -- We didnt found anything between requested bonus and cap, so a 100% match is a perfect capped nmatch
     self.cappedkey=key
     self.bestcappedfound=true
  elseif perc > 100 then
    -- Alas, no uncapped perfect nor capped perfect
  -- We get as candidate any key which is over 100
  -- but will continue lowering it
     self.cappedkey=key
  end
  if perc < 100 and perc >=self.baseChance then
    if not self.overCap  then
      self.cappedkey=key
    end
    self.bestcappedfound=true
  end
  return self.bestcappedfound
end
function partyManager:GetSelectedParty(key,dbg)
	-- When we receive a key we MUST return the selected party, no question asked
	if type(key)=="string" and self.candidates[key] then
		return self.candidates[key],key
	end
	if #self.candidatesIndex ==0 then return self.candidates["EMPTY"],"EMPTY" end
	local missionID=self.missionID
	local xpgainers=0
	self.maximizeXP=addon:GetBoolean("MAXIMIZEXP")
	self.minChance=addon:GetNumber("MINCHANCE")
	self.baseChance=addon:GetNumber("BASECHANCE")
	self.bonusChance=self.elite and 100 or addon:GetNumber("BONUSCHANCE")
	self.ignoreBusy=addon:GetBoolean("IGNOREBUSY")
	self.noTroops=addon:GetBoolean("NOTROOPS")
	self.saveTroops=addon:GetBoolean("SAVETROOPS")
	self.dontKillTroops=addon:GetBoolean("NEVERKILLTROOPS")
	self.capChance=self.elite and 100 or 200
	self.maxXp=0
	self.bestkey,self.xpkey,self.absolutebestkey,self.lastkey,self.uncappedkey,self.cappedkey=nil,nil,nil,nil,nil,nil
	self.mandatoryFollowers=new()
	self.lastreason='GOOD'
	self.maxChampions=addon:GetNumber("MAXCHAMP")
	self.bestcappedfound=false
	self.mandatoryFollowers=addon:GetReservedFollowers(missionID)
	self.overCap=self.elite and addon:GetBoolean("ELITEOVERCAP") or false
	for i=1,#self.candidatesIndex do
		local candidate=self.candidates[self.candidatesIndex[i]]
		self.current=candidate
		if candidate then
			local key = candidate.key
			candidate.reservedChampions=0
			if self:CheckParty(candidate) then
				if candidate.perc <= self.capChance and candidate.totalXP >self.maxXp then
					self.maxXp=candidate.totalXP
					self.xpkey=key
				end
				if candidate.champions > math.max(candidate.reservedChampions,self.maxChampions) then
					self:Fail(format("%d champions, ony %d allowed",candidate.champions,self.maxChampions))
				else
				  self:SetReason("Acceptable")
					if not self.uncappedkey then self.uncappedkey=key end
           -- If already found the best capped or if the current key has same chance of the previous one
           -- we dont go in cap search
					if not self.bestcappedfound and self:GetChanceForKey(self.cappedkey)~=self:GetChanceForKey(key) then
            self:Cap(candidate.perc,candidate.key)
					end
					if not self.bestkey then self.bestkey=key end
					self.lastkey=key
				end
			end
--@debug@
			if dbg then
				print(i,candidate.key,candidate.reason)
			end
--@end-debug@
		end
    candidate.busyUntil=addon:BusyFor(candidate)

	end -- for i,key in ipairs(self.candidatesIndex) do
	self.current=nil
	del(self.mandatoryFollowers,false)
	self.mandatoryFollowers=nil
	local selected
	if self.maximizeXP and self.xpkey then
    self.candidates[self.xpkey].reason="Best xp value"
		selected = self.candidates[self.xpkey]
  elseif self.cappedkey then
    selected = self.candidates[self.cappedkey]
	elseif self.bestkey then
		selected = self.candidates[self.bestkey]
	elseif self.lastkey then
		--if self.candidates[lastkey].busyUntil <= GetTime() then
			selected = self.candidates[self.lastkey] -- should not return busy followers
		--end
	else
		selected = self.candidates["EMPTY"]
	end
	self.bestChance=selected.perc or 0
	self.bestTimeseconds=selected.timeseconds or 0
	return selected,selected.key
end
function partyManager:Remove(...)
	local tbl=...
	if type(tbl)=="table" then
		for i =1,#tbl do
			local id=tbl[i]
			if type(id)=="table" then id=id.followerID end
			local rc,message=pcall(G.RemoveFollowerFromMission,self.missionID,id)
		end
	else
		for i=1,select('#',...) do
			local rc,message=pcall(G.RemoveFollowerFromMission,self.missionID,(select(i,...)))
		end
	end
end
function partyManager:GetEffects()
	local timestring,timeseconds,timeImproved,chance,buffs,missionEffects,xpBonus,materials,gold=G.GetPartyMissionInfo(self.missionID)
	if not missionEffects then missionEffects={} end
	missionEffects.timestring=timestring
	missionEffects.timeseconds=timeseconds
	missionEffects.perc=chance or 0
	missionEffects.timeImproved=timeImproved
	missionEffects.xpBonus=xpBonus
	missionEffects.materials=materials
	missionEffects.gold=gold

	local improvements=5
	if timeImproved then improvements=improvements -1 end
	if missionEffects.hasMissionTimeNegativeEffect then improvements=improvements+1 end
	missionEffects.baseCost,missionEffects.cost=G.GetMissionCost(self.missionID)
	if missionEffects.baseCost and missionEffects.cost then
		if missionEffects.baseCost < missionEffects.cost then
			improvements=improvements+2
		elseif missionEffects.baseCost > missionEffects.cost then
			improvements=improvements-1
		end
	end
	if missionEffects.hasKillTroopsEffect then
		improvements=improvements+2
	end
	missionEffects.improvements=improvements
	return missionEffects

end
function partyManager:Build(...)
	local missionID=self.missionID
	self.numFollowers=self.numFollowers or G.GetMissionMaxFollowers(missionID)
	local followers=new()
	local troopcost,xpGainers,champions,troops=0,0,0,0
	local assigned=select('#',...)
	if assigned>0 then
		for i=1,self.numFollowers or 3 do
			local s=select(i,...)
			if s then
				local fType,followerID,value,slot=strsplit('|',s)
				value=tonumber(value) or 0
				if fType=='T' then
					slot=tonumber(slot) or 1
					followerID=addon:GetTroop(followerID,slot)
					if not followerID then print(s,"not converted") end
				end
				if followerID then
					local rc,res = pcall(G.AddFollowerToMission,missionID,followerID)
					if not rc or not res then
						self:Remove(followers)
						del(followers)
						return
					end
					tinsert(followers,followerID)
					if fType=="H" then -- Champion
						champions=champions+1
						if value < addon:MAXQLEVEL() then
							xpGainers=xpGainers+1
						end
					else
						troops=troops +1
						troopcost=troopcost + value + addon:GetFollowerData(followerID,"maxDurability",2) *10 + addon:GetFollowerData(followerID,'quality',2)
					end
				end
			end
		end
	end
	local missionEffects=self:GetEffects()
	missionEffects.xpGainers=xpGainers
	missionEffects.totalXP=(todefault(missionEffects.bonusXP,0) + todefault(self.baseXP,0))*(missionEffects.xpGainers or 0)
	if missionEffects.perc >= 200 then
	 missionEffects.totalXP=missionEffects.totalXP * 2
	end
	missionEffects.champions=champions
	missionEffects.troops=troops
	missionEffects.troopcost=troopcost
	self.unique=self.unique+1
	for i=1,#followers do
		local id=followers[i]
		if id then tinsert(missionEffects,id) end
	end
	for i=1,assigned do
		local id=select(i,...)
		if id then missionEffects['f' .. i]=id end
	end
	local index=format("%04d:%1d:%3d:%1d:%1d:%1d:%2d %3d",
		1000-missionEffects.perc,
		#missionEffects,
		999-troopcost,
		missionEffects.improvements,
		missionEffects.champions,
		3-missionEffects.xpGainers,
		missionEffects.perc,
		self.unique)
	if #missionEffects==0 then index="EMPTY" end
	missionEffects.key=index
	self.candidates[index]=setmetatable(missionEffects,CandidateMeta)
	self:Remove(followers)
	del(followers)
	return index
end

--
function partyManager:Match()
	local missionID=self.missionID
	if not missionID then print("Missing missionID",self) return false end
	local mission=addon:GetMissionData(missionID)
	if not mission then print("Missing mission ",missionID,self)return false end
	self.name=mission.name
	wipe(self.candidates)
	self.unique=0
	local t=C_Garrison.GetMissionDeploymentInfo(missionID)
	local baseXP=t.xp
	local exhausting=t.isExhausting 
	self.numFollowers=mission.numFollowers or G.GetMissionMaxFollowers(missionID)
	self.exhausting=exhausting
	self.elite=mission.elite
	self.baseXP=baseXP or 0
	self.rewardXP=(mission.class=="FollowerXP" and mission.value) or 0
	self.totalXP=self.baseXP+self.rewardXP
	local n
	local p=addon:GetFullPermutations()
	for i=1,#p do
		local tuple=p[i]
		local total,f1,f2,f3=strsplit(',',tuple)
		if tonumber(total) > self.numFollowers then break end
		self:Build(f1,f2,f3)
		n=i
	end
	self:Build()
	self:GenerateIndex()
	return true
end
function partyManager:GenerateIndex()
	wipe(self.candidatesIndex)
	for k,_ in pairs(self.candidates) do
		tinsert(self.candidatesIndex,k)
	end
	table.sort(self.candidatesIndex)
end
function module:OnInitialized()
	addon:AddLabel(L["Missions"],L["Configuration for mission party builder"])
	addon:AddBoolean("SAVETROOPS",false,L["Counter kill Troops"],L["Always counter kill troops (ignored if we can only use troops with just 1 durability left)"])
	addon:AddBoolean("NEVERKILLTROOPS",false,L["Never kill Troops"],L["Makes sure that no troops will be killed"])
  addon:AddBoolean("NOTROOPS",false,L["Don't use troops"],L["Only use champions even if troops are available"])
	addon:AddBoolean("PREFERHIGH",false,L["Prefer high durability"],L["Uses troops with the highest durability instead of the ones with the lowest"])
	addon:AddBoolean("BONUS",true,L["Keep extra bonus"],L["Always counter no bonus loot threat"])
	addon:AddBoolean("SPARE",false,L["Keep cost low"],L["Always counter increased resource cost"])
	addon:AddBoolean("MAKEITQUICK",true,L["Keep time short"],L["Always counter increased time"])
	addon:AddBoolean("MAKEITVERYQUICK",false,L["Keep time VERY short"],L["Only accept missions with time improved"])
	addon:AddBoolean("MAXIMIZEXP",false,L["Maximize xp gain"],L["Favours leveling follower for xp missions"])
	addon:AddRange("MAXCHAMP",3,1,3,L["Max champions"],L["Use at most this many champions"],1)
	addon:AddRange("BONUSCHANCE",100,100,200,L["Bonus Chance"],
	safeformat(L["If %1$s is lower than this, then we try to achieve at least %2$s without going over 100%%. Ignored for elite missions."],
	 L["Bonus Chance"],L["Base Chance"]),
	5)
	addon:AddRange("BASECHANCE",0,0,120,L["Base Chance"],safeformat(L["When we cant achieve the requested %1$s, we try to reach at least this one without (if possible) going over 100%%"],L["Bonus Chance"]),5)
  addon:AddBoolean("ELITEOVERCAP",true,L["Elite: Prefer overcap"],L["For elite missions, tries hard to not go under 100% even at cost of overcapping"])
	addon:AddBoolean("USEALLY",false,L["Use combat ally"],L["Combat ally is proposed for missions so you can consider unassigning him"])
	addon:AddBoolean("IGNOREBUSY",true,L["Ignore busy followers"],L["When no free followers are available shows empty follower"])
	addon:AddBoolean("IGNOREINACTIVE",true,L["Ignore inactive followers"],L["If not checked, inactive followers are used as last chance"])
	addon:RegisterForMenu("mission",
		"SAVETROOPS",
		"NEVERKILLTROOPS",
		'NOTROOPS',
		'PREFERHIGH',
		"BONUS",
		"SPARE",
		"MAKEITQUICK",
		"MAKEITVERYQUICK",
		"MAXIMIZEXP",
		'MAXCHAMP',
    'BONUSCHANCE',
		'BASECHANCE',
		'ELITEOVERCAP',
		'USEALLY',
		'IGNOREBUSY',
		'IGNOREINACTIVE')
end
function module:ResetParties()
	partiesPool:ReleaseAll()
	wipe(missionParties)
end
function addon:HoldEvents()
	return holdEvents()
end
function addon:ReleaseEvents()
	return releaseEvents()
end
function addon:GetSelectedParty(missionID,key)
	if addon:GetMissionData(missionID,"inProgress") then return emptyTable,"progress" end
	return self:GetMissionParties(missionID):GetSelectedParty(key)
end
function addon:ResetParties()
	return module:ResetParties()
end
--@debug@
local cache={}
function addon:TestParty(missionID)
	local parties=self:GetMissionParties(missionID)
	wipe(cache)
	tinsert(cache,addon:GetMissionData(missionID,'name',missionID))
	local title=G.GetMissionName(missionID)
	self:Print("Debug for ", title)
	local choosen,choosenkey=parties:GetSelectedParty()
	self:Print(choosenkey)
	if ViragDevTool_AddData then
		ViragDevTool_AddData({_title=title,_key=choosenkey,data=parties.candidates},"Mission debug " .. title)
		parties:GetSelectedParty(true)
	end
end
--@end-debug@

function addon:GetMissionParties(missionID)
	if not missionParties[missionID] then
		missionParties[missionID]=partiesPool:Acquire()
		missionParties[missionID].missionID=missionID
	end
	return missionParties[missionID]
end
function addon:GetAllMissionParties()
	return missionParties
end
function addon:RefillParties()
	local i=0
	collectgarbage("stop")
	holdEvents()
	addon:GetFullPermutations(true)
	partiesPool:ReleaseAll()
	wipe(missionParties)
	for n=1,#OHFMissions.availableMissions do
		self:GetMissionParties(OHFMissions.availableMissions[n].missionID):Match()
		i=n
	end
	releaseEvents()
	collectgarbage("restart")
	return i
end
function module:ProfileStats()
	addon:LoadProfileData(partyManager,"Matchmaker")
end
