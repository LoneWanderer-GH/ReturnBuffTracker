local ReturnBuffTracker                   = LibStub("AceAddon-3.0"):GetAddon("ReturnBuffTracker")
local L                                   = LibStub("AceLocale-3.0"):GetLocale("ReturnBuffTracker")

local WARRIOR, MAGE, ROGUE, DRUID, HUNTER = "WARRIOR", "MAGE", "ROGUE", "DRUID", "HUNTER"
local SHAMAN, PRIEST, WARLOCK, PALADIN    = "SHAMAN", "PRIEST", "WARLOCK", "PALADIN"
local format                              = format
local tinsert, tconcat, tremove           = table.insert, table.concat, table.remove

local localized_classes                   = {}
FillLocalizedClassList(localized_classes, true)

local all_classes       = { WARRIOR, MAGE, ROGUE, DRUID, HUNTER, SHAMAN, PRIEST, WARLOCK, PALADIN }

ReturnBuffTracker.Buffs = {
    {
        name             = L["Alive"],
        shortName        = L["Alive"],
        func             = "CheckAlive",
        color            = { r = 0.3, g = 1, b = 0.3 },
        buffOptionsGroup = L["General"]
    },
    {
        name             = L["Useless unit"],
        shortName        = L["Useless unit"],
        color            = { r = 1.0, g = 0.3, b = 0.3 },
        func             = "CheckCannotHelpRaid",
        buffOptionsGroup = L["General"],
    },
    --{
    --    name             = L["Carrot on a stick"],
    --    shortName        = L["Carrot on a stick"],
    --    color            = { r = 1.0, g = 0.3, b = 0.3 },
    --    func             = "CheckCarrot",
    --    buffOptionsGroup = L["General"],
    --},
    {
        name             = L["Healer Mana"],
        shortName        = L["Healer"],
        optionText       = L["Healer Mana"],
        powerType        = Enum.PowerType.Mana,
        func             = "CheckPowerType",
        color            = { r = 0.4, g = 0.6, b = 1 },
        classes          = { PRIEST, PALADIN, DRUID, SHAMAN },
        buffOptionsGroup = L["General"]
    },
    {
        name             = L["DPS Mana"],
        shortName        = L["DPS"],
        optionText       = L["DPS Mana"],
        powerType        = Enum.PowerType.Mana,
        func             = "CheckPowerType",
        color            = { r = 0.2, g = 0.2, b = 1 },
        classes          = { HUNTER, WARLOCK, MAGE },
        buffOptionsGroup = L["General"]
    },
    {
        name             = L["In Combat"],
        shortName        = L["In Combat"],
        color            = { r = 1, g = 1, b = 1 },
        buffOptionsGroup = L["General"],
        func             = "CheckInCombat"
    },
    {
        name             = L["Soulstone Resurrection"],
        shortName        = L["Soulstones"],
        color            = { r = 0.58, g = 0.51, b = 0.79 },
        buffIDs          = { 20765 },
        buffOptionsGroup = L["Player buffs"],
        func             = "CheckSoulstones",
        buffingClass     = WARLOCK,
    },
    {
        name             = L["Arcane Intellect"],
        shortName        = L["Intellect"],
        color            = { r = 0.41, g = 0.8, b = 0.94 },
        buffNames        = { L["Arcane Intellect"], L["Arcane Brilliance"] },
        buffIDs          = { 10157, 23028 },
        classes          = { HUNTER, WARLOCK, PRIEST, PALADIN, DRUID, MAGE, SHAMAN },
        buffOptionsGroup = L["Player buffs"],
        buffingClass     = MAGE,
    },
    {
        name             = L["Mark of the Wild"],
        shortName        = L["MotW"],
        color            = { r = 1.0, g = 0.49, b = 0.04 },
        buffIDs          = { 9885, 21850, 16878 },
        buffNames        = { L["Mark of the Wild"], L["Gift of the Wild"] },
        buffOptionsGroup = L["Player buffs"],
        buffingClass     = DRUID,
        classes          = all_classes,
    },
    {
        name             = L["Power Word: Fortitude"],
        shortName        = L["Fortitude"],
        color            = { r = 1.0, g = 1.0, b = 1.0 },
        buffIDs          = { 10938, 21564 },
        buffNames        = { L["Power Word: Fortitude"], L["Prayer of Fortitude"] },
        buffOptionsGroup = L["Player buffs"],
        buffingClass     = PRIEST,
        classes          = all_classes,
    },
    {
        name             = L["Divine Spirit"],
        shortName        = L["Spirit"],
        color            = { r = 1.0, g = 1.0, b = 1.0 },
        buffNames        = { L["Divine Spirit"], L["Prayer of Spirit"] },
        buffIDs          = { 27841, 27681 },
        classes          = { PRIEST, PALADIN, DRUID, MAGE, SHAMAN, WARLOCK },
        buffOptionsGroup = L["Player buffs"],
        buffingClass     = PRIEST,
    },
    {
        name             = L["Shadow Protection"],
        shortName        = L["Shadow Prot."],
        color            = { r = 0.6, g = 0.6, b = 0.6 },
        buffIDs          = { 10958, 27683 },
        buffNames        = { L["Shadow Protection"], L["Prayer of Shadow Protection"] },
        buffOptionsGroup = L["Player buffs"],
        buffingClass     = PRIEST,
        classes          = all_classes,
    },
    {
        name             = L["Blessing of Kings"],
        shortName        = L["Kings"],
        color            = { r = 0.96, g = 0.55, b = 0.73 },
        buffNames        = { L["Blessing of Kings"], L["Greater Blessing of Kings"] },
        buffIDs          = { 20217, 25898 },
        buffOptionsGroup = L["Player buffs"],
        missingMode      = L["class"],
        buffingClass     = PALADIN,
        classes          = all_classes,
    },
    {
        name             = L["Blessing of Salvation"],
        shortName        = L["Salvation"],
        color            = { r = 0.96, g = 0.55, b = 0.73 },
        buffIDs          = { 1038, 25895 },
        buffNames        = { L["Blessing of Salvation"], L["Greater Blessing of Salvation"] },
        buffOptionsGroup = L["Player buffs"],
        missingMode      = L["class"],
        buffingClass     = PALADIN,
        classes          = { MAGE, WARLOCK, PRIEST, HUNTER, ROGUE },
    },
    {
        name             = L["Blessing of Wisdom"],
        shortName        = L["Wisdom"],
        color            = { r = 0.96, g = 0.55, b = 0.73 },
        buffNames        = { L["Blessing of Wisdom"], L["Greater Blessing of Wisdom"] },
        buffIDs          = { 19854, 25290, 25894, 25918 },
        classes          = { HUNTER, WARLOCK, PRIEST, PALADIN, DRUID, MAGE },
        buffOptionsGroup = L["Player buffs"],
        missingMode      = L["class"],
        buffingClass     = PALADIN,
    },
    {
        name             = L["Blessing of Might"],
        shortName        = L["Might"],
        color            = { r = 0.96, g = 0.55, b = 0.73 },
        buffNames        = { L["Blessing of Might"], L["Greater Blessing of Might"] },
        buffIDs          = { 19838, 25291, 25782, 25916 },
        classes          = { WARRIOR, ROGUE },
        buffOptionsGroup = L["Player buffs"],
        missingMode      = L["class"],
        buffingClass     = PALADIN,
    },
    {
        name             = L["Blessing of Light"],
        shortName        = L["Light"],
        color            = { r = 0.96, g = 0.55, b = 0.73 },
        buffIDs          = { 19979, 25890 },
        buffNames        = { L["Blessing of Light"], L["Greater Blessing of Light"] },
        buffOptionsGroup = L["Player buffs"],
        missingMode      = L["class"],
        buffingClass     = PALADIN,
        classes          = all_classes,
    },
    {
        name             = L["Blessing of Sanctuary"],
        shortName        = L["Sanctuary"],
        color            = { r = 0.96, g = 0.55, b = 0.73 },
        buffIDs          = { 20914, 25899 },
        buffNames        = { L["Blessing of Sanctuary"], L["Greater Blessing of Sanctuary"] },
        buffOptionsGroup = L["Player buffs"],
        missingMode      = L["class"],
        buffingClass     = PALADIN,
        classes          = all_classes,
    },
    {
        name             = L["Rallying Cry of the Dragonslayer"],
        shortName        = L["Dragonslayer"],
        buffIDs          = { 22888 },
        color            = { r = 0.5, g = 0, b = 0 },
        buffOptionsGroup = L["World"]
    },
    {
        name             = L["Spirit of Zandalar"],
        shortName        = L["ZG"],
        buffIDs          = { 24425 },
        color            = { r = 0, g = 0.5, b = 0 },
        buffOptionsGroup = L["World"]
    },
    {
        name             = L["Songflower Serenade"],
        shortName        = L["Songflower"],
        buffIDs          = { 15366 },
        color            = { r = 0, g = 0, b = 0 },
        buffOptionsGroup = L["World"]
    },
    {
        name             = L["Fengus' Ferocity"],
        shortName        = L["DMT AP"],
        color            = { r = 0, g = 1, b = 1 },
        buffIDs          = { 22817 },
        classes          = { WARRIOR, ROGUE },
        buffOptionsGroup = L["World"]
    },
    {
        name             = L["Slip'kik's Savvy"],
        shortName        = L["DMT Crit"],
        classes          = { WARLOCK, PRIEST, PALADIN, DRUID, MAGE, SHAMAN },
        buffIDs          = { 22820 },
        color            = { r = 0, g = 1, b = 1 },
        buffOptionsGroup = L["World"]
    },
    {
        name             = L["Mol'dar's Moxie"],
        shortName        = L["DMT Stamina"],
        buffIDs          = { 22818 },
        color            = { r = 0, g = 1, b = 1 },
        buffOptionsGroup = L["World"]
    },
    {
        name             = L["Sayge's Dark Fortune of Damage"],
        shortName        = L["DMF Damage"],
        color            = { r = 0, g = 1, b = 1 },
        buffIDs          = { 23768 },
        buffOptionsGroup = L["World"],
        classes          = { HUNTER, WARRIOR, ROGUE, WARLOCK, MAGE }
    },
    {
        name             = L["Greater Arcane Elixir"],
        shortName        = L["Greater Arcane E."],
        --optionText       = L["+dmg"],
        color            = { r = 0.58, g = 0.51, b = 0.79 },
        buffIDs          = { 17539 },
        buffOptionsGroup = L["Consumable"],
        sourceItemId     = { 13454 },
        classes          = { WARLOCK, MAGE }
    },
    {
        name             = L["Arcane Elixir"],
        shortName        = L["Arcane E."],
        --optionText       = L["+dmg"],
        color            = { r = 0.58, g = 0.51, b = 0.79 },
        buffIDs          = { 11390 },
        buffOptionsGroup = L["Consumable"],
        sourceItemId     = { 9155 },
        classes          = { WARLOCK, MAGE }
    },
    {
        name             = L["+magic dmg"],
        shortName        = L["+magic dmg"],
        optionText       = L["+magic dmg"],
        color            = { r = 0.58, g = 0.51, b = 0.79 },
        buffIDs          = { 11390, 17539 },
        buffOptionsGroup = L["Consumable"],
        sourceItemId     = { 9155, 13454 },
        classes          = { WARLOCK, MAGE }
    },
    {
        name             = L["Elixir of Shadow Power"],
        shortName        = L["+shadow dmg"],
        optionText       = L["+shadow dmg"],
        color            = { r = 0.58, g = 0.51, b = 0.79 },
        buffIDs          = { 11474 },
        buffOptionsGroup = L["Consumable"],
        classes          = { WARLOCK },
        sourceItemId     = { 9264 },
    },
    {
        name             = L["Elixir of Fire Mastery"],
        shortName        = L["+fire dmg"],
        optionText       = L["+fire dmg"],
        color            = { r = 0.58, g = 0.51, b = 0.79 },
        buffIDs          = { 26276 },
        buffOptionsGroup = L["Consumable"],
        classes          = { MAGE, WARLOCK },
        sourceItemId     = { 21546 },
    },
    {
        name             = L["Elixir of the Mongoose"],
        shortName        = L["Mongoose"],
        color            = { r = 0.58, g = 0.51, b = 0.79 },
        buffIDs          = { 17538 },
        buffOptionsGroup = L["Consumable"],
        classes          = { WARRIOR, ROGUE, HUNTER },
        sourceItemId     = { 21546 },
    },
    {
        name             = L["Juju Power"],
        shortName        = L["Juju Power"],
        color            = { r = 0.58, g = 0.51, b = 0.79 },
        buffIDs          = { 16323 },
        buffOptionsGroup = L["Consumable"],
        classes          = { WARRIOR, ROGUE },
        sourceItemId     = { 12451 },
    },
    {
        name             = L["Giant Elixir"],
        shortName        = L["Giant Elixir"],
        color            = { r = 0.58, g = 0.51, b = 0.79 },
        buffIDs          = { 11405 },
        sourceItemId     = { 9206 },
        buffOptionsGroup = L["Consumable"],
        classes          = { WARRIOR, ROGUE },
    },
    {
        name             = L["Juju Power || Giant Elixir"],
        --shortName        = L["Strength Buff"],
        color            = { r = 0.58, g = 0.51, b = 0.79 },
        buffIDs          = { 11405, 16323 },
        sourceItemId     = { 9206, 12451 },
        buffOptionsGroup = L["Consumable"],
        classes          = { WARRIOR, ROGUE },
    },
    {
        name             = L["Juju Might"],
        shortName        = L["Juju Might"],
        color            = { r = 0.58, g = 0.51, b = 0.79 },
        buffIDs          = { 16329 },
        buffOptionsGroup = L["Consumable"],
        classes          = { WARRIOR, ROGUE, HUNTER },
        sourceItemId     = { 12460 },
    },
    {
        name             = L["Winterfall Firewater"],
        shortName        = L["Firewater"],
        color            = { r = 0.58, g = 0.51, b = 0.79 },
        buffIDs          = { 17038 },
        buffOptionsGroup = L["Consumable"],
        classes          = { WARRIOR, ROGUE },
        sourceItemId     = { 12820 },
    },
    {
        name             = L["Juju Might || Firewater"],
        --shortName        = L["AP Buff"],
        color            = { r = 0.58, g = 0.51, b = 0.79 },
        buffIDs          = { 16329, 17038 },
        sourceItemId     = { 12460, 17205 },
        buffOptionsGroup = L["Consumable"],
        classes          = { WARRIOR, ROGUE },
    },
    {
        name             = L["Elixir of Fortitude"],
        shortName        = L["E. Fortitude"],
        color            = { r = 0.58, g = 0.51, b = 0.79 },
        buffIDs          = { 3593 },
        buffOptionsGroup = L["Consumable"],
        classes          = { WARRIOR, ROGUE },
        sourceItemId     = { 3825 },
    },
    {
        name             = L["Fire Protection"],
        shortName        = L["Fire Prot."],
        optionText       = L["Fire Protection Potions"],
        color            = { r = 1, g = 0, b = 0 },
        buffIDs          = { 7233, 17543 },
        sourceItemId     = { 6049, 13457 },
        buffOptionsGroup = L["Consumable"],
    },

    -- {
    --    name             = L["Greater Fire Protection"],
    --    shortName        = L["Greater Fire Prot."],
    --    optionText       = L["Greater Fire Protection Potion"],
    --    color            = { r = 1, g = 0, b = 0 },
    --    buffIDs          = { 17543 },
    --    buffOptionsGroup = L["Consumable"]
    --},
    {
        name             = L["Nature Protection"],
        shortName        = L["Nature Prot."],
        optionText       = L["Nature Protection Potions"],
        color            = { r = 0, g = 1, b = 0 },
        buffIDs          = { 7254, 17546 },
        buffOptionsGroup = L["Consumable"],
        sourceItemId     = { 6052, 13458 },
    },

    --{
    --    name             = L["Greater Nature Protection"],
    --    shortName        = L["Greater Nature Prot."],
    --    optionText       = L["Greater Nature Protection Potion"],
    --    color            = { r = 0, g = 1, b = 0 },
    --    buffIDs          = { 17546 },
    --    buffOptionsGroup = L["Consumable"]
    --},

    {
        name             = L["Shadow Protection"],
        shortName        = L["Shadow Prot."],
        optionText       = L["Shadow Protection Potions"],
        color            = { r = 0.5, g = 0, b = 0.5 },
        buffIDs          = { 7242, 17548 },
        buffOptionsGroup = L["Consumable"],
        sourceItemId     = { 6048, 13459 },
    },

    --{
    --    name             = L["Greater Shadow Protection"],
    --    shortName        = L["Greater Shadow Prot."],
    --    optionText       = L["Greater Shadow Protection Potion"],
    --    color            = { r = 0.5, g = 0, b = 0.5 },
    --    buffIDs          = { 17548 },
    --    buffOptionsGroup = L["Consumable"]
    --},
    {
        name             = L["Arcane Protection"],
        shortName        = L["Arcane Prot."],
        optionText       = L["Arcane Protection Potions"],
        color            = { r = 0, g = 0, b = 1 },
        buffIDs          = { 17549 },
        buffOptionsGroup = L["Consumable"],
        sourceItemId     = { 13461 },
    },

    {
        name             = L["Frost Protection"],
        shortName        = L["Frost Prot."],
        optionText       = L["Frost Protection Potions"],
        color            = { r = 0, g = 1, b = 1 },
        buffIDs          = { 7239, 17544 },
        buffOptionsGroup = L["Consumable"],
        sourceItemId     = { 6050, 13456 },
    },
}

