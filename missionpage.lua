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
local module=addon:NewSubModule('Missionpage',"AceHook-3.0","AceEvent-3.0","AceTimer-3.0")  --#Module
function addon:GetMissionpageModule() return module end
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
local GARRISON_MISSION_AVAILABILITY2=C(GARRISON_MISSION_AVAILABILITY,'Yellow') .. " %s"
local GARRISON_MISSION_ID="MissionID: %d"
local button,expires,missionid,panel,listpanel
function module:OnInitialized()
end
function module:GetAnalyzeButton()
  return button
end
function module:FillMissionPage(missionInfo,key)

	if type(missionInfo)=="number" then missionInfo=addon:GetMissionData(missionInfo) end
	if not missionInfo then return end
	local missionType=missionInfo.followerTypeID
	if not missionInfo.canStart then return end
	local main=OHF
	if not main then return end
	local missionpage=main:GetMissionPage()
	local stage=main.MissionTab.MissionPage.Stage
	local model=stage.MissionInfo.MissionTime
	if not expires then
		expires=stage:CreateFontString()
		expires:SetFontObject(model:GetFontObject())
		expires:SetDrawLayer(model:GetDrawLayer())
	end
	expires:SetFormattedText(GARRISON_MISSION_AVAILABILITY2,missionInfo.offerTimeRemaining or "")
	expires:SetTextColor(addon:GetAgeColor(missionInfo.offerEndTime))
	expires:SetPoint("TOPLEFT",stage.MissionInfo,"BOTTOMLEFT",0,-2)
	if not button then
    button=addon:GetFactory():Button(OHFMissionPage,L["Analyze parties"],L["See all possible parties for this mission"])
    button:SetPoint("TOPRIGHT",-32,0)
    button:Show()
  end
  button:SetOnChange(function() module:Analyze(missionInfo) end)
	if not button then
    stage.button=addon:GetFactory():Button(OHFMissionPage,L["Analyze parties"],L["See all possible parties for this mission"])
    stage.button:SetPoint("TOPRIGHT",-32,0)
    stage.button:Show()
  end
  button:SetOnChange(function() module:Analyze(missionInfo) end)
--@debug@
	if not missionid then
		missionid=stage:CreateFontString()
		missionid:SetFontObject(model:GetFontObject())
		missionid:SetDrawLayer(model:GetDrawLayer())
		missionid:SetPoint("TOPLEFT",button,"BOTTOMLEFT",0,-2)
	end
	missionid:SetFormattedText(GARRISON_MISSION_ID,missionInfo.missionID)
--@end-debug@
	if( IsControlKeyDown()) then self:Print("Ctrl key, ignoring mission prefill") return end
	if (addon:GetBoolean("NOFILL")) then return end
	OHF:ClearParty()
	self:FillParty(missionInfo.missionID,key)

	if panel and panel:IsVisible() then
    self:Analyze(missionInfo)
	end
end
function module:Tooltip(frame)
  local tip=GameTooltip
  tip:SetOwner(frame,"ANCHOR_RIGHT")
  tip:AddLine(frame.key)
  _G.OrderHallCommanderMixin.DumpData(tip,addon:GetSelectedParty(frame.info.missionID,frame.key))  
  tip:Show()
end
function module:TooltipList(frame)
  local tip=GameTooltip
  tip:SetOwner(frame,"ANCHOR_RIGHT")
  tip:AddLine("Will contain a better explanation of selctions done on this party")
  tip:AddLine(frame.key)
  tip:Show()
end
function module:UpdateList(scrollFrame)
  local offset = HybridScrollFrame_GetOffset(scrollFrame);
  local buttons = scrollFrame.buttons;
  local numButtons = #buttons;
  local permutations=addon:GetFullPermutations()
  local numPermutations=#permutations
  for i=1,#buttons do
    local tuple=permutations[i+offset]
    local total,f1,f2,f3=strsplit(',',tuple)
    local button=buttons[i]
    button.Perc:SetText(i+offset)
    button.Title:SetText(tuple)
    button.Status:SetText((f2 or '') .. ',' .. (f3 or '') )
    --local fType,followerID,value,slot=addon:ParsePermutationFollower(f1 or '',true)
    local fType,cost,followerID,status,busy,durability,busyuntil=addon:UnpackFollower(f1)    
    button.Followers.Champions[1]:SetFollower(followerID):SmartHide()
    --local fType,followerID,value,slot=addon:ParsePermutationFollower(f2 or '',true)
    local fType,cost,followerID,status,busy,durability,busyuntil=addon:UnpackFollower(f2)    
    button.Followers.Champions[2]:SetFollower(followerID):SmartHide()
    --local fType,followerID,value,slot=addon:ParsePermutationFollower(f3 or '',true)
    local fType,cost,followerID,status,busy,durability,busyuntil=addon:UnpackFollower(f3)    
    button.Followers.Champions[3]:SetFollower(followerID):SmartHide()
    button.Followers:SetNotReady(false)
  end
  local totalHeight = numPermutations * scrollFrame.buttonHeight;
  local displayedHeight = numButtons * scrollFrame.buttonHeight;
  HybridScrollFrame_Update(scrollFrame, totalHeight, displayedHeight);   
  
