local RBT                                 = LibStub("AceAddon-3.0"):GetAddon("ReturnBuffTracker")
local L                                   = LibStub("AceLocale-3.0"):GetLocale("ReturnBuffTracker")

local WARRIOR, MAGE, ROGUE, DRUID, HUNTER = "WARRIOR", "MAGE", "ROGUE", "DRUID", "HUNTER"
local SHAMAN, PRIEST, WARLOCK, PALADIN    = "SHAMAN", "PRIEST", "WARLOCK", "PALADIN"
local format                              = format
local GetRaidRosterInfo                   = GetRaidRosterInfo

local UnitIsAFK, UnitIsFeignDeath         = UnitIsAFK, UnitIsFeignDeath
local UnitBuff, UnitIsConnected           = UnitBuff, UnitIsConnected
local RAID_CLASS_COLORS                   = RAID_CLASS_COLORS
local tinsert, tconcat, tremove           = table.insert, table.concat, table.remove

RBT.localized_classes                     = {}
FillLocalizedClassList(RBT.localized_classes, true)

RBT.all_classes                           = { WARRIOR, MAGE, ROGUE, DRUID, HUNTER, SHAMAN, PRIEST, WARLOCK, PALADIN }
local MAX_PLAYER_LEVEL                    = GetMaxPlayerLevel()
RBT.ITEM_QUALITY_ENUM_TO_LOCALIZED_STRING = {
}
local _G                                  = _G
local BUFF_MAX_DISPLAY                    = BUFF_MAX_DISPLAY
for quality_base_name, quality_int_val in pairs(Enum.ItemQuality) do
    RBT.ITEM_QUALITY_ENUM_TO_LOCALIZED_STRING[quality_int_val] = _G[format("ITEM_QUALITY%d_DESC", quality_int_val)]
end

RBT.Buffs = {}

function RBT:compute_percent_string(nb, total)
    --@debug@
    -- RBT:Debugf("compute_percent_string", "compute_percent_string(%s, %s)", tostring(nb), tostring(total))
    --@end-debug@
    local return_value_str = "NA"
    local return_value_f
    if total > 0 and nb <= total then
        return_value_f = (nb / total)
        if return_value_f ~= return_value_f then
            -- NaN/Inf checks
            return_value_str = "NA"
            return_value_f   = nil
        else
            return_value_str = format("%.0f%%", return_value_f * 100.0)
        end
    end
    return return_value_str, return_value_f
end

function RBT:clearArrayList(t)
    local count = #t
    for i = 0, count do
        t[i] = nil
    end
end

function RBT:clearTable(t)
    for k, _ in pairs(t) do
        t[k] = nil
    end
end

--function RBT:ClearBuffTooltipTable(buff)
local function ClearBuffTooltipTable(buff)
    --@debug@
    RBT:Debugf("ClearBuffTooltipTable", "ClearBuffTooltipTable for %s", buff.displayText)
    --@end-debug@
    if buff.tooltip then
        RBT:clearArrayList(buff.tooltip)
    else
        buff.tooltip = {}
    end
end

--function RBT:ResetBuffData(buff)
local function ResetBuffData(buff)
    --@debug@
    RBT:Debugf("ResetBuffData", "ResetBuffData for %s", buff.displayText)
    --@end-debug@
    buff.count = 0
    buff.total = 0
    --RBT:ClearBuffTooltipTable(buff)
    ClearBuffTooltipTable(buff)
end

function RBT:CheckUnitCannotHelpRaid(name)
    local slacker   = false
    local low_level = false
    local afk       = false
    local fd        = false
    --local inInstance, instanceType = IsInInstance(name)
    local co        = UnitIsConnected(name)
    --local not_in_raid              = not inInstance or instanceType ~= "raid"
    if co then
        afk       = UnitIsAFK(name)
        fd        = UnitIsFeignDeath(name)
        low_level = UnitLevel(name) < MAX_PLAYER_LEVEL
    end

    slacker = not co or afk or fd or low_level -- or not_in_raid
    return slacker, not co, fd, low_level --, not_in_raid
end

function RBT:CheckUnitIsRealDPS(name)
    local is_real_dps = true
    local real_role   = "DPS"
    if GetPartyAssignment("MAINTANK", name) then
        is_real_dps = false
        real_role   = "MAINTANK"
    else
        -- ok
    end
    return is_real_dps, real_role
