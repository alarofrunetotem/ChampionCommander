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
local module=addon:NewSubModule('Cache',"AceHook-3.0","AceEvent-3.0","AceTimer-3.0")  --#Module
function addon:GetCacheModule() return module end
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
local CATEGORY_INFO_FORMAT=GARRISON_LANDING_COMPLETED:gsub("%%d/%%d","%%d/%%d %%d")
local CATEGORY_INFO_FORMAT_SHORT="%d/%d %d " .. READY
local CATEGORY_INFO_FORMAT_VERY_SHORT="%d/%d (%d) "
local pairs,math,wipe,tinsert,GetTime,next,ipairs,strjoin=pairs,math,wipe,tinsert,GetTime,next,ipairs,strjoin
local GARRISON_FOLLOWER_INACTIVE=GARRISON_FOLLOWER_INACTIVE
local AVAILABLE=AVAILABLE
local GARRISON_FOLLOWER_COMBAT_ALLY=GARRISON_FOLLOWER_COMBAT_ALLY
local GARRISON_FOLLOWER_ON_MISSION=GARRISON_FOLLOWER_ON_MISSION
local GARRISON_FOLLOWER_IN_PARTY=GARRISON_FOLLOWER_IN_PARTY
local missionsRefresh,followersRefresh=0,0
local volatile={
followers={
xp=G.GetFollowerXP,
levelXP=G.GetFollowerLevelXP,
quality=G.GetFollowerQuality,
level=G.GetFollowerLevel,
isMaxLevel=function(followerID)	return G.GetFollowerLevelXP(followerID)==0 end,
prettyName=G.GetFollowerLink,
iLevel=G.GetFollowerItemLevelAverage,
status=G.GetFollowerStatus,
busyUntil=function(followerID) return GetTime() + (G.GetFollowerMissionTimeLeftSeconds(followerID) or 0) end
},
missions={
}
}--- Caches

--
local currency
local currencyName
local currencyTexture
local resources=0
local id2index={f={},m={}}
local avgLevel,avgIlevel=0,0
local cachedFollowers={}
local cachedMissions={}
local categoryInfo
local shipmentInfo={}
local emptyTable=setmetatable({},{__newindex=function() end})
local methods={available='GetAvailableMissions',inProgress='GetInProgressMissions',completed='GetCompleteMissions'}
local catPool={}
local function fillCachedMission(mission,time)
	if not time then time=GetTime() end
	local _,baseXP,_,_,_,_,exhausting,enemies=G.GetMissionInfo(mission.missionID)
	mission.exhausting=exhausting
	mission.baseXP=baseXP
	mission.enemies=enemies
	mission.lastUpdate=time
	mission.available=not mission.inProgress
end
local function getCachedMissions()
	if not next(cachedMissions) then
		local time=GetTime()
		for property,method in pairs(methods) do
			local missions=G[method](followerType)
			for i=1,#missions do
				local mission=missions[i]
				mission[property]=true
				fillCachedMission(mission,time)
				cachedMissions[mission.missionID]=mission
			end
		end
	end
	return cachedMissions
end
local function getCachedFollowers()
	if empty(cachedFollowers) then
		local followers=G.GetFollowers(followerType)
		if type(followers)=="table" then
			local time=GetTime()
			for i=1,#followers do
				local follower=followers[i]
				if follower.isCollected and follower.status ~= GARRISON_FOLLOWER_INACTIVE then
					cachedFollowers[follower.followerID]=follower
					cachedFollowers[follower.followerID].lastUpdate=time
					cachedFollowers[follower.followerID].busyUntil=volatile.followers.busyUntil(follower.followerID)
				end
			end
		end
	end
	return cachedFollowers
end
function module:GetAverageLevels(cached)
	if avgLevel==0 or not cached then
		local level,ilevel,tot=0,0,0
		local f=getCachedFollowers()
		for i,d in pairs(f) do
			if d.isCollected and not d.isTroop then
				tot=tot+1
				level=level+self:GetKey(d,'level',0)
				ilevel=ilevel+self:GetKey(d,'iLevel',0)
			end
		end
		avgLevel,avgIlevel=math.floor(level/tot),math.floor(ilevel/tot)
	end
	return avgLevel,avgIlevel
