local RBT                         = LibStub("AceAddon-3.0"):GetAddon("ReturnBuffTracker")
local L                           = LibStub("AceLocale-3.0"):GetLocale("ReturnBuffTracker")

local format                      = format
local GetRaidRosterInfo           = GetRaidRosterInfo
local UnitIsAFK, UnitIsFeignDeath = UnitIsAFK, UnitIsFeignDeath
local MAX_PLAYER_LEVEL            = GetMaxPlayerLevel()
local RAID_CLASS_COLORS           = RAID_CLASS_COLORS

local tinsert, tconcat, tremove   = table.insert, table.concat, table.remove

local function Check(buff)
    --@debug@
    --RBT:Debugf("CheckCannotHelpRaid", "CheckCannotHelpRaid")
    --@end-debug@
    buff:ResetBuffData()
    if buff.deco_players then
        RBT:clearArrayList(buff.deco_players)
    else
        buff.deco_players = {}
    end
    if buff.afk_players then
        RBT:clearArrayList(buff.afk_players)
    else
        buff.afk_players = {}
    end
    if buff.fd_players then
        RBT:clearArrayList(buff.fd_players)
    else
        buff.fd_players = {}
    end
    --if buff.not_raid_instance_players then
    --    RBT:clearArrayList(buff.not_raid_instance_players)
    --else
    --    buff.not_raid_instance_players = {}
    --end
    if buff.low_level_players then
        RBT:clearArrayList(buff.low_level_players)
    else
        buff.low_level_players = {}
    end

    local slacker = false
    local name, rank, subgroup, level, class, fileName, zone, online, isDead, role, isML
    local colored_name
    for i = 1, 40 do
        name, rank, subgroup, level, class, fileName, zone, online, isDead, role, isML = GetRaidRosterInfo(i)
        if name then
            colored_name = RAID_CLASS_COLORS[fileName].colorStr
            colored_name = WrapTextInColorCode(name, colored_name)
            slacker      = false -- we assume they are doing good :)
            buff.total   = buff.total + 1
            --inInstance, instanceType = IsInInstance(name)
            if online and level < MAX_PLAYER_LEVEL then
                slacker = true
                --@debug@
                -- RBT:Debugf("CheckCannotHelpRaid", "Adding Low Level: %s", colored_name)
                --@end-debug@
                tinsert(buff.low_level_players, format("%s (%d)", colored_name, level))
            end
            if online then
                -- UnitIsConnected(name) then
                if UnitIsAFK(name) then
                    slacker = true
                    --@debug@
                    -- RBT:Debugf("CheckCannotHelpRaid", "Adding AFK: %s", colored_name)
                    --@end-debug@
                    tinsert(buff.afk_players, colored_name)
                end
                if UnitIsFeignDeath(name) then
                    slacker = true
                    --@debug@
                    -- RBT:Debugf("CheckCannotHelpRaid", "Adding FD: %s", colored_name)
                    --@end-debug@
                    tinsert(buff.fd_players, colored_name)
                end
                --if not inInstance or instanceType ~= "raid" then
                --    tinsert(buff.not_raid_instance_players, name)
                --    --@debug@
                --    RBT:Debugf("CheckCannotHelpRaid", "Adding No in raid instance: %s", name)
                --    --@end-debug@
                --    slacker = true
                --end
                if slacker then
                    buff.count = buff.count + 1
                end
            else
                buff.count = buff.count + 1
                --@debug@
                -- RBT:Debugf("CheckCannotHelpRaid", "Adding deco: %s", colored_name)
                --@end-debug@
                tinsert(buff.deco_players, colored_name)
            end

        end
    end
end

local function BuildToolTip(buff)
    --@debug@
    -- RBT:Debugf("CheckCannotHelpRaid", "Preparing tooltip")
    --@end-debug@

    local percent_string = RBT:compute_percent_string(buff.count, buff.total)
    local header         = format("%s %d/%d %s",
                                  "Boulets:",
                                  buff.count, buff.total,
                                  percent_string)
    tinsert(buff.tooltip, header)
    local low_str = format(" ||- level < max (%d):", MAX_PLAYER_LEVEL)
    local mapping = { [" ||- Deco:"] = buff.deco_players,
                      [" ||- AFK :"] = buff.afk_players,
                      [" ||- FD  :"] = buff.fd_players,
        --[" ||- Not in raid instance:"] = buff.not_raid_instance_players,
                      [low_str]      = buff.low_level_players,
    }
    local tmp_str
    for line_label, players_table in pairs(mapping) do
        --@debug@
        -- RBT:Debugf("CheckCannotHelpRaid", "Tooltip %s", line_label)
        --@end-debug@
        if players_table and #players_table > 0 then
            --@debug@
            -- RBT:Debugf("CheckCannotHelpRaid", "Tooltip %s has players in list", line_label)
            --@end-debug@
            if #players_table <= 5 then
                tmp_str = tconcat(players_table, " ")
                tmp_str = format("%s %s", line_label, tmp_str)
                tinsert(buff.tooltip, tmp_str)
            else
                tmp_str = format("%s %d", line_label, #players_table)
                tinsert(buff.tooltip, tmp_str)
            end
            --@debug@
        else
            -- RBT:Debugf("CheckCannotHelpRaid", "Tooltip %s 0 players in list", line_label)
            --@end-debug@
        end
    end
end

local check_conf = {
    name             = L["Useless unit"],
    shortName        = L["Useless unit"],
    color            = { r = 1.0, g = 0.3, b = 0.3 },
    func             = Check,
    buffOptionsGroup = L["General"],
    BuildToolTipText = BuildToolTip,
}
RBT:RegisterCheck(check_conf)