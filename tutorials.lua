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
local module=addon:NewSubModule('Tutorials',"AceHook-3.0","AceEvent-3.0","AceTimer-3.0")  --#Module
function addon:GetTutorialsModule() return module end
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
local tutorialVersion=1
local OHFButtons=OHFMissions.listScroll.buttons
local HelpPlate_TooltipHide=HelpPlate_TooltipHide
local HelpPlateTooltip=HelpPlateTooltip
local platestrata = HelpPlateTooltip:GetFrameStrata()
-- Uses X for key already present i standard file
local X=L
local currentTutorialIndex
local fcolor="Yellow"
local ncolor="Green"
local missingMessage=L["A requested window is not open\nTutorial will resume as soon as possible"]
local tutorials
tutorials={
  {
    text=L["Welcome to the first release of ChampionCommander\nRight now it's just an OrderHallCommander clone\nPlease follow this short tutorial to discover all new functionalities.\nYou will not regret it"],
    anchor="CENTER",
    parent=OHF,
    noglow=true
  },
  {
    text=function()
        local c,n=C(X["Counter kill Troops"], fcolor),C(X["Never kill Troops"],fcolor),C(addon:GetNumber("MAXCHAMP"),ncolor)
        return format(L["With %1$s you ask to always counter the Hazard kill troop.\nThis means that BFA will try to counter it OR use a troop with just one durability left.\nThe target for this switch is to avoid wasting durability point, NOT to avoid troops' death."],
        c)
    end,
    parent=function() return module:GetMenuItem("SAVETROOPS") end,
    anchor="RIGHT"
  },
  {
    text=function()
        local c,n,x=C(X["Counter kill Troops"], fcolor),C(X["Never kill Troops"]),C(L["Prefer high durability"], fcolor)
        return format(L["With %2$s you ask to never let a troop die.\nThis not only implies %1$s and %3$s, but force BFA to never send to mission a troop which will die.\nThe target for this switch is to totally avoid killing troops, even it for this we cant fill the party"],
        c,n,x)
    end,
    parent=function() return module:GetMenuItem("NEVERKILLTROOPS") end,
    anchor="RIGHT"
  },
  {
    text=function()
        local c=C(L["Prefer high durability"], fcolor)
        return format(L["Usually ChampionCommander tries to use troops with the lowest durability in order to let you enque new troops request as soon as possible.\nChecking %1$s reverse it and ChampionCommander will choose for each mission troops with the highest possible durability"],
        c)
    end,
    parent=function() return module:GetMenuItem("PREFERHIGH") end,
    anchor="RIGHT"
  },
  {
    text=function()
        local c,g,n=C(X["Max champions"], fcolor),C(X["Maximize xp gain"],fcolor),C(addon:GetNumber("MAXCHAMP"),ncolor)
        return format(L["You can choose to limit how much champions are sent together.\nRight now BFA is not using more than %3$s champions in the same mission-\n\nNote that %2$s overrides it."],
        c,g,n)
    end,
    parent=function() return module:GetMenuItem("MAXCHAMP") end,
    anchor="RIGHT"
  },
  {
    text=function()
        local g,b,ng,nb=C(X["Bonus Chance"],fcolor), C(X["Base Chance"],fcolor),C(addon:GetNumber("BONUSCHANCE"),ncolor),C(addon:GetNumber("BASECHANCE"),ncolor)
        return format(L["%1$s and %2$s switches work together to customize how you want your mission filled\n\nThe value you set for %1$s (right now %3$s%%) is the minimum acceptable chance for attempting to achieve bonus while the value to set for %2$s (right now %4$s%%) is the chance you want achieve when you are forfaiting bonus (due to not enough powerful followers)"],
        g,b,ng,nb)
    end,
    parent=function() return module:GetMenuItem("BONUSCHANCE"), module:GetMenuItem("BASECHANCE") end,
    anchor="RIGHT"
  },
  {
    text=function()
        local g,b=C(X["Bonus Chance"],fcolor), C(X["Base Chance"],fcolor)
        return format(L["For example, let's say a mission can reach 95%%, 130%% and 180%% success chance.\nIf %1$s is set to 170%%, the 180%% one will be choosen.\nIf %1$s is set to 200%% BFA will try to find the nearest to 100%% respecting %2$s setting\nIf for example %2$s is set to 100%%, then the 130%% one will be choosen, but if %2$s is set to 90%% then the 95%% one will be choosen"],
        g,b)
    end,
    parent=function() return module:GetMenuItem("BONUSCHANCE"), module:GetMenuItem("BASECHANCE") end,
    anchor="RIGHT"
  },
  {
    text=function()
        local g,b=C(X["Bonus Chance"],fcolor), C(X["Base Chance"],fcolor)
        return format(L["If instead you just want to always see the best available mission just set %1$s to 100%% and %2$s to 0%%"],
        g,b)
    end,
    parent=function() return module:GetMenuItem("BONUSCHANCE") , module:GetMenuItem("BASECHANCE") end,
    anchor="RIGHT"
  },
  {
    text=L["Equipment and upgrades are listed here as clickable buttons.\nDue to an issue with Blizzard Taint system, drag and drop from bags raise an error.\nif you drag and drop an item from a bag, you receive an error.\nIn order to assign equipments which are not listed (I update the list often but sometimes Blizzard is faster), you can right click the item in the bag and the left click the follower.\nThis way you dont receive any error"],
    anchor="CENTER",
    parent=OHFFollowerTab,
    tab=2,
  },
  {
    back=1,
    text=L["You can blacklist missions right clicking mission button.\nSince 1.5.1 you can start a mission witout passing from mission page shift-clicking the mission button.\nBe sure you liked the party because no confirmation is asked"],
    parent=function() return OHFButtons[1] end,
    anchor="TOP",
    onmissing=missingMessage,
  },
  {
    back=2,
    text='Followers can be "locked" to a specific mission.\nWhen you lock a follower, he will not used for any other mission\nLocking follower around is a way to optimize your setup, you can keep locking and unlocking followers to different missions to achieve the best overall combination',
    anchor="TOP",
    parent=function() local f=addon:GetMembersFrame(OHFButtons[1]) if f then return f.Champions[1] end end,
    level=-1,
    onmissing=missingMessage,
  },
  {
    back=3,
    text=L['Slots (non the follower in it but just the slot) can be banned.\nWhen you ban a slot, that slot will not be filled for that mission.\nExploiting the fact that troops are always in the leftmost slot(s) you can achieve a nice degree of custom tailoring, reducing the overall number of followers used for a mission'],
    anchor="TOP",
    parent=function() local f=addon:GetMembersFrame(OHFButtons[1]) if f then return f.Champions[3] or f.Champions[2] or f.Champions[1] end end,
    level=-1,
    onmissing=missingMessage,
  },
  {
    text="When you have locked some followers to missions, you can start the mission without going to the mission page.\nShift-Clicking this button will scan missions from top to bottom (so, sort order IS important) and start the first one with at least one locked follower",
    parent=function() return module:GetMenuItem("BUTTON1") end,
    anchor="BOTTOM",
    level=-1,
    onmissing=missingMessage,
  },
  {
    text="You can quickly remove all locks and bans clicking here",
    parent=function() return module:GetMenuItem("BUTTON2") end,
    anchor="BOTTOM",
    level=-1,
    onmissing=missingMessage,
  },
  {
    text="If you cant see missions filled, maybe you have a too restrictive set of switches checked on.\nClicking here reset BFA to a very permissive setup.\nTry this before filing a ticket, please :)",
    parent=function() return module:GetMenuItem("BUTTON3") end,
    anchor="BOTTOM",
    level=-1,
    onmissing=missingMessage,
  },
  --[[
  {
    back=1,
    action=function()
      if OHFButtons[1] then
        addon:GetMissionlistModule():RawMissionClick(OHFButtons[1],"LeftButton")
      end
    end,
    anchor="TOP",
    text=L["If you dont understand why BFA choosed a setup for a mission, you can request a full analysis.\nAnalyze party will show all the possible combinations and how BFA evaluated them"],
    parent=function() local b=addon:GetMissionpageModule():GetAnalyzeButton() return (b and b:IsVisible()) and b end,
    level=-1,
    onmissing=missingMessage,
  },
  {
    back=2,
    action=function()
      if OHFMissionPage:IsVisible() and addon:GetMissionpageModule():GetAnalyzeButton() then
        addon:GetMissionpageModule():GetAnalyzeButton():Click()
      end
    end,
    anchor="RIGHT",
    text=L["Clicking a party button will assign its followers to the current mission.\nUse it to verify BFA calculated chance with Blizzard one.\nIf they differs please take a screenshot and open a ticket :)."],
    parent=function() addon:Print("Retrieving",_G.BFAAnalyzer) return _G.BFAAnalyzer end,
    level=-1,
    onmissing=missingMessage,
    tab=false,
  },
  --]]
  {
    text=L["You can choose not to use a troop type clicking its icon"],
    parent=function() return addon:GetCacheModule():GetTroopsFrame() end,
    anchor="TOP",
  },
  {
    back=1,
    anchor="CENTER",
    parent=OHF,
    text=format(L["Thank you for reading this, enjoy %s"],me),
    action=function() addon.db.global.tutorialStep=#tutorials end
  }


}
local Clicker
local Enhancer
local function callOrUse(data)
  if type(data)=="function" then
    return data()
  else
    return data
  end