end
function module:DeleteFollower(followerID)
	if followerID and cachedFollowers[followerID] then
		del(cachedFollowers[followerID])
	end
end
function module:BuildFollower(followerID)
	local f=getCachedFollowers()
	if f[followerID] then
		f[followerID].busyUntil=volatile.followers.busyUntil(followerID)
		return
	end
	local rc,data=pcall(G.GetFollowerInfo,followerID)
	if rc then
		if data and data.isCollected then
			data.lastUpdate=GetTime()
			data.busyUntil=volatile.followers.busyUntil(data.followerID)
			cachedFollowers[followerID]=data
		elseif data then
			del(data,true)
		end
	end
end
function module:BuildMission(missionID,followerID)
	local rc,data=pcall(G.GetFollowerInfo,followerID)
	if rc then
		if data and data.isCollected then
			data.lastUpdate=GetTime()
			data.busyUntil=volatile.followers.busyUntil(data.followerID)
			cachedFollowers[followerID]=data
		elseif data then
			del(data,true)
		end
	end
end
--@debug@
function module:GetFollower(key)
	if (key:sub(1,2)=='0x') then
		key="0x" .. ("0000000000000000" ..key:sub(3)):sub(-16)
		return self:GetFollowerData(key)
	end
	for _,data in pairs(getCachedFollowers()) do
		if data.name:find(key)==1 then
			return data
		end
	end
end
--@end-debug@
local indexes={followers={},missions={}}
local followerCache={}
local followerCacheUpdate=GetTime()
local emptyFollower={}
local function rebuildFollowerIndex()
	wipe(indexes.followers)
	for i = 1,#followerCache do
		indexes.followers[followerCache[i].followerID]=i
		indexes.followers[followerCache[i].name]=i
	end
end
--- Return followerdata-
-- Available fields:
--
-- * classAtlas
-- * className
-- * classSpec
-- * displayHeight
-- * displayIDs = { followerPageScale=1,showWeapon=true,id=68026 }
-- * durability
-- * followerID
-- * followerTypeID (4)
-- * garrFollowerID
-- * height
-- * iLevel
-- * isCollected
-- * isFavorite
-- * isTroop
-- * level
-- * levelXP
-- * name
-- * portraitIconID
-- * quality
-- * scaled
-- * slotSoundKitID
-- * xp
-- Calculated fields
-- * qLevel
-- * busyUntil
--
--
local function GetFollowers()
	if not empty(OHFFollowerList.followers) then return  OHFFollowerList.followers end
	return G.GetFollowers(LE_FOLLOWER_TYPE_GARRISON_7_0) or emptyTable
end

function module:GetFollowerData(followerID,field,defaultValue)
	if empty(followerCache) then
		addon:RefreshFollowers()
	end
	if not followerID then return followerCache end
	local followerIndex=indexes.followers[followerID]
	local pointer=followerCache[followerIndex]
	if not pointer or pointer.followerID~=followerID then
		addon:RefreshFollowers()
	end
	followerIndex=indexes.followers[followerID]
	pointer=followerCache[followerIndex] or emptyFollower
	if empty(pointer) then
		return field and defaultValue or nil
	end
	if not field then return pointer end
	if pointer[field] then
		return pointer[field]
	else
		if field=="qLevel" then
			return pointer.level+(pointer.level==MAX_LEVEL and pointer.quality or 0)
		elseif field=="busyUntil" then
			return GetTime() + (G.GetFollowerMissionTimeLeftSeconds(followerID) or 0)
		end
		return defaultValue
	end
end
--	local list=inProgress and m.inProgressMissions or m.availableMissions
-- OHF.MissionTab.MissionList
local emptyMissions={}
local missionCacheIndex={}
local function scanList(map,id)
	if map=="completedMissions" then
	end
	local list=OHFMissions[map]
	if type(list)~="table" then return end
	for i=1,#list do
		local key=format("%d,%s",i,map)
		missionCacheIndex[id]=key
		if list[i].missionID==id then
			return list[i]
		end
	end
