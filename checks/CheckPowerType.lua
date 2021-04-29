local RBT                                 = LibStub("AceAddon-3.0"):GetAddon("ReturnBuffTracker")
local L                                   = LibStub("AceLocale-3.0"):GetLocale("ReturnBuffTracker")

local WARRIOR, MAGE, ROGUE, DRUID, HUNTER = "WARRIOR", "MAGE", "ROGUE", "DRUID", "HUNTER"
local SHAMAN, PRIEST, WARLOCK, PALADIN    = "SHAMAN", "PRIEST", "WARLOCK", "PALADIN"
local format                              = format
local GetRaidRosterInfo                   = GetRaidRosterInfo

local UnitPowerType                       = UnitPowerType
local mana_power                          = Enum.PowerType.Mana
local tinsert, tconcat, tremove           = table.insert, table.concat, table.remove

local mana_power_RGB                      = PowerBarColor[mana_power]
local RAID_CLASS_COLORS                   = RAID_CLASS_COLORS

local POWER_IGNORED_ROLES                 = { "Slacker", "HEALER", "SHADOWPRIEST", "MOONKIN", "MAINTANK", "CAT" }
for p, _ in pairs(Enum.PowerType) do
    table.insert(POWER_IGNORED_ROLES, p)
end

local function CheckPowerType(buff)
    --@debug@
    -- RBT:Debugf("CheckPowerType", "CheckPowerType - power = %s", tostring(buff.name))
    --@end-debug@
    
    buff:ResetBuffData()
    if buff.ignoredPlayers then
        --for role, name_list in ipairs(POWER_IGNORED_ROLES) do
        for role, name_list in pairs(buff.ignoredPlayers) do
            --RBT:clearArrayList(buff.ignoredPlayers[role])
            RBT:clearArrayList(name_list)
        end
    else
        buff.ignoredPlayers = {}
        for _, role_number in ipairs(POWER_IGNORED_ROLES) do
            buff.ignoredPlayers[role_number] = {}
            --@debug@
            -- RBT:Debugf("CheckPowerType", "Adding power ignore: %s", role_number)
            --@end-debug@
        end
    end
    
    local unitPower, unitPowerMax, unitPowerPercent, unitPowerType, unitPowerTypeName
    
    local slacker, disco, fd, low_level
    local is_real_healer, is_real_dps, real_role
    for player_name, player_cache_data in pairs(RBT.raid_player_cache) do
        if player_cache_data.class and RBT:Contains(buff.classes, player_cache_data.class) then
            slacker, disco, fd, low_level = unpack(player_cache_data.slack_status)
            if slacker then
                --@debug@
                -- RBT:Debugf("CheckPowerType", "Checking %s is SLACKER, ignoring", player_cache_data.colored_player_name)
                --@end-debug@
                tinsert(buff.ignoredPlayers["Slacker"], player_cache_data.colored_player_name)
            else
                unitPowerType, unitPowerTypeName = UnitPowerType(player_name)
                -- --@debug@
                -- RBT:Debugf("CheckPowerType", "Checking %s -> %s", tostring(name), unitPowerTypeName)
                -- --@end-debug@
                --if unitPowerType ~= buff.powerType then
                --    if not buff.ignoredPlayers[unitPowerType] then
                --        --@debug@
                --        RBT:Warningf("CheckPowerType", "Missing energy ?! %s, %s", unitPowerType, unitPowerTypeName)
                --        buff.ignoredPlayers[unitPowerTypeName] = {}
                --        --@end-debug@
                --    end
                --    tinsert(buff.ignoredPlayers[unitPowerTypeName], name)
                --else
                -- --@debug@
                -- RBT:Debugf("CheckPowerType", "%s has the targeted power (%s)", tostring(name), unitPowerTypeName)
                -- --@end-debug@
                
                --unitPower    = UnitPower(name, buff.powerType)
                --unitPowerMax = UnitPowerMax(name, buff.powerType)
                --if not UnitIsConnected(name) then
                --    if not ignoredPlayers["DISCONNECTED"] then
                --        ignoredPlayers["DISCONNECTED"] = {}
                --    end
                --    tinsert(ignoredPlayers["DISCONNECTED"], name)
                --else
                
                
                if buff.shortName == L["Healer"] then
                    is_real_healer, real_role = RBT:CheckUnitIsRealHealer(player_name)
                    if not is_real_healer then
                        tinsert(buff.ignoredPlayers[real_role], player_cache_data.colored_player_name)
                    else
                        unitPower, unitPowerMax, unitPowerPercent = RBT:CountUnitPower(player_name,
                                                                                       buff.powerType)
                        buff.count                                = buff.count + unitPower
                        buff.total                                = buff.total + unitPowerMax
                    end
                elseif buff.shortName == L["DPS"] then
                    is_real_dps, real_role = RBT:CheckUnitIsRealDPS(player_name)
                    if not is_real_dps then
                        tinsert(buff.ignoredPlayers[real_role], player_cache_data.colored_player_name)
                    else
                        unitPower, unitPowerMax, unitPowerPercent = RBT:CountUnitPower(player_name,
                                                                                       buff.powerType)
                        --
                        buff.count                                = buff.count + unitPower
                        buff.total                                = buff.total + unitPowerMax
                    end
                    --@debug@
                else
                    RBT:Debugf("CheckPowerType", "Checking power type that is not DPS mana and not HEALER mana ?!")
                    --@end-debug@
                end
                --end
            end
        end
    end
end

local function BuildToolTip(buff)
    local percent_string = RBT:compute_percent_string(buff.count, buff.total)
    local header         = format("%s: %s", tostring(buff.name), percent_string)
    
    tinsert(buff.tooltip.main_text, header)
    
    for reason, player_details in pairs(buff.ignoredPlayers) do
        --@debug@
        -- RBT:Debugf("CheckPowerType", "Ignored players: [%s] = %d", tostring(reason), #player_details)
        --@end-debug@
        if #player_details > 0 then
            local players_str = tconcat(player_details, " ")
            tinsert(buff.tooltip.slacker_text,
                    format(" ||- Ignoring [%s]: %s", tostring(reason), players_str))
        end
    end
end

local healer_mana = {
    name             = L["Healer Mana"],
    shortName        = L["Healer"],
    optionText       = L["Healer Mana"],
    powerType        = Enum.PowerType.Mana,
    func             = CheckPowerType,
    --color            = { r = 0.4, g = 0.6, b = 1 },
    color            = mana_power_RGB,
    classes          = { PRIEST, PALADIN, DRUID, SHAMAN },
    buffOptionsGroup = L["General"],
    BuildToolTipText = BuildToolTip,
}

local dps_mana    = {
    name             = L["DPS Mana"],
    shortName        = L["DPS"],
    optionText       = L["DPS Mana"],
    powerType        = Enum.PowerType.Mana,
    func             = CheckPowerType,
    --color            = { r = 0.2, g = 0.2, b = 1 },
    color            = RAID_CLASS_COLORS[MAGE],
    classes          = { HUNTER, WARLOCK, MAGE },
    buffOptionsGroup = L["General"],
    BuildToolTipText = BuildToolTip,
}

RBT:RegisterCheck(healer_mana)
RBT:RegisterCheck(dps_mana)