--[[
Written by 'Rolf' for TES3MP 0.8.0/0.8.1.

Description: Fixes the impossibility of becoming a vampire/werewolf without commands due to the passage of time; executes appropriate orders when infected.

Steps:
1. Place this file inside 'server\scripts\custom' folder, located in your TES3MP directory.
2. Open 'customScripts.lua' file ('server\scripts') and write in it the next line: require('custom/fixVampireWerewolf')
3. Save the changes and close it.
--]]

local vampire = true -- 'false' disables vampire fix.
local werewolf = true -- 'false' disables werewolf fix.
local vampTalk = false -- 'true' allows vampires to talk to everyone, but disables sun damage.
local tableHelper = require('tableHelper')

local function OnPlayerCellChange(eventStatus, pid)
    local player = Players[pid]
    if player and player:IsLoggedIn() then
        if (tableHelper.containsValue(player.data.spellbook, 'vampire blood quarra') or tableHelper.containsValue(player.data.spellbook, 'vampire blood aundae') or tableHelper.containsValue(player.data.spellbook, 'vampire blood berne')) and vampire and not tableHelper.containsValue(player.data.spellbook, 'vampire attributes') then
            local vampireSpells = {'set PCVampire to 1', 'addspell "vampire attributes"', 'addspell "vampire skills"', 'addspell "vampire immunities"'}
            for _, command in pairs(vampireSpells) do
                logicHandler.RunConsoleCommandOnPlayer(player.pid, command)
            end
            if vampTalk == false then
                logicHandler.RunConsoleCommandOnPlayer(player.pid, 'addspell "vampire sun damage"')
            elseif tableHelper.containsValue(player.data.spellbook, 'vampire blood quarra') then
                logicHandler.RunConsoleCommandOnPlayer(player.pid, 'addspell "vampire quarra specials"')
            elseif tableHelper.containsValue(player.data.spellbook, 'vampire blood aundae') then
                logicHandler.RunConsoleCommandOnPlayer(player.pid, 'addspell "vampire aundae specials"')
            elseif tableHelper.containsValue(player.data.spellbook, 'vampire blood berne') then
                logicHandler.RunConsoleCommandOnPlayer(player.pid, 'addspell "vampire berne specials"')
            end
        elseif tableHelper.containsValue(player.data.spellbook, 'werewolf blood') and werewolf and not tableHelper.containsValue(player.data.spellbook, 'werewolf resists') then
            local werewolfSpells = {'set PCWerewolf to 1', 'addspell "werewolf resists"', 'addspell "werewolf regeneration"', 'addspell "werewolf vision"'}
            for _, command in pairs(werewolfSpells) do
                logicHandler.RunConsoleCommandOnPlayer(player.pid, command)
            end
        end
    end
end

customEventHooks.registerValidator('OnPlayerCellChange', OnPlayerCellChange)