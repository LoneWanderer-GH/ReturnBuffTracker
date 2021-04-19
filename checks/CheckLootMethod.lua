local RBT                                                  = LibStub("AceAddon-3.0"):GetAddon("ReturnBuffTracker")
local L                                                    = LibStub("AceLocale-3.0"):GetLocale("ReturnBuffTracker")

local format                                               = format

local GetLootMethod, GetLootThreshold, GetItemQualityColor = GetLootMethod, GetLootThreshold, GetItemQualityColor
local GetUnitName                                          = GetUnitName

local tinsert, tconcat, tremove                            = table.insert, table.concat, table.remove

local function Check(buff)
    RBT:ResetBuffData(buff)
    local method, _, raid_unit_index = GetLootMethod()
    buff.loot_threshold              = GetLootThreshold()
    buff.count                       = 0
    buff.total                       = 1
    buff.method                      = method
    buff.ML_name                     = "undefined"
    if buff.method == "master" then
        buff.count   = 1
        buff.ML_name = GetUnitName("raid" .. raid_unit_index, false)
    end
end

local function BuildToolTip(buff)
    local r, g, b, hex = GetItemQualityColor(buff.loot_threshold)
    tinsert(buff.tooltip, format("Method: %s", buff.method))
    tinsert(buff.tooltip, format("Threshold: |c%s%s|r",
                                 hex,
                                 RBT.ITEM_QUALITY_ENUM_TO_LOCALIZED_STRING[buff.loot_threshold]))
    if buff.bar then
        buff.bar.texture:SetColorTexture(r, g, b, 0.9)
    end
    if buff.method ~= "master" then
        tinsert(buff.tooltip, "NO ML !")
    else
        tinsert(buff.tooltip, format("ML: %s", buff.ML_name))
    end
end
local check_conf = {
    name             = L["Loot Method"],
    shortName        = L["Loot Method"],
    color            = { r = 1.0, g = 0.3, b = 0.3 },
    func             = Check,
    buffOptionsGroup = L["General"],
    BuildToolTipText = BuildToolTip,
}
RBT:RegisterCheck(check_conf)