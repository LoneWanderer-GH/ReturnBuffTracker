local ReturnBuffTracker                   = LibStub("AceAddon-3.0"):GetAddon("ReturnBuffTracker")
local L                                   = LibStub("AceLocale-3.0"):GetLocale("ReturnBuffTracker")

local WARRIOR, MAGE, ROGUE, DRUID, HUNTER = "WARRIOR", "MAGE", "ROGUE", "DRUID", "HUNTER"
local SHAMAN, PRIEST, WARLOCK, PALADIN    = "SHAMAN", "PRIEST", "WARLOCK", "PALADIN"
local format                              = format
local tinsert, tconcat, tremove           = table.insert, table.concat, table.remove

local localized_classes                   = {}
FillLocalizedClassList(localized_classes, true)

local all_classes                           = { WARRIOR, MAGE, ROGUE, DRUID, HUNTER, SHAMAN, PRIEST, WARLOCK, PALADIN }
local MAX_PLAYER_LEVEL                      = GetMaxPlayerLevel()
local ITEM_QUALITY_ENUM_TO_LOCALIZED_STRING = {
}
local _G                                    = _G
local BUFF_MAX_DISPLAY                      = BUFF_MAX_DISPLAY
for quality_base_name, quality_int_val in pairs(Enum.ItemQuality) do
    ITEM_QUALITY_ENUM_TO_LOCALIZED_STRING[quality_int_val] = _G[format("ITEM_QUALITY%d_DESC", quality_int_val)]
