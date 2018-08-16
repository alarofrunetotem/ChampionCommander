local __FILE__=tostring(debugstack(1,2,0):match("(.*):1:")) -- Always check line number in regexp and file, must be 1
--@debug@
print('Loaded',__FILE__)
--@end-debug@
local function pp(...) print(GetTime(),"|cff009900",__FILE__:sub(-15),strjoin(",",tostringall(...)),"|r") end
--*TYPE module
--*CONFIG profile=true,enhancedProfile=true
-- Auto Generated
local me,ns=...
if ns.die then return end
local addon=ns --#Addon (to keep eclipse happy)
ns=nil
local module=addon:NewSubModule('Data')  --#Module
function addon:GetDataModule() return module end
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
local fake={}
local data={
	ArtifactNotes={
		146745
	},
	U850={
		136412, -- Heavy Armor Set +5 (capped 850)
		137207, -- Fortified Armor Set +10 (capped 850)
		137208, -- Indestructible Armor Set +15 (capped 850)

	},
	U880={
		153005, -- Relinquished Armor Set 800
	},
	U900={
    147348, -- Bulky Armor Set +5 (capped 900(
    147349, -- Spiked Armor Set +10 (capped 900)
    147350, -- Invincible Armor Set +15 (capped 900)
    151842, -- Krokul Armor Set 900
	},
	U925={
	 151843, -- Mac'Aree Armor Set 925
	},
	U950={
		151844, -- Xenedar Armor Set 950
	},
	Buffs={
		140749, -- Horn of Winter Increases Chance
		143852, -- Lucky Rabbit's Foot Increases Chance
		139419, -- Golden Banana Increases Chance
		140760, -- Libram of Truth Increases Chance
		140156, -- Blessing of the Order Increases Chance
		139428, -- A Master Plan Increases Chance
		143605, -- Strange Ball of Energy Increases Chance
		139177, -- Shattered Soul +1 vitality 
		139420, -- Wild Mushroom +1 vitality
		138883, -- Meryl's Conjured Refreshment +1 vitality
		139376, -- Healing Well +1 vitality
		139418, -- Healing Stream Totem +1 vitality
		138412, -- Iresoul's Healthstone +1 vitality
		--140922, -- Imp Pact Summon
		--139670, -- Scream of the Dead Summon
    --143849, -- Summon Royal Guard Summon
    --143850, -- Summon Grimtotem Warrior Summon
		--142209, -- Dinner Invitation Summon
	},
	Xp={
		141028, -- Grimoire of Knowledge
	},
	Krokuls={
	 152095, -- Krokul Ridgestalke
   152096, -- Void-Purged Krokul
   152097, -- Lightforged Bulwark
	},
	ANY={
	 143605, -- Strange Ball of Energy
	 142209, --  Dinner Invitation
	},
	DEATHKNIGHT={
	 140767, -- Pile of Bits and Bones
	 140749, -- Horn of Winter
	},
	DEMONHUNTER={
	 143849, -- Summon Royal Guard
	 139177, -- Shattered Soul
	},
	DRUID={
	 139420, --  Wild Mushroom
	},
	HUNTER={
	},
	MAGE={
	 138883, --  Meryl's Conjured Refreshment
	 143852, -- Lucky Rabbit's Foo
	},
	MONK={
	 139419, -- Golden Banana
	},
	PALADIN={
	 140760, -- Libram of Truth 
	 140929, -- Squire's Oath
	},
	PRIEST={
	 139376, -- Healing Well
	 140156, -- Blessing of the order
	},
	ROGUE={
	 139428, -- A Master Plan 
	 140931, -- Bandit wanted poster
	},
	SHAMAN={
	 143850, -- Summon Grimtotem Warrior
	 139418, -- Healing Stream Totem
	 140932, -- Earthen Mark
	},
	WARLOCK={
	 138412, -- Iresoul's Healthstone
   140922, -- Imp Pact 
	},
	WARRIOR={
	 139670, --  Scream of the Dead
	},
	Class={},
	Equipments={}
}
local icon2item={}
local itemquality={}
function addon:GetData(key)
	key=key or "none"
	return data[key] or fake
end
local tickle
function module:OnInitialized()
  data.Equipments=addon.allEquipments
  local cs=data[select(2,UnitClass("player"))]
  if cs then
    data.Class=cs
  end
  for _,i in ipairs(data.ANY) do
    tinsert(data.Class,i)
  end
	--@debug@
	DevTools_Dump(data.Class)
	addon:Print("Starting coroutine")
	--@end-debug@
	addon.coroutineExecute(module,0.1,"TickleServer")
end
local GetItemIcon=GetItemIcon
local GetItemInfo=GetItemInfo
local pcall=pcall
function module:AddItem(itemID)

end
function addon:GetItemIdByIcon(iconid)
  if not icon2item[iconid] then icon2item[iconid] = select(2,pcall,GetItemIcon,iconid) end 
	return icon2item[iconid]
end
function addon:GetItemQuality(itemid)
  if not itemquality[itemid] then itemquality[itemid] = select(4,pcall,GetItemInfo,itemid) end
	return itemquality[itemid]
end

do
  local pairs=pairs
  local type=type
  local GetItemIcon=GetItemIcon
  local GetItemInfo=GetItemInfo
  local coroutine=coroutine
  local pcall=pcall
  local i=0
  local debugprofilestop=debugprofilestop
  local start=0
  local function tickle(category,useleft)
    for left,right in pairs(category) do
      local itemid=useleft and left or right
  		if type(itemid)=="number" and itemid > 10 then
  			if not itemquality[itemid] then
  				local rc,name,link,quality=pcall(GetItemInfo,itemid)
  				if rc and name then
  					itemquality[itemid]=quality
  					icon2item[GetItemIcon(itemid)]=itemid
  					i=i+1
  --@debug@
  					if i % 100 == 0 then
  						addon:Print(format("Precached %d items in %.3f so far",i,(debugprofilestop()-start)))
  					end
  --@end-debug@
  				end
  				if coroutine.running() then coroutine.yield() end
  			end
  		end
  	end
  end
  function module:TickleServer()
  	start=debugprofilestop()
  	tickle(data.Equipments)
    tickle(addon.allArtifactPower,true)
  	--@debug@
  	addon:Print(format("Precached %d items in %.3f seconds",i,(debugprofilestop()-start)/1000))
  	--@end-debug@
  end
end
--@do-not-package@
--[[

dbBFAperChar = {
	"GameTooltip/GarrisonMissionListTooltipThreatsFrame", -- [299]
	"GameTooltip/GarrisonMissionListTooltipThreatsFrame", -- [301]
	"GameTooltip/GarrisonMissionListTooltipThreatsFrame", -- [303]
	"GameTooltip/GarrisonMissionListTooltipThreatsFrame", -- [367]
	"GameTooltip/GarrisonMissionListTooltipThreatsFrame", -- [369]
	"GameTooltip/GarrisonMissionListTooltipThreatsFrame", -- [371]
	"GarrisonFollowerTooltip/GarrisonFollowerTooltip.PortraitFrame", -- [421]
	"GarrisonFollowerTooltip/GarrisonFollowerTooltip.PortraitFrame", -- [425]
	"GarrisonFollowerTooltip/UNK_0", -- [422]
	"GarrisonFollowerTooltip/UNK_0", -- [426]
	"GarrisonFollowerTooltip/UNK_0", -- [427]
	"GarrisonMissionListTooltipThreatsFrame/UNK_0", -- [298]
	"GarrisonMissionListTooltipThreatsFrame/UNK_0", -- [300]
	"GarrisonMissionListTooltipThreatsFrame/UNK_0", -- [302]
	"GarrisonMissionListTooltipThreatsFrame/UNK_0", -- [366]
	"GarrisonMissionListTooltipThreatsFrame/UNK_0", -- [368]
	"GarrisonMissionListTooltipThreatsFrame/UNK_0", -- [370]
	"OrderHallCommandBar/OrderHallCommandBar.CurrencyHitTest", -- [173]
	"OrderHallCommandBar/OrderHallCommandBar.CurrencyHitTest", -- [1]
	"OrderHallCommandBar/OrderHallCommandBar.CurrencyHitTest", -- [87]
	"OrderHallCommandBar/OrderHallCommandBar.WorldMapButton", -- [13]
	"OrderHallCommandBar/OrderHallCommandBar.WorldMapButton", -- [174]
	"OrderHallCommandBar/OrderHallCommandBar.WorldMapButton", -- [88]
	"OrderHallFollowerOptionDropDown/OrderHallFollowerOptionDropDownButton", -- [324]
	"OrderHallFollowerOptionDropDown/OrderHallFollowerOptionDropDownButton", -- [411]
	"OrderHallMissionFrame.FollowerTab.AbilitiesFrame/OrderHallMissionFrame.FollowerTab.AbilitiesFrame.CombatAllySpell1", -- [311]
	"OrderHallMissionFrame.FollowerTab.AbilitiesFrame/OrderHallMissionFrame.FollowerTab.AbilitiesFrame.CombatAllySpell2", -- [312]
	"OrderHallMissionFrame.FollowerTab.ModelCluster.Child/OrderHallMissionFrame.FollowerTab.ModelCluster.Child.Model1", -- [327]
	"OrderHallMissionFrame.FollowerTab.ModelCluster.Child/OrderHallMissionFrame.FollowerTab.ModelCluster.Child.Shadows", -- [307]
	"OrderHallMissionFrame.FollowerTab.ModelCluster/OrderHallMissionFrame.FollowerTab.ModelCluster.Child", -- [308]
	"OrderHallMissionFrame.FollowerTab/OrderHallMissionFrame.FollowerTab.AbilitiesFrame", -- [313]
	"OrderHallMissionFrame.FollowerTab/OrderHallMissionFrame.FollowerTab.DurabilityFrame", -- [304]
	"OrderHallMissionFrame.FollowerTab/OrderHallMissionFrame.FollowerTab.ItemAverageLevel", -- [315]
	"OrderHallMissionFrame.FollowerTab/OrderHallMissionFrame.FollowerTab.ModelCluster", -- [309]
	"OrderHallMissionFrame.FollowerTab/OrderHallMissionFrame.FollowerTab.PortraitFrame", -- [306]
	"OrderHallMissionFrame.FollowerTab/OrderHallMissionFrame.FollowerTab.QualityFrame", -- [305]
	"OrderHallMissionFrame.FollowerTab/OrderHallMissionFrame.FollowerTab.Source", -- [314]
	"OrderHallMissionFrame.FollowerTab/OrderHallMissionFrame.FollowerTab.XPBar", -- [310]
	"OrderHallMissionFrame.MissionTab.MissionPage.BuffsFrame/UNK_0", -- [418]
	"OrderHallMissionFrame.MissionTab.MissionPage.Enemy1/OrderHallMissionFrame.MissionTab.MissionPage.Enemy1.MechanicEffect", -- [386]
	"OrderHallMissionFrame.MissionTab.MissionPage.Enemy1/OrderHallMissionFrame.MissionTab.MissionPage.Enemy1.PortraitFrame", -- [384]
	"OrderHallMissionFrame.MissionTab.MissionPage.Enemy1/UNK_0", -- [385]
	"OrderHallMissionFrame.MissionTab.MissionPage.Enemy2/OrderHallMissionFrame.MissionTab.MissionPage.Enemy2.MechanicEffect", -- [390]
	"OrderHallMissionFrame.MissionTab.MissionPage.Enemy2/OrderHallMissionFrame.MissionTab.MissionPage.Enemy2.PortraitFrame", -- [388]
	"OrderHallMissionFrame.MissionTab.MissionPage.Enemy2/UNK_0", -- [389]
	"OrderHallMissionFrame.MissionTab.MissionPage.Enemy3/OrderHallMissionFrame.MissionTab.MissionPage.Enemy3.MechanicEffect", -- [394]
	"OrderHallMissionFrame.MissionTab.MissionPage.Enemy3/OrderHallMissionFrame.MissionTab.MissionPage.Enemy3.PortraitFrame", -- [392]
	"OrderHallMissionFrame.MissionTab.MissionPage.Enemy3/UNK_0", -- [393]
	"OrderHallMissionFrame.MissionTab.MissionPage.Follower1/OrderHallMissionFrame.MissionTab.MissionPage.Follower1.PortraitFrame", -- [396]
	"OrderHallMissionFrame.MissionTab.MissionPage.Follower2/OrderHallMissionFrame.MissionTab.MissionPage.Follower2.Durability", -- [416]
	"OrderHallMissionFrame.MissionTab.MissionPage.Follower2/OrderHallMissionFrame.MissionTab.MissionPage.Follower2.PortraitFrame", -- [398]
	"OrderHallMissionFrame.MissionTab.MissionPage.Follower3/OrderHallMissionFrame.MissionTab.MissionPage.Follower3.Durability", -- [417]
	"OrderHallMissionFrame.MissionTab.MissionPage.Follower3/OrderHallMissionFrame.MissionTab.MissionPage.Follower3.PortraitFrame", -- [400]
	"OrderHallMissionFrame.MissionTab.MissionPage.RewardsFrame/OrderHallMissionFrame.MissionTab.MissionPage.RewardsFrame.MissionXPTooltipHitBox", -- [381]
	"OrderHallMissionFrame.MissionTab.MissionPage.RewardsFrame/OrderHallMissionFrame.MissionTab.MissionPage.RewardsFrame.OvermaxItem", -- [378]
	"OrderHallMissionFrame.MissionTab.MissionPage.RewardsFrame/OrderHallMissionFrame.MissionTab.MissionPage.RewardsFrame.OvermaxItem", -- [415]
	"OrderHallMissionFrame.MissionTab.MissionPage.RewardsFrame/OrderHallMissionFrame.MissionTab.MissionPage.RewardsFrame.OvermaxItem", -- [420]
	"OrderHallMissionFrame.MissionTab.MissionPage.RewardsFrame/OrderHallMissionFrame.MissionTab.MissionPage.RewardsFrame.Reward1", -- [379]
	"OrderHallMissionFrame.MissionTab.MissionPage.RewardsFrame/OrderHallMissionFrame.MissionTab.MissionPage.RewardsFrame.Reward2", -- [380]
	"OrderHallMissionFrame.MissionTab.MissionPage.RewardsFrame/OrderHallMissionFrame.MissionTab.MissionPage.RewardsFrame.TooltipHitBox", -- [382]
	"OrderHallMissionFrame.MissionTab.MissionPage.Stage/OrderHallMissionFrame.MissionTab.MissionPage.Stage.MissionEnvIcon", -- [374]
	"OrderHallMissionFrame.MissionTab.MissionPage.Stage/OrderHallMissionFrame.MissionTab.MissionPage.Stage.MissionInfo", -- [373]
	"OrderHallMissionFrame.MissionTab.MissionPage/OrderHallMissionFrame.MissionTab.MissionPage.BuffsFrame", -- [419]
	"OrderHallMissionFrame.MissionTab.MissionPage/OrderHallMissionFrame.MissionTab.MissionPage.CloseButton", -- [372]
	"OrderHallMissionFrame.MissionTab.MissionPage/OrderHallMissionFrame.MissionTab.MissionPage.CostFrame", -- [377]
	"OrderHallMissionFrame.MissionTab.MissionPage/OrderHallMissionFrame.MissionTab.MissionPage.EmptyFollowerModel", -- [402]
	"OrderHallMissionFrame.MissionTab.MissionPage/OrderHallMissionFrame.MissionTab.MissionPage.Enemy1", -- [387]
	"OrderHallMissionFrame.MissionTab.MissionPage/OrderHallMissionFrame.MissionTab.MissionPage.Enemy2", -- [391]
	"OrderHallMissionFrame.MissionTab.MissionPage/OrderHallMissionFrame.MissionTab.MissionPage.Enemy3", -- [395]
	"OrderHallMissionFrame.MissionTab.MissionPage/OrderHallMissionFrame.MissionTab.MissionPage.Follower1", -- [397]
	"OrderHallMissionFrame.MissionTab.MissionPage/OrderHallMissionFrame.MissionTab.MissionPage.Follower2", -- [399]
	"OrderHallMissionFrame.MissionTab.MissionPage/OrderHallMissionFrame.MissionTab.MissionPage.Follower3", -- [401]
	"OrderHallMissionFrame.MissionTab.MissionPage/OrderHallMissionFrame.MissionTab.MissionPage.ItemLevelHitboxFrame", -- [414]
	"OrderHallMissionFrame.MissionTab.MissionPage/OrderHallMissionFrame.MissionTab.MissionPage.RewardsFrame", -- [383]
	"OrderHallMissionFrame.MissionTab.MissionPage/OrderHallMissionFrame.MissionTab.MissionPage.Stage", -- [375]
	"OrderHallMissionFrame.MissionTab.MissionPage/OrderHallMissionFrame.MissionTab.MissionPage.StartMissionButton", -- [376]
	"OrderHallMissionFrame.MissionTab/OrderHallMissionFrame.MissionTab.MissionPage", -- [403]
	"OrderHallMissionFrame.MissionTab/OrderHallMissionFrameMissions", -- [280]
	"OrderHallMissionFrame.MissionTab/OrderHallMissionFrameMissions", -- [351]
	"OrderHallMissionFrame.MissionTab/UNK_0", -- [281]
	"OrderHallMissionFrame.MissionTab/UNK_0", -- [282]
	"OrderHallMissionFrame.MissionTab/UNK_0", -- [283]
	"OrderHallMissionFrame.MissionTab/UNK_0", -- [284]
	"OrderHallMissionFrame.MissionTab/UNK_0", -- [285]
	"OrderHallMissionFrame.MissionTab/UNK_0", -- [286]
	"OrderHallMissionFrame.MissionTab/UNK_0", -- [287]
	"OrderHallMissionFrame.MissionTab/UNK_0", -- [288]
	"OrderHallMissionFrame.MissionTab/UNK_0", -- [289]
	"OrderHallMissionFrame.MissionTab/UNK_0", -- [290]
	"OrderHallMissionFrame.MissionTab/UNK_0", -- [291]
	"OrderHallMissionFrame.MissionTab/UNK_0", -- [292]
	"OrderHallMissionFrame.MissionTab/UNK_0", -- [293]
	"OrderHallMissionFrame.MissionTab/UNK_0", -- [352]
	"OrderHallMissionFrame.MissionTab/UNK_0", -- [353]
	"OrderHallMissionFrame.MissionTab/UNK_0", -- [354]
	"OrderHallMissionFrame.MissionTab/UNK_0", -- [355]
	"OrderHallMissionFrame.MissionTab/UNK_0", -- [356]
	"OrderHallMissionFrame.MissionTab/UNK_0", -- [357]
	"OrderHallMissionFrame.MissionTab/UNK_0", -- [358]
	"OrderHallMissionFrame.MissionTab/UNK_0", -- [359]
	"OrderHallMissionFrame.MissionTab/UNK_0", -- [360]
	"OrderHallMissionFrame.MissionTab/UNK_0", -- [361]
	"OrderHallMissionFrame.MissionTab/UNK_0", -- [362]
	"OrderHallMissionFrame.MissionTab/UNK_0", -- [363]
	"OrderHallMissionFrame.MissionTab/UNK_0", -- [364]
	"OrderHallMissionFrame/OrderHallMissionFrame.ClassHallIcon", -- [253]
	"OrderHallMissionFrame/OrderHallMissionFrame.CloseButton", -- [251]
	"OrderHallMissionFrame/OrderHallMissionFrame.FollowerTab", -- [316]
	"OrderHallMissionFrame/OrderHallMissionFrame.GarrCorners", -- [252]
	"OrderHallMissionFrame/OrderHallMissionFrame.MissionTab", -- [294]
	"OrderHallMissionFrame/OrderHallMissionFrame.MissionTab", -- [365]
	"OrderHallMissionFrame/OrderHallMissionFrameFollowers", -- [326]
	"OrderHallMissionFrame/OrderHallMissionFrameFollowers", -- [413]
	"OrderHallMissionFrame/OrderHallMissionFrameTab1", -- [254]
	"OrderHallMissionFrame/OrderHallMissionFrameTab1", -- [296]
	"OrderHallMissionFrame/OrderHallMissionFrameTab2", -- [255]
	"OrderHallMissionFrame/OrderHallMissionFrameTab2", -- [297]
	"OrderHallMissionFrame/OrderHallMissionFrameTab3", -- [256]
	"OrderHallMissionFrameFollowers/OrderHallFollowerOptionDropDown", -- [325]
	"OrderHallMissionFrameFollowers/OrderHallFollowerOptionDropDown", -- [412]
	"OrderHallMissionFrameFollowers/OrderHallMissionFrameFollowers.MaterialFrame", -- [322]
	"OrderHallMissionFrameFollowers/OrderHallMissionFrameFollowers.MaterialFrame", -- [409]
	"OrderHallMissionFrameFollowers/OrderHallMissionFrameFollowers.SearchBox", -- [323]
	"OrderHallMissionFrameFollowers/OrderHallMissionFrameFollowers.SearchBox", -- [410]
	"OrderHallMissionFrameFollowers/OrderHallMissionFrameFollowersListScrollFrame", -- [321]
	"OrderHallMissionFrameFollowers/OrderHallMissionFrameFollowersListScrollFrame", -- [408]
	"OrderHallMissionFrameFollowersListScrollFrame/OrderHallMissionFrameFollowersListScrollFrameScrollBar", -- [320]
	"OrderHallMissionFrameFollowersListScrollFrame/OrderHallMissionFrameFollowersListScrollFrameScrollBar", -- [407]
	"OrderHallMissionFrameFollowersListScrollFrame/OrderHallMissionFrameFollowersListScrollFrameScrollChild", -- [317]
	"OrderHallMissionFrameFollowersListScrollFrame/OrderHallMissionFrameFollowersListScrollFrameScrollChild", -- [404]
	"OrderHallMissionFrameFollowersListScrollFrameScrollBar/OrderHallMissionFrameFollowersListScrollFrameScrollBarScrollDownButton", -- [319]
	"OrderHallMissionFrameFollowersListScrollFrameScrollBar/OrderHallMissionFrameFollowersListScrollFrameScrollBarScrollDownButton", -- [406]
	"OrderHallMissionFrameFollowersListScrollFrameScrollBar/OrderHallMissionFrameFollowersListScrollFrameScrollBarScrollUpButton", -- [318]
	"OrderHallMissionFrameFollowersListScrollFrameScrollBar/OrderHallMissionFrameFollowersListScrollFrameScrollBarScrollUpButton", -- [405]
	"OrderHallMissionFrameMissions.CombatAllyUI.Available/OrderHallMissionFrameMissions.CombatAllyUI.Available.AddFollowerButton", -- [277]
	"OrderHallMissionFrameMissions.CombatAllyUI.Available/OrderHallMissionFrameMissions.CombatAllyUI.Available.AddFollowerButton", -- [348]
	"OrderHallMissionFrameMissions.CombatAllyUI/OrderHallMissionFrameMissions.CombatAllyUI.Available", -- [278]
	"OrderHallMissionFrameMissions.CombatAllyUI/OrderHallMissionFrameMissions.CombatAllyUI.Available", -- [349]
	"OrderHallMissionFrameMissions/OrderHallMissionFrameMissions.CombatAllyUI", -- [279]
	"OrderHallMissionFrameMissions/OrderHallMissionFrameMissions.CombatAllyUI", -- [350]
	"OrderHallMissionFrameMissions/OrderHallMissionFrameMissions.MaterialFrame", -- [276]
	"OrderHallMissionFrameMissions/OrderHallMissionFrameMissions.MaterialFrame", -- [347]
	"OrderHallMissionFrameMissions/OrderHallMissionFrameMissionsListScrollFrame", -- [273]
	"OrderHallMissionFrameMissions/OrderHallMissionFrameMissionsListScrollFrame", -- [344]
	"OrderHallMissionFrameMissions/OrderHallMissionFrameMissionsTab1", -- [274]
	"OrderHallMissionFrameMissions/OrderHallMissionFrameMissionsTab1", -- [345]
	"OrderHallMissionFrameMissions/OrderHallMissionFrameMissionsTab2", -- [275]
	"OrderHallMissionFrameMissions/OrderHallMissionFrameMissionsTab2", -- [346]
	"OrderHallMissionFrameMissionsListScrollFrame/OrderHallMissionFrameMissionsListScrollFrameScrollBar", -- [272]
	"OrderHallMissionFrameMissionsListScrollFrame/OrderHallMissionFrameMissionsListScrollFrameScrollBar", -- [343]
	"OrderHallMissionFrameMissionsListScrollFrame/OrderHallMissionFrameMissionsListScrollFrameScrollChild", -- [269]
	"OrderHallMissionFrameMissionsListScrollFrame/OrderHallMissionFrameMissionsListScrollFrameScrollChild", -- [340]
	"OrderHallMissionFrameMissionsListScrollFrameButton1/UNK_0", -- [257]
	"OrderHallMissionFrameMissionsListScrollFrameButton1/UNK_0", -- [328]
	"OrderHallMissionFrameMissionsListScrollFrameButton2/UNK_0", -- [259]
	"OrderHallMissionFrameMissionsListScrollFrameButton2/UNK_0", -- [330]
	"OrderHallMissionFrameMissionsListScrollFrameButton3/UNK_0", -- [261]
	"OrderHallMissionFrameMissionsListScrollFrameButton3/UNK_0", -- [332]
	"OrderHallMissionFrameMissionsListScrollFrameButton4/UNK_0", -- [263]
	"OrderHallMissionFrameMissionsListScrollFrameButton4/UNK_0", -- [334]
	"OrderHallMissionFrameMissionsListScrollFrameButton5/UNK_0", -- [265]
	"OrderHallMissionFrameMissionsListScrollFrameButton5/UNK_0", -- [336]
	"OrderHallMissionFrameMissionsListScrollFrameButton6/UNK_0", -- [267]
	"OrderHallMissionFrameMissionsListScrollFrameButton6/UNK_0", -- [338]
	"OrderHallMissionFrameMissionsListScrollFrameScrollBar/OrderHallMissionFrameMissionsListScrollFrameScrollBarScrollDownButton", -- [271]
	"OrderHallMissionFrameMissionsListScrollFrameScrollBar/OrderHallMissionFrameMissionsListScrollFrameScrollBarScrollDownButton", -- [342]
	"OrderHallMissionFrameMissionsListScrollFrameScrollBar/OrderHallMissionFrameMissionsListScrollFrameScrollBarScrollUpButton", -- [270]
	"OrderHallMissionFrameMissionsListScrollFrameScrollBar/OrderHallMissionFrameMissionsListScrollFrameScrollBarScrollUpButton", -- [341]
	"OrderHallMissionFrameMissionsListScrollFrameScrollChild/OrderHallMissionFrameMissionsListScrollFrameButton1", -- [258]
	"OrderHallMissionFrameMissionsListScrollFrameScrollChild/OrderHallMissionFrameMissionsListScrollFrameButton1", -- [329]
	"OrderHallMissionFrameMissionsListScrollFrameScrollChild/OrderHallMissionFrameMissionsListScrollFrameButton2", -- [260]
	"OrderHallMissionFrameMissionsListScrollFrameScrollChild/OrderHallMissionFrameMissionsListScrollFrameButton2", -- [331]
	"OrderHallMissionFrameMissionsListScrollFrameScrollChild/OrderHallMissionFrameMissionsListScrollFrameButton3", -- [262]
	"OrderHallMissionFrameMissionsListScrollFrameScrollChild/OrderHallMissionFrameMissionsListScrollFrameButton3", -- [333]
	"OrderHallMissionFrameMissionsListScrollFrameScrollChild/OrderHallMissionFrameMissionsListScrollFrameButton4", -- [264]
	"OrderHallMissionFrameMissionsListScrollFrameScrollChild/OrderHallMissionFrameMissionsListScrollFrameButton4", -- [335]
	"OrderHallMissionFrameMissionsListScrollFrameScrollChild/OrderHallMissionFrameMissionsListScrollFrameButton5", -- [266]
	"OrderHallMissionFrameMissionsListScrollFrameScrollChild/OrderHallMissionFrameMissionsListScrollFrameButton5", -- [337]
	"OrderHallMissionFrameMissionsListScrollFrameScrollChild/OrderHallMissionFrameMissionsListScrollFrameButton6", -- [268]
	"OrderHallMissionFrameMissionsListScrollFrameScrollChild/OrderHallMissionFrameMissionsListScrollFrameButton6", -- [339]
	"UIParent/GameMenuFrame", -- [440]
	"UIParent/GarrisonFollowerMissionAbilityWithoutCountersTooltip", -- [424]
	"UIParent/GarrisonFollowerTooltip", -- [423]
	"UIParent/GarrisonFollowerTooltip", -- [428]
	"UIParent/OrderHallCommandBar", -- [14]
	"UIParent/OrderHallCommandBar", -- [175]
	"UIParent/OrderHallCommandBar", -- [89]
	"UIParent/OrderHallMissionFrame", -- [295]
}
GarrisonFollowerOptions[followerid].strings=
RETURN_TO_START = "Return to your Class Hall to start this mission"
FOLLOWER_ADDED_TOAST = "Follower Gained"
TROOP_ADDED_UPGRADED_TOAST = "Upgraded Troop Gained"
TRAITS_LABEL = "Equipment Slots"
FOLLOWER_COUNT_LABEL = "Champions"
FOLLOWER_ADDED_UPGRADED_TOAST = "Upgraded Follower Gained"
FOLLOWER_COUNT_STRING = "Champions: %s%d/%d%s"
CONFIRM_EQUIPMENT = "Are you sure you want to equip your follower with %s?"
TROOP_ADDED_TOAST = "Troop Gained"
LANDING_COMPLETE = "Complete - Return to your Class Hall"

followerListCounterInnerSpacing = 4
minQualityLevelToShowLevel = 0
showSpikyBordersOnSpecializationAbilities = true
hideMissionTypeInLandingPage = true
missionCompleteUseNeutralChest = true
followerPageShowGear = false
followerListCounterScale = 1.15
isPrimaryFollowerType = true
garrisonType = 3
missionPageMaxCountersInFollowerFrame = 3
missionPageMaxCountersInFollowerFrameBeforeScaling = 2
hideCountersInAbilityFrame = true
usesOvermaxMechanic = true
showCategoriesInFollowerList = true
missionFrame = "OrderHallMissionFrame"
missionTooltipShowPartialCountersAsFull = true
showCautionSignOnMissionFollowersSmallBias = false
displayCounterAbilityInPlaceOfMechanic = true
showSingleMissionCompleteAnimation = true
followerPageShowSourceText = false
missionPageAssignTroopSound = "UI_Mission_SlotTroop"
minFollowersForThreatCountersFrame = 1.#INF
partyNotFullText = "You do not have enough Champions to start this mission."
followerListCounterOuterSpacingX = 8
missionAbilityTooltipFrame = "GarrisonFollowerMissionAbilityWithoutCountersTooltip"
abilityTooltipFrame = "GarrisonFollowerAbilityWithoutCountersTooltip"
missionPageMechanicYOffset = -32
followerListCounterNumPerRow = 2
traitAbilitiesAreEquipment = true
missionFollowerSortFunc = function: 000000003F78CD70
followerListCounterOuterSpacingY = 4
useAbilityTooltipStyleWithoutCounters = true
missionFollowerInitSortFunc = function: 00007FF788B90998
missionPageAssignFollowerSound = "UI_Mission_SlotChampion"
showSingleMissionCompleteFollower = false
showILevelOnFollower = false
showILevelInFollowerList = true
missionPageShowXPInMissionInfo = true
}

GARRISON_MISSION_NPC_OPEN,followerType
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
--@end-do-not-package@
