local me,ns=...
if ns.die then return end
local L=ns:GetLocale()
function ns:loadHelp()
self:HF_Title(me,"RELNOTES")
self:HF_Paragraph("Description")
self:Wiki([[
= OrderHallCommander helps you when choosing the right follower for the right mission =
== General enhancements ==
* Mission panel is movable (position not saved, it's jus to see things, panel is so huge...)
* Success chance extimation shown in mission list (optionally considering only available followers)
* Proposed party buttons and mission autofill
* "What if" switches to change party composition based on criteria
== Silent mode ==
typing /BFA silent in chat will eliminate every chat message from OrderHallCommander
]])
self:RelNotes(1,6,0, [[
Feature: fully working under Battle for Azeroth
Fix: error in autocomplete.lua line 484
]])
self:RelNotes(1,5,14,[[
Feature: added Earthen Mark for Shamans
]])
self:RelNotes(1,5,13,[[
Fix: lua error when both sorts were on "Original method" Thanks to Septh for noting it
Feature: added Squires'Oath for paladins
]])
self:RelNotes(1,5,11,[[
Fix: Second sort was not working if not changed at least once in the current session
Feature: Via Options now you can disable right click for blacklisting (Sponsorized by Katmandu)
Fix: Removes Alpha warning (was due to a curse packager bug)
Fix: #153 now closing mission panel with ESC also closes all BFA windows
]])
self:RelNotes(1,5,10,[[
Feature: Added a second level sort criteria
Fix: LeftSide Icon are now updates as soon as mission table appears
Feature: Added itemid 140931 (Bandit wanted poster) to quick buttons
Feature: For reputation rewards, your current reputation with the related faction is shown
]])
self:RelNotes(1,5,9,[[
Feature: added more items to side bar
Feature: removed from followerpage and moved to sidebar some items which doesnt need to be cast on a follower
]])
self:RelNotes(1,5,8,[[
Fix: 1x OrderHallCommander\missionlist.lua:469: attempt to call method 'RefreshValue' (a nil value)
]])
self:RelNotes(1,5,7,[[
Fix: #136 (and others) Lua error
Fix: #137 Removed chat spam
Feature: Class specific troop generating items added. Let me know if your class has issue
Feature: Total xp are now shown as "xp x followers", so you can better compare missions (feature request #97)
]])
self:RelNotes(1,5,6,[[
Fix: #135 Using champion equipment causes the game to hang
Fix: #117 Sometimes "in progress" mission were shown without followers
Fix: Removed chat spam
]])
self:RelNotes(1,5,5,[[
Feature: Base chance can be now set up to 120% to allow for a bit of overcapping
Feature: New Elite Overcap switch to force elites mission to always stay over 100%, if possibile
Feature: You can restore shift-click to send a single mission from mission list
Fix: Reset button was not working
Fix: You can again change switches while viewing the mission page
]])
self:RelNotes(1,5,'4.1',[[
Feature: Removed tutorial autoopening
Fix: when capping a mission if a satisfying mission cannot be found, prefer overcap over lowercap
Fix: #133 Counter kill troops switch was not working
]])
self:RelNotes(1,5,4,[[
Feature: #120 Starting mission from list now requires ctrl-shift
Feature: #124 Moved action buttons to a safer spot
Fix: #127 Side menu didnt stay closed
Fix: #121 Window is now draggable even by the troop status bar
Fix: #123 Sorting should now be more responsive to config changes
Fix: #119 Bad display when more than 5 types of troops (really!) Tested up to 10 troops
Fix: Side menu no longer get reopened at each start
]])
self:RelNotes(1,5,3,[[
Feature: you can now disable a troop type clicking its icon in the BFA troop bar
Fix: Maximize xp was ignoring cap
Fix: #119 Bad display when more than 5 types of troops
Fix: #109 Future mission were missing in tooltip
Fix: #118 Troops with random abilities should now be considered
Fix: #99 Caused by same issue of 118, should be fixed
]])
self:RelNotes(1,5,2,[[
Fix: #108 Ignored/Blacklisted missions aren't sorted at the bottom since 1.5.1
]])
self:RelNotes(1,5,1,[[
Feature: Added an (hopefully) nice tutorial
Fix: Threat icons in missions panel are now consistent with the ones in mission page
]])
self:RelNotes(1,5,0,[[
Feature: Left Clicking a follower will lock him to the mission, so you can see how a mission composition will affect all the other ones
Feature: Right clicking a follower slot forbids using it, so you can force BFA to use less follower for a specific mission. Usable only on the leftmost slot
Feature: Autostart. Mission can be launched whith just one click via the "Quick start mission button". The first mission in the list is started.
Blacklisted missions or missions which are aunder the "Absolute Minimum Chance" value are not autolaunched
Feature: You can now set a minimum success chance. If bonus chance can not be achieved, than BFA will not fill mission whicn not reach at least this percentage
Feature: You can now set a minimum bonus chance. If it's not achieved, than BFA wil not waste forces and will try set the success chance closest to 100 as possible
Feature: For troops, durability is shown in the mission button icon
Feature: Reorganized troops' related switches
Feature: Never kill troops switch forces BFA to only use troop with more than 1 durability left AND to counter deadly
Feature: You can now choose if BFA prefers low or high durability troops

Fix: #68 Initial lag when opening panels should be gone or at least greatly reduced. YMV
Fix: #65 Errors from ACE when rapidly changing sliders
Fix: #66 Not using less than 3 units total
Fix: #80 Krokul troops should be used more rarely
Fix: #78 Ignore busy follower will be checked by defaults for new installs
Fix: #86 Added mising equipments

Note: fixes to errors only appeared during beta testing are not listed
]])
self:RelNotes(1,4,0,[[
Feature: You can now deactivate the Not enough champions warning
Feature: Item level in upgrade items is now more evident
Feature: Equipped items are now quality colored
Fix: Elite mission were not identified the right way
Fix: #59 When changing switches while mission page was shown, selection was not updated
Fix: #59 Mission report is now also closed when you use esc to close mission panel
Fix: #60 Future parties now dont include compab ally if "Use combat ally" is not checked
]])
self:RelNotes(1,3,0,[[
Feature: updates time duration with the actual time duration with the selected party and colors it (green if better, red if worse)
Fix: if mission is maxed, no longer fills it (mission can be sent with less than 3 followers)
Feature: tries to use cheaper troops when available
Fix: Elite mission chance is now computed the right way
]])
self:RelNotes(1,2,2,[[
Fix: #44 Error when changing options on send mission page
Fix: #47 Troops shipment not appearing on panel loading
Fix: Not enough champions warning was appearing way too often
Feature: "Better party available" tooltip improvement, now also lists party composition
Fix: Removes an incompatibility with AuroraUI
]])
self:RelNotes(1,2,1,[[
Fix: #43 Added missing consumable items
Fix: #41 Consumables are now always shown
Fix: #39 Removed usage of Blizzard UIDropDown in order to avoid random taint
Feature: #40 Missions blacklisting available
]])
self:RelNotes(1,1,3,[[
Fix: #35 Now manages new champions ilevel upgrade token
Feature: #30 added option to sort unfilled missions as last
]])
self:RelNotes(1,1,2,[[
Toc bump
]])
self:RelNotes(1,1,1,[[
Fix: Save troops honored (https://wow.curseforge.com/projects/orderhallcommander/issues/33)
Fix: restored future missions in tooltip
Fix: improved kill troop information, now the skull is green if klll troops is in effect but used troops only have 1 durability left
]])
self:RelNotes(1,1,0,[[
Fix: All cache error should be gone
Feature: new Don't use troops switch
Feature: Separate state rcap for Champions and Troops
Feature: you can decide if show busy or even inactive followers
Feature: shift click on reward prints wowhead link in chat
Feature: added icon to show active bonus and malus in mission buttons
Feature: added an informative message when the options you checked lead to not being able to fill missions
Fix: Healing Stream Totem is now considered as upgrade
]])
self:RelNotes(0,2,4,[[
Fix: lua errors in matchmaker.lua
]])
self:RelNotes(0,2,0,[[
Fix: sometimes cache was not refresh after completing missions,leaving al missions unpopulated
]])
self:RelNotes(0,1,1,[[
Fix: Checks we actually cached a follower before removing it from cache
Fix: one follower missions where not supported
Fix: Countered spells are now always marked
Feature: new options for party selection
]])
self:RelNotes(0,1,0,[[
Feature: First release
]])
end