function ReturnBuffTracker:compute_percent_string(nb, total)
    ReturnBuffTracker:Debugf("ADDON", "compute_percent_string(%s, %s)", tostring(nb), tostring(total))
    local return_value = "NA"
    if total > 0 and nb <= total then
        return_value = ((nb / total) * 100.0)
        if return_value ~= return_value then
            -- NaN/Inf checks
            return_value = "NA"
        else
            return_value = format("%.0f%%", return_value)
        end
    end
    return return_value
end

function ReturnBuffTracker:CheckAlive()

    local tooltip                 = {}
    local dead_players_by_classes = {}
    local j                       = 2

    local aliveNumber             = 0
    local totalNumber             = 0
    local name, _, _, _, localized_class, class
    for i = 1, 40 do
        name, _, _, _, localized_class, class = GetRaidRosterInfo(i)
        if name then
            totalNumber = totalNumber + 1
            if not UnitIsDeadOrGhost(name) then
                aliveNumber = aliveNumber + 1
            else
                if not dead_players_by_classes[class] then
                    dead_players_by_classes[class] = {}
                end
                tinsert(dead_players_by_classes[class], name)
            end
        end
    end
    local dead_number = (totalNumber - aliveNumber)
    local percent     = ReturnBuffTracker:compute_percent_string(dead_number, totalNumber)
    tooltip[1]        = format("%s %d/%d - %s", L["Dead:"], dead_number, totalNumber, percent)
    if #dead_players_by_classes > 0 then
        for dead_class, dead_names in ipairs(dead_players_by_classes) do
            tooltip[j] = format("%s: %s",
                                localized_classes[dead_class],
                                tconcat(dead_names, " "))
            j          = j + 1
        end
    else
        tooltip[j] = L["no one."]
    end
    return aliveNumber, totalNumber, tooltip
