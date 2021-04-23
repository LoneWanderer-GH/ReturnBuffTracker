local addonName, T                        = ...;
local RBT                                 = LibStub("AceAddon-3.0"):NewAddon("ReturnBuffTracker",
                                                                             "AceConsole-3.0",
                                                                             "AceEvent-3.0"
--@debug@
, "LoggingLib-0.1"
--@end-debug@
)
--@debug@
local LoggingLib                          = LibStub("LoggingLib-0.1")
--@end-debug@
local L                                   = LibStub("AceLocale-3.0"):GetLocale("ReturnBuffTracker")

local WARRIOR, MAGE, ROGUE, DRUID, HUNTER = "WARRIOR", "MAGE", "ROGUE", "DRUID", "HUNTER"
local SHAMAN, PRIEST, WARLOCK, PALADIN    = "SHAMAN", "PRIEST", "WARLOCK", "PALADIN"

--@debug@
local RAID_CLASS_COLORS                   = RAID_CLASS_COLORS

-- Colors
local DEFAULT                             = "DEFAULT"

--local BASIC                                    = "BASIC"
local EMPHASIS                            = "EMPHASIS"
local BROWN                               = "BROWN"
local ORANGE                              = "ORANGE"
--local BLUE                                     = "BLUE"
local VIOLET                              = "VIOLET"
--local YELLOW                                   = "YELLOW"
--local GREEN                                    = "GREEN"
local PINK                                = "PINK"
--local WHITE                                    = "WHITE"

local LIGHTBLUE                           = "LIGHTBLUE"
local LIGHTRED                            = "LIGHTRED"
local SPRINGGREEN                         = "SPRINGGREEN"
local GREENYELLOW                         = "GREENYELLOW"
local BLUE                                = "BLUE"
local PURPLE                              = "PURPLE"
local GREEN                               = "GREEN"
local RED                                 = "RED"
local GOLD                                = "GOLD"
local GOLD2                               = "GOLD2"
local GREY                                = "GREY"
local WHITE                               = "WHITE"
local SUBWHITE                            = "SUBWHITE"
local MAGENTA                             = "MAGENTA"
local YELLOW                              = "YELLOW"
local ORANGEY                             = "ORANGEY"
local CHOCOLATE                           = "CHOCOLATE"
local CYAN                                = "CYAN"
local IVORY                               = "IVORY"
local LIGHTYELLOW                         = "LIGHTYELLOW"
local SEXGREEN                            = "SEXGREEN"
local SEXTEAL                             = "SEXTEAL"
local SEXPINK                             = "SEXPINK"
local SEXBLUE                             = "SEXBLUE"
local SEXHOTPINK                          = "SEXHOTPINK"