end

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
    {
        name             = L["Loot Method"],
        shortName        = L["Loot Method"],
        color            = { r = 1.0, g = 0.3, b = 0.3 },
        func             = "CheckML",
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

for i, b in ipairs(ReturnBuffTracker.Buffs) do
    b.total   = 0
    b.count   = 0
    b.tooltip = {}
end

function ReturnBuffTracker:compute_percent_string(nb, total)
    --@debug@
    ReturnBuffTracker:Debugf("compute_percent_string", "compute_percent_string(%s, %s)", tostring(nb), tostring(total))
    --@end-debug@
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

local function clearArrayList(t)
    local count = #t
    for i = 0, count do t[i] = nil end
end

local function clearTable(t)
    for k, _ in pairs(t) do t[k] = nil end
end

local function ClearBuffTooltipTable(buff)
    if buff.tooltip then
        local t = buff.tooltip
        --local count = #t
        --for i = 0, count do t[i] = nil end
        clearArrayList(t)
    else
        buff.tooltip = {}
    end
    return buff.tooltip
end

local function ResetBuffData(buff)
    buff.count = 0
    buff.total = 0
    ClearBuffTooltipTable(buff)
end

function ReturnBuffTracker:CheckAlive(buff)

    --local tooltip                 = {}

    --local tooltip = ClearBuffTooltipTable(buff)
    --ClearBuffTooltipTable(buff)
    ResetBuffData(buff)
    if buff.dead_players_by_classes then
        --clearTable(buff.dead_players_by_classes)
        for _, class in ipairs(all_classes) do
            clearArrayList(buff.dead_players_by_classes[class])
        end
    else
        buff.dead_players_by_classes = {}
        for _, class in ipairs(all_classes) do
            buff.dead_players_by_classes[class] = {}
        end
    end

    local dead_players_by_classes = buff.dead_players_by_classes
    local j                       = 2

    --local aliveNumber             = 0
    --local totalNumber             = 0
    --local name, _, _, _, localized_class, class
    --local name, rank, subgroup, level, class, fileName, zone, online, isDead, role, isML
    local name, localized_class, class, isDead
    for i = 1, 40 do
        --name, _, _, _, localized_class, class = GetRaidRosterInfo(i)
        name, _, _, _, localized_class, class, _, _, isDead, _, _ = GetRaidRosterInfo(i)
        if name then
            buff.total = buff.total + 1
            --if not UnitIsDeadOrGhost(name) then
            if not isDead then
                buff.count = buff.count + 1
            else
                --if not dead_players_by_classes[class] then
                --    dead_players_by_classes[class] = {}
                --end
                tinsert(dead_players_by_classes[class], name)
            end
        end
    end
    local dead_number = (buff.total - buff.count)
    local percent     = ReturnBuffTracker:compute_percent_string(dead_number, buff.total)
    buff.tooltip[1]   = format("%s %d/%d - %s", L["Dead:"], dead_number, buff.total, percent)
    --if #dead_players_by_classes > 0 then
    for dead_class, dead_names in ipairs(dead_players_by_classes) do
        if #dead_names > 0 then
            buff.tooltip[j] = format("%s: %s",
                                     localized_classes[dead_class],
                                     tconcat(dead_names, " "))
            j               = j + 1
        end
    end
    --else
    --    tooltip[j] = L["no one."]
    --end
    return buff.count, buff.total, buff.tooltip
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

function ReturnBuffTracker:CheckCannotHelpRaid(buff)
    --@debug@
    ReturnBuffTracker:Debugf("CheckCannotHelpRaid", "CheckCannotHelpRaid")
    --@end-debug@
    --local tooltip                   = {}
    --local tooltip = ClearBuffTooltipTable(buff)
    ResetBuffData(buff)
    if buff.deco_players then
        clearArrayList(buff.deco_players)
    else
        buff.deco_players = {}
    end
    if buff.afk_players then
        clearArrayList(buff.afk_players)
    else
        buff.afk_players = {}
    end
    if buff.fd_players then
        clearArrayList(buff.fd_players)
    else
        buff.fd_players = {}
    end
    if buff.not_raid_instance_players then
        clearArrayList(buff.not_raid_instance_players)
    else
        buff.not_raid_instance_players = {}
    end
    if buff.low_level_players then
        clearArrayList(buff.low_level_players)
    else
        buff.low_level_players = {}
    end

    --local nb_of_useless_players     = 0
    --local totalNumber               = 0
    local inInstance, instanceType
    --local name
    local slacker = false
    --local deco_players              = buff.deco_players
    --local afk_players               = buff.afk_players
    --local fd_players                = buff.fd_players
    --local not_raid_instance_players = buff.not_raid_instance_players
    --local low_level_players         = buff.low_level_players
    local name, rank, subgroup, level, class, fileName, zone, online, isDead, role, isML

    for i = 1, 40 do
        name, rank, subgroup, level, class, fileName, zone, online, isDead, role, isML = GetRaidRosterInfo(i)
        if name then
            slacker                  = false -- we assume they are doing good :)
            buff.total               = buff.total + 1
            inInstance, instanceType = IsInInstance(name)
            if level < MAX_PLAYER_LEVEL then
                slacker = true
                --@debug@
                ReturnBuffTracker:Debugf("CheckCannotHelpRaid", "Adding Low Level: %s", name)
                --@end-debug@
                tinsert(buff.low_level_players, format("%s (%d)", name, level))
            end
            if online then
                -- UnitIsConnected(name) then
                if UnitIsAFK(name) then
                    slacker = true
                    --@debug@
                    ReturnBuffTracker:Debugf("CheckCannotHelpRaid", "Adding AFK: %s", name)
                    --@end-debug@
                    tinsert(buff.afk_players, name)
                end
                if UnitIsFeignDeath(name) then
                    slacker = true
                    --@debug@
                    ReturnBuffTracker:Debugf("CheckCannotHelpRaid", "Adding FD: %s", name)
                    --@end-debug@
                    tinsert(buff.fd_players, name)
                end
                if not inInstance or instanceType ~= "raid" then
                    tinsert(buff.not_raid_instance_players, name)
                    --@debug@
                    ReturnBuffTracker:Debugf("CheckCannotHelpRaid", "Adding No in raid instance: %s", name)
                    --@end-debug@
                    slacker = true
                end
                if slacker then
                    buff.count = buff.count + 1
                end
            else
                buff.count = buff.count + 1
                --@debug@
                ReturnBuffTracker:Debugf("CheckCannotHelpRaid", "Adding deco: %s", name)
                --@end-debug@
                tinsert(buff.deco_players, name)
            end

        end
    end
    --@debug@
    ReturnBuffTracker:Debugf("CheckCannotHelpRaid", "Preparing tooltip")
    --@end-debug@

    local percent_string = ReturnBuffTracker:compute_percent_string(buff.count, buff.total)
    local header         = format("%s %d/%d %s",
                                  "Boulets:",
                                  buff.count, buff.total,
                                  percent_string)
    tinsert(buff.tooltip, header)
    local low_str = format(" ||- level < max (%d):", MAX_PLAYER_LEVEL)
    local mapping = { [" ||- Deco:"]                 = buff.deco_players,
                      [" ||- AFK :"]                 = buff.afk_players,
                      [" ||- FD  :"]                 = buff.fd_players,
                      [" ||- Not in raid instance:"] = buff.not_raid_instance_players,
                      [low_str]                      = buff.low_level_players,
    }
    local tmp_str
    for line_label, players_table in pairs(mapping) do
        --@debug@
        ReturnBuffTracker:Debugf("CheckCannotHelpRaid", "Tooltip %s", line_label)
        --@end-debug@
        if players_table and #players_table > 0 then
            --@debug@
            ReturnBuffTracker:Debugf("CheckCannotHelpRaid", "Tooltip %s has players in list", line_label)
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
            ReturnBuffTracker:Debugf("CheckCannotHelpRaid", "Tooltip %s 0 players in list", line_label)
            --@end-debug@
        end

    end
    return buff.count, buff.total, buff.tooltip