end
local function getMissionFromBlizzardData(cache,missionID)
	local key=missionCacheIndex[missionID]
	if key then
		local index,map=strsplit(',',key)
		local t=OHFMissions[map]
		index=tonumber(index)
		if t[index] and t[index].missionID==missionID then
			return t[index]
		end
	end
	return scanList("availableMissions",missionID) or scanList("inProgressMissions",missionID) or scanList("completedMissions",missionID) or emptyMissions
end
local missionCache=setmetatable({},{__index=
		function(t,key)
			return getMissionFromBlizzardData(t,key)
		end
	}
)
local classOrder=setmetatable({
	["0"]=10,
	["1342"]=11,
	Artifact=20,
	Equipment=30,
	Quest=40,
	Upgrades=50,
	Reputation=60,
	PlayerXP=70,
	FollowerXP=80,
	Generic=99999
},{
	__index=function(t,k) if type(k)=="number" then
		t[k]=k
		return k % 100000
		else
			return 99999
		end
	end
})
local function GetItemQuality(itemid)
	local _,_,quality=GetItemInfo(itemid)
	return quality and quality or 0
end
local function Reward2Class(self,mission)
	if type(mission)=="number" then mission=addon:GetMissionData(mission) end
	if not mission then return "Generic",0,0 end
	local overReward=mission.overmaxRewards
	if not overReward then overReward=mission.OverRewards end
	local reward=mission.rewards
	if not reward then reward=mission.Rewards end
	if type(overReward)=="table" then
		overReward=overReward[1]
	else
		overReward=emptyTable
	end
	if type(reward)=="table" then
		reward=reward[1]
	else
		return "Generic",1
	end
	if not overReward then overReward = emptyTable end
	if reward.currencyID then
		local qt=reward.currencyID==0 and reward.quantity/10000 or reward.quantity
		return reward.currencyID,math.floor(qt)
	elseif reward.followerXP then
			return "FollowerXp",reward.followerXP
	elseif type(reward.itemID) == "number" then
		local artifactPower=self.allArtifactPower[reward.itemID]
		if artifactPower then
			return "Artifact",artifactPower or 1
		elseif overReward.itemID==1447868 then
			return "PlayerXP",1
		elseif overReward.itemID==141344 then
			return "Reputation",1
		elseif tContains(self:GetData('Equipment'),reward.itemID) then
			return "Equipment",GetItemInfo(reward.itemID) or 0
		elseif tContains(self:GetData("Upgrades"),reward.itemID) then
			return "Upgrades",1
		elseif tContains(self:GetData("Upgrades"),reward.itemID) then
			return "Upgrades2",2
		elseif tContains(self:GetData("Upgrades"),reward.itemID) then
			return "Upgrades3",3
		elseif tContains(self:GetData("Upgrades"),reward.itemID) then
			return "Upgrades4",4
		else
			local class,subclass=select(12,GetItemInfo(reward.itemID))
			class=class or -1
			if class==12 then
				return "Quest",1
			elseif class==7 then
				return "Reagent",reward.quantity or 1
			end
		end
	end
	return "Generic",reward.quantity or 1
end
function addon:Reward2Class(mission)
	local missionID=type(mission)=="table" and mission.missionID or mission
	if not missionID then return "generic,0,99" end
	local class,value=Reward2Class(self,mission)
	return strjoin(',',tostringall(class,value,classOrder[tostring(class)]))
