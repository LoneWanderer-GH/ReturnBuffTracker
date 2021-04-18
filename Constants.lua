local ReturnBuffTracker                           = LibStub("AceAddon-3.0"):GetAddon("ReturnBuffTracker")
local L                                           = LibStub("AceLocale-3.0"):GetLocale("ReturnBuffTracker")
local GUILD                                       = GUILD
local INSTANCE_CHAT                               = INSTANCE_CHAT
local OFFICER                                     = OFFICER
local PARTY                                       = PARTY
local RAID                                        = RAID
local RAID_WARNING                                = RAID_WARNING
local SAY                                         = SAY

ReturnBuffTracker.Constants                       = {}

ReturnBuffTracker.Constants.BarOptionGroups       = {
    General    = L["General"],
    Player     = L["Player buffs"],
    World      = L["World"],
    Consumable = L["Consumable"],
    Misc       = L["Misc"],
}

ReturnBuffTracker.Constants.ReportChannel         = {
    --"CHANNEL",
    --"DND",
    --"EMOTE",
    ["GUILD"]         = L["Guild"],
    ["INSTANCE_CHAT"] = L["Instance"],
    ["OFFICER"]       = L["Officer"],
    ["PARTY"]         = L["Party"],
    ["RAID"]          = L["Raid"],
    ["RAID_WARNING"]  = L["Raid Warning"],
    ["SAY"]           = L["Say"],
    --"WHISPER",
    --"YELL"
}


local ERROR                               = 0
local WARNING                             = 1
local INFO                                = 2
local DEBUG                               = 3
local TRACE                               = 4

ReturnBuffTracker.Constants.LoggingConfig = {
    [ERROR]   = "ERROR",
    [WARNING] = "WARNING",
    [INFO]    = "INFO",
    [DEBUG]   = "DEBUG",
    [TRACE]   = "TRACE",
}

