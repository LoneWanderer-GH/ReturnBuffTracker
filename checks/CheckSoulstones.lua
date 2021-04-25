local RBT                       = LibStub("AceAddon-3.0"):GetAddon("ReturnBuffTracker")
local L                         = LibStub("AceLocale-3.0"):GetLocale("ReturnBuffTracker")

local WARLOCK                   = "WARLOCK"

local format                    = format
local GetRaidRosterInfo         = GetRaidRosterInfo
local GetUnitName               = GetUnitName
local RAID_CLASS_COLORS         = RAID_CLASS_COLORS
local WARLOCK_COLOR             = RAID_CLASS_COLORS[WARLOCK]
local WARLOCK_COLOR_STR         = WARLOCK_COLOR.colorStr
local tinsert, tconcat, tremove = table.insert, table.concat, table.remove

local function Check(buff)
    buff:ResetBuffData()

    local player_name, group, localized_class, class
    if buff.players_having_soulstone then
        RBT:clearArrayList(buff.players_having_soulstone)
    else
        buff.players_having_soulstone = {}
    end
    local present, caster
    for player_name, player_cache_data in pairs(RBT.raid_player_cache) do
        if class == buff.buffingClass then
            buff.total = buff.total + 1
        end
        present, caster = RBT:CheckUnitBuff(player_name, buff)
        if caster then
            caster = GetUnitName(caster)
        end
        if present then
            buff.count = buff.count + 1
            tinsert(buff.players_having_soulstone, format("%s (from |c%s%s|r)", player_cache_data.colored_player_name, WARLOCK_COLOR_STR, caster))
        end
    end

    -- override for bar display
    if buff.count <= 0 then
        buff.count = 0
        buff.total = 1
    else
        buff.count = 1
        buff.total = 1
    end
end

local function BuildToolTip(buff)
    local j         = 2
    buff.tooltip[j] = L["none"].."."
    buff.tooltip[1] = format("%s: (%d %s)", L["Soulstones"],
                             buff.total,
                             RBT.localized_classes[buff.buffingClass])
    if #buff.players_having_soulstone > 0 then
        buff.tooltip[j] = tconcat(buff.players_having_soulstone, " ")
    end
end

local check_conf = {
    name             = L["Soulstone Resurrection"],
    shortName        = L["Soulstones"],
    --color            = { r = 0.58, g = 0.51, b = 0.79 },
    color            = WARLOCK_COLOR,
    buffIDs          = { 20765 },
    buffOptionsGroup = L["Player buffs"],
    buffingClass     = WARLOCK,
    func             = Check,
    BuildToolTipText = BuildToolTip,
}

RBT:RegisterCheck(check_conf)