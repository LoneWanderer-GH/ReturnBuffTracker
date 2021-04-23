local RBT                                 = LibStub("AceAddon-3.0"):GetAddon("ReturnBuffTracker")
local L                                   = LibStub("AceLocale-3.0"):GetLocale("ReturnBuffTracker")

local WARRIOR, MAGE, ROGUE, DRUID, HUNTER = "WARRIOR", "MAGE", "ROGUE", "DRUID", "HUNTER"
local SHAMAN, PRIEST, WARLOCK, PALADIN    = "SHAMAN", "PRIEST", "WARLOCK", "PALADIN"
local DMF_specific                        = { [true] = "active", [false] = "inactive" }

local function DMF_Special(buff)
    local is_active = RBT:isDMFActive()
    if not is_active then
        buff.bar.buffNameTextString:SetText("DMF " .. DMF_specific[is_active])
        local tmp = format("%s (%s)", buff.shortName, DMF_specific[is_active])
        buff.bar.texture:SetColorTexture(0.1, 0.1, 0.1, 1.0)
        buff.bar.buffNameTextString:SetText(tmp)
        buff.percentage_float = 1.0
        buff.percentage_str   = "0%"
    end
end
local world_buffs          = {
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

}
local dm_buffs             = {
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
}

-- try not to have classes overlap (1 DMF possible at a time)
local dmf_buffs            = {
    {
        name              = L["Sayge's Dark Fortune of Damage"],
        shortName         = L["DMF Damage"],
        color             = { r = 0, g = 1, b = 1 },
        buffIDs           = { 23768 },
        buffOptionsGroup  = L["World"],
        classes           = { HUNTER, ROGUE, WARLOCK, MAGE },
        SpecialBarDisplay = DMF_Special
    },
    --    {
    --    name              = L["Sayge's Dark Fortune of Resistance"],
    --    shortName         = L["DMF Resist."],
    --    color             = { r = 0, g = 1, b = 1 },
    --    buffIDs           = { 23768 },
    --    buffOptionsGroup  = L["World"],
    --    classes           = { ???????? },
    --    SpecialBarDisplay = DMF_Special
    --},
    {
        name              = L["Sayge's Dark Fortune of Stamina"],
        shortName         = L["DMF Sta."],
        color             = { r = 0, g = 1, b = 1 },
        buffIDs           = { 23737 },
        buffOptionsGroup  = L["World"],
        classes           = { WARRIOR, DRUID, PALADIN },
        roles             = { "MAINTANK" },
        SpecialBarDisplay = DMF_Special
    },
    {
        name              = L["Sayge's Dark Fortune of Intelligence"],
        shortName         = L["DMF Int."],
        color             = { r = 0, g = 1, b = 1 },
        buffIDs           = { 23766 },
        buffOptionsGroup  = L["World"],
        classes           = { PRIEST, DRUID, SHAMAN, PALADIN },
        SpecialBarDisplay = DMF_Special
    },
    {
        name              = L["Sayge's Dark Fortune of Spirit"],
        shortName         = L["DMF Spi."],
        color             = { r = 0, g = 1, b = 1 },
        buffIDs           = { 23738 },
        buffOptionsGroup  = L["World"],
        classes           = { PRIEST, DRUID, SHAMAN, PALADIN },
        SpecialBarDisplay = DMF_Special
    },
    {
        name              = L["Sayge's Dark Fortune of Armor"],
        shortName         = L["DMF Armor"],
        color             = { r = 0, g = 1, b = 1 },
        buffIDs           = { 23767 },
        buffOptionsGroup  = L["World"],
        classes           = { WARRIOR },
        roles             = { "MAINTANK" },
        SpecialBarDisplay = DMF_Special
    },
}

local aggregated_dmf_buffs = {
    {
        name              = L["DMF buffs"],
        shortName         = L["DMF buffs"],
        color             = { r = 0, g = 1, b = 1 },
        buffIDs           = { 23768, 23737, 23768, 23766, 23738, 23767 },
        buffOptionsGroup  = L["World"],
        SpecialBarDisplay = DMF_Special
    },
}

--local function SpecialBarDisplay(buff)
--        if buff.shortName and buff.shortName == L["DMF Damage"] then
--
--end
local all                  = table.concat(world_buffs,
                                          dm_buffs,
                                          dmf_buffs,
                                          aggregated_dmf_buffs)

local tmp_c
for i, c in ipairs(all) do
    tmp_c = c
    --tmp_c.func             = RBT.CheckBuff
    --tmp_c.BuildToolTipText = RBT.BuildToolTip
    RBT:RegisterCheck(tmp_c)
end