end

local non_healer_class_buff_ids_clues = {
    [15473] = "SHADOWPRIEST", -- shadowform buff
    [24907] = "MOONKIN", -- moonkin buff
}

function RBT:CheckUnitIsRealHealer(name)
    local is_real_healer = true
    local real_role      = "HEALER"
    if RBT:CheckUnitBuff(name, { buffIDs = { 15473 } }) then
        is_real_healer = false
        real_role      = "SHADOWPRIEST"
    elseif RBT:CheckUnitBuff(name, { buffIDs = { 24858 } }) then
        is_real_healer = false
        real_role      = "MOONKIN"
    elseif RBT:CheckUnitBuff(name, { buffIDs = { 768 } }) then
        is_real_healer = false
        real_role      = "CAT"
    elseif GetPartyAssignment("MAINTANK", name) then
        is_real_healer = false
        real_role      = "MAINTANK"
    else
        -- ok
    end
    return is_real_healer, real_role
end

function RBT:CountUnitPower(name, power_type, current_power_type)
    local unitPower    = UnitPower(name, power_type)
    local unitPowerMax = UnitPowerMax(name, power_type)

    return unitPower, unitPowerMax, unitPower / unitPowerMax
end

local function fill_tooltip_data_array(buff,
                                       tool_tip_index)
    local player_name_data_map = buff.bad_players
    local p_class
    local tmp                  = {}
    if buff.missingMode == L["class"] then
        for _, player in pairs(player_name_data_map) do
            p_class = player.class
            if not tmp[p_class] then
                tmp[p_class] = {}
            end
            tinsert(tmp[p_class], player.name)
        end

        for cls, player_names_array in pairs(tmp) do
            if #player_names_array > 0 then
                buff.tooltip[tool_tip_index] = format("%s : %s",
                                                      RBT.localized_classes[cls],
                                                      tconcat(player_names_array, " "))
                tool_tip_index               = tool_tip_index + 1
            end
        end
    else
        local player_group_nb
        for _, player in pairs(player_name_data_map) do
            player_group_nb = tonumber(player.group)
            if not tmp[player_group_nb] then
                tmp[player_group_nb] = {}
            end
            tinsert(tmp[player_group_nb], player.name)
        end

        --table.sort(tmp) -- its a table of <group number ; list>

        --for group_nb, player_names_array in ipairs(tmp) do
        local player_names_array
        for group_nb = 1, 8 do
            player_names_array = tmp[group_nb]
            if player_names_array and #player_names_array > 0 then

                buff.tooltip[tool_tip_index] = format("%s %s",
                                                      format("%s: %d", L["Group"], group_nb),
                                                      tconcat(player_names_array, " "))
                tool_tip_index               = tool_tip_index + 1
            end
        end
    end
    return tool_tip_index
end

--function RBT:CheckBuff(buff)
local function CheckBuff(buff)
    buff:ResetBuffData()

    local slacker, disco, fd, not_in_raid, low_level

    local isClassExpected
    if buff.ignoredPlayers then
        for k, v in pairs(buff.ignoredPlayers) do
            RBT:clearArrayList(v)
        end
    else
        buff.ignoredPlayers = {}
    end
    if buff.bad_players then
        RBT:clearTable(buff.bad_players)
    else
        buff.bad_players = {}
    end
    for player_name, player_cache_data in pairs(RBT.raid_player_cache) do

        slacker, disco, fd = unpack(player_cache_data.slack_status)
        if slacker then
            --@debug@
                RBT:Debugf("CheckBuff", "Checking %s is SLACKER, ignoring", player_cache_data.colored_player_name)
            --@end-debug@
            if not buff.ignoredPlayers["Slacker"] then
                buff.ignoredPlayers["Slacker"] = {}
            end
                tinsert(buff.ignoredPlayers["Slacker"], player_cache_data.colored_player_name)
        else
            isClassExpected = RBT:Contains(buff.classes, player_cache_data.class)
            if isClassExpected then
                buff.total = buff.total + 1
                if RBT:CheckUnitBuff(player_name, buff) then
                    buff.count = buff.count + 1
                else
                        buff.bad_players[player_name] = { name  = player_cache_data.colored_player_name,
                                                      group = player_cache_data.group,
                                                      class = player_cache_data.class,
                    }
                end
            end
        end
    end
    --for i = 1, 40 do
    --    player_name, _, player_group, _, player_localized_class, player_class = GetRaidRosterInfo(i)
    --    if player_class then
    --        slacker, disco, fd = RBT:CheckUnitCannotHelpRaid(player_name)
    --        if slacker then
    --            --@debug@
    --            RBT:Debugf("CheckBuff", "Checking %s is SLACKER, ignoring", tostring(player_name))
    --            --@end-debug@
    --            if not buff.ignoredPlayers["Slacker"] then
    --                buff.ignoredPlayers["Slacker"] = {}
    --            end
    --            tinsert(buff.ignoredPlayers["Slacker"], player_name)
    --        else
    --            isClassExpected = RBT:Contains(buff.classes, player_class)
    --            if isClassExpected then
    --                buff.total = buff.total + 1
    --                if RBT:CheckUnitBuff(player_name, buff) then
    --                    buff.count = buff.count + 1
    --                else
    --                    buff.bad_players[player_name] = { name  = player_name,
    --                                                      group = player_group,
    --                                                      class = player_class,
    --                    }
    --                end
    --            end
    --        end
    --    end
    --end