end

function ReturnBuffTracker:CheckML(buff)
    --local tooltip                              = {}
    --local tooltip                              = ClearBuffTooltipTable(buff)
    ResetBuffData(buff)
    local method, partyMaster, raid_unit_index = GetLootMethod()
    local loot_threshold                       = GetLootThreshold()
    --local count                                = 0
    buff.count                                 = 0
    buff.total                                 = 1
    local ML_name
    local r, g, b, hex                         = GetItemQualityColor(loot_threshold)
    tinsert(buff.tooltip, format("Method: %s", method))
    --tinsert(tooltip, format("Threshold: |c%s%s|r", hex, _G[format("ITEM_QUALITY%d_DESC", loot_threshold)]))
    tinsert(buff.tooltip, format("Threshold: |c%s%s|r", hex, ITEM_QUALITY_ENUM_TO_LOCALIZED_STRING[loot_threshold]))
    if buff.bar then
        buff.bar.texture:SetColorTexture(r, g, b, 0.9)
    end
    if method ~= "master" then
        tinsert(buff.tooltip, "NO ML !")
    else
        buff.count = 1
        ML_name    = GetUnitName("raid" .. raid_unit_index, false)
        tinsert(buff.tooltip, format("ML: %s", ML_name))
    end
    return buff.count, buff.total, buff.tooltip
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

local POWER_IGNORED_ROLES = { "Slacker", "HEALER", "SHADOWPRIEST", "MOONKIN", "MAINTANK" }
for p, _ in pairs(Enum.PowerType) do
    table.insert(POWER_IGNORED_ROLES, p)
end

