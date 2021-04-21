local RBT                                 = LibStub("AceAddon-3.0"):GetAddon("ReturnBuffTracker")
local L                                   = LibStub("AceLocale-3.0"):GetLocale("ReturnBuffTracker")

local WARRIOR, MAGE, ROGUE, DRUID, HUNTER = "WARRIOR", "MAGE", "ROGUE", "DRUID", "HUNTER"
local SHAMAN, PRIEST, WARLOCK, PALADIN    = "SHAMAN", "PRIEST", "WARLOCK", "PALADIN"

local player_raid_buffs                   = {
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
        classes          = RBT.all_classes,
    },
    {
        name             = L["Power Word: Fortitude"],
        shortName        = L["Fortitude"],
        color            = { r = 1.0, g = 1.0, b = 1.0 },
        buffIDs          = { 10938, 21564 },
        buffNames        = { L["Power Word: Fortitude"], L["Prayer of Fortitude"] },
        buffOptionsGroup = L["Player buffs"],
        buffingClass     = PRIEST,
        classes          = RBT.all_classes,
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
        classes          = RBT.all_classes,
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
        classes          = RBT.all_classes,
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
        classes          = RBT.all_classes,
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
        classes          = RBT.all_classes,
    },
}

local tmp_c
for i, c in ipairs(player_raid_buffs) do
    tmp_c                  = c
    --tmp_c.func             = RBT.CheckBuff
    --tmp_c.BuildToolTipText = RBT.BuildToolTip
    RBT:RegisterCheck(tmp_c)
end
