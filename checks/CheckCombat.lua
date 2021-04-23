local RBT                             = LibStub("AceAddon-3.0"):GetAddon("ReturnBuffTracker")
local L                               = LibStub("AceLocale-3.0"):GetLocale("ReturnBuffTracker")

local GetRaidRosterInfo               = GetRaidRosterInfo

local UnitIsDead, UnitAffectingCombat = UnitIsDead, UnitAffectingCombat

local tinsert, tconcat, tremove       = table.insert, table.concat, table.remove

local MAX_GROUPS_IN_RAID              = 8
local function Check(buff)

    buff:ResetBuffData()
    if buff.groups_array then
        for i = 1, MAX_GROUPS_IN_RAID do
            RBT:clearArrayList(buff.groups_array[i])
        end
    else
        buff.groups_array = {}
        for i = 1, MAX_GROUPS_IN_RAID do
            buff.groups_array[i] = {}
        end
    end
    buff.count = 0
    buff.total = 0

    --local player_name, player_group
    for player_name, player_cache_data in pairs(RBT.raid_player_cache) do
        if not player_cache_data.dead then
            buff.total = buff.total + 1
            if player_cache_data.combat then
                buff.count = buff.count + 1
            else
                tinsert(buff.groups_array[player_cache_data.group], player_name)
            end
        end
    end
    --for i = 1, 40 do
    --    player_name, _, player_group = GetRaidRosterInfo(i)
    --    if player_name and not UnitIsDead(player_name) then
    --        buff.total = buff.total + 1
    --        if UnitAffectingCombat(player_name) then
    --            buff.count = buff.count + 1
    --        else
    --            tinsert(buff.groups_array[player_group], player_name)
    --        end
    --    end
    --end
end

local function BuildToolTip(buff)
    buff.tooltip[1]              = L["Not in Combat: "]
    local tool_tip_index         = 2
    buff.tooltip[tool_tip_index] = L["no one."]

    for i = 1, MAX_GROUPS_IN_RAID do
        if #buff.groups_array[i] > 0 then
            buff.tooltip[tool_tip_index] = tconcat(buff.groups_array[i], " ")
            tool_tip_index               = tool_tip_index + 1
        end
    end
end

local check_conf = {
    name             = L["In Combat"],
    shortName        = L["In Combat"],
    color            = { r = 1, g = 1, b = 1 },
    buffOptionsGroup = L["General"],
    func             = Check,
    BuildToolTipText = BuildToolTip,
}

RBT:RegisterCheck(check_conf)