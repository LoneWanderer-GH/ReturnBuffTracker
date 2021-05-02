local RBT                                 = LibStub("AceAddon-3.0"):GetAddon("ReturnBuffTracker")
local L                                   = LibStub("AceLocale-3.0"):GetLocale("ReturnBuffTracker")

local WARRIOR, MAGE, ROGUE, DRUID, HUNTER = "WARRIOR", "MAGE", "ROGUE", "DRUID", "HUNTER"
local SHAMAN, PRIEST, WARLOCK, PALADIN    = "SHAMAN", "PRIEST", "WARLOCK", "PALADIN"
local format                              = format

local CreateColor                         = CreateColor
local UnitIsAFK, UnitIsFeignDeath         = UnitIsAFK, UnitIsFeignDeath
local UnitIsConnected                     = UnitIsConnected

local tinsert, tconcat, tremove           = table.insert, table.concat, table.remove

RBT.localized_classes                     = {}
FillLocalizedClassList(RBT.localized_classes, true)

RBT.all_classes                           = { WARRIOR, MAGE, ROGUE, DRUID, HUNTER, SHAMAN, PRIEST, WARLOCK, PALADIN }
local MAX_PLAYER_LEVEL                    = GetMaxPlayerLevel()
RBT.ITEM_QUALITY_ENUM_TO_LOCALIZED_STRING = {}
RBT.ITEM_QUALITY_ENUM_TO_COLOR            = {}
local _G                                  = _G

do
    local r, g, b, hex
    for quality_base_name, quality_int_val in pairs(Enum.ItemQuality) do
        RBT.ITEM_QUALITY_ENUM_TO_LOCALIZED_STRING[quality_int_val] = _G[format("ITEM_QUALITY%d_DESC", quality_int_val)]
        r, g, b, hex                                               = GetItemQualityColor(quality_int_val)
        RBT.ITEM_QUALITY_ENUM_TO_COLOR[quality_int_val]            = { r = r, g = g, b = b, colorStr = hex, }
    end
end

RBT.Buffs = {}

function RBT:compute_percent_string(nb, total)
    --@debug@
    -- RBT:Debugf("compute_percent_string", "compute_percent_string(%s, %s)", tostring(nb), tostring(total))
    --@end-debug@
    local return_value_str = ""
    local return_value_f   = 0.0
    if total > 0 and nb <= total then
        return_value_f = (nb / total)
        if return_value_f ~= return_value_f then
            -- NaN/Inf checks
            return_value_str = ""
            return_value_f   = nil
        else
            return_value_str = string.format("%.0f%%", return_value_f * 100.0)
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
    -- RBT:Debugf("ClearBuffTooltipTable", "ClearBuffTooltipTable for %s", buff.displayText)
    --@end-debug@
    if buff.tooltip.main_text then
        RBT:clearArrayList(buff.tooltip.main_text)
    else
        buff.tooltip.main_text = {}
    end
    if buff.tooltip.slacker_text then
        RBT:clearArrayList(buff.tooltip.slacker_text)
    else
        buff.tooltip.slacker_text = {}
    end

end

--function RBT:ResetBuffData(buff)
local function ResetBuffData(buff)
    --@debug@
    -- RBT:Debugf("ResetBuffData", "ResetBuffData for %s", buff.displayText)
    --@end-debug@
    buff.count = 0
    buff.total = 0
    --RBT:ClearBuffTooltipTable(buff)
    ClearBuffTooltipTable(buff)
end

function RBT:CheckUnitCannotHelpRaid(name)
    local slacker
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
        --else
        --    -- ok
    end
    return is_real_dps, real_role
end

RBT.POWER_IGNORED_ROLES = { L["Slacker"],
                              --L["HEALER"],
                              L["SHADOWPRIEST"],
                              L["MOONKIN"],
                              L["MAINTANK"],
                              L["CAT"],
                              L["SHAMELIO"],
                              L["CHAMELEM"]
}
for p, _ in pairs(Enum.PowerType) do
    table.insert(RBT.POWER_IGNORED_ROLES, p)
end

RBT.non_healer_class_buff_ids_clues = {

    [15473] = L["SHADOWPRIEST"], -- shadowform buff

    [24907] = L["MOONKIN"], -- moonkin buff
    [768]   = L["CAT"], -- cat form
    --[24932] = L["BEARTANK"], -- leader of the pack

    [16257] = L["SHAMELIO"], -- flurry
    [16277] = L["SHAMELIO"], -- flurry
    [16278] = L["SHAMELIO"], -- flurry
    [16279] = L["SHAMELIO"], -- flurry
    [16280] = L["SHAMELIO"], -- flurry

    [16246] = L["CHAMELEM"], -- clearcast
    [16166] = L["CHAMELEM"], -- elemental mastery
    --[29063] = L["CHAMELEM"], -- Focused casting
}

RBT.buff_def_not_healer             = {
    buffIDs = { 15473,

                24858,
                768,
        --24932,

                16257, 16277, 16278, 16279, 16280,

                16166, 16246, --29063
    },
}