end
--- Retrieves mission data.
-- Uses tables already loaded by Blizzard and works on both inProgress and availableMissions
-- Possibile fields
-- * description
-- * cost
-- * locPrefix
-- * followers -- empty in availableMissions
-- * areaID
-- * overmaxRewards
-- * hasBonusEffect
-- * isMaxLevel
-- * name
-- * canStart
-- * typeAtlas
-- * followerTypeID
-- * offeredGarrMissionTextureID
-- * durationSeconds
-- * odderTimeRemaining formatted time
-- * inProgress
-- * offerEndTime timestamp
-- * mapPosY
-- * type
-- * ilevel
-- * duration (formatted)
-- * completed
-- * basecost
-- * missionID
-- * numFollowers
-- * requiredSuccessChance
-- * rewards
-- * mapPosX
-- * requiredChampionCount
-- Pseudo fields
-- * class
-- * classValue
-- * classOrder
-- * elite
-- * baseXP
-- * exhausting
-- * enemies
-- Calcolated field manager
local mt={
	__index=function(mission,field)
		local missionID=rawget(mission,'missionID')
		if not missionID then return end
		if field=="class" or field=='classValue' then
			mission.class,mission.classValue=strsplit(',',addon:Reward2Class(mission.missionID))
		elseif field=="classOrder" then
			return classOrder[mission.class]
		elseif field=="elite" then
			mission.elite = empty(mission.overmaxRewards)
		elseif field=="baseXP" or field =="enemies" or field=="exhausting" then
			local _,baseXP,_,_,_,_,exhausting,enemies=G.GetMissionInfo(mission.missionID)
			mission.baseXP=addon:todefault(baseXP,0)
		end
		return rawget(mission,field)
	end
}
function module:GetMissionData(missionID,field,defaultValue)
	if not missionID then return OHFMissions.availableMissions end
	local mission=setmetatable(missionCache[missionID],mt)
	if not field then return mission end
	if field then
		if empty(mission[field]) then
			return defaultValue
		end
		return mission[field]
	else
		return defaultValue
	end
end


function module:GetKey(data,key,defaultvalue)
-- some keys need to be fresh only if champions is not maxed

	if volatile[key] and not data[key] then
		data[key]=volatile[key](data.followerID)
	end
	if key=='status' and data.status=="refresh" then
		data.status=G.GetFollowerStatus(data.followerID)
	end
	if data[key] then return data[key] end
	-- pseudokeys
	if key=="qLevel" then
		return data.isMaxLevel and data.quality+data.level or data.level
	end
	assert("Invalid pseudo key " .. tostring(key))
	return defaultvalue
end
function module:Clear()
	wipe(cachedFollowers)
	wipe(cachedMissions)
end
local function alertSetup(frame,name,...)
	GarrisonFollowerAlertFrame_SetUp(frame,FAKE_FOLLOWERID,...)
	frame.Title:SetText(name)
	return frame
end
local TroopsHeader
function module:GetTroopsFrame()
	if not TroopsHeader then
		local frame=CreateFrame("Frame",nil,OHF,"TooltipBorderedFrameTemplate")
		frame.Background:Hide()
		frame.Top=frame:CreateTexture(nil,"BACKGROUND",nil,-1)
		frame.Top:SetPoint("TOPLEFT")
		frame.Top:SetPoint("BOTTOMRIGHT")
		frame.Top:SetAtlas("_StoneFrameTile-Top")
		frame:SetHeight(35)
		frame:ClearAllPoints()
		frame:SetPoint("BOTTOMLEFT",OHF,"BOTTOMLEFT",0,-2)
		frame:SetPoint("BOTTOMRIGHT",OHF,"BOTTOMRIGHT",2,-2)
    frame:EnableMouse(true)
		frame:RegisterForDrag("LeftButton")
		frame:SetScript("OnDragStart",function(frame) if addon:GetBoolean('MOVEPANEL') then OHF:StartMoving() end end)
		frame:SetScript("OnDragStop",function(frame) OHF:StopMovingOrSizing() end)
		frame:Show()
		frame.Buttons={}
		TroopsHeader=frame
	end
	return TroopsHeader
end

function module:ParseFollowers()
  G.RequestClassSpecCategoryInfo(followerType)
	G.RequestLandingPageShipmentInfo();
end
local function paintCat(frame)
  if addon:GetBoolean(frame.key) then
    frame.Count:SetTextColor(C.red())
    frame.Icon:SetDesaturated(true)
  else
    frame.Count:SetTextColor(C.green())
    frame.Icon:SetDesaturated(false)
  end