end
function module:Update(scrollFrame)
  local offset = HybridScrollFrame_GetOffset(scrollFrame);
  local buttons = scrollFrame.buttons;
  local numButtons = #buttons;
  local mission=scrollFrame:GetParent().info
  local parties=addon:GetMissionParties(mission.missionID)
  local numParties=#parties.candidatesIndex
  local skip=0
  local now=GetTime()
  for i=1,#buttons do
    local key,button,party,index
    button=buttons[i]
    while true do
      index=i+offset+skip
      if index > numParties or key=="EMPTY" then
        break
      end
      key=parties.candidatesIndex[index]
      party=parties.candidates[key]
      if not scrollFrame.readyOnly then break end
      if addon:BusyFor(party) > now then
        skip=skip+1
      else
        break
      end
    end
    if party then
      local discarded=false
      button.info=mission
      button.key=key
      button.party=party
      button.Perc:SetFormattedText(PERCENTAGE_STRING,party.perc)
      button.Perc:SetTextColor(addon:GetDifficultyColors(party.perc,true))
      local text=''
      if key==parties.uncappedkey then
        text=text .. C(L["Uncapped"],"Blue") .. ' '
      end
      if key==parties.cappedkey then
        text=text .. C(L["Capped"],"Orange") .. ' '
      end
      if key==parties.xpkey then
        text=text .. C(L["XP"],"Cyan")
      end
      if key==parties.selectedkey then
        button.Title:SetText("==> " .. text .. " <==")
      elseif text=='' then
        button.Title:SetText(C(L["Not Selected"],"Silver"))
      else
        button.Title:SetText(text)
      end      
      button.Status:SetText(party.reason)
      button:Show()
      for j=1,3 do
        local champion=button.Followers.Champions[j]
        if party[j] then 
          local status=G.GetFollowerStatus(party[j])
          if status== GARRISON_FOLLOWER_IN_PARTY then status = nil end
          champion:SetFollower(party[j],status)
          champion:Show()
        else 
          champion:Hide()
        end
      end 
     button.Followers:SetNotReady(false)
    else
      button.info=nil
      button.party=nil
      button:Hide()
    end
  end
  local totalHeight = numParties * scrollFrame.buttonHeight;
  local displayedHeight = numButtons * scrollFrame.buttonHeight;
  HybridScrollFrame_Update(scrollFrame, totalHeight, displayedHeight);  
end
local function fix(button,w)
      --button.Perc:SetWidth(50)
      button.Title:ClearAllPoints()
      button.Title:SetPoint("TOPLEFT",button.Perc,"TOPRIGHT",10,-10)
      button.Title:SetWidth(w-100)
      button.Status:ClearAllPoints()
      button.Status:SetPoint("TOPLEFT",button.Title,"BOTTOMLEFT",0,-10)
      button.Status:SetWidth(w-100)
      button.Status:SetJustifyH("LEFT")
      button:SetWidth(w-30)
      button.BG:SetWidth(button:GetWidth())      
