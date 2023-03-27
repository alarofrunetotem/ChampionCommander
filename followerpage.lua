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
local module=addon:NewSubModule('Followerpage',"AceHook-3.0","AceEvent-3.0","AceTimer-3.0")  --#Module
function addon:GetFollowerpageModule() return module end
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
local GetItemCount=GetItemCount
local GetItemInfo=GetItemInfo
local GarrisonMissionFrame_SetItemRewardDetails=GarrisonMissionFrame_SetItemRewardDetails
local GetItemInfoInstant=GetItemInfoInstant
local select=select

local function GetItemName(id) return (GetItemInfo(id)) end
local UpgradeFrame
local UpgradeButtons={}
--@debug@
local debugInfo
--@end-debug@
function module:CheckSpell()
end
function module:OnInitialized()
	UpgradeFrame=CreateFrame("Frame",nil,OHFFollowerTab)
	local u=UpgradeFrame
	u:SetPoint("TOPLEFT",OHFFollowerTab,"TOPLEFT",5,-72)
	u:SetPoint("BOTTOMLEFT",OHFFollowerTab,"BOTTOMLEFT",5,7)
	u:SetWidth(70)
	u:Show()
--@debug@
	--addon:SetBackdrop(u,C:Green())
--@end-debug@
	self:SecureHook("GarrisonMission_SetFollowerModel","RefreshUpgrades")
	UpgradeFrame:EnableMouse(true)
--@debug@
	self:RawHookScript(UpgradeFrame,"OnEnter","ShowFollowerData")
	self:SecureHook(OHFFollowerTab,"ShowEquipment","CheckEquipment")
	self:RawHookScript(UpgradeFrame,"OnLeave",function() GameTooltip:Hide() end)
	debugInfo=u:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	debugInfo:SetPoint("TOPLEFT",70,20)
--@end-debug@
end
function module:Events()
	self:RegisterEvent("GARRISON_FOLLOWER_UPGRADED")
	self:RegisterEvent("GARRISON_FOLLOWER_LIST_UPDATE","GARRISON_FOLLOWER_UPGRADED")
	self:RegisterEvent("GARRISON_FOLLOWER_XP_CHANGED","GARRISON_FOLLOWER_UPGRADED")
end
function module:ShowFollowerData(this)
	local tip=GameTooltip
	tip:SetOwner(this,"CURSOR_ANCHOR")
	tip:AddLine(this:GetName())
	ChampionCommanderMixin.DumpData(tip,addon:GetFollowerData(OHFFollowerTab.followerID))
	tip:Show()
end
function module:GARRISON_FOLLOWER_UPGRADED(event,championType,followerId)
	if followerType ~= championType then
		return
	end
	if OHFFollowerTab:IsVisible() then
		self:ScheduleTimer("RefreshUpgrades",0.3)
	end
end
do
	local left=0
	local i=0
	local previous=nil
	local rendered=false
	function module:RenderEquipmentButton(id)
		if not(id) then
			left=-15
			i=0
			previous=nil
		else
			if i > 13 then
				i=0
				left=left + 50
				previous=nil
			end
			previous,rendered=self:RenderButton(id,left,previous)
			if rendered then i=i+1 end
		end
	end
end
do
	local left=360
	local i=0
	local previous=nil
	local rendered=false
	function module:RenderUpgradeButton(id)
		if not(id) then
			left=360
			i=0
			previous=nil
			return
		else
			if i > 12 then
				i=0
				left=left - 50
				previous=nil
			end
			previous,rendered=self:RenderButton(id,left,previous)
			if rendered then i=i+1 end
		end
	end
end
local originalcolor
function module:CheckEquipment(this,followerInfo)
	local equipmentFrames=this.AbilitiesFrame.Equipment
	for _,f in pairs(equipmentFrames) do
		local iconid=f.Icon:GetTexture()
		local colored=false
		if type(iconid)=="number" then
			local itemid=addon:GetItemIdByIcon(iconid)
			if  type(iconid)=="number" then
				local quality=addon:GetItemQuality(itemid)
				if  type(quality)=="number" then
					colored=true
					f.Border:SetVertexColor(GetItemQualityColor(quality))
				end
			end
		end
		if not colored then f.Border:SetVertexColor(1,1,1,1) end
	end
