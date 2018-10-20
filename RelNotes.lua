local me,ns=...
if ns.die then return end
local L=ns:GetLocale()
function ns:loadHelp()
self:HF_Title(me,"RELNOTES")
self:HF_Paragraph("Description")
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
self:RelNotes(1,1,1, [[
Fix: Parties are now refreshed on every mission start
]])
self:RelNotes(1,1,0, [[
Feature: Added equipment buttons to circumvent clumsy Blizzard taint
Fix: Italian localization is back (scusatemi, l'avevo sovrascritta col cinese)
]])
self:RelNotes(1,0,4, [[
Fix: OrderHallCommander\tutorials.lua:498: '<eof>' expected near 'end'
]])
self:RelNotes(1,0,3, [[
Fix: Removed debug messages
]])
self:RelNotes(1,0,2, [[
Fix: Next round of fixes
]])
self:RelNotes(1,0,1, [[
Fix: Removes error when opening scouting map for the first time
]])
self:RelNotes(1,0,0, [[
Fix: Added libs
]])
self:RelNotes(0,1,2, [[
Fix: Fixing various things as I discover them
]])
self:RelNotes(0,1,1, [[
Feature: This is a clone of OrderHallCommander for BFA champions table
Feature: Expect improvements over time
]])
end