end
function addon:ShowPermutations()
  local panel=listpanel
  local w=1000
  local elapsed=debugprofilestop()
  local combinations=#addon:GetFullPermutations(true)
  elapsed=debugprofilestop()-elapsed
  if not panel then
    panel= CreateFrame("Frame","BFAPermutations",UIParent,"BFABaseFrame")
    panel.list=CreateFrame("Scrollframe","BFAPermutationsList",panel,"BasicHybridScrollFrameTemplate")
    panel.list:ClearAllPoints()
    panel.list:SetPoint("BOTTOMLEFT",0,12)
    panel.list:SetPoint("BOTTOMRIGHT",-30,12)
    panel.list:SetPoint("TOP",panel.Title,"BOTTOM")
    panel:SetHeight(OHFMissionPage:GetHeight())
    panel:SetWidth(w)
    panel:SetPoint("LEFT",50,0)
    panel:MakeMovable()
    panel:Show()
    panel:SetFrameStrata("HIGH")
    HybridScrollFrame_CreateButtons(panel.list,"BFAMiniMissionButton", 10, -5, nil, nil, nil,10)
    for i=1,#panel.list.buttons do
      local button=panel.list.buttons[i]
      fix(button,w)
      button.tooltip=function(frame) module:TooltipList(frame) end
    end
  end
  local scrollFrame=panel.list
  panel:SetTitle(format("Permutation listing. %d combinations generated in %f seconds",combinations,elapsed/1000))
  panel.list.update=function(frame) module:UpdateList(frame) end
  panel.list.range=1
  module:UpdateList(scrollFrame)
  panel:Show()
end  
local function click(self)
  if self.info and self.key then
    if IsShiftKeyDown() then
      local parties=addon:GetMissionParties(self.info.missionID)
      local candidate=parties.candidates[self.key]
      parties.current=candidate      
      for i=1,3 do
        addon:Print("Checking",addon:GetFollowerName(candidate[i]))
        addon:Print(addon:ParsePermutationFollower(candidate['f'..i]))        
        addon:Print(parties:SatisfyCondition(candidate,i))
      end
    end 
    module:FillMissionPage(self.info,self.key)
  else 
  addon:Print(self:GetName(),"No mission data") 
  end 
end
function module:ClearParty()
  OHF:ClearParty()
end
function module:Analyze(mission)
  if not panel then
    local w=600
    panel= CreateFrame("Frame","BFAAnalyzer",OHFMissionPage,"BFABaseFrame")
    panel.list=CreateFrame("Scrollframe","BFAAnalizerList",panel,"BasicHybridScrollFrameTemplate")
    panel.list:ClearAllPoints()
    panel.list:SetPoint("BOTTOMLEFT",0,10)
    panel.list:SetPoint("BOTTOMRIGHT",-25,10)
    panel.list:SetPoint("TOP",panel.Title,"BOTTOM")
    panel.checkbox=addon:GetFactory():Checkbox(panel,false,L["Only ready"],L["Shows only parties with available followers"],150)
    panel.checkbox:SetOnChange(function(this,value) panel.list.readyOnly=value module:Update(panel.list) end)
    panel.checkbox:SetPoint("TOPLEFT",15,-3)
    panel:SetHeight(OHFMissionPage:GetHeight())
    panel:SetWidth(w)
    panel:SetPoint("RIGHT",OHFMissionPage,"LEFT",0,0)
    --panel:MakeMovable()
    panel:Show()
    panel:SetFrameStrata("HIGH")
    HybridScrollFrame_CreateButtons(panel.list,"BFAMiniMissionButton", 10, -5, nil, nil, nil,10)
    for i=1,#panel.list.buttons do
      local button=panel.list.buttons[i]
      fix(button,w)
--      button.Title:ClearAllPoints()
--      button.Title:SetPoint("TOPLEFT",button.Perc,"TOPRIGHT",10,-10)
--      button.Status:ClearAllPoints()
--      button.Status:SetPoint("BOTTOMLEFT",button.Perc,"BOTTOMRIGHT",0,10)
--      button:SetWidth(panel.list:GetWidth()-30)
--      button.BG:SetWidth(button:GetWidth())
--      button.Title:SetWidth(button:GetWidth()-button.Perc:GetWidth())
--      button.Status:SetWidth(button:GetWidth()-button.Perc:GetWidth())
      button.tooltip=function(frame) module:Tooltip(frame) end
      button:SetScript("OnClick",click)
    end
  end
  local scrollFrame=panel.list
  panel.info=mission
  panel:SetTitle(mission.name .. ' analisys')
  panel.list.update=function(frame) module:Update(frame) end
  panel.list.range=1
  module:Update(scrollFrame)
  panel:Show()
end
function module:FillParty(missionID,key)
	--addon:HoldEvents()
	local parties=addon:GetMissionParties(missionID)
	if not parties then return end
	local party=parties:GetSelectedParty(key)
	local missionPage=OHF:GetMissionPage()
	for i=1,#party do
		local followerID=party[i]
--@debug@
    addon:Print("adding",addon:GetFollowerName(followerID))
--@end-debug@
		if followerID and not G.GetFollowerStatus(followerID) then
			missionPage:AddFollower(followerID)
		end
	end
	--addon:ReleaseEvents()
end
