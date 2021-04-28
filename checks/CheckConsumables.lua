local RBT                                 = LibStub("AceAddon-3.0"):GetAddon("ReturnBuffTracker")
local L                                   = LibStub("AceLocale-3.0"):GetLocale("ReturnBuffTracker")

local WARRIOR, MAGE, ROGUE, DRUID, HUNTER = "WARRIOR", "MAGE", "ROGUE", "DRUID", "HUNTER"
local SHAMAN, PRIEST, WARLOCK, PALADIN    = "SHAMAN", "PRIEST", "WARLOCK", "PALADIN"

local aggregated_spell_bonuses            = {
    {
        name             = L["+20dmg OR +30dmg"],
        shortName        = L["+20dmg OR +30dmg"],
        optionText       = L["+20dmg OR +30dmg"],
        color            = { r = 0.58, g = 0.51, b = 0.79 },
        buffIDs          = { 11390, 17539 },
        buffOptionsGroup = L["Consumables"],
        sourceItemId     = { 9155, 13454 },
        classes          = { WARLOCK, MAGE }
    },
}
local aggregated_elemental_spell_bonuses  = {
    {
        name             = L["+40 fire OR shadow dmg"],
        shortName        = L["+40 fire OR shadow dmg"],
        optionText       = L["+40 fire OR shadow dmg"],
        color            = { r = 0.58, g = 0.51, b = 0.79 },
        buffIDs          = { 11474, 26276 },
        buffOptionsGroup = L["Consumables"],
        classes          = { WARLOCK, MAGE },
        sourceItemId     = { 9264, 21546 },
    },
}
local spell_bonuses                       = {
    {
        name             = L["Greater Arcane Elixir"],
        shortName        = L["+30dmg"],
        color            = { r = 0.58, g = 0.51, b = 0.79 },
        buffIDs          = { 17539 },
        buffOptionsGroup = L["Consumables"],
        sourceItemId     = { 13454 },
        classes          = { WARLOCK, MAGE }
    },
    {
        name             = L["Arcane Elixir"],
        shortName        = L["+20dmg"],
        --optionText       = L["+dmg"],
        color            = { r = 0.58, g = 0.51, b = 0.79 },
        buffIDs          = { 11390 },
        buffOptionsGroup = L["Consumables"],
        sourceItemId     = { 9155 },
        classes          = { WARLOCK, MAGE }
    },
    {
        name             = L["Elixir of Shadow Power"],
        shortName        = L["+40 shadow dmg"],
        optionText       = L["+40 shadow dmg"],
        color            = { r = 0.58, g = 0.51, b = 0.79 },
        buffIDs          = { 11474 },
        buffOptionsGroup = L["Consumables"],
        classes          = { WARLOCK },
        sourceItemId     = { 9264 },
    },
    {
        name             = L["Elixir of Fire Mastery"],
        shortName        = L["+40 fire dmg"],
        optionText       = L["+40 fire dmg"],
        color            = { r = 0.58, g = 0.51, b = 0.79 },
        buffIDs          = { 26276 },
        buffOptionsGroup = L["Consumables"],
        classes          = { MAGE, WARLOCK },
        sourceItemId     = { 21546 },
    },
}

local aggregated_agility                  = {
    {
        name             = L["+25 AGI OR Mongoose"],
        shortName        = L["+25 AGI OR Mongoose"],
        color            = { r = 0.51, g = 0.79, b = 0.51 },
        buffIDs          = { 11334, 17538 },
        buffOptionsGroup = L["Consumables"],
        classes          = { WARRIOR, ROGUE, HUNTER, "CAT", "MAINTANK" },
        sourceItemId     = { 9187, 21546 },
    },
}

local agility                             = {
    {
        name             = L["Elixir of the Mongoose"],
        shortName        = L["Mongoose"],
        color            = { r = 0.58, g = 0.51, b = 0.79 },
        buffIDs          = { 17538 },
        buffOptionsGroup = L["Consumables"],
        classes          = { WARRIOR, ROGUE, HUNTER, "CAT", "MAINTANK" },
        sourceItemId     = { 21546 },
    },
    {
        name             = L["Elixir of Greater Agility"],
        color            = { r = 0.51, g = 0.79, b = 0.51 },
        shortName        = L["+25 AGI"],
        buffIDs          = { 11334 },
        buffOptionsGroup = L["Consumables"],
        classes          = { WARRIOR, ROGUE, HUNTER, "CAT", "MAINTANK" },
        sourceItemId     = { 9187 },
    },
}

