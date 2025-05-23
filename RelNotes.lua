-- AUTOGENERATED
---@diagnostic disable: undefined-field, inject-field
local me=...
local hlp=LibStub('AceAddon-3.0'):GetAddon(me)
function hlp:loadHelp()
self:HF_Title([[me]],[[RELNOTES]])
self:HF_Paragraph('Description')
self:Wiki([[
= ChampionCommander helps you when choosing the right follower for the right mission =
== General enhancements ==
* It's basically a OrderHallCommander clone
* Mission panel is movable (position not saved, it's jus to see things, panel is so huge...)
* Success chance extimation shown in mission list (optionally considering only available followers)
* Proposed party buttons and mission autofill
* "What if" switches to change party composition based on criteria
== Silent mode ==
typing /BFA silent in chat will eliminate every chat message from ChampionCommander
]])
self:HF_Paragraph('Release Notes')
self:RelNotes(1,13,2,[[
Fix: work in progress
]])
self:RelNotes(1,13,1,[[
Toc: 11.0.7
]])
self:RelNotes(1,13,0,[[
Toc: Update for 11.0.5, 11.0.2
]])
self:RelNotes(1,12,1,[[
Rebuild: Updated libraries
]])
self:RelNotes(1,12,0,[[
Toc: Update for 11.0.0, 11.0.2
]])
self:RelNotes(1,11,3,[[
Toc: Update for 10.2.7
Fix: Lua Error about SetJustifyV
]])
self:RelNotes(1,9,0,[[
Toc: bump for 1.2.5
]])
self:RelNotes(1,4,0,[[
Toc: bump for 9.1.0
]])
self:RelNotes(1,3,5,[[
Fix: 44x ChampionCommander\missionlist.lua
]])
self:RelNotes(1,3,2,[[
Fix: 3x ...rfaceChampionCommander\ChampionCommander-1.3.1 90001.lua
]])
self:RelNotes(1,2,4,[[
Feature: Toc BUMP
]])
self:RelNotes(1,2,3,[[
Feature: Improved reputation color codes.
]])
self:RelNotes(1,2,2,[[
Fix: #33 attempt to concatenate field 'reason' (a nil value)
Feature: #11 Reputation info on rewards. Amount of rep colored in red for exalted reps
]])
self:RelNotes(1,2,1,[[
Feature: Show duration on Analyze parties BUSY items (#27)
Fix: Ready only in analyse works again (#31)
Fix: Tutorial now fits in the screen (#28)
Fix: Scouting map was not responsive with panel in locked mode (#23)
]])
self:RelNotes(1,2,0,[[
Feature: TOC Bump 8.2.0
]])
self:RelNotes(1,1,1,[[
Fix: Parties are now refreshed on every mission start
]])
self:RelNotes(1,1,0,[[
Feature: Added equipment buttons to circumvent clumsy Blizzard taint
Fix: Italian localization is back (scusatemi, l'avevo sovrascritta col cinese)
]])
self:RelNotes(1,0,4,[[
Fix: OrderHallCommander\tutorials.lua
]])
self:RelNotes(1,0,3,[[
Fix: Removed debug messages
]])
self:RelNotes(1,0,2,[[
Fix: Next round of fixes
]])
self:RelNotes(1,0,1,[[
Fix: Removes error when opening scouting map for the first time
]])
self:RelNotes(1,0,0,[[
Fix: Added libs
]])
self:RelNotes(0,1,2,[[
Fix: Fixing various things as I discover them
]])
self:RelNotes(0,1,1,[[
Feature: This is a clone of OrderHallCommander for BFA champions table
Feature: Expect improvements over time
]])
end