function ReturnBuffTracker:CheckPowerType(buff)
    --@debug@
    ReturnBuffTracker:Debugf("CheckPowerType", "CheckPowerType - power = %s", tostring(buff.name))
    --@end-debug@
    --local tooltip_lines = ClearBuffTooltipTable(buff)
    ResetBuffData(buff)
    if buff.ignoredPlayers then
        for _, role in ipairs(POWER_IGNORED_ROLES) do
            clearArrayList(buff.ignoredPlayers[role])
        end
    else
        buff.ignoredPlayers = {}
        for _, role in ipairs(POWER_IGNORED_ROLES) do
            --buff.ignoredPlayers = { ["Slacker"]      = {},
            --                        ["HEALER"]       = {},
            --                        ["SHADOWPRIEST"] = {},
            --                        ["MOONKIN"]      = {},
            --                        ["MAINTANK"]     = {},
            --}
            buff.ignoredPlayers[role] = {}
        end
    end
    --local current_power  = 0
    --local total_power    = 0
    local unitPower, unitPowerMax, unitPowerPercent, unitPowerType, unitPowerTypeName
    --local ignoredPlayers = buff.ignoredPlayers
    local name, localized_class, class
    local slacker, disco, fd, not_in_raid
    local is_real_healer, is_real_dps, real_role
    for i = 1, 40 do
        name, _, _, _, localized_class, class = GetRaidRosterInfo(i)

        if class and ReturnBuffTracker:Contains(buff.classes, class) then
            slacker, disco, fd, not_in_raid = ReturnBuffTracker:CheckUnitCannotHelpRaid(name)
            if slacker then
                --@debug@
                ReturnBuffTracker:Debugf("CheckPowerType", "Checking %s is SLACKER, ignoring", tostring(name), unitPowerTypeName)
                --@end-debug@
                tinsert(buff.ignoredPlayers["Slacker"], name)
            else
                unitPowerType, unitPowerTypeName = UnitPowerType(name)
                --@debug@
                ReturnBuffTracker:Debugf("CheckPowerType", "Checking %s -> %s", tostring(name), unitPowerTypeName)
                --@end-debug@
                if unitPowerType ~= buff.powerType then
                    tinsert(buff.ignoredPlayers[unitPowerType], name)
                else
                    --@debug@
                    ReturnBuffTracker:Debugf("CheckPowerType", "%s has the targeted power (%s)", tostring(name), unitPowerTypeName)
                    --@end-debug@

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
                            tinsert(buff.ignoredPlayers[real_role], name)
                        else
                            unitPower, unitPowerMax, unitPowerPercent = ReturnBuffTracker:CountUnitPower(name,
                                                                                                         buff.powerType)
                            buff.count                                = buff.count + unitPower
                            buff.total                                = buff.total + unitPowerMax
                        end
                    elseif buff.shortName == L["DPS"] then
                        is_real_dps, real_role = ReturnBuffTracker:CheckUnitIsRealDPS(name)
                        if not is_real_dps then
                            tinsert(buff.ignoredPlayers[real_role], name)
                        else
                            unitPower, unitPowerMax, unitPowerPercent = ReturnBuffTracker:CountUnitPower(name,
                                                                                                         buff.powerType)
                            buff.count                                = buff.count + unitPower
                            buff.total                                = buff.total + unitPowerMax
                        end
                        --@debug@
                    else
                        ReturnBuffTracker:Debugf("CheckPowerType", "Checking power type that is not DPS mana and not HEALER mana ?!")
                        --@end-debug@
                    end
                end
            end
        end
    end
    local percent_string = ReturnBuffTracker:compute_percent_string(buff.count, buff.total)
    local header         = format("%s: %s", tostring(buff.name), percent_string)
    --local tooltip_lines  = {}
    tinsert(buff.tooltip, header)

    --ReturnBuffTracker:Debugf("ADDON", "Ignored players %d", #ignoredPlayers)
    for reason, player_details in pairs(buff.ignoredPlayers) do
        --@debug@
        ReturnBuffTracker:Debugf("CheckPowerType", "Ignored players: [%s] = %d", tostring(reason), #player_details)
        --@end-debug@
        local players_str = tconcat(player_details, " ")
        tinsert(buff.tooltip,
                format("Ignoring: %s %s", tostring(reason), players_str))
    end
    return buff.count, buff.total, buff.tooltip
end

local MAX_GROUPS_IN_RAID = 8
function ReturnBuffTracker:CheckInCombat(buff)
    --local tooltip = ClearBuffTooltipTable(buff)
    ResetBuffData(buff)
    if buff.groups_array then
        for i = 1, MAX_GROUPS_IN_RAID do
            buff.groups_array[i] = {}
        end
    else
        for i = 1, MAX_GROUPS_IN_RAID do
            clearArrayList(buff.groups_array[i])
        end
    end
    buff.count = 0
    buff.total = 0
    --local inCombat = buff.count
    --local total    = buff.total
    --local players  = {}
    local player_name, player_group
    for i = 1, 40 do
        player_name, _, player_group = GetRaidRosterInfo(i)
        if player_name and not UnitIsDead(player_name) then
            buff.total = buff.total + 1
            if UnitAffectingCombat(player_name) then
                buff.count = buff.count + 1
            else
                --players[player_name] = { name = player_name, group = player_group }
                tinsert(buff.groups_array[player_group], player_name)
            end
        end
    end

    --local tooltip = {}
    buff.tooltip[1]              = L["Not in Combat: "]
    local tool_tip_index         = 2
    buff.tooltip[tool_tip_index] = L["no one."]

    for i = 1, MAX_GROUPS_IN_RAID do
        if #buff.groups_array[i] > 0 then
            buff.tooltip[tool_tip_index] = tconcat(buff.groups_array[i], " ")
            tool_tip_index               = tool_tip_index + 1
        end
    end
    return buff.count, buff.total, buff.tooltip
end

function ReturnBuffTracker:CheckSoulstones(buff)
    ResetBuffData(buff)
    --local tooltip                  = {}
    local j                        = 2
    buff.tooltip[j]                = L["none."]
    local name, group, localized_class, class
    --local total                    = 0
    local players_having_soulstone = {}
    local present, caster
    for i = 1, 40 do
        name, _, group, _, localized_class, class = GetRaidRosterInfo(i)
        if name then
            if class == buff.buffingClass then
                buff.total = buff.total + 1
            end
            present, caster = ReturnBuffTracker:CheckUnitBuff(name, buff)
            if caster then
                caster = GetUnitName(caster)
            end
            if present then
                buff.count = buff.count + 1
                tinsert(players_having_soulstone, format("%s (from %s)", name, tostring(caster)))
                --j = j + 1
            end
        end
    end
    buff.tooltip[1] = format("%s (%d %s)", L["Soulstones: "], buff.total, localized_classes[buff.buffingClass])
    if #players_having_soulstone > 0 then
        buff.tooltip[j] = tconcat(players_having_soulstone, " ")
    end

    -- override for bar display
    if buff.count <= 0 then
        buff.count = 0
        buff.total = 1
        --return 0, 1, buff.tooltip
    else
        buff.count = 1
        buff.total = 1
    end
    return buff.count, buff.total, buff.tooltip
end

--function ReturnBuffTracker:CheckCarrot(_)
--    ReturnBuffTracker:Debug("ADDON", "CheckCarrot")
--    local inCombat              = 0
--    local total                 = 0
--    local group_names_map       = {}
--    local player_name, _, group_nb
--    local current_speed, current_max_ground_speed, current_flight_speed, current_swim_speed
--    local carrot_multiplier     = 1.03
--    local mount_60_perc         = 11.2
--    local mount_100_perc        = 14.0
--    local carrot_mount_60_perc  = mount_60_perc * carrot_multiplier
--    local carrot_mount_100_perc = mount_100_perc * carrot_multiplier
--
--    -- Walking: 2.5
--    -- Running backwards: 4.5
--    -- Normal Running: 7
--    -- Ground Mount, 60% speed (Apprentice): 11.2
--    -- Ground Mount, 100% speed (Journeyman): 14
--    -- Flying Mount, 150% speed (Expert): 17.5
--    -- Flying Mount, 280% speed (Artisan): 26.6
--    -- Flying Mount, 310% speed (Master): 28.7
--
--    for i = 1, 40 do
--        player_name, _, group_nb                                                          = GetRaidRosterInfo(i)
--        current_speed, current_max_ground_speed, current_flight_speed, current_swim_speed = GetUnitSpeed("raid" .. i)
--        if player_name then
--            total = total + 1
--            if current_max_ground_speed > 0.0 then
--                ReturnBuffTracker:Debugf("ADDON", "%s - %2.2f", player_name, current_max_ground_speed)
--            end
--            if not group_names_map[group_nb] then
--                --group_names_map[group_nb] = {}
--                tinsert(group_names_map, group_nb, {})
--            end
--            local player_list = group_names_map[group_nb]
--            if current_max_ground_speed >= carrot_mount_100_perc then
--                ReturnBuffTracker:Debugf("ADDON", "Wiht carrot: %s - %2.2f", player_name, current_max_ground_speed)
--                --players[name] = { name = name .. "(100%) ", group = group }
--                tinsert(player_list, player_name)
--                inCombat = inCombat + 1
--            elseif current_max_ground_speed >= carrot_mount_60_perc then
--                ReturnBuffTracker:Debugf("ADDON", "Wiht carrot: %s - %2.2f", player_name, current_max_ground_speed)
--                --players[name] = { name = name .. "(60%)", group = group }
--                tinsert(player_list, player_name)
--                inCombat = inCombat + 1
--            else
--                --
--            end
--        end
--
--    end
--
--    local tooltip = {}
--    tooltip[1]    = L["Possible carrot on a stick: "]
--    local i       = 2
--    tooltip[i]    = L["no one."]
--    local grp_str, names_str
--    for group, names in pairs(group_names_map) do
--        if #names > 0 then
--            grp_str    = format(L["Group %d:"], group)
--            names_str  = tconcat(names, " ")
--            tooltip[i] = format("%s %s", grp_str, names_str)
--            ReturnBuffTracker:Debugf("ADDON", "%s %s", grp_str, names_str)
--            i = i + 1
--        else
--            ReturnBuffTracker:Debugf("ADDON", "Group %d has no carrots (%d)", group, #names)
--        end
--    end
--
--    return inCombat, total, tooltip
--end

local function fill_tooltip_data_array(buff, players, tooltip, tool_tip_index)
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
        local player_group_nb
        for _, player in pairs(players) do
            player_group_nb = tonumber(player.group)
            if not group_players[player_group_nb] then
                --group_players[tonumber(player.group)] = {
                --    --count = 0,
                --    text  = format(L["Group %d:"], player.group)
                --}
                group_players[player_group_nb] = {}
                tinsert(group_players[player_group_nb], format(L["Group %d:"], player_group_nb))
            end
            tinsert(group_players[player_group_nb], player.name)
        end

        --local group_players_key = {}
        --for k in pairs(group_players) do
        --    tinsert(group_players_key, k)
        --end
        --table.sort(group_players_key)
        table.sort(group_players) -- its a table of <group number ; list>

        --for _, k in ipairs(group_players_key) do
        --local tmp_str
        for group_nb, player_names_array in ipairs(group_players) do
            --tmp_str                 = format(L["Group %d:"], group_nb)
            --tmp_str                 = format("%s %s", tmp_str, )
            tooltip[tool_tip_index] = tconcat(player_names_array, " ")
            tool_tip_index          = tool_tip_index + 1
        end
    end
    return tool_tip_index
end

function ReturnBuffTracker:CheckBuff(buff)
    ResetBuffData(buff)

    --local class_count    = {
    --    [WARRIOR] = 0, [MAGE] = 0, [ROGUE] = 0, [DRUID] = 0, [HUNTER] = 0, [SHAMAN] = 0, [PRIEST] = 0, [WARLOCK] = 0, [PALADIN] = 0
    --}
    local slacker, disco, fd, not_in_raid
    --local tooltip        = {}
    local player_name, player_group, player_localized_class, player_class
    local isClassExpected
    for i = 1, 40 do
        player_name, _, player_group, _, player_localized_class, player_class = GetRaidRosterInfo(i)
        if player_class then
            slacker, disco, fd, not_in_raid = ReturnBuffTracker:CheckUnitCannotHelpRaid(player_name)
            if slacker then
                --@debug@
                ReturnBuffTracker:Debugf("CheckBuff", "Checking %s is SLACKER, ignoring", tostring(player_name), unitPowerTypeName)
                --@end-debug@
                if not buff.ignoredPlayers["Slacker"] then
                    buff.ignoredPlayers["Slacker"] = {}
                end
                tinsert(buff.ignoredPlayers["Slacker"], player_name)
            else
                isClassExpected = ReturnBuffTracker:Contains(buff.classes, player_class)
                if isClassExpected then
                    buff.total = buff.total + 1
                    if ReturnBuffTracker:CheckUnitBuff(player_name, buff) then
                        buff.count = buff.count + 1
                        --buff.good_players[player_name] = { name = player_name, group = player_group, class = player_class, localized_class = player_localized_class }
                    else
                        buff.bad_players[player_name] = { name = player_name, group = player_group, class = player_class, localized_class = player_localized_class }
                        --if class_count[player_class] then
                        --    class_count[player_class] = class_count[player_class] + 1
                        --else
                        --    class_count[player_class] = 1
                        --end
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


    buff.tooltip[1]              = format("{rt7}" .. L["Missing %s"], (buff.name or buff.shortName or str(buff.buffIDs[1])))
    local tool_tip_index         = 2
    buff.tooltip[tool_tip_index] = L["no one."]

    tool_tip_index               = fill_tooltip_data_array(buff, buff.bad_players, buff.tooltip, tool_tip_index)

    -- TODO: Make the goodboys tooltip and report configurable
    --tooltip[tool_tip_index] = "Good boys:"
    --tool_tip_index          = tool_tip_index + 1
    --tooltip[tool_tip_index] = L["no one."]
    --
    --tool_tip_index          = foo(buff, buff.good_players, tooltip, tool_tip_index)

    local players_str
    for reason, player_details in pairs(buff.ignoredPlayers) do
        --@debug@
        ReturnBuffTracker:Debugf("CheckBuff", "Ignored players: [%s] = %d", tostring(reason), #player_details)
        --@end-debug@
        players_str = tconcat(player_details, " ")
        tinsert(buff.tooltip,
                format("Ignoring: %s %s", tostring(reason), players_str))
    end

    return buff.count, buff.total, buff.tooltip
end

function ReturnBuffTracker:CheckUnitBuff(unit, buff)
    local buff_name, caster, spellId
    for i = 1, BUFF_MAX_DISPLAY do
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
        end

    end
    return false, nil
end