end
local function plate(self,tutorial)
  local text
  local rc=false
  if type(tutorial)=="table" then
    if tutorial.tab==nil then tutorial.tab=1 end
    if tutorial.tab then
      OHF:SelectTab(tutorial.tab)
    end
    if type(tutorial.action)=="function" then tutorial.action() end
    text = callOrUse(tutorial.text)
    local a1=callOrUse(tutorial.anchor)
    local o,o2=callOrUse(tutorial.parent)
    self:Hide()
    local arrow="ArrowRIGHT"
    local glow="ArrowGlowRIGHT"
    local x=20
    local y=0
    local a2="RIGHT"
    if not o then a1="CENTER" end
    if a1=="RIGHT" then
      a2="LEFT"
      arrow="ArrowLEFT"
      glow="ArrowGlowLEFT"
      x=-20
      y=0
    elseif a1 =="BOTTOM" then
      a2="TOP"
      arrow="ArrowUP"
      glow="ArrowGlowUP"
      x= 0
      y=20
    elseif a1 =="TOP" then
      a2="BOTTOM"
      arrow="ArrowDOWN"
      glow="ArrowGlowDOWN"
      x= 0
      y= -20
    elseif a1 == "CENTER" then
      a2="CENTER"
      arrow=false
      glow=false
      x=0
      y=0
    end
    platestrata=HelpPlateTooltip:GetFrameStrata()
    HelpPlateTooltip.HookedByBFA=true
    if arrow then HelpPlateTooltip[arrow]:Show() end
    if glow then HelpPlateTooltip[glow]:Show() end
    HelpPlateTooltip:SetPoint(a1, o or OHF, a2, x, y)
    HelpPlateTooltip:SetParent(o or OHF)
    HelpPlateTooltip:SetFrameStrata("TOOLTIP")
    Clicker:SetParent(HelpPlateTooltip)
    Clicker:Show()
    if tutorial.noglow then
      Enhancer:Hide()
    else
      if o then
        Enhancer:SetParent(o)
        Enhancer:ClearAllPoints()
        if o2 then
          if o2:GetTop() >= o:GetTop() and o2:GetLeft() <= o:GetLeft() then
            Enhancer:SetPoint("TOPLEFT",o,"TOPLEFT")
            Enhancer:SetPoint("BOTTOMRIGHT",o2,"BOTTOMRIGHT")
          elseif o2:GetTop() <= o:GetTop() and o2:GetLeft() >= o:GetLeft() then
            Enhancer:SetPoint("TOPLEFT",o,"TOPLEFT")
            Enhancer:SetPoint("BOTTOMRIGHT",o2,"BOTTOMRIGHT")
          else
            Enhancer:SetAllPoints()
          end
        else
          Enhancer:SetAllPoints()
        end
        Enhancer:SetFrameStrata(o:GetFrameStrata())
        if tutorial.level then
          Enhancer:SetFrameLevel(o:GetFrameLevel() + (tutorial.level))
        end
        Enhancer:Show()
      else
        Enhancer:Hide()
        text=tutorial.onmissing
        rc=true
      end
    end
  else
    text=tutorial
  end
  HelpPlateTooltip.Text:SetText(C(me .. ' ' .. addon.version,'Green') .. "\n" .. text .. "\n\n" )
  HelpPlateTooltip:Show()
  return rc
  --HelpPlateTooltip:SetScript("OnMouseDown",function(this) this:SetScript("OnMouseDown",this.oldClick) HelpPlate_TooltipHide() end)