local strength_ap                         = {
    {
        name             = L["Giant Elixir"],
        shortName        = L["Giant Elixir"],
        color            = { r = 0.58, g = 0.51, b = 0.79 },
        buffIDs          = { 11405 },
        sourceItemId     = { 9206 },
        buffOptionsGroup = L["Consumables"],
        classes          = { WARRIOR, ROGUE, "CAT", "MAINTANK" },
    },
}
local aggregated_strength_ap              = {
    {
        name             = L["Juju Power OR Giant Elixir"],
        color            = { r = 0.58, g = 0.51, b = 0.79 },
        buffIDs          = { 11405, 16323 },
        sourceItemId     = { 9206, 12451 },
        buffOptionsGroup = L["Consumables"],
        classes          = { WARRIOR, ROGUE, "CAT", "MAINTANK" },
    },
    {
        name             = L["Juju Might OR Firewater"],
        color            = { r = 0.58, g = 0.51, b = 0.79 },
        buffIDs          = { 16329, 17038 },
        sourceItemId     = { 12460, 17205 },
        buffOptionsGroup = L["Consumables"],
        classes          = { WARRIOR, ROGUE, "CAT", "MAINTANK" },
    },
}

local physical_mitigation                 = {
    {
        name             = L["Elixir of Fortitude"],
        shortName        = L["E. Fortitude"],
        color            = { r = 0.58, g = 0.51, b = 0.79 },
        buffIDs          = { 3593 },
        buffOptionsGroup = L["Consumables"],
        classes          = { WARRIOR, ROGUE, "CAT", "MAINTANK" },
        sourceItemId     = { 3825 },
    },
    {
        name             = L["Elixir of Superior Defense"],
        shortName        = L["+450 armor"],
        color            = { r = 0.58, g = 0.51, b = 0.79 },
        buffIDs          = { 11348 },
        buffOptionsGroup = L["Consumables"],
        classes          = { WARRIOR, "MAINTANK" },
        sourceItemId     = { 13445 },
    }
}
for _, conf in ipairs(physical_mitigation) do
    conf.buffOptionsSubGroup = L["Physical mitig."]
end

local aggregated_life_regen = {
    {
        name             = L["Troll's Blood Potions"],
        shortName        = L["+12/20 HP5"],
        color            = { r = 0.60, g = 0.85, b = 0.60 },
        buffIDs          = { 3223, 24361 },
        buffOptionsGroup = L["Consumables"],
        --classes          = { MAGE, WARLOCK, DRUID, SHAMAN, PALADIN, PRIEST, HUNTER },
        sourceItemId     = { 3826, 20004 },
    }
}

local life_regen            = {
    {
        name             = L["Major Troll's Blood Potion"],
        shortName        = L["+20 MP5"],
        color            = { r = 0.60, g = 0.85, b = 0.60 },
        buffIDs          = { 24361 },
        buffOptionsGroup = L["Consumables"],
        --classes          = { MAGE, WARLOCK, DRUID, SHAMAN, PALADIN, PRIEST, HUNTER },
        sourceItemId     = { 20004 },
    },
    {
        name             = L["Mighty Troll's Blood Potion"],
        shortName        = L["+12 HP5"],
        color            = { r = 0.60, g = 0.85, b = 0.60 },
        buffIDs          = { 3223 },
        buffOptionsGroup = L["Consumables"],
        --classes          = { MAGE, WARLOCK, DRUID, SHAMAN, PALADIN, PRIEST, HUNTER },
        sourceItemId     = { 3826 },
    }
}

local mana_regen            = {
    {
        name             = L["Mageblood Potion"],
        shortName        = L["+12 MP5"],
        color            = { r = 0.58, g = 0.51, b = 0.79 },
        buffIDs          = { 24363 },
        buffOptionsGroup = L["Consumables"],
        classes          = { MAGE, WARLOCK, DRUID, SHAMAN, PALADIN, PRIEST, HUNTER },
        sourceItemId     = { 20007 },
    }
}