end
local eqCount={}
function addon:RefreshEquipments()
  wipe(eqCount)
  for followerID,followerInfo in pairs(addon:GetFollowerData()) do
    if pcall(GarrisonFollowerTabMixin.SetupAbilities,GarrisonFollowerTabMixin,followerInfo) then
      for i=1,#followerInfo.equipment do
        local eq=followerInfo.equipment[i]
        if eq.icon then
          if not eqCount[eq.icon] then eqCount[eq.icon]={} end
          tinsert(eqCount[eq.icon],followerInfo.followerID)
        end
      end
    end
  end
end
function module:RefreshUpgrades(model,followerID,displayID,showWeapon)
  if not OHFFollowerTab:IsVisible() then return end
  if model then
    UpgradeFrame:SetFrameStrata(model:GetFrameStrata())
    UpgradeFrame:SetFrameLevel(model:GetFrameLevel()+5)
  end
  if not followerID then followerID=OHFFollowerTab.followerID end
  local follower=addon:GetFollowerData(followerID)
  --@debug@
  if followerID then
    debugInfo:SetText(followerID  ..  " " .. (displayID or "no display id") .. " " .. (follower.status or ""))
  end
  --@end-debug@
  for i=1,#UpgradeButtons do
    self:ReleaseButton(UpgradeButtons[i])
  end
  wipe(UpgradeButtons)
  self:RenderUpgradeButton()
  self:RenderEquipmentButton()
  if not follower then return end
  if not follower.isCollected then return end
  --if follower.status==GARRISON_FOLLOWER_ON_MISSION then return end
  --if follower.status==GARRISON_FOLLOWER_COMBAT_ALLY then return end
  --if follower.status==GARRISON_FOLLOWER_INACTIVE then return end
  local data=addon:GetData("Buffs")
  --@debug@
  print("Buffs",#data)
  --@end-debug@
  for i=1,#data do
    local id=data[i]
    self:RenderUpgradeButton(id)
  end
  if follower.isTroop then return end
  if follower.iLevel <850  then
    local data=addon:GetData("U850")
    --@debug@
    print("U850",#data)
    --@end-debug@
    for i=1,#data do
      local id=data[i]
      self:RenderUpgradeButton(id)
    end
  end
  if follower.iLevel <880 then
    local data=addon:GetData("U880")
    --@debug@
    print("U880",#data)
    --@end-debug@
    for i=1,#data do
      local id=data[i]
      self:RenderUpgradeButton(id)
    end
  end
  if follower.iLevel <900 then
    local data=addon:GetData("U900")
    --@debug@
    print("U900",#data)
    --@end-debug@
    for i=1,#data do
      local id=data[i]
      self:RenderUpgradeButton(id)
    end
  end
  if follower.iLevel <925 then
    local data=addon:GetData("U925")
    --@debug@
    print("U925",#data)
    --@end-debug@
    for i=1,#data do
      local id=data[i]
      self:RenderUpgradeButton(id)
    end
  end
  if follower.iLevel <950 then
    local data=addon:GetData("U950")
    --@debug@
    print("U950",#data)
    --@end-debug@
    for i=1,#data do
      local id=data[i]
      self:RenderUpgradeButton(id)
    end
  end
  if not follower.isMaxLevel or  follower.quality < 5 then
    local data=addon:GetData("Xp")
    --@debug@
    print("Xp",#data)
    --@end-debug@
    for i=1,#data do
      local id=data[i]
      self:RenderUpgradeButton(id)
    end
  end
  if follower.quality >=Enum.ItemQuality.Rare then
    local data=addon:GetData("Equipments")
    --@debug@
    print("Equipments",#data)
    --@end-debug@
    for i=1,#data do
      local id=data[i]
      self:RenderEquipmentButton(id)
    end
  end
end
function module:UpgradeTooltip(this)
  local t=this.Icon:GetTexture()
  local tip=GameTooltip
  local followers=eqCount[t]
  if followers and #followers > 0 then
    tip:AddLine(L["Equipped by following champions:"])
    for i=1,#followers do
      tip:AddLine(G.GetFollowerLink(followers[i]))
    end
  end
  tip:Show()
end

local UpgradeFollower
do local pool={}
  function addon:AcquireButton(frame)
  	local b=tremove(pool)
    frame=frame or UpgradeFrame
  	if not b then
  		b=CreateFrame("Button",nil,frame,"BFAUpgradeButton,SecureActionbuttonTemplate")
  		b:EnableMouse(true)
  		b:RegisterForClicks("LeftButtonDown")
  		b:SetAttribute("type","item")
  		--b.Quantity:SetFontObject("NumberFont_Outline_Huge")
  		b.Quantity:SetFontObject("GameFontNormalShadowHuge2")
  		--b:SetScript("PostClick",UpgradeFollower)
  		--b:SetSize(35,35)
  		--b.Icon:SetSize(35,35)
  		--b.IconBorder:SetSize(36,36)
  		b:SetScale(0.7)
  		addon.SecureHookScript(module,b,"OnEnter","UpgradeTooltip")
  	else
  	 b:SetParent(frame)
  	end
  	tinsert(UpgradeButtons,b)
  	return b
  end
  function addon:ReleaseButton(u)
  	u:Hide()
  	u:ClearAllPoints()
  	u:SetParent(nil)
  	tinsert(pool,u)
  end
  function addon:RenderButton(id,left,previous)
      local qt=GetItemCount(id)
      if qt == 0 then return previous end --Not rendering empty buttons
      if type(id) ~= "number" then return previous end
      local b=module:AcquireButton()
      if previous then
        b:SetPoint("TOPLEFT",previous,"BOTTOMLEFT",0,0)
      else
        b:SetPoint("TOPLEFT",left,-5)
      end
      --b.IconBorder:SetVertexColor(1,0,0)
      self:DrawButton(b,id,qt)
      return b,true
  end
  function addon:DrawButton(b,id,qt)
      qt=qt or GetItemCount(id)
      b.itemID=id
      b:SetAttribute("item",select(2,GetItemInfo(id)))
      GarrisonMissionFrame_SetItemRewardDetails(b)
      local t=b.Icon:GetTexture()
      if not t and GetItemInfoInstant then
        b.Icon:SetTexture(select(5,GetItemInfoInstant(id)))
        t=b.Icon:GetTexture()
      end
      if not t then
        b.Icon:SetTexture("Interface/ICONS/INV_Misc_QuestionMark")
      end
      b.Quantity:SetFormattedText("%d",qt)
      b.Quantity:Show()
      if qt>0 then
        b.Icon:SetDesaturated(false)
        b.Quantity:SetTextColor(b.IconBorder:GetVertexColor())
      else
        b.Icon:SetDesaturated(true)
        b.Quantity:SetTextColor(C.Grey())
      end
      b:Show()
  end

module.ReleaseButton=addon.ReleaseButton
module.AcquireButton=addon.AcquireButton
module.RenderButton=addon.RenderButton
module.DrawButton=addon.DrawButton
end
local CONFIRM1=L["Upgrading to |cff00ff00%d|r"].."\n" .. CONFIRM_GARRISON_FOLLOWER_UPGRADE
local CONFIRM2=L["Upgrading to |cff00ff00%d|r"].."\n|cffffd200 "..L["You are wasting |cffff0000%d|cffffd200 point(s)!!!"].."|r\n" .. CONFIRM_GARRISON_FOLLOWER_UPGRADE
local function DoUpgradeFollower(this)
		G.CastSpellOnFollower(this.data);
end
function UpgradeFollower(this)
	local follower=this:GetParent()
	local followerID=follower.followerID
	local upgradelevel=this.rawlevel
	local genere=this.tipo:sub(1,1)
	local currentlevel=genere=="w" and follower.ItemWeapon.itemLevel or  follower.ItemArmor.itemLevel
	local name = ITEM_QUALITY_COLORS[G.GetFollowerQuality(followerID)].hex..G.GetFollowerName(followerID)..FONT_COLOR_CODE_CLOSE;
	local losing=false
	local upgrade=math.min(upgradelevel>600 and upgradelevel or upgradelevel+currentlevel,GARRISON_FOLLOWER_MAX_ITEM_LEVEL)
	if upgradelevel > 600 and currentlevel>600 then
		if (currentlevel > upgradelevel) then
			losing=upgradelevel - 600
		else
			losing=currentlevel -600
		end
	elseif upgrade > GARRISON_FOLLOWER_MAX_ITEM_LEVEL then
		losing=(upgrade)-GARRISON_FOLLOWER_MAX_ITEM_LEVEL
	end
	if losing then
		return module:Popup(format(CONFIRM2,upgrade,losing,name),0,DoUpgradeFollower,true,followerID,true)
	else
		if addon:GetToggle("NOCONFIRM") then
			return G.CastSpellOnFollower(followerID);
		else
			return module:Popup(format(CONFIRM1,upgrade,name),0,DoUpgradeFollower,true,followerID,true)
		end
	end
end