end

local function BuildToolTip(buff)
    buff.tooltip[1]              = format("%s %s --> %s",
                                          "{rt7}",
                                          L["Missing"],
                                          (buff.name or buff.shortName or tostring(buff.buffIDs[1])))
    local tool_tip_index         = 2
    buff.tooltip[tool_tip_index] = L["no one"].."."

    tool_tip_index               = fill_tooltip_data_array(buff, tool_tip_index)

    local players_str
    for reason, player_details in pairs(buff.ignoredPlayers) do
        --@debug@
        RBT:Debugf("CheckBuff", "Ignored players: [%s] = %d", tostring(reason), #player_details)
        --@end-debug@
        if #player_details > 0 then
            players_str = tconcat(player_details, " ")
            tinsert(buff.tooltip,
                    format("Ignoring [%s]: %s", tostring(reason), players_str))
        end
    end
end

function RBT:CheckUnitBuff(player_name, buff)
    -- exploit cache
    local player_cache_data
    if buff.buffIDs then
        if type(buff.buffIDs) == "table" then
            for _, v in pairs(buff.buffIDs) do
                player_cache_data = RBT.raid_player_cache[player_name]
                if RBT.raid_player_cache[player_name].active_buff_ids[v] then
                    return true, RBT.raid_player_cache[player_name].active_buff_ids[v].caster
                end
            end
        else
            --if RBT.raid_player_cache[player_name].active_buff_ids[buff.buffIDs then
            --    return true, caster
            --end
            print("WTF_BBQ ?! type: " .. type(buff.buffIDs))
        end
    end
    return false, nil
end
--function RBT:CheckUnitBuff(unit, buff)
--    local buff_name, caster, spellId
--    for i = 1, BUFF_MAX_DISPLAY do
--        buff_name, _, _, _, _, _, caster, _, _, spellId = UnitBuff(unit, i)
--        if buff.buffIDs then
--            if type(buff.buffIDs) == table then
--                for _, v in pairs(buff.buffIDs) do
--                    if RBT:Contains(v, spellId) then
--                        return true, caster
--                    end
--                end
--            else
--                if RBT:Contains(buff.buffIDs, spellId) then
--                    return true, caster
--                end
--            end
--        else
--            if (buff.buffNames and RBT:Contains(buff.buffNames, buff_name)) or
--                    buff.name == buff_name then
--                return true, caster
--            end
--        end
--
--    end
--    return false, nil
--end

function RBT:RegisterCheck(check_conf)
    check_conf.total   = 0
    check_conf.count   = 0
    check_conf.tooltip = {}
    if not check_conf.func then
        check_conf.func = CheckBuff
    end
    if not check_conf.BuildToolTipText then
        check_conf.BuildToolTipText = BuildToolTip
    end
    if not check_conf.SpecialBarDisplay then
        check_conf.SpecialBarDisplay = function()
            return check_conf.displayText
        end
    end
    check_conf.ResetBuffData = ResetBuffData
    tinsert(RBT.Buffs, check_conf)
    check_conf.ready = true
end