end
local data={}
function module:DrawKrokuls(main)
  --if true then return end
  if #data==0 then
    for _,n in ipairs(addon:GetData("Krokuls")) do
      tinsert(data,n)
    end
    for _,n in ipairs(addon:GetData("Class")) do
      tinsert(data,n)
    end
  end

  for i=1,#data do
    local id=data[i]
    local b=main.Buttons[i]
    if not b then b=CreateFrame("Button",nil,OHF,"BFAUpgradeButton,SecureActionbuttonTemplate")
      main.Buttons[i]=b
      b:EnableMouse(true)
      b:RegisterForClicks("LeftButtonDown")
      b:SetScript("PostClick",function()
        module:DrawKrokuls(main)
        --module:DrawTroopStatus(main)
      end)
      b:SetAttribute("type","item")
      b.Quantity:SetFontObject("GameFontNormalShadowHuge2")
      b:SetScale(0.65)
    end
    addon:DrawButton(b,id)
    if i==1 then
      b:SetPoint("TOPLEFT",0,-120)
    else
      b:SetPoint("TOP",main.Buttons[i-1],"BOTTOM",0,-10)
    end
    b:Show()
  end
end
function module:xDrawTroopStatus(main)
  categoryInfo = G.GetClassSpecCategoryInfo(followerType)
  DevTools_Dump(categoryInfo)
  if not OHF:IsVisible() then return end
  local prevCategory, firstCategory;
  local nCategories=_G.XX or #categoryInfo
  if nCategories < 1 then return end
  local previous
  local mask=nCategories <5 and CATEGORY_INFO_FORMAT or nCategories <7 and CATEGORY_INFO_FORMAT_SHORT or CATEGORY_INFO_FORMAT_VERY_SHORT
  local margin=45
  local W=main:GetWidth() - (margin + 15)
  local w=W/nCategories
  for i=1,nCategories do
    local category=categoryInfo[i]
    local index=category.classSpec
    local frame = catPool[i];
    if not frame then
      frame=CreateFrame("Button","FollowerIcon",main,"BFATroop")
      catPool[i]=frame
      frame:EnableMouse(true)
      frame:RegisterForDrag("LeftButton")
      frame:SetScript("OnDragStart",function(frame) if addon:GetBoolean('MOVEPANEL') then OHF:StartMoving() end end)
      frame:SetScript("OnDragStop",function(frame) OHF:StopMovingOrSizing() end)
      frame:SetScript("OnClick",function(frame) local value=not addon:GetBoolean(frame.key) addon:SetVar(frame.key,value) paintCat(frame) addon:Apply(frame.key,value) end)
      frame.OnEnter=frame:GetScript("OnEnter")
      frame:SetScript("OnEnter",function(frame)
        frame:OnEnter()
        if addon:GetBoolean(frame.key) then
          GameTooltip:AddLine(KEY_BUTTON1 .. " " .. C(ENABLE,"green"))
        else
          GameTooltip:AddLine(KEY_BUTTON1 .. " " .. C(DISABLE,"red"))
        end
        GameTooltip:Show()
      end)
    end
    if not shipmentInfo[category.icon] then
      shipmentInfo[category.icon]={0,0}
    end
    frame.key="BAN"..index
    frame.Icon:SetTexture(category.icon);
    frame.Icon:SetTexCoord(0, 1, 0.25, 0.75)
    frame.TroopPortraitCover:Hide()
    frame.Icon:SetHeight(15)
    frame.Icon:SetWidth(30)
    frame.name = category.name;
    frame.description = category.description;
    frame.Count:SetFormattedText(mask,category.count, category.limit,unpack(shipmentInfo[category.icon]));
    frame.Count:SetWidth(frame.Count:GetStringWidth()+30)
    frame:ClearAllPoints();
    local padding  = math.max(w,frame.Count:GetWidth())
    frame:SetWidth(padding)
    paintCat(frame)
    frame:SetPoint("TOPLEFT",margin +(w) *(i-1), 0);
    frame:Show();
  end
end
function module:GARRISON_FOLLOWER_CATEGORIES_UPDATED()
  --local main=self:GetTroopsFrame()
  --self:DrawTroopStatus(main)
  --self:DrawKrokuls(main)
end
function addon:ParseFollowers()
	return module:ParseFollowers()