local protection_potions    = {
    {
        name             = L["Fire Protection"],
        shortName        = L["Fire Pot."],
        optionText       = L["Fire Protection Potions"],
        color            = { r = 1, g = 0, b = 0 },
        buffIDs          = { 7233, 17543 },
        sourceItemId     = { 6049, 13457 },
        buffOptionsGroup = L["Consumables"],
    },
    -- {
    --    name             = L["Greater Fire Protection"],
    --    shortName        = L["Greater Fire Prot."],
    --    optionText       = L["Greater Fire Protection Potion"],
    --    color            = { r = 1, g = 0, b = 0 },
    --    buffIDs          = { 17543 },
    --    buffOptionsGroup = L["Consumables"]
    --},
    {
        name             = L["Nature Protection"],
        shortName        = L["Nature Pot."],
        optionText       = L["Nature Protection Potions"],
        color            = { r = 0, g = 1, b = 0 },
        buffIDs          = { 7254, 17546 },
        buffOptionsGroup = L["Consumables"],
        sourceItemId     = { 6052, 13458 },
    },
    --{
    --    name             = L["Greater Nature Protection"],
    --    shortName        = L["Greater Nature Prot."],
    --    optionText       = L["Greater Nature Protection Potion"],
    --    color            = { r = 0, g = 1, b = 0 },
    --    buffIDs          = { 17546 },
    --    buffOptionsGroup = L["Consumables"]
    --},
    {
        name             = L["Shadow Protection"],
        shortName        = L["Shadow Pot."],
        optionText       = L["Shadow Protection Potions"],
        color            = { r = 0.5, g = 0, b = 0.5 },
        buffIDs          = { 7242, 17548 },
        buffOptionsGroup = L["Consumables"],
        sourceItemId     = { 6048, 13459 },
    },
    --{
    --    name             = L["Greater Shadow Protection"],
    --    shortName        = L["Greater Shadow Prot."],
    --    optionText       = L["Greater Shadow Protection Potion"],
    --    color            = { r = 0.5, g = 0, b = 0.5 },
    --    buffIDs          = { 17548 },
    --    buffOptionsGroup = L["Consumables"]
    --},
    {
        name             = L["Arcane Protection"],
        shortName        = L["Arcane Pot."],
        optionText       = L["Arcane Protection Potions"],
        color            = { r = 0, g = 0, b = 1 },
        buffIDs          = { 17549 },
        buffOptionsGroup = L["Consumables"],
        sourceItemId     = { 13461 },
    },
    {
        name             = L["Frost Protection"],
        shortName        = L["Frost Pot."],
        optionText       = L["Frost Protection Potions"],
        color            = { r = 0, g = 1, b = 1 },
        buffIDs          = { 7239, 17544 },
        buffOptionsGroup = L["Consumables"],
        sourceItemId     = { 6050, 13456 },
    },
    {
        name             = L["Gift of Arthas"],
        shortName        = L["Arthas 10 RO"],
        --optionText       = L["Frost Protection Potions"],
        color            = { r = 0, g = 0.1, b = 0.9 },
        buffIDs          = { 11371 },
        buffOptionsGroup = L["Consumables"],
        sourceItemId     = { 9088 },
    }
}
for _, conf in ipairs(protection_potions) do
    conf.buffOptionsSubGroup = L["Protection Potions"]
end

local flasks = {
    {
        name             = L["Flask of Distilled Wisdom"],
        shortName        = L["+Mana Flask"],
        color            = { r = 0.45, g = 0.45, b = 0.79 },
        buffIDs          = { 17627 },
        buffOptionsGroup = L["Consumables"],
        classes          = { PRIEST, DRUID, PALADIN, SHAMAN },
        sourceItemId     = { 13511 },
    },
    {
        name             = L["Flask of Supreme Power"],
        shortName        = L["+dmg Flask"],
        color            = { r = 0.75, g = 0.45, b = 0.45 },
        buffIDs          = { 17628 },
        buffOptionsGroup = L["Consumables"],
        classes          = { MAGE, WARLOCK },
        sourceItemId     = { 13512 },
    },
    {
        name             = L["Flask of the Titans"],
        shortName        = L["+HP Flask"],
        color            = { r = 0.20, g = 0.70, b = 0.70 },
        buffIDs          = { 17626 },
        buffOptionsGroup = L["Consumables"],
        classes          = { WARRIOR, "MAINTANK" },
        sourceItemId     = { 13510 },
    },
}
for _, conf in ipairs(flasks) do
    conf.buffOptionsSubGroup = L["Flasks"]
end

local zanza = {
    {
        name             = L["Spirit of Zanza"],
        shortName        = L["+50 STA/SPI"],
        color            = { r = 0.70, g = 0.10, b = 0.70 },
        buffIDs          = { 24382 },
        buffOptionsGroup = L["Consumables"],
        --classes          = ,
        sourceItemId     = { 20079 },
    },
}
for _, conf in ipairs(zanza) do
    conf.buffOptionsSubGroup = L["Zul'Gurub"]
end

local aggregated_blasted_lands = {
    {
        name             = L["+25 stat (Blasted Lands)"],
        shortName        = L["+25 stat (BL)"],
        color            = { r = 0.58, g = 0.51, b = 0.79 },
        buffIDs          = { 10667, 10699, 10668, 10692, 10693 },
        buffOptionsGroup = L["Consumables"],
        sourceItemId     = { 8410, 8412, 8411, 8423, 8424 },
    },
}
for _, conf in ipairs(aggregated_blasted_lands) do
    conf.buffOptionsSubGroup = L["Blasted Lands"]