local colors                              = {
    [DEFAULT]     = "|r",
    -- from https://www.wowinterface.com/forums/showthread.php?t=25712
    [LIGHTBLUE]   = '|cff00ccff',
    [LIGHTRED]    = '|cffff6060',
    [SPRINGGREEN] = '|cff00FF7F',
    [GREENYELLOW] = '|cffADFF2F',
    [BLUE]        = '|cff0000ff',
    [PURPLE]      = '|cffDA70D6',
    [GREEN]       = '|cff00ff00',
    [RED]         = '|cffff0000',
    [GOLD]        = '|cffffcc00',
    [GOLD2]       = '|cffFFC125',
    [GREY]        = '|cff888888',
    [WHITE]       = '|cffffffff',
    [SUBWHITE]    = '|cffbbbbbb',
    [MAGENTA]     = '|cffff00ff',
    [YELLOW]      = '|cffffff00',
    [ORANGEY]     = '|cffFF4500',
    [CHOCOLATE]   = '|cffCD661D',
    [CYAN]        = '|cff00ffff',
    [IVORY]       = '|cff8B8B83',
    [LIGHTYELLOW] = '|cffFFFFE0',
    [SEXGREEN]    = '|cff71C671',
    [SEXTEAL]     = '|cff388E8E',
    [SEXPINK]     = '|cffC67171',
    [SEXBLUE]     = '|cff00E5EE',
    [SEXHOTPINK]  = '|cffFF6EB4',

    -- from classes
    [BROWN]       = format("|c%s", RAID_CLASS_COLORS[WARRIOR].colorStr),
    [ORANGE]      = format("|c%s", RAID_CLASS_COLORS[DRUID].colorStr),
    --[BLUE]        = format("|c%s", RAID_CLASS_COLORS[MAGE].colorStr),
    [VIOLET]      = format("|c%s", RAID_CLASS_COLORS[WARLOCK].colorStr),
    --[YELLOW]      = format("|c%s", RAID_CLASS_COLORS[ROGUE].colorStr),
    --[GREEN]       = format("|c%s", RAID_CLASS_COLORS[HUNTER].colorStr),
    [PINK]        = format("|c%s", RAID_CLASS_COLORS[PALADIN].colorStr),
    -- shaman may become dark blue :)
    [WHITE]       = format("|c%s", RAID_CLASS_COLORS[PRIEST].colorStr),
    [WARRIOR]     = format("|c%s", RAID_CLASS_COLORS[WARRIOR].colorStr),
    [MAGE]        = format("|c%s", RAID_CLASS_COLORS[MAGE].colorStr),
    [ROGUE]       = format("|c%s", RAID_CLASS_COLORS[ROGUE].colorStr),
    [DRUID]       = format("|c%s", RAID_CLASS_COLORS[DRUID].colorStr),
    [HUNTER]      = format("|c%s", RAID_CLASS_COLORS[HUNTER].colorStr),
    [SHAMAN]      = format("|c%s", RAID_CLASS_COLORS[SHAMAN].colorStr),
    [PRIEST]      = format("|c%s", RAID_CLASS_COLORS[PRIEST].colorStr),
    [WARLOCK]     = format("|c%s", RAID_CLASS_COLORS[WARLOCK].colorStr),
    [PALADIN]     = format("|c%s", RAID_CLASS_COLORS[PALADIN].colorStr),
}
--@end-debug@
--@debug@
local logging_categories_colors           = {
    ["ADDON"]                   = colors[GOLD],
    ["OnInitialize"]            = colors[SEXGREEN],
    ["OnUpdate"]                = colors[SEXPINK],
    ["UpdateBars"]              = colors[YELLOW],
    ["ResetConfiguration"]      = colors[CYAN],
    ["ActivatePlayerClassOnly"] = colors[LIGHTBLUE],
    ["compute_percent_string"]  = colors[ORANGEY],
    ["CheckAlive"]              = colors[GOLD2],
    ["CheckCannotHelpRaid"]     = colors[GREY],
    ["CheckPowerType"]          = colors[MAGE],
    ["CheckBuff"]               = colors[PALADIN],
}
--@end-debug@

RBT.Constants                             = {}

RBT.Constants.BarOptionGroups             = {
    General    = L["General"],
    Player     = L["Player buffs"],
    World      = L["World"],
    Consumable = L["Consumable"],
    Misc       = L["Misc"],
}

