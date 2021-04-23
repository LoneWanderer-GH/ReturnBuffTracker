local RBT                       = LibStub("AceAddon-3.0"):GetAddon("ReturnBuffTracker")
local L                         = LibStub("AceLocale-3.0"):GetLocale("ReturnBuffTracker")

local format                    = format
local GetRaidRosterInfo         = GetRaidRosterInfo

local tinsert, tconcat, tremove = table.insert, table.concat, table.remove

local function Check(buff)

    buff:ResetBuffData()
    if buff.dead_players_by_classes then
        --for _, class in ipairs(RBT.all_classes) do
        --    RBT:clearArrayList(buff.dead_players_by_classes[class])
        --end
        for _,v in pairs(buff.dead_players_by_classes) do
            RBT:clearArrayList(v)
        end
    else
        buff.dead_players_by_classes = {}
        for _, class in ipairs(RBT.all_classes) do
            buff.dead_players_by_classes[class] = {}
        end
    end

    local dead_players_by_classes = buff.dead_players_by_classes

    local name, localized_class, class, isDead
    for i = 1, 40 do
        name, _, _, _, localized_class, class, _, _, isDead, _, _ = GetRaidRosterInfo(i)
        if name then
            buff.total = buff.total + 1
            if not isDead then
                buff.count = buff.count + 1
            else
                tinsert(dead_players_by_classes[class], name)
            end
        end
    end
end

local function BuildToolTip(buff)
    local j                       = 2
    local dead_players_by_classes = buff.dead_players_by_classes
    local dead_number             = (buff.total - buff.count)
    local percent                 = RBT:compute_percent_string(dead_number, buff.total)
    buff.tooltip[1]               = format("%s: %d/%d - %s", L["Dead"], dead_number, buff.total, percent)
    for dead_class, dead_names in pairs(dead_players_by_classes) do
        if #dead_names > 0 then
            buff.tooltip[j] = format("%s: %s",
                                     RBT.localized_classes[dead_class],
                                     tconcat(dead_names, " "))
            j               = j + 1
        end
    end
end

local check_conf = {
    name             = L["Alive"],
    shortName        = L["Alive"],
    func             = Check,
    color            = { r = 0.3, g = 1, b = 0.3 },
    buffOptionsGroup = L["General"],
    BuildToolTipText = BuildToolTip,
}

RBT:RegisterCheck(check_conf)