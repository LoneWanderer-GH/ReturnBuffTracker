local RBT = LibStub("AceAddon-3.0"):GetAddon("ReturnBuffTracker")
local L   = LibStub("AceLocale-3.0"):GetLocale("ReturnBuffTracker")

local function Check(buff)
    buff:ResetBuffData()
    -- TODO:
end

local function BuildToolTip(buff)
    -- TODO:
end
local function SpecialBarDisplay(buff)
    -- special treatment
end
local check_conf = {
    name             = nil, -- ex: L["Text_to_localize"],
    shortName        = nil, -- ex: L["Text_to_localize_short"],
    color            = { r = 1.0, g = 0.3, b = 0.3 },
    func             = Check,
    buffOptionsGroup = nil, -- ex: L["General"],
    BuildToolTipText = BuildToolTip,
    SpecialBarDisplay   = SpecialBarDisplay
}

-- uncomment this:
-- RBT:RegisterCheck(check_conf)