end
local ChampionCommanderAlertSystem=AlertFrame:AddSimpleAlertFrameSubSystem("BFAAlertFrameTemplate", alertSetup)
local shownAlerts={}
function module:GARRISON_LANDINGPAGE_SHIPMENTS()
	if not addon:GetBoolean('TROOPALERT') then return end
	if (not G.IsPlayerInGarrison(garrisonType)) then return end
	local followerShipments = G.GetFollowerShipments(garrisonType);
	for _,t in pairs(shipmentInfo) do
		t[1]=0
		t[2]=0
	end
	for i = 1, #followerShipments do
		local name, texture, shipmentCapacity, shipmentsReady, shipmentsTotal, creationTime, duration, timeleftString, _, _, _, _, followerID = C_Garrison.GetLandingPageShipmentInfoByContainerID(followerShipments[i]);
		if name and shipmentCapacity > 0 then
			shipmentInfo[texture]=shipmentInfo[texture] or {}
			shipmentInfo[texture][1]=shipmentsReady
			shipmentInfo[texture][2]=shipmentsTotal
			local signature=strjoin(':',name,shipmentsReady)
			if not shownAlerts[signature] then shownAlerts[signature]=GetTime()+15 end
			if shipmentsReady > 0 then
				if GetTime()>shownAlerts[signature] then
					shownAlerts[signature]=GetTime()+60
					ChampionCommanderAlertSystem:AddAlert(name, GARRISON_LANDING_COMPLETED:format(shipmentsReady,shipmentsTotal), 110, 0, false,
						{isTroop=true,followerTypeID=4,portraitIconID=texture,quality=1}
					)
				end
			end
		end
	end

end
function module:Refresh(event,...)
	if (event == "CURRENCY_DISPLAY_UPDATE") then
		resources = select(2,GetCurrencyInfo(currency))
		return
	elseif event=="GARRISON_FOLLOWER_REMOVED" or
			event=="GARRISON_FOLLOWER_ADDED" then
		return self:ParseFollowers()
	elseif event=="GARRISON_FOLLOWER_LIST_UPDATE" or
			event=="GARRISON_MISSION_STARTED" or
			event=="GARRISON_MISSION_FINISHED" or
			event=="GARRISON_MISSION_COMPLETE_RESPONSE" then
		return addon:RefreshFollowerStatus()
	end
end
function module:OnInitialized()
  LoadAddOn("Blizzard_OrderHallUI")
	currency, _ = C_Garrison.GetCurrencyTypes(garrisonType);
	currencyName, resources, currencyTexture = GetCurrencyInfo(currency);
--@debug@
	print("Currency init",currencyName, resources, currencyTexture)
--@end-debug@
	addon.resourceFormat=COSTS_LABEL .." %d"
	self:ParseFollowers()
end
function module:Events()
	self:RegisterEvent("CURRENCY_DISPLAY_UPDATE","Refresh")
	self:RegisterEvent("GARRISON_FOLLOWER_REMOVED","Refresh")
	self:RegisterEvent("GARRISON_FOLLOWER_LIST_UPDATE","Refresh")
	self:RegisterEvent("GARRISON_FOLLOWER_ADDED","Refresh")
	self:RegisterEvent("GARRISON_MISSION_STARTED","Refresh")
	self:RegisterEvent("GARRISON_MISSION_FINISHED","Refresh")
	self:RegisterEvent("GARRISON_MISSION_COMPLETE_RESPONSE","Refresh")
	self:RegisterEvent("GARRISON_MISSION_LIST_UPDATE","Refresh")
	self:RegisterEvent("GARRISON_LANDINGPAGE_SHIPMENTS")
--  self:RegisterEvent("GARRISON_FOLLOWER_CATEGORIES_UPDATED")
end
function module:EventsOff()
	self:UnregisterAllEvents()
	self:RegisterEvent("GARRISON_LANDINGPAGE_SHIPMENTS")
end
---- Public Interface
--
function addon:GetResources(refresh)
	if refresh then
		resources = select(2,GetCurrencyInfo(currency))
	end
	return resources,currencyName,currencyTexture
end
function addon:GetMissionData(...)
	return module:GetMissionData(...)
end
function addon:RefreshFollowers()
	followerCache=G.GetFollowers(followerType)
	rebuildFollowerIndex()