end
function module:Refresh()
  if HelpPlateTooltip.HookedByBFA then
    local tutorial=tutorials[currentTutorialIndex]
    if tutorial then
      local text = type(tutorial.text)=="function" and tutorial.text() or tutorial.text
      plate(self,text)
      return
    end
  end
end
function module:Hide(this)
  HelpPlateTooltip.HookedByBFA=nil
  HelpPlateTooltip:SetFrameStrata(platestrata)
  HelpPlate_TooltipHide()
  HelpPlateTooltip:SetParent(UIParent)
  Clicker:SetParent(nil)
  Clicker:Hide()
  Enhancer:SetParent(nil)
  Enhancer:Hide()
end
function module:Backward()
  currentTutorialIndex=math.max(currentTutorialIndex-1,1)
  self:Show()
end
function module:Forward()
  currentTutorialIndex=currentTutorialIndex+1
  self:Show()
end
function module:Home()
  currentTutorialIndex=1
  self:Show()
end
function addon:NeedsTutorial()
  if not addon.db.global.tutorialStep then addon.db.global.tutorialStep =1 end
  if addon.db.global.tutorialStep < #tutorials then
    return format(L["There are %d tutorial step you didnt read"],#tutorials - addon.db.global.tutorialStep) .. "\n"
  end
end
function module:Show(opening)

  HelpPlateTooltip.HookedByBFA=nil
  if not currentTutorialIndex then currentTutorialIndex=addon.db.global.tutorialStep or 1 end
  local tutorial=tutorials[currentTutorialIndex]
  addon.db.global.tutorialStep=currentTutorialIndex
--@debug@
  _G.print("Tutorial step ",addon.db.global.tutorialStep,' of ', #tutorials)
--@end-debug@
  if tutorial then
    if opening and tutorial.back then
      currentTutorialIndex=currentTutorialIndex - tutorial.back
      return self:Show()
    end

    if plate(self,tutorial) then
      Clicker.Forward:Hide()
    elseif currentTutorialIndex < #tutorials
    then Clicker.Forward:Show()
    else Clicker.Forward:Hide()
    end
    if currentTutorialIndex > 1 then
      Clicker.Backward:Show()
      Clicker.Home:Show()
    else
      Clicker.Backward:Hide()
      Clicker.Home:Hide()
    end
    return
  else
    self:Terminate()
  end
end
function module:Terminate()
  self:Hide()
  addon.db.global.tutorialStep=#tutorials +1
end
function module:OnInitialized()
  if not Clicker then
    Clicker=CreateFrame("Frame",nil,HelpPlateTooltip,"BFANavigator")
    Clicker:SetAllPoints()
    self:RawHookScript(Clicker.Forward,"OnClick","Forward")
    self:RawHookScript(Clicker.Backward,"OnClick","Backward")
    self:RawHookScript(Clicker.Close,"OnClick","Hide")
    self:RawHookScript(Clicker.Home,"OnClick","Home")
    Clicker.Home.tooltip=L["Restart the tutorial"]
    Clicker.Close.tooltip=L["Terminate the tutorial. You can resume it anytime clicking on the info icon in the side menu"]
  end
  if not Enhancer then
    Enhancer = CreateFrame("Frame",nil,nil,"GlowBoxTemplate")
  end
  self:Hide()
end
function module:GetMenuItem(flag)
  return addon:GetMissionlistModule():GetMenuItem(flag)
end

