local RBT                                                  = LibStub("AceAddon-3.0"):GetAddon("ReturnBuffTracker")
local L                                                    = LibStub("AceLocale-3.0"):GetLocale("ReturnBuffTracker")
local AceEvent                                             = LibStub("AceEvent-3.0")
local format                                               = format

local GetLootMethod, GetLootThreshold, GetItemQualityColor = GetLootMethod, GetLootThreshold, GetItemQualityColor
local GetUnitName                                          = GetUnitName

local tinsert, tconcat, tremove                            = table.insert, table.concat, table.remove
local RAID_CLASS_COLORS                                    = RAID_CLASS_COLORS
local UnitClass                                            = UnitClass

local function BuildMLToolTip(buff)
    if buff.ready then
        local r, g, b, hex = GetItemQualityColor(buff.loot_threshold)
        --buff.rgb           = { r = r, g = g, b = b }
        buff.coloredStr    = format("|c%s%s|r",
                                    hex,
                                    RBT.ITEM_QUALITY_ENUM_TO_LOCALIZED_STRING[buff.loot_threshold])
        tinsert(buff.tooltip, format("Method: %s", buff.method))
        tinsert(buff.tooltip, format("Threshold: %s", buff.coloredStr))

        if buff.method ~= "master" then
            tinsert(buff.tooltip, "NO ML !")
        else
            tinsert(buff.tooltip, format("ML: %s", buff.ML_name))
        end
    end
end

local function SpecialBarDisplay(buff)
    if buff.ready then
        if buff.bar then
            buff.bar.texture:SetColorTexture(0.1, 0.1, 0.1, 0.9) --buff.rgb.r, buff.rgb.g, buff.rgb.b, 0.9)
        end
        local ML_str = ""
        if buff.ML_name then
            ML_str = format("@ %s", buff.ML_name)
        end
        buff.bar.buffNameTextString:SetText(format("[%s] %s %s",
                                                   buff.method,
                                                   ML_str,
                                                   buff.coloredStr))
    end
end

local ml_buff = {
    name              = L["Loot Method"],
    shortName         = L["Loot Method"],
    color             = { r = 1.0, g = 0.3, b = 0.3 },
    func              = function() return end, -- buff checked on event, as well as tooltip and bar display
    buffOptionsGroup  = L["General"],
    BuildToolTipText  = function() return end, -- buff checked on event, as well as tooltip and bar display
    SpecialBarDisplay = function() return end, -- buff checked on event, as well as tooltip and bar display
    loot_threshold    = 0,
    method            = "NA",
    ML_name           = "NA",
    ready             = false,
}

local function OnEventCheckML(buff, event)
    --@debug@
    RBT:Info("OnEvent", "Loot method - %s", event)
    --@end-debug@
    local classFileName
    if buff and buff.ready then
        --@debug@
        RBT:Info("OnEvent", "Loot method - %s - Buff ready", event)
        --@end-debug@
        buff:ResetBuffData()
        local method, _, raid_unit_index = GetLootMethod()
        buff.loot_threshold              = GetLootThreshold()
        buff.count                       = 0
        buff.total                       = 1
        buff.method                      = method
        buff.ML_name                     = nil
        buff.ML_class                    = nil
        if buff.method == "master" then
            buff.count          = 1
            buff.ML_name        = GetUnitName("raid" .. raid_unit_index, false)
            _, classFileName, _ = UnitClass("unit")
            buff.ML_name        = format("|c%s%s|r", RAID_CLASS_COLORS[classFileName].colorStr, buff.ML_name)
        end

        BuildMLToolTip(buff)
        buff.bar:Update()
    else
        --@debug@
        RBT:Debug("OnEvent", "No buff ?! or buff NOT ready ?!")
        --@end-debug@
    end
end

RBT:RegisterEvent("PLAYER_ENTERING_WORLD", OnEventCheckML, ml_buff)
RBT:RegisterEvent("GROUP_JOINED", OnEventCheckML, ml_buff)
RBT:RegisterEvent("GROUP_LEFT", OnEventCheckML, ml_buff)
RBT:RegisterEvent("PARTY_LOOT_METHOD_CHANGED", OnEventCheckML, ml_buff)
--RBT:RegisterEvent("GROUP_ROSTER_UPDATE", Check_on_event, ml_buff)

RBT:RegisterCheck(ml_buff)