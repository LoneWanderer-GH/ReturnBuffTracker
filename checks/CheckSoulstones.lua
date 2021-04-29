local RBT                       = LibStub("AceAddon-3.0"):GetAddon("ReturnBuffTracker")
local L                         = LibStub("AceLocale-3.0"):GetLocale("ReturnBuffTracker")

local WARLOCK                   = "WARLOCK"

local format                    = format
local GetUnitName               = GetUnitName
local RAID_CLASS_COLORS         = RAID_CLASS_COLORS
local WARLOCK_COLOR             = RAID_CLASS_COLORS[WARLOCK]
local WARLOCK_COLOR_STR         = WARLOCK_COLOR.colorStr
local tinsert, tconcat, tremove = table.insert, table.concat, table.remove

local function Check(buff)
    buff:ResetBuffData()
    buff.nb_of_possible_casters = 0
    
    if buff.players_having_soulstone then
        RBT:clearArrayList(buff.players_having_soulstone)
    else
        buff.players_having_soulstone = {}
    end
    local present, caster
    for player_name, player_cache_data in pairs(RBT.raid_player_cache) do
        if player_cache_data.class == buff.buffingClass then
            buff.total                  = buff.total + 1
            buff.nb_of_possible_casters = buff.nb_of_possible_casters + 1
        end
        present, caster = RBT:CheckUnitBuff(player_name, buff)
        if caster then
            caster = GetUnitName(caster)
        end
        if present then
            buff.count = buff.count + 1
            
            tinsert(buff.players_having_soulstone, format("%s (from %s)",
                                                          player_cache_data.colored_player_name,
                                                          WrapTextInColorCode(caster, WARLOCK_COLOR_STR)))
        end
    end
    
    -- override for bar display
    if buff.count >= 1 then
        buff.total = 1
    end
end

local function BuildToolTip(buff)
    local j         = 2
    buff.tooltip[j] = L["none"] .. "."
    buff.tooltip[1] = format("%s: (%d %s)",
                             WrapTextInColorCode(L["Soulstones"], WARLOCK_COLOR_STR),
                             buff.nb_of_possible_casters,
                             RBT.localized_classes[buff.buffingClass])
    if #buff.players_having_soulstone > 0 then
        buff.tooltip[j] = tconcat(buff.players_having_soulstone, " ")
    end
end

local check_conf = {
    name                   = L["Soulstone Resurrection"],
    shortName              = L["Soulstones"],
    --color            = { r = 0.58, g = 0.51, b = 0.79 },
    color                  = WARLOCK_COLOR,
    buffIDs                = { 20765 },
    buffOptionsGroup       = L["Player buffs"],
    buffOptionsSubGroup    = RBT.localized_classes[WARLOCK],
    buffingClass           = WARLOCK,
    func                   = Check,
    BuildToolTipText       = BuildToolTip,
    nb_of_possible_casters = 0,
}

RBT:RegisterCheck(check_conf)