--RBT.healer_class_buff_ids_clues = {
--    [17116] = L["RESTAURATION_DRUID"], -- Nature's switftness
--}

function RBT:CheckUnitIsRealHealer(name)
    local is_real_healer = true
    local real_role      = L["HEALER"]

    if self.raid_player_cache[name].role then
        -- we already checked that player was not to be considered as a healer
        is_real_healer = self.raid_player_cache[name].is_real_healer
        real_role      = self.raid_player_cache[name].role
    else
        -- try to determine if it is really a healer
        local is_dps_aura_present, _, matching_id = RBT:CheckUnitBuff(name, RBT.buff_def_not_healer)
        if is_dps_aura_present then
            is_real_healer                              = false
            real_role                                   = RBT.non_healer_class_buff_ids_clues[matching_id]
            self.raid_player_cache[name].is_real_healer = is_real_healer
            self.raid_player_cache[name].role           = real_role
        elseif GetPartyAssignment("MAINTANK", name) then
            is_real_healer                              = false
            real_role                                   = L["MAINTANK"]
            self.raid_player_cache[name].is_real_healer = is_real_healer
            self.raid_player_cache[name].role           = real_role
        end
    end

    return is_real_healer, real_role
end

function RBT:CountUnitPower(name, power_type)
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
                buff.tooltip.main_text[tool_tip_index] = format("%s : %s",
                                                                RBT.localized_classes[cls],
                                                                tconcat(player_names_array, " "))
                tool_tip_index                         = tool_tip_index + 1
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

                buff.tooltip.main_text[tool_tip_index] = format("%s %s",
                                                                format("%s: %d", L["Group"], group_nb),
                                                                tconcat(player_names_array, " "))
                tool_tip_index                         = tool_tip_index + 1
            end
        end
    end
    return tool_tip_index
end

local function CheckBuff(buff)
    buff:ResetBuffData()

    local slacker, disco, fd, low_level

    local isClassExpected
    if buff.ignoredPlayers then
        for _, v in pairs(buff.ignoredPlayers) do
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
    local has_buff
    for player_name, player_cache_data in pairs(RBT.raid_player_cache) do
        slacker, disco, fd, low_level = unpack(player_cache_data.slack_status)
        isClassExpected               = RBT:Contains(buff.classes, player_cache_data.class)
        if isClassExpected then
            if slacker then
                --@debug@
                -- RBT:Debugf("CheckBuff", "Checking %s is SLACKER, ignoring", player_cache_data.colored_player_name)
                --@end-debug@
                if not buff.ignoredPlayers["Slacker"] then
                    buff.ignoredPlayers["Slacker"] = {}
                end
                tinsert(buff.ignoredPlayers["Slacker"], player_cache_data.colored_player_name)
            else
                buff.total  = buff.total + 1
                has_buff, _ = RBT:CheckUnitBuff(player_name, buff)
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
end

local function BuildToolTip(buff)
    local colored_buff_name                = WrapTextInColorCode((buff.name or buff.shortName or tostring(buff.buffIDs[1])),
                                                                 buff.color.colorStr)
    buff.tooltip.main_text[1]              = format("%s %s",
                                                    L["Missing"],
                                                    colored_buff_name)
    local tool_tip_index                   = 2
    buff.tooltip.main_text[tool_tip_index] = L["no one"] .. "."

    tool_tip_index                         = fill_tooltip_data_array(buff, tool_tip_index)

    local players_str

    for reason, player_details in pairs(buff.ignoredPlayers) do
        --@debug@
        -- RBT:Debugf("CheckBuff", "Ignored players: [%s] = %d", tostring(reason), #player_details)
        --@end-debug@
        if #player_details > 0 then
            players_str = tconcat(player_details, " ")
            tinsert(buff.tooltip.slacker_text,
                    format("Ignoring [%s]: %s", tostring(reason), players_str))
        end
    end
end

function RBT:CheckUnitBuff(player_name, buff)
    -- exploit cache
    local player_cache_data = RBT.raid_player_cache[player_name]
    if buff.buffIDs then
        if type(buff.buffIDs) == "table" then
            for _, spell_id in pairs(buff.buffIDs) do
                if player_cache_data.active_buff_ids[spell_id] then
                    return true, player_cache_data.active_buff_ids[spell_id].caster, spell_id
                end
            end
        else
            print("WTF_BBQ ?! type: " .. type(buff.buffIDs))
        end
    end
    return false
end

function RBT:RegisterCheck(check_conf)
    check_conf.total   = 0
    check_conf.count   = 0
    check_conf.tooltip = {
        main_text    = {},
        slacker_text = {},
    }
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

    local colorMixin          = CreateColor(check_conf.color.r,
                                            check_conf.color.g,
                                            check_conf.color.b,
                                            check_conf.color.a or 1.0)
    check_conf.color.colorStr = colorMixin:GenerateHexColor()
    check_conf.ResetBuffData  = ResetBuffData
    tinsert(RBT.Buffs, check_conf)
    check_conf.ready = true
end