RBT.Constants.ReportChannel               = {
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

local defaults                            = {
    profile = {
        position               = nil,
        width                  = 180,
        hideFrameWhenNotInRaid = true,
        deactivatedBars        = {  },
        reportChannel          = RBT.Constants.ReportChannel["RAID_WARNING"],
        --@debug@
        logLevel               = LoggingLib.TRACE,
        logging                = true,
        mem_profiling          = false,
        --@end-debug@
    }
}
defaults.char                             = defaults.profile

function RBT:RaidOrGroupChanged()
    if IsInRaid() then
        RBT.mainFrame:Show()
    else
        if RBT.db.char.hideFrameWhenNotInRaid then
            RBT.mainFrame:Hide()
        else
            RBT.mainFrame:Show()
        end
    end
    RBT:UnregisterEvent("PLAYER_ENTERING_WORLD")
end

for _, raid_event_name in ipairs({ "GROUP_JOINED",
                                   "GROUP_FORMED",
                                   "GROUP_LEFT",
                                     --"PARTY_CONVERTED_TO_RAID",
                                   "GROUP_ROSTER_UPDATE",
                                   "RAID_ROSTER_UPDATE" }) do
    RBT:RegisterEvent(raid_event_name, "RaidOrGroupChanged")
end

RBT:RegisterEvent("PLAYER_ENTERING_WORLD", "RaidOrGroupChanged")

function RBT:OnInitialize()
    --@debug@
    RBT:InitializeLogging(addonName,
                          nil,
                          logging_categories_colors,
                          LoggingLib.TRACE)
    RBT:Debug("OnInitialize", "OnInitialize")
    --@end-debug@
    self.OptionBarNames             = {}
    self.OptionBarClassesToBarNames = {}
    local buff_name, rank
    local itemName--itemName --, link, quality, iLevel, reqLevel, class, subclass, maxStack, equipSlot, texture, vendorPrice
    self.buff_id_to_buff_count_data = {}
    for k, buff in pairs(self.Buffs) do

        --@debug@
        RBT:Debugf("OnInitialize", "Treating buff at index: %d", k)
        --@end-debug@
        if buff then
            --@debug@
            RBT:Debugf("OnInitialize", "Preparing OptionbarNames - Initial data [" .. (buff.name or "no .name") .. "]")
            RBT:Debugf("OnInitialize", "Preparing OptionbarNames - Initial data [" .. (buff.buffOptionsGroup or "no .buffOptionsGroup") .. "]")
            RBT:Debugf("OnInitialize", "Preparing OptionbarNames - Initial data [" .. (buff.optionText or "no .optionText") .. "]")
            RBT:Debugf("OnInitialize", "Preparing OptionbarNames - Initial data [" .. (buff.text or "no .text") .. "]")
            --@end-debug@
            if buff.buffOptionsGroup then
                if not self.OptionBarNames[buff.buffOptionsGroup] then
                    self.OptionBarNames[buff.buffOptionsGroup] = {}
                end
                -- try to put exact buff name if ID availabe and its a unique buff
                if not buff.shortName and not buff.buffOptionsGroup == L["Consumable"] then
                    --@debug@
                    RBT:Debugf("OnInitialize", "Buff has no shortName")
                    --@end-debug@
                    if buff.sourceItemId ~= nil then
                        --if #buff.sourceItemId == 1 then
                        --@debug@
                        RBT:Debugf("OnInitialize", "Using source item ID")
                        --@end-debug@
                        itemName, _, _, _, _, _, _, _, _, _, _ = GetItemInfo(buff.sourceItemId[1])
                        buff.optionText                        = itemName
                        buff.name                              = itemName
                        --end
                    elseif buff.buffIDs ~= nil then
                        --@debug@
                        RBT:Debugf("OnInitialize", "Using buff ID")
                        --@end-debug@
                        buff_name, rank, _, _, _, _, _ = GetSpellInfo(buff.buffIDs[1])
                        if rank then
                            buff.optionText = format("%s (%s)", buff_name, rank)
                        else
                            buff.optionText = format("%s", buff_name)
                        end
                        buff.name = buff_name
                        --if #buff.buffIDs == 1 then
                        --    local buff_name, rank, _, _, _, _, _ = GetSpellInfo(buff.buffIDs[1])
                        --    if rank then
                        --        buff.optionText = format("%s (%s)", buff_name, rank)
                        --    else
                        --        buff.optionText = format("%s", buff_name)
                        --    end
                        --    buff.name = buff_name
                        --else
                        --    RBT:Debugf("OnInitialize", "index=%d several buffs IDs (%d)", k, #buff.buffIDs)
                        --end
                        --for _, id in ipairs(buff.buffIDs) do
                        --    self.buff_id_to_buff_count_data[id] = { count = 0, total = 0, buff_definition = buff }
                        --end
                    else
                        --@debug@
                        RBT:Warningf("OnInitialize", "index=%d no sourceItemId, no buffIDs", k)
                        --@end-debug@
                    end
                end
            end
            --@debug@
            RBT:Debugf("OnInitialize", "Consolidated data:")
            if self == nil then
                RBT:Tracef("OnInitialize", " ||-- WTF ???????????????")
            end
            if self.OptionBarNames == nil then
                RBT:Tracef("OnInitialize", " ||-- WTF ???????????????")
            end
            if self.OptionBarNames[buff.buffOptionsGroup] == nil then
                RBT:Tracef("OnInitialize", " ||-- WTF ?? index=%d", k)
            end
            if buff.optionText == nil then
                RBT:Tracef("OnInitialize", " ||-- index=%d optionText is nil", k)
            end
            if buff.text == nil then
                RBT:Tracef("OnInitialize", " ||-- index=%d text is nil", k)
            end
            if buff.name == nil then
                RBT:Tracef("OnInitialize", " ||-- index=%d name is nil", k)
            end
            --@end-debug@

            --self.OptionBarNames[buff.buffOptionsGroup]
            --[buff.optionText
            --        or buff.text
            --        or buff.name
            --] = buff.optionText
            --        or buff.text
            --        or buff.name;

            local key = ""
            if buff.shortName then
                key = buff.shortName
            elseif buff.optionText then
                key = buff.optionText
            elseif buff.text then
                key = buff.text
            elseif buff.name then
                key = buff.name
            else
                --@debug@
                key = "TA CHATTE"
                RBT:Errorf("OnInitialize", "index=%d no option text, no text no name (%s)", k, buff.shortName)
                --@end-debug@
            end
            --@debug@
            RBT:Tracef("OnInitialize", "index=%d effective option bar name is [%s]", k, key)
            --@end-debug@
            local tmp = self.OptionBarNames[buff.buffOptionsGroup]
            if tmp then
                if key then
                    tmp[key]         = key
                    buff.displayText = key
                    if buff.classes then
                        for _, c in ipairs(buff.classes) do
                            if not self.OptionBarClassesToBarNames[c] then
                                self.OptionBarClassesToBarNames[c] = {}
                            end
                            tinsert(self.OptionBarClassesToBarNames[c], key)
                        end
                    end
                    --@debug@
                else
                    RBT:Errorf("OnInitialize", "index=%d null key ?!", k)
                    --@end-debug@
                end
                --@debug@
            else
                RBT:Errorf("OnInitialize", "index=%d WTF ?!!", k)
                --@end-debug@
            end
        end
    end

    self.db = LibStub("AceDB-3.0"):New("ReturnBuffTrackerDB", defaults, true)

    RBT:SetupOptions()
    RBT:CreateMainFrame()

    local buffbars = {}
    for _, group in pairs(self.Constants.BarOptionGroups) do
        buffbars[group] = {}
    end
    RBT:SetNumberOfBarsToDisplay(#self.Buffs)
    for index, buff in ipairs(self.Buffs) do
        tinsert(buffbars[buff.buffOptionsGroup], buff)
        --buff.bar = RBT:CreateInfoBar(buff.text or buff.shortName, buff.color.r, buff.color.g, buff.color.b)
        buff.bar = RBT:CreateBuffInfoBar(index, buff)
    end

    self.nextTime          = 0
    RBT.current_buff_index = 1
    RBT.mainFrame:SetScript("OnUpdate", self.OnUpdate)
    RBT:UpdateBars()
    --RBT:CheckVisible()
end

function RBT:UpdateBars()
    --@debug@
    RBT:Debugf("UpdateBars", "UpdateBars")
    --@end-debug@
    local nb_of_bars_to_display = 0
    for _, buff in ipairs(RBT.Buffs) do
        --if RBT.db.char.deactivatedBars[buff.optionText or buff.text or buff.name] then
        if RBT.db.char.deactivatedBars[buff.displayText] then
            --@debug@
            RBT:Debugf("UpdateBars", "UpdateBars - %s deactivated", buff.optionText or buff.text or buff.name)
            --@end-debug@
            buff.bar:SetIndex(nil)
        else
            --@debug@
            RBT:Debugf("UpdateBars", "UpdateBars - %s activated", buff.optionText or buff.text or buff.name)
            --@end-debug@
            buff.bar:SetIndex(nb_of_bars_to_display)
            nb_of_bars_to_display = nb_of_bars_to_display + 1
        end
    end
    RBT:SetNumberOfBarsToDisplay(nb_of_bars_to_display)
end

--function RBT:AggregateAllRaidUnitBuffs()
--    local buff_name, caster, spellId
--    RBT.raid_player_cache = {}
--    local player_name, player_group, player_localized_class, player_class
--    local buff_id_data
--    --
--    for raid_index = 1, 40 do
--        player_name, _, player_group, _, player_localized_class, player_class = GetRaidRosterInfo(raid_index)
--        if player_name then
--            local player_counted = false
--            --table.insert(RBT.raid_player_cache, {})
--
--            --
--            for buff_index = 1, BUFF_MAX_DISPLAY do
--                buff_name, _, _, _, _, _, caster, _, _, spellId = UnitBuff(player_name, buff_index)
--
--                buff_id_data                                    = self.buff_id_to_buff_count_data[spellId]
--                if buff_id_data then
--
--                    --
--                    if buff_id_data.buff_definition then
--                        if buff_id_data.buff_definition.classes then
--                            -- class specific buff
--                            for _, c in ipairs(buff_id_data.buff_definition.classes) do
--                                if c == player_class then -- match
--                                    -- count player in total once
--                                    if not player_counted then
--                                        buff_id_data.total = buff_id_data.total + 1
--                                        player_counted     = true
--                                    end
--                                    -- count buff occurrence
--                                    buff_id_data.count = buff_id_data.count + 1
--                                end -- other iterations won't do anything
--                            end
--                        else
--                            -- general buff
--                            -- count player in total once
--                            if not player_counted then
--                                buff_id_data.total = buff_id_data.total + 1
--                                player_counted     = true
--                            end
--                            -- count player buff occurrence
--                            buff_id_data.count = buff_id_data.count + 1
--                        end
--                    end -- buff is to be analyzed (robustness)
--                end -- end buff is to be analyzed
--            end -- end loop payer auras
--        end
--
--    end
--end

function RBT:OnUpdate(self)
    local currentTime = GetTime()
    if RBT.nextTime and currentTime < RBT.nextTime then
        return
    end
    RBT.nextTime = currentTime + 0.180
    --RBT.nextTime = currentTime + 1 -- 1 sec refresh rate

    --if not RBT:CheckVisible() then
    --    return
    --end
    if RBT.mainFrame:IsVisible() then
        --@debug@
        local mem_before_g, mem_after_g, mem_before, mem_after, diff
        if RBT.db.char.mem_profiling then
            mem_before_g = GetAddOnMemoryUsage(addonName)
        end
        --@end-debug@

        --for _, buff in ipairs(RBT.Buffs) do
        --    buff.count = 0
        --    buff.total = 0
        --end
        --@debug@
        RBT:Debugf("OnUpdate", "Buff index [ %d ]", RBT.current_buff_index)
        --@end-debug@
        local buff             = RBT.Buffs[RBT.current_buff_index]
        RBT.current_buff_index = ((RBT.current_buff_index + 1) % #RBT.Buffs) + 1
        --for _, buff in ipairs(RBT.Buffs) do
        if RBT.db.char.deactivatedBars[buff.displayText] then
            --@debug@
            RBT:Debugf("OnUpdate", "Ignoring deactivated buff %s", buff.displayText)
            --@end-debug@
            return
        end
        --@debug@
        if RBT.db.char.mem_profiling then
            mem_before = GetAddOnMemoryUsage(addonName)
        end
        --@end-debug@

        buff:func()
        buff:BuildToolTipText()

        --@debug@
        if RBT.db.char.mem_profiling then
            UpdateAddOnMemoryUsage()
            mem_after = GetAddOnMemoryUsage(addonName)
            diff      = (mem_after - mem_before)
        end
        --@end-debug@

        --@debug@
        if RBT.db.char.mem_profiling and diff > 2.0 then
            RBT:Infof("OnUpdate", "Memory increase for %s : %.1f -> %.1f (%.1f)",
                      buff.displayText,
                      mem_before,
                      mem_after,
                      diff)
        end
        --@end-debug@

        buff.bar:Update()
        --end -- end for loop
        -- --@debug@
        -- if RBT.db.char.mem_profiling then
        --     UpdateAddOnMemoryUsage()
        --     mem_after_g = GetAddOnMemoryUsage(addonName)
        --     RBT:Infof("OnUpdate", "Memory increase ----> : %.1f -> %.1f (%.1f)",
        --               mem_before_g,
        --               mem_after_g,
        --               (mem_after_g - mem_before_g))
        --
        -- end
        -- --@end-debug@
    end -- end frame visible
end

function RBT:Contains(tab, val)
    if not tab then
        return true
    end
    for _, value in pairs(tab) do
        if value == val then
            return true
        end
    end

    return false
end

--function RBT:CheckVisible()
--    --if not RBT.db.char.hideFrameWhenNotInRaid or IsInRaid() then
--    if IsInRaid() then
--        --if not RBT.mainFrame:IsVisible() then
--        RBT.mainFrame:Show()
--        --end
--        return true
--    end
--    if RBT.db.char.hideFrameWhenNotInRaid then
--        --if RBT.mainFrame:IsVisible() then
--        RBT.mainFrame:Hide()
--        --end
--        return false
--    else
--        RBT.mainFrame:Show()
--        --end
--        return true
--    end
--end

function RBT:ResetConfiguration()
    --@debug@
    RBT:Debug("ResetConfiguration", "ResetConfiguration")
    --@end-debug@
    for bar_name, _ in pairs(RBT.db.char.deactivatedBars) do
        --@debug@
        RBT:Debugf("ResetConfiguration", "Deactivating %s", bar_name)
        --@end-debug@
        RBT.db.char.deactivatedBars[bar_name] = true
    end
    RBT.db.char = defaults.profile
    RBT:UpdateBars()
end

function RBT:ActivatePlayerClassOnly()
    --@debug@
    RBT:Debugf("ActivatePlayerClassOnly", "ActivatePlayerClassOnly")
    --@end-debug@
    local _, player_class, _ = UnitClass("player")

    RBT:Debugf("ActivatePlayerClassOnly", "ActivatePlayerClassOnly - deactivating all")

    for _, buff in ipairs(RBT.Buffs) do
        RBT.db.char.deactivatedBars[buff.displayText] = (
                (buff.buffingClass and buff.buffingClass ~= player_class) or true)
    end
    --@debug@
    RBT:Debugf("ActivatePlayerClassOnly", "ActivatePlayerClassOnly - my class: %s", player_class)
    --@end-debug@
    for class, bar_names in pairs(RBT.OptionBarClassesToBarNames) do
        if player_class == class then
            --@debug@
            RBT:Debugf("ActivatePlayerClassOnly", "ActivatePlayerClassOnly - Matching class")
            --@end-debug@
            for _, bar_name_to_activate in ipairs(bar_names) do
                --@debug@
                RBT:Debugf("ActivatePlayerClassOnly", "ActivatePlayerClassOnly - Activating bar %s", bar_name_to_activate)
                --@end-debug@
                RBT.db.char.deactivatedBars[bar_name_to_activate] = false
            end
        end
    end
    RBT:UpdateBars()
end

--- Taken from NWB
--- DMF spawns the following monday after first friday of the month at daily reset time.
--- Whole region shares time of day for spawn (I think).
--- Realms within the region possibly don't all spawn at same moment though, realms may wait for their own monday.
--- (Bug: US player reported it showing 1 day late DMF end time while on OCE realm, think this whole thing needs rewriting tbh).
function RBT:getDmfStartEnd(month, nextYear)
    local startOffset, endOffset, validRegion, isDst;
    local minOffset, hourOffset, dayOffset = 0, 0, 0;
    local region                           = GetCurrentRegion();
    local realm                            = GetRealmName()

    --I may change this to realm names later instead, region may be unreliable with US client on EU region if that issue still exists.
    if (realm == "Arugal" or realm == "Felstriker" or realm == "Remulos" or realm == "Yojamba") then
        --OCE Sunday 12pm UTC reset time (4am server time).
        dayOffset   = 2; --2 days after friday (sunday).
        hourOffset  = 18; -- 6pm.
        validRegion = true;
    elseif (realm == "Arcanite Reaper" or realm == "Old Blanchy" or realm == "Anathema" or realm == "Azuresong"
            or realm == "Kurinnaxx" or realm == "Myzrael" or realm == "Rattlegore" or realm == "Smolderweb"
            or realm == "Thunderfury" or realm == "Atiesh" or realm == "Bigglesworth" or realm == "Blaumeux"
            or realm == "Fairbanks" or realm == "Grobbulus" or realm == "Whitemane") then
        --US west Sunday 11am UTC reset time (4am server time).
        dayOffset   = 3; --3 days after friday (monday).
        hourOffset  = 11; -- 11am.
        validRegion = true;
    elseif (region == 1) then
        --US east + Latin Monday 8am UTC reset time (4am server time).
        dayOffset   = 3; --3 days after friday (monday).
        hourOffset  = 8; -- 8am.
        validRegion = true;
    elseif (region == 2) then
        --Korea 1am UTC monday (9am monday local) reset time.
        --(TW seems to be region 2 for some reason also? Hopefully they have same DMF spawn).
        --I can change it to server name based if someone from KR says this spawn time is wrong.
        dayOffset   = 3;
        hourOffset  = 1;
        validRegion = true;
    elseif (region == 3) then
        --EU Monday 4am UTC reset time.
        dayOffset   = 3; --3 days after friday (monday).
        hourOffset  = 2; -- 4am.
        validRegion = true;
    elseif (region == 4) then
        --Taiwan 1am UTC monday (9am monday local) reset time.
        dayOffset   = 3;
        hourOffset  = 1;
        validRegion = true;
    elseif (region == 5) then
        --China 8pm UTC sunday (4am monday local) reset time.
        dayOffset   = 2;
        hourOffset  = 20;
        validRegion = true;
    end
    --Create current UTC date table.
    local data          = date("!*t", GetServerTime());
    local dataLocalTime = date("*t", GetServerTime());
    --Spawns change with DST by 1 hour UTC to stay the same server time.
    if (dataLocalTime.isdst) then
        hourOffset = hourOffset - 1;
    end
    --If month is specified then use that month instead (next dmf spawn is next month);
    if (month) then
        data.month = month;
    end
    --If nextYear is true then next dmf spawn is next year (we're in december right now).
    if (nextYear) then
        data.year = data.year + 1;
    end
    local dmfStartDay;
    for i = 1, 7 do
        --Iterate the first 7 days in the month to find first friday.
        local time = date("!*t", time({ year = data.year, month = data.month, day = i }));
        if (time.wday == 6) then
            --If day of the week (wday) is 6 (friday) then set this as first friday of the month.
            dmfStartDay = i;
        end
    end
    local timeTable   = { year = data.year, month = data.month, day = dmfStartDay + dayOffset, hour = hourOffset, min = minOffset, sec = 0 };
    local utcdate     = date("!*t", GetServerTime());
    local localdate   = date("*t", GetServerTime());
    localdate.isdst   = false;
    local secondsDiff = difftime(time(utcdate), time(localdate));
    local dmfStart    = time(timeTable) - secondsDiff;
    if (date("%w", dmfStart) == "0") then
        --Not sure if whole region spawns at the same moment or if each realm waits for their own monday.
        --All realms spawn same time of day, but possibly not same UTC day depending on timezone.
        --Just incase each realm waits for monday we can add a day here.
        dmfStart = dmfStart + 86400;
    end
    --Add 7 days to get end timestamp.
    local dmfEnd = dmfStart + 604800;
    --Only return if we have set daily reset offsets for this region.
    if (validRegion) then
        return dmfStart, dmfEnd;
    end
end

--- Taken from NWB
function RBT:isDMFActive()
    local dmfStart, dmfEnd = RBT:getDmfStartEnd();
    local isActive         = false
    local cur_time         = GetServerTime()
    if (dmfStart and dmfEnd) then
        isActive = cur_time >= dmfStart and cur_time <= dmfEnd
    end
    return isActive
end