end

local blasted_lands = {
    {
        name             = L["+25 STR (R.O.I.D.S)"],
        shortName        = L["+25 STR (BL)"],
        color            = { r = 0.58, g = 0.51, b = 0.79 },
        buffIDs          = { 10667 },
        buffOptionsGroup = L["Consumables"],
        classes          = { WARRIOR },
        sourceItemId     = { 8410 },
    },
    {
        name             = L["+25 AGI (Ground Scorpok Assay)"],
        shortName        = L["+25 AGI (BL)"],
        color            = { r = 0.58, g = 0.51, b = 0.79 },
        buffIDs          = { 10699 },
        buffOptionsGroup = L["Consumables"],
        classes          = { ROGUE, HUNTER, "CAT" },
        sourceItemId     = { 8412 },
    },
    {
        name             = L["+25 STA (Lung Juice Cocktail)"],
        shortName        = L["+25 STA (BL)"],
        color            = { r = 0.58, g = 0.51, b = 0.79 },
        buffIDs          = { 10668 },
        buffOptionsGroup = L["Consumables"],
        classes          = { WARRIOR, "MAINTANK" },
        sourceItemId     = { 8411 },
    },
    {
        name             = L["+25 INT (Cerebral Cortex Compound)"],
        shortName        = L["+25 INT (BL)"],
        color            = { r = 0.58, g = 0.51, b = 0.79 },
        buffIDs          = { 10692 },
        buffOptionsGroup = L["Consumables"],
        classes          = { MAGE, WARLOCK, "MOONKIN" },
        sourceItemId     = { 8423 },
    },
    {
        name             = L["+25 SPI (Gizzard Gum)"],
        shortName        = L["+25 SPI (BL)"],
        color            = { r = 0.58, g = 0.51, b = 0.79 },
        buffIDs          = { 10693 },
        buffOptionsGroup = L["Consumables"],
        classes          = { PRIEST, SHAMAN, PALADIN, DRUID },
        sourceItemId     = { 8424 },
    },
}
for _, conf in ipairs(blasted_lands) do
    conf.buffOptionsSubGroup = L["Blasted Lands"]
end

local winter_fall = {

    {
        name             = L["Winterfall Firewater"],
        shortName        = L["Firewater"],
        color            = { r = 0.58, g = 0.51, b = 0.79 },
        buffIDs          = { 17038 },
        buffOptionsGroup = L["Consumables"],
        classes          = { WARRIOR, ROGUE },
        sourceItemId     = { 12820 },
    },

    {
        name             = L["Juju Power"],
        shortName        = L["Juju Power"],
        color            = { r = 0.58, g = 0.51, b = 0.79 },
        buffIDs          = { 16323 },
        buffOptionsGroup = L["Consumables"],
        classes          = { WARRIOR, ROGUE },
        sourceItemId     = { 12451 },
    },

    {
        name             = L["Juju Might"],
        shortName        = L["Juju Might"],
        color            = { r = 0.58, g = 0.51, b = 0.79 },
        buffIDs          = { 16329 },
        buffOptionsGroup = L["Consumables"],
        classes          = { WARRIOR, ROGUE, HUNTER },
        sourceItemId     = { 12460 },
    },
    {
        name             = L["Juju Chill"],
        shortName        = L["Juju Chill"],
        color            = { r = 0.58, g = 0.51, b = 0.79 },
        buffIDs          = { 16325 },
        buffOptionsGroup = L["Consumables"],
        sourceItemId     = { 12457 }
    },
    {
        name             = L["Juju Ember"],
        shortName        = L["Juju Ember"],
        color            = { r = 0.58, g = 0.51, b = 0.79 },
        buffIDs          = { 16326 },
        buffOptionsGroup = L["Consumables"],
        sourceItemId     = { 12455 }
    },
}

for _, conf in ipairs(winter_fall) do
    conf.buffOptionsSubGroup = L["Winterfell"]
end

local all = { aggregated_spell_bonuses,
              aggregated_elemental_spell_bonuses,
              spell_bonuses,
              aggregated_agility,
              agility,
              strength_ap,
              aggregated_strength_ap,
              physical_mitigation,
              aggregated_life_regen,
              life_regen,
              mana_regen,
              protection_potions,
              flasks,
              zanza,
              aggregated_blasted_lands,
              blasted_lands,
              winter_fall }

for _, conf_list in ipairs(all) do
    for _, conf in ipairs(conf_list) do
        RBT:RegisterCheck(conf)
    end
end