--@debug@
	print("Followeres refreshed:",#followerCache)
--@end-debug@
end
function addon:GetFollowerData(...)
	return module:GetFollowerData(...)
end
function addon:GetFollower(...)
	return module:GetFollower(...)
end
function addon:GetFollowerName(id)
	if not id then return "none" end
	local rc,error=pcall(G.GetFollowerName,id)
	return strconcat(tostringall(id,'(',error,')'))
end
function addon:GetFollowerNames(...)
  local s=""
  for i=1,select('#',...) do
    s= s .. self:GetFollowerName(select(i,...))
  end
end

local fullPermutations={}
local classTroops={}
local classDurability={}
local function isGood(missionID,follower,durability,ignoreBusy)
	local followerID=follower.followerID
	local reserved=addon:IsReserved(followerID)
	if reserved then return reserved==missionID end
	if ignoreBusy then
		if G.GetFollowerStatus(followerID) then
			return false
		end
	end
	if not durability then return true end
	if durability < 0 then
		return follower.durability >= math.abs(durability)
	else
		return follower.durability <= durability
	end
	return false
end
local troopCosts={}
function addon:GetTroopCost(classSpec)
	if not troopCosts[classSpec] then
		local t=G.GetClassSpecCategoryInfo(followerType)
		for i=1,#t do
			troopCosts[t[i].classSpec]=t[i].limit * 100
		end
	end
	return troopCosts[classSpec] or 0
end
local function sortLow(a,b)
	return module:GetFollowerData(a,'durability',0) < module:GetFollowerData(b,'durability',0)
end
local function sortHigh(a,b)
	return module:GetFollowerData(a,'durability',0) > module:GetFollowerData(b,'durability',0)
end
function addon:SortTroop()
	local f=addon:GetBoolean("PREFERHIGH") and sortHigh or sortLow
	for _,tipo in pairs(classTroops) do
		table.sort(tipo,f)
	end
end
function addon:GetTroop(troopkey,slot,missionID,durability,ignoreBusy)
	local troops=classTroops[troopkey]
	slot=slot or 1
	if not troops then return end -- No troops for this spec
	if not ignoreBusy and not durability and not missionID then -- no more check requested
		return troops[slot]
	end
	for i=1,#troops do
		local followerID=troops[i]
		for j=1,1 do -- Used to break out from elaboration (I miss "continue")
			if not self:IsUsable(missionID,followerID) then break end
			if ignoreBusy and module:GetFollowerData(followerID,'status') then break end
			if durability then
				local d=module:GetFollowerData(followerID,'durability',0)
				if durability < 0 then
					if d < math.abs(durability) then break end
				else
					if  d > durability then break end
				end
			end
			-- Didnt break out so this is a good one
			if slot == 1 then
				return followerID
			else
				slot=1 -- max 2 troop for mission, so when I found a good one, the next one is good
			end
		end
	end
end
function addon:EmptyPermutations()
  return #fullPermutations==0
end
function addon:GetFullPermutations(dowipe)
	if dowipe then wipe(fullPermutations) end
	if #fullPermutations==0 then
    self:RefreshFollowers()
		for _,v in pairs(classTroops) do wipe(v) end
		local seen=new()
		local all=new()
		local t=module:GetFollowerData()
		for i=1,#t do
			local f=t[i]
			if f.isCollected then
				if f.isTroop then
				  local abilities=G.GetFollowerAbilities(f.followerID)
          local abi=new()
				  for i=1,#abilities do
				    tinsert(abi,abilities[i].id)
				  end
				  table.sort(abi)
				  local troopkey=strjoin('@',f.classSpec,unpack(abi))
				  del(abi)
					if not classTroops[troopkey] then
						classTroops[troopkey]={}
					end
					tinsert(classTroops[troopkey],f.followerID)
					if not seen[troopkey] then
						tinsert(all,strjoin('|','T',troopkey,self:GetTroopCost(f.classSpec)))
						seen[troopkey]=1
					else
						seen[troopkey]=seen[troopkey] +1
					end
				else
					tinsert(all,strjoin('|','H',f.followerID,f.level+(f.level==MAX_LEVEL and f.quality or 0)))
				end
			end
		end
		table.sort(all) -- We need champions first and a predictable order
--@debug@
		for x=1,1 do
--@end-debug@
		for i=1,#all do
			local class,id,value=strsplit('|',all[i])
			if class=="T" then -- champions ended, troops only parties are invalid
				break
			end
			tinsert(fullPermutations,'1,' .. all[i])
			for j=i+1,#t do
				if all[j] then
					local class,id,value=strsplit('|',all[j])
					tinsert(fullPermutations,'2,'.. strjoin(',',all[i],all[j]))
					if class=="T" and seen[id] > 1 then
						-- I only see a classSpec once. Here if i know I have more than one troop for this spec, i force
						-- a combination with both of them
						tinsert(fullPermutations,'3,'.. strjoin(',',all[i],all[j],all[j] .. '|2'))
					end
				end
				for k=j+1,#t do
					if all[k] then
						tinsert(fullPermutations,'3,'.. strjoin(',',all[i],all[j],all[k]))
					end
				end
			end
		end
--@debug@
		end
--@end-debug@
		table.sort(fullPermutations)
		del(all)
		del(seen)
	end
	return fullPermutations
end
function addon:DumpPermutations()
	addon:Dump("Permutations",fullPermutations)
end

local function isInParty(followerID)
	return G.GetFollowerStatus(followerID)==GARRISON_FOLLOWER_IN_PARTY
end

function addon:RebuildMissionCache()
	wipe(cachedMissions)
	getCachedMissions()
end
function addon:RebuildFollowerCache()
	wipe(cachedFollowers)
	getCachedFollowers()
end
function addon:RebuildAllCaches()
	self:RebuildFollowerCache()
	self:RebuildMissionCache()
end

function addon:GetAverageLevels(...)
	return module:GetAverageLevels(...)
end
local s=setmetatable({},{__index=function(t,k) return 0 end})
local CHAMPIONS_STATUS_FORMAT= FOLLOWERLIST_LABEL_CHAMPIONS .. ":" ..
							C(AVAILABLE..':%d ','green') ..
							C(GARRISON_FOLLOWER_COMBAT_ALLY .. ":%d ",'cyan') ..
							C(GARRISON_FOLLOWER_ON_MISSION .. ":%d ",'red') ..
							C(GARRISON_FOLLOWER_INACTIVE .. ":%d","silver")
local TROOPS_STATUS_FORMAT= FOLLOWERLIST_LABEL_TROOPS .. ":" ..
							C(AVAILABLE..':%d ','green') ..
							C(GARRISON_FOLLOWER_ON_MISSION .. ":%d ",'red')
function addon:RefreshFollowerStatus()
	if not OHF:IsVisible() then return end
	wipe(s)
	local followers=module:GetFollowerData()
	if type(followers)~="table" then
	--@debug@
		print("GetFollowerData returned",followers)
	--@end-debug@
		return
	end
	for i=1,#followers do
		local follower=followers[i]
		if follower.isCollected then
			local status=follower.status or AVAILABLE
			s[status]=s[status]+1
			if follower.isTroop then
				s['TROOP_'..status]=s['TROOP_'..status]+1
			else
				s['CHAMP_'..status]=s['CHAMP_'..status]+1
			end
		end
	end
	if (OHF.ChampionsStatusInfo) then
		OHF.ChampionsStatusInfo:SetWidth(0)
		OHF.ChampionsStatusInfo:SetFormattedText(
			CHAMPIONS_STATUS_FORMAT,
			s['CHAMP_' .. AVAILABLE],
			s[GARRISON_FOLLOWER_COMBAT_ALLY],
			s['CHAMP_' .. GARRISON_FOLLOWER_ON_MISSION],
			s[GARRISON_FOLLOWER_INACTIVE]
			)
	end
	if (OHF.TroopsStatusInfo) then
		OHF.TroopsStatusInfo:SetWidth(0)
		OHF.TroopsStatusInfo:SetFormattedText(
			TROOPS_STATUS_FORMAT,
			s['TROOP_' .. AVAILABLE],
			s['TROOP_' .. GARRISON_FOLLOWER_ON_MISSION]
			)
	end
end
function addon:GetTotFollowers(status)
	if not status then
		return s[AVAILABLE]+
			s[GARRISON_FOLLOWER_COMBAT_ALLY]+
			s[GARRISON_FOLLOWER_ON_MISSION]
	else
		return s[status] or 0
	end
end
local startedCacheMission
function addon:CacheStartedMission(missionID,t)


end