end

function ReturnBuffTracker:CheckUnitCannotHelpRaid(name)
    local slacker                  = false
    --local disco   = false
    local afk                      = false
    local fd                       = false
    local inInstance, instanceType = IsInInstance(name)
    local co                       = UnitIsConnected(name)
    local not_in_raid              = not inInstance or instanceType ~= "raid"
    if co then
        afk = UnitIsAFK(name)
        fd  = UnitIsFeignDeath(name)
    end
    slacker = not co or afk or fd or not_in_raid
    return slacker, not co, fd, not_in_raid
end

function ReturnBuffTracker:CheckCannotHelpRaid()
    ReturnBuffTracker:Debugf("ADDON", "CheckCannotHelpRaid")

    local tooltip                   = {}

    local nb_of_useless_players     = 0
    local totalNumber               = 0
    local inInstance, instanceType
    local name
    local slacker                   = false
    local deco_players              = {}
    local afk_players               = {}
    local fd_players                = {}
    local not_raid_instance_players = {}
    for i = 1, 40 do
        name = GetRaidRosterInfo(i)
        if name then
            slacker                  = false -- we assume they are doing good :)
            totalNumber              = totalNumber + 1
            inInstance, instanceType = IsInInstance(name)
            if UnitIsConnected(name) then
                if UnitIsAFK(name) then
                    slacker = true
                    ReturnBuffTracker:Debugf("ADDON", "Adding AFK: %s", name)
                    tinsert(afk_players, name)
                end
                if UnitIsFeignDeath(name) then
                    slacker = true
                    ReturnBuffTracker:Debugf("ADDON", "Adding FD: %s", name)
                    tinsert(fd_players, name)
                end
                if not inInstance or instanceType ~= "raid" then
                    tinsert(not_raid_instance_players, name)
                    ReturnBuffTracker:Debugf("ADDON", "Adding No in raid instance: %s", name)
                    slacker = true
                end
                if slacker then
                    nb_of_useless_players = nb_of_useless_players + 1
                end
            else
                nb_of_useless_players = nb_of_useless_players + 1
                ReturnBuffTracker:Debugf("ADDON", "Adding deco: %s", name)
                tinsert(deco_players, name)
            end

        end
    end
    ReturnBuffTracker:Debugf("ADDON", "Preparing tooltip")

    local percent_string = ReturnBuffTracker:compute_percent_string(nb_of_useless_players, totalNumber)
    local header         = format("%s %d/%d %s",
                                  "Boulets:",
                                  nb_of_useless_players, totalNumber,
                                  percent_string)
    tinsert(tooltip, header)
    local mapping = { [" ||- Deco:"]                 = deco_players,
                      [" ||- AFK :"]                 = afk_players,
                      [" ||- FD  :"]                 = fd_players,
                      [" ||- Not in raid instance:"] = not_raid_instance_players }
    local tmp_str
    for line_label, players_table in pairs(mapping) do
        ReturnBuffTracker:Debugf("ADDON", "Tooltip %s", line_label)
        if players_table and #players_table > 0 then
            ReturnBuffTracker:Debugf("ADDON", "Tooltip %s has players in list", line_label)
            if #players_table <= 5 then
                tmp_str = tconcat(players_table, " ")
                tmp_str = format("%s %s", line_label, tmp_str)
                tinsert(tooltip, tmp_str)
            else
                tmp_str = format("%s %d", line_label, #players_table)
                tinsert(tooltip, tmp_str)
            end
        else
            ReturnBuffTracker:Debugf("ADDON", "Tooltip %s 0 players in list", line_label)
        end
    end

    --ReturnBuffTracker:Debugf("ADDON", "nb_of_useless_players %s / %s", tostring(nb_of_useless_players), tostring(totalNumber))
    --return nb_of_useless_players, totalNumber, new_tooltip
    return nb_of_useless_players, totalNumber, tooltip
end

function ReturnBuffTracker:CheckUnitIsRealDPS(name)
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

function ReturnBuffTracker:CheckUnitIsRealHealer(name)
    local is_real_healer = true
    local real_role      = "HEALER"
    if ReturnBuffTracker:CheckUnitBuff(name, { buffIDs = { 15473 } }) then
        is_real_healer = false
        real_role      = "SHADOWPRIEST"
    elseif ReturnBuffTracker:CheckUnitBuff(name, { buffIDs = { 24907 } }) then
        is_real_healer = false
        real_role      = "MOONKIN"
    elseif GetPartyAssignment("MAINTANK", name) then
        is_real_healer = false
        real_role      = "MAINTANK"
    else
        -- ok
    end
    return is_real_healer, real_role
end

function ReturnBuffTracker:CountUnitPower(name, power_type, current_power_type)
    local unitPower    = UnitPower(name, power_type)
    local unitPowerMax = UnitPowerMax(name, power_type)

    return unitPower, unitPowerMax, unitPower / unitPowerMax
end

function ReturnBuffTracker:CheckPowerType(buff)
    ReturnBuffTracker:Debugf("ADDON", "CheckPowerType - power = %s", tostring(buff.name))
    local current_power  = 0
    local total_power    = 0
    local unitPower, unitPowerMax, unitPowerPercent, unitPowerType, unitPowerTypeName
    local ignoredPlayers = {}
    local name, localized_class, class
    local slacker, disco, fd, not_in_raid
    local is_real_healer, is_real_dps, real_role
    for i = 1, 40 do
        name, _, _, _, localized_class, class = GetRaidRosterInfo(i)

        if class and ReturnBuffTracker:Contains(buff.classes, class) then
            slacker, disco, fd, not_in_raid = ReturnBuffTracker:CheckUnitCannotHelpRaid(name)
            if slacker then
                ReturnBuffTracker:Debugf("ADDON", "Checking %s is SLACKER, ignoring", tostring(name), unitPowerTypeName)
                if not ignoredPlayers["Slacker"] then
                    ignoredPlayers["Slacker"] = {}
                end
                tinsert(ignoredPlayers["Slacker"], name)
            else
                unitPowerType, unitPowerTypeName = UnitPowerType(name)
                ReturnBuffTracker:Debugf("ADDON", "Checking %s -> %s", tostring(name), unitPowerTypeName)
                if unitPowerType ~= buff.powerType then
                    if not ignoredPlayers[unitPowerType] then
                        ignoredPlayers[unitPowerType] = {}
                    end
                    tinsert(ignoredPlayers[unitPowerType], name)
                else
                    ReturnBuffTracker:Debugf("ADDON", "%s has the targeted power (%s)", tostring(name), unitPowerTypeName)

                    --unitPower    = UnitPower(name, buff.powerType)
                    --unitPowerMax = UnitPowerMax(name, buff.powerType)
                    --if not UnitIsConnected(name) then
                    --    if not ignoredPlayers["DISCONNECTED"] then
                    --        ignoredPlayers["DISCONNECTED"] = {}
                    --    end
                    --    tinsert(ignoredPlayers["DISCONNECTED"], name)
                    --else


                    if buff.shortName == L["Healer"] then
                        is_real_healer, real_role = ReturnBuffTracker:CheckUnitIsRealHealer(name)
                        if not is_real_healer then
                            if not ignoredPlayers[real_role] then
                                ignoredPlayers[real_role] = { }
                            end
                            tinsert(ignoredPlayers[real_role], name)
                        else
                            unitPower, unitPowerMax, unitPowerPercent = ReturnBuffTracker:CountUnitPower(name,
                                                                                                         buff.powerType)
                            current_power                             = current_power + unitPower
                            total_power                               = total_power + unitPowerMax
                        end
                    elseif buff.shortName == L["DPS"] then
                        is_real_dps, real_role = ReturnBuffTracker:CheckUnitIsRealDPS(name)
                        if not is_real_dps then
                            if not ignoredPlayers[real_role] then
                                ignoredPlayers[real_role] = { }
                            end
                            tinsert(ignoredPlayers[real_role], name)
                        else
                            unitPower, unitPowerMax, unitPowerPercent = ReturnBuffTracker:CountUnitPower(name,
                                                                                                         buff.powerType)
                            current_power                             = current_power + unitPower
                            total_power                               = total_power + unitPowerMax
                        end
                    else
                        ReturnBuffTracker:Debugf("ADDON", "Checking power type that is not DPS mana and not HEALER mana ?!")
                    end
                end
                --if ReturnBuffTracker:CheckUnitBuff(name, { buffIDs = { 15473 } }) then
                --    if not ignoredPlayers["SHADOWPRIEST"] then
                --        ignoredPlayers["SHADOWPRIEST"] = {}
                --    end
                --    tinsert(ignoredPlayers["SHADOWPRIEST"], name)
                --elseif ReturnBuffTracker:CheckUnitBuff(name, { buffIDs = { 24907 } }) then
                --    if not ignoredPlayers["MOONKIN"] then
                --        ignoredPlayers["MOONKIN"] = {}
                --    end
                --    tinsert(ignoredPlayers["MOONKIN"], name)
                --elseif GetPartyAssignment("MAINTANK", name) then
                --    if not ignoredPlayers["MAINTANK"] then
                --        ignoredPlayers["MAINTANK"] = {}
                --    end
                --    tinsert(ignoredPlayers["MAINTANK"], name)
                --else
                --if unitPower then
                --    if unitPowerMax then
                --        if unitPowerMax > 0 then
                --            current_power = current_power + (unitPower / unitPowerMax)
                --            total_power   = total_power + 1
                --        else
                --            if not ignoredPlayers[unitPowerType] then
                --                ignoredPlayers[unitPowerType] = {}
                --            end
                --            tinsert(ignoredPlayers[unitPowerType], name)
                --        end
                --    else
                --        ReturnBuffTracker:Debugf("ADDON", "%s has the targeted power (%s) but has no power max ?!",
                --                                 tostring(name),
                --                                 unitPowerTypeName)
                --        if not ignoredPlayers["no power max"] then
                --            ignoredPlayers["no power max"] = {}
                --        end
                --        tinsert(ignoredPlayers["no power max"], name)
                --    end
                --else
                --    ReturnBuffTracker:Debugf("ADDON", "%s has the targeted power (%s) but cannot get its value ?!",
                --                             tostring(name),
                --                             unitPowerTypeName)
                --    if not ignoredPlayers["unavailable power ?!"] then
                --        ignoredPlayers["unavailable power ?!"] = {}
                --    end
                --    tinsert(ignoredPlayers["unavailable power ?!"], name)
                --end
                --end
                --end
                --    else
                --    ReturnBuffTracker:Debugf("ADDON", "Checking %s is SLACKER, ignoring", tostring(name), unitPowerTypeName)
                --if not ignoredPlayers["Slacker"] then
                --ignoredPlayers["Slacker"] = {}
                --    end
                --    tinsert(ignoredPlayers["Slacker"], name)
            end
        end
    end
    local percent_string = ReturnBuffTracker:compute_percent_string(current_power, total_power)
    local header         = format("%s: %s", tostring(buff.name), percent_string)
    local tooltip_lines  = {}
    tinsert(tooltip_lines, header)

    --ReturnBuffTracker:Debugf("ADDON", "Ignored players %d", #ignoredPlayers)
    for reason, player_details in pairs(ignoredPlayers) do
        ReturnBuffTracker:Debugf("ADDON", "Ignored players: [%s] = %d", tostring(reason), #player_details)
        local players_str = tconcat(player_details, " ")
        tinsert(tooltip_lines,
                format("Ignoring: %s %s", tostring(reason), players_str))
    end
    return current_power, total_power, tooltip_lines
end

function ReturnBuffTracker:CheckInCombat(_)

    local inCombat = 0
    local total    = 0
    local players  = {}
    local name, group
    for i = 1, 40 do
        name, _, group = GetRaidRosterInfo(i)
        if name and not UnitIsDead(name) then
            total = total + 1
            if UnitAffectingCombat(name) then
                inCombat = inCombat + 1
            else
                players[name] = { name = name, group = group }
            end
        end
    end

    local tooltip = {}
    tooltip[1]    = L["Not in Combat: "]
    tooltip[2]    = L["no one."]

    local groups  = {}
    for _, player in pairs(players) do
        if not groups[player.group] then
            groups[player.group] = { text = format(L["Group %d:"], player.group) }
        end
        groups[player.group].text = format("%s %s", groups[player.group].text, player.name)
    end

    local i = 2
    for _, group in ipairs(groups) do
        tooltip[i] = group.text
        i          = i + 1
    end

    return inCombat, total, tooltip
end

function ReturnBuffTracker:CheckSoulstones(buff)
    local tooltip                  = {}
    local j                        = 2
    tooltip[2]                     = L["none."]
    local name, group, localized_class, class
    local total                    = 0
    local players_having_soulstone = {}
    local present, caster
    for i = 1, 40 do
        name, _, group, _, localized_class, class = GetRaidRosterInfo(i)
        if name then
            if class == WARLOCK then
                total = total + 1
            end
            present, caster = ReturnBuffTracker:CheckUnitBuff(name, buff)
            if caster then
                caster = GetUnitName(caster)
            end
            if present then
                tinsert(players_having_soulstone, format("%s (from %s)", name, tostring(caster)))
                j = j + 1
            end
        end
    end
    tooltip[1] = format("%s (%d %s)", L["Soulstones: "], total, localized_classes[WARLOCK])
    if #players_having_soulstone > 0 then
        tooltip[2] = tconcat(players_having_soulstone, " ")
    end
    if (j - 2) <= 0 then
        return 0, 1, tooltip
    end
    return 1, 1, tooltip
end

function ReturnBuffTracker:CheckCarrot(_)
    ReturnBuffTracker:Debug("ADDON", "CheckCarrot")
    local inCombat              = 0
    local total                 = 0
    local group_names_map       = {}
    local player_name, _, group_nb
    local current_speed, current_max_ground_speed, current_flight_speed, current_swim_speed
    local carrot_multiplier     = 1.03
    local mount_60_perc         = 11.2
    local mount_100_perc        = 14.0
    local carrot_mount_60_perc  = mount_60_perc * carrot_multiplier
    local carrot_mount_100_perc = mount_100_perc * carrot_multiplier

    -- Walking: 2.5
    -- Running backwards: 4.5
    -- Normal Running: 7
    -- Ground Mount, 60% speed (Apprentice): 11.2
    -- Ground Mount, 100% speed (Journeyman): 14
    -- Flying Mount, 150% speed (Expert): 17.5
    -- Flying Mount, 280% speed (Artisan): 26.6
    -- Flying Mount, 310% speed (Master): 28.7

    for i = 1, 40 do
        player_name, _, group_nb                                                          = GetRaidRosterInfo(i)
        current_speed, current_max_ground_speed, current_flight_speed, current_swim_speed = GetUnitSpeed("raid" .. i)
        if player_name then
            total = total + 1
            if current_max_ground_speed > 0.0 then
                ReturnBuffTracker:Debugf("ADDON", "%s - %2.2f", player_name, current_max_ground_speed)
            end
            if not group_names_map[group_nb] then
                --group_names_map[group_nb] = {}
                tinsert(group_names_map, group_nb, {})
            end
            local player_list = group_names_map[group_nb]
            if current_max_ground_speed >= carrot_mount_100_perc then
                ReturnBuffTracker:Debugf("ADDON", "Wiht carrot: %s - %2.2f", player_name, current_max_ground_speed)
                --players[name] = { name = name .. "(100%) ", group = group }
                tinsert(player_list, player_name)
                inCombat = inCombat + 1
            elseif current_max_ground_speed >= carrot_mount_60_perc then
                ReturnBuffTracker:Debugf("ADDON", "Wiht carrot: %s - %2.2f", player_name, current_max_ground_speed)
                --players[name] = { name = name .. "(60%)", group = group }
                tinsert(player_list, player_name)
                inCombat = inCombat + 1
            else
                --
            end
        end

    end

    local tooltip = {}
    tooltip[1]    = L["Possible carrot on a stick: "]
    local i       = 2
    tooltip[i]    = L["no one."]
    local grp_str, names_str
    for group, names in pairs(group_names_map) do
        if #names > 0 then
            grp_str    = format(L["Group %d:"], group)
            names_str  = tconcat(names, " ")
            tooltip[i] = format("%s %s", grp_str, names_str)
            ReturnBuffTracker:Debugf("ADDON", "%s %s", grp_str, names_str)
            i = i + 1
        else
            ReturnBuffTracker:Debugf("ADDON", "Group %d has no carrots (%d)", group, #names)
        end
    end

    return inCombat, total, tooltip
end

local function foo(buff, players, tooltip, tool_tip_index)
    local group_players = {}
    if buff.missingMode == L["class"] then
        for _, player in pairs(players) do
            if not group_players[player.class] then
                group_players[player.class] = {}
                tinsert(group_players[player.class], format("%s :", player.localized_class))
            end
            tinsert(group_players[player.class], name)
        end

        for cls, str_list in pairs(group_players) do
            tooltip[tool_tip_index] = tconcat(str_list, " ")
            tool_tip_index          = tool_tip_index + 1
        end
    else
        for _, player in pairs(players) do
            if not group_players[tonumber(player.group)] then
                group_players[tonumber(player.group)] = {
                    count = 0,
                    text  = format(L["Group %d:"], player.group)
                }
            end
            group_players[tonumber(player.group)].text = group_players[tonumber(player.group)].text .. " " .. player.name
        end

        local group_players_key = {}
        for k in pairs(group_players) do
            tinsert(group_players_key, k)
        end
        table.sort(group_players_key)

        for _, k in ipairs(group_players_key) do
            tooltip[tool_tip_index] = group_players[k].text
            tool_tip_index          = tool_tip_index + 1
        end
    end
    return tool_tip_index
end

function ReturnBuffTracker:CheckBuff(buff)
    local buffs          = 0
    local totalBuffs     = 0
    local bad_players    = {}
    local good_players   = {}
    local ignoredPlayers = {}
    local class_count    = {
        [WARRIOR] = 0, [MAGE] = 0, [ROGUE] = 0, [DRUID] = 0, [HUNTER] = 0, [SHAMAN] = 0, [PRIEST] = 0, [WARLOCK] = 0, [PALADIN] = 0
    }
    local slacker, disco, fd, not_in_raid
    local tooltip        = {}

    for i = 1, 40 do
        local name, _, group, _, localized_class, class = GetRaidRosterInfo(i)
        if class then
            slacker, disco, fd, not_in_raid = ReturnBuffTracker:CheckUnitCannotHelpRaid(name)
            if slacker then
                ReturnBuffTracker:Debugf("ADDON", "Checking %s is SLACKER, ignoring", tostring(name), unitPowerTypeName)
                if not ignoredPlayers["Slacker"] then
                    ignoredPlayers["Slacker"] = {}
                end
                tinsert(ignoredPlayers["Slacker"], name)
            else
                local isClassExpected = ReturnBuffTracker:Contains(buff.classes, class)
                if isClassExpected then
                    totalBuffs = totalBuffs + 1
                    if ReturnBuffTracker:CheckUnitBuff("raid" .. i, buff) then
                        buffs              = buffs + 1
                        good_players[name] = { name = name, group = group, class = class, localized_class = localized_class }
                    else
                        bad_players[name] = { name = name, group = group, class = class, localized_class = localized_class }
                        if class_count[class] then
                            class_count[class] = class_count[class] + 1
                        else
                            class_count[class] = 1
                        end
                    end
                end
            end
        end
    end

    --if buff.classes and #buff.classes >= 1 then
    --    local nb_of_players_concerned = 0
    --    local concerned_classes_names = ""
    --    for _, v in pairs(buff.classes) do
    --        concerned_classes_names = concerned_classes_names .. " " .. v
    --        if class_count[v] ~= 0 then
    --            nb_of_players_concerned = nb_of_players_concerned + class_count[v]
    --        end
    --    end
    --    -- print("Total class count for buff: " .. (buff.name or buff.text or "??") .. " = " .. nb_of_players_concerned)
    --    if nb_of_players_concerned == 0 then
    --        tooltip[1] = "No relevant classes:"
    --        tooltip[2] = concerned_classes_names
    --        return buffs, totalBuffs, tooltip
    --    end
    --else
    --    --
    --end


    tooltip[1]              = format("{rt7}" .. L["Missing %s"], (buff.name or buff.shortName or str(buff.buffIDs[1])))
    local tool_tip_index    = 2
    tooltip[tool_tip_index] = L["no one."]

    tool_tip_index          = foo(buff, bad_players, tooltip, tool_tip_index)

    -- TODO: Make the goodboys tooltip and report configurable
    --tooltip[tool_tip_index] = "Good boys:"
    --tool_tip_index          = tool_tip_index + 1
    --tooltip[tool_tip_index] = L["no one."]
    --
    --tool_tip_index          = foo(buff, good_players, tooltip, tool_tip_index)


    for reason, player_details in pairs(ignoredPlayers) do
        ReturnBuffTracker:Debugf("ADDON", "Ignored players: [%s] = %d", tostring(reason), #player_details)
        local players_str = tconcat(player_details, " ")
        tinsert(tooltip,
                format("Ignoring: %s %s", tostring(reason), players_str))
    end

    return buffs, totalBuffs, tooltip
end

function ReturnBuffTracker:CheckUnitBuff(unit, buff)
    local buff_name, caster, spellId
    for i = 1, 40 do
        buff_name, _, _, _, _, _, caster, _, _, spellId = UnitBuff(unit, i)
        if buff.buffIDs then
            if type(buff.buffIDs) == table then
                for _, v in pairs(buff.buffIDs) do
                    if ReturnBuffTracker:Contains(v, spellId) then
                        return true, caster
                    end
                end
            else
                if ReturnBuffTracker:Contains(buff.buffIDs, spellId) then
                    return true, caster
                end
            end
        else
            if (buff.buffNames and ReturnBuffTracker:Contains(buff.buffNames, buff_name)) or
                    buff.name == buff_name then
                return true, caster
            end
            --return (buff.buffNames and ReturnBuffTracker:Contains(buff.buffNames, buff_name)), caster or buff.name == buff_name, caster
        end

    end
    return false, nil
end
