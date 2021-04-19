local RBT                                 = LibStub("AceAddon-3.0"):GetAddon("ReturnBuffTracker")
local L                                   = LibStub("AceLocale-3.0"):GetLocale("ReturnBuffTracker")

local WARRIOR, MAGE, ROGUE, DRUID, HUNTER = "WARRIOR", "MAGE", "ROGUE", "DRUID", "HUNTER"
local SHAMAN, PRIEST, WARLOCK, PALADIN    = "SHAMAN", "PRIEST", "WARLOCK", "PALADIN"

local consumables                         = {
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

local tmp_c
for i, c in ipairs(consumables) do
    tmp_c                  = c
    tmp_c.func             = RBT.CheckBuff
    tmp_c.BuildToolTipText = RBT.BuildToolTip
    RBT:RegisterCheck(tmp_c)
end
