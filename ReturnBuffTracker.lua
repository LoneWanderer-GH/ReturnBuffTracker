local addonName, T                        = ...;
local ReturnBuffTracker                   = LibStub("AceAddon-3.0"):NewAddon("ReturnBuffTracker",
                                                                             "AceConsole-3.0",
                                                                             "AceEvent-3.0",
                                                                             "LoggingLib-0.1"
)
local LoggingLib                          = LibStub("LoggingLib-0.1")
local L                                   = LibStub("AceLocale-3.0"):GetLocale("ReturnBuffTracker")

local WARRIOR, MAGE, ROGUE, DRUID, HUNTER = "WARRIOR", "MAGE", "ROGUE", "DRUID", "HUNTER"
local SHAMAN, PRIEST, WARLOCK, PALADIN    = "SHAMAN", "PRIEST", "WARLOCK", "PALADIN"
local RAID_CLASS_COLORS                   = RAID_CLASS_COLORS

-- log levels
local ERROR                               = 0
local WARNING                             = 1
local INFO                                = 2
local DEBUG                               = 3
local TRACE                               = 4
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

local logging_categories_colors           = {
    ["ADDON"]        = colors[GOLD],
    ["OnInitialize"] = colors[SEXGREEN],
    ["OnUpdate"]     = colors[SEXPINK],
}

local defaults                            = {
    profile = {
        position        = nil,
        width           = 180,
        hideNotInRaid   = true,
        deactivatedBars = {  },
        reportChannel   = ReturnBuffTracker.Constants.ReportChannel["RAID_WARNING"],
    }
}

function ReturnBuffTracker:OnInitialize()
    ReturnBuffTracker:InitializeLogging(addonName,
                                        nil,
                                        logging_categories_colors,
                                        LoggingLib.TRACE)
    ReturnBuffTracker:Debug("ADDON", "OnInitialize")
    self.OptionBarNames             = {}
    self.OptionBarClassesToBarNames = {}
    local buff_name, rank
    local itemName--itemName --, link, quality, iLevel, reqLevel, class, subclass, maxStack, equipSlot, texture, vendorPrice
    for k, buff in pairs(self.Buffs) do
        ReturnBuffTracker:Debugf("OnInitialize", "Treating buff at index: %d", k)
        if buff then
            ReturnBuffTracker:Debugf("OnInitialize", "Preparing OptionbarNames - Initial data [" .. (buff.name or "no .name") .. "]")
            ReturnBuffTracker:Debugf("OnInitialize", "Preparing OptionbarNames - Initial data [" .. (buff.buffOptionsGroup or "no .buffOptionsGroup") .. "]")
            ReturnBuffTracker:Debugf("OnInitialize", "Preparing OptionbarNames - Initial data [" .. (buff.optionText or "no .optionText") .. "]")
            ReturnBuffTracker:Debugf("OnInitialize", "Preparing OptionbarNames - Initial data [" .. (buff.text or "no .text") .. "]")
            if buff.buffOptionsGroup then
                if not self.OptionBarNames[buff.buffOptionsGroup] then
                    self.OptionBarNames[buff.buffOptionsGroup] = {}
                end
                -- try to put exact buff name if ID availabe and its a unique buff
                if not buff.shortName and not buff.buffOptionsGroup == L["Consumable"] then
                    ReturnBuffTracker:Debugf("OnInitialize", "Buff has no shortName")
                    if buff.sourceItemId ~= nil then
                        --if #buff.sourceItemId == 1 then
                        ReturnBuffTracker:Debugf("OnInitialize", "Using source item ID")
                        itemName, _, _, _, _, _, _, _, _, _, _ = GetItemInfo(buff.sourceItemId[1])
                        buff.optionText                        = itemName
                        buff.name                              = itemName
                        --end
                    elseif buff.buffIDs ~= nil then
                        ReturnBuffTracker:Debugf("OnInitialize", "Using buff ID")
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
                        --    ReturnBuffTracker:Debugf("OnInitialize", "index=%d several buffs IDs (%d)", k, #buff.buffIDs)
                        --end
                    else
                        ReturnBuffTracker:Warningf("OnInitialize", "index=%d no sourceItemId, no buffIDs", k)
                    end
                end
            end

            ReturnBuffTracker:Debugf("OnInitialize", "Consolidated data:")
            if self == nil then
                ReturnBuffTracker:Tracef("OnInitialize", " ||-- WTF ???????????????")
            end
            if self.OptionBarNames == nil then
                ReturnBuffTracker:Tracef("OnInitialize", " ||-- WTF ???????????????")
            end
            if self.OptionBarNames[buff.buffOptionsGroup] == nil then
                ReturnBuffTracker:Tracef("OnInitialize", " ||-- WTF ?? index=%d", k)
            end
            if buff.optionText == nil then
                ReturnBuffTracker:Tracef("OnInitialize", " ||-- index=%d optionText is nil", k)
            end
            if buff.text == nil then
                ReturnBuffTracker:Tracef("OnInitialize", " ||-- index=%d text is nil", k)
            end
            if buff.name == nil then
                ReturnBuffTracker:Tracef("OnInitialize", " ||-- index=%d name is nil", k)
            end
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
                key = "TA CHATTE"
                ReturnBuffTracker:Errorf("OnInitialize", "index=%d no option text, no text no name (%s)", k, buff.shortName)
            end
            ReturnBuffTracker:Tracef("OnInitialize", "index=%d effective option bar name is [%s]", k, key)
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
                else
                    ReturnBuffTracker:Errorf("OnInitialize", "index=%d null key ?!", k)
                end
            else
                ReturnBuffTracker:Errorf("OnInitialize", "index=%d WTF ?!!", k)
            end
        else

            --end
            --else
            --ReturnBuffTracker:Print("no buff at index: " .. k)
        end
    end

    self.db = LibStub("AceDB-3.0"):New("ReturnBuffTrackerDB", defaults, true)

    ReturnBuffTracker:SetupOptions()
    ReturnBuffTracker:CreateMainFrame()

    local buffbars = {}
    for _, group in pairs(self.Constants.BarOptionGroups) do
        buffbars[group] = {}
    end
    ReturnBuffTracker:SetNumberOfBarsToDisplay(#self.Buffs)
    for index, buff in ipairs(self.Buffs) do
        tinsert(buffbars[buff.buffOptionsGroup], buff)
        --buff.bar = ReturnBuffTracker:CreateInfoBar(buff.text or buff.shortName, buff.color.r, buff.color.g, buff.color.b)
        buff.bar = ReturnBuffTracker:CreateBuffInfoBar(index, buff)
    end


    --self.nextBuff = 1
    self.nextTime = 0
    --self.updateFrame = CreateFrame("Frame")
    --self.updateFrame:SetScript("OnUpdate", self.OnUpdate)
    ReturnBuffTracker.mainFrame:SetScript("OnUpdate", self.OnUpdate)

    ReturnBuffTracker:UpdateBars()
end

function ReturnBuffTracker:UpdateBars()
    --ReturnBuffTracker:Debugf("ADDON", "UpdateBars")
    local nb_of_bars_to_display = 0
    for _, buff in ipairs(ReturnBuffTracker.Buffs) do
        --if ReturnBuffTracker.db.profile.deactivatedBars[buff.optionText or buff.text or buff.name] then
        if ReturnBuffTracker.db.profile.deactivatedBars[buff.displayText] then
            --ReturnBuffTracker:Debugf("ADDON", "UpdateBars - %s deactivated", buff.optionText or buff.text or buff.name)
            buff.bar:SetIndex(nil)
        else
            --ReturnBuffTracker:Debugf("ADDON", "UpdateBars - %s activated", buff.optionText or buff.text or buff.name)
            buff.bar:SetIndex(nb_of_bars_to_display)
            nb_of_bars_to_display = nb_of_bars_to_display + 1
        end
    end
    ReturnBuffTracker:SetNumberOfBarsToDisplay(nb_of_bars_to_display)
    --self.nextBuff = 1
    --self.nextTime = 0
    --ReturnBuffTracker.mainFrame:SetScript("OnUpdate", self.OnUpdate)
    --ReturnBuffTracker:OnUpdate()
end

function ReturnBuffTracker:OnUpdate(self)
    local currentTime = GetTime()
    if ReturnBuffTracker.nextTime and currentTime < ReturnBuffTracker.nextTime then
        return
    end
    --ReturnBuffTracker.nextTime = currentTime + 0.500
    ReturnBuffTracker.nextTime = currentTime + 1 -- 1 sec refresh rate

    if not ReturnBuffTracker:CheckHideIfNotInRaid() then
        return
    end

    --local buff = ReturnBuffTracker.Buffs[ReturnBuffTracker.nextBuff]
    --if buff == nil then
    --    ReturnBuffTracker:Warningf("OnUpdate", format("No buff at index %d" .. ReturnBuffTracker.nextBuff))
    --    return
    --end
    --
    --ReturnBuffTracker.nextBuff = ReturnBuffTracker.nextBuff + 1
    --if ReturnBuffTracker.nextBuff > table.getn(ReturnBuffTracker.Buffs) then
    --    ReturnBuffTracker.nextBuff = 1
    --end
    for _, buff in ipairs(ReturnBuffTracker.Buffs) do

        --if ReturnBuffTracker.db.profile.deactivatedBars[buff.optionText or buff.text or buff.name] then
        if ReturnBuffTracker.db.profile.deactivatedBars[buff.displayText] then
            return
        end

        local value    = 0
        local maxValue = 1
        local tooltip --  = nil
        if buff.func then
            value, maxValue, tooltip = ReturnBuffTracker[buff.func](ReturnBuffTracker, buff)
        else
            value, maxValue, tooltip = ReturnBuffTracker:CheckBuff(buff)
        end
        if value and maxValue and maxValue > 0 then
            buff.bar:Update(value, maxValue, tooltip)
        else
            buff.bar:Update(0, 1, tooltip)
        end
    end
end

function ReturnBuffTracker:Contains(tab, val)
    if not tab then
        return true
    end
    --ReturnBuffTracker:Print(format("Checking %s in tab", val))
    for _, value in pairs(tab) do
        if value == val then
            return true
        end
    end

    return false
end

function ReturnBuffTracker:CheckHideIfNotInRaid()
    if not ReturnBuffTracker.db.profile.hideNotInRaid or IsInRaid() then
        if not ReturnBuffTracker.mainFrame:IsVisible() then
            ReturnBuffTracker.mainFrame:Show()
        end
        return true
    else
        if ReturnBuffTracker.mainFrame:IsVisible() then
            ReturnBuffTracker.mainFrame:Hide()
        end
        return false
    end
end

function ReturnBuffTracker:resetConfig()
    for bar_name, _ in pairs(ReturnBuffTracker.db.profile.deactivatedBars) do
        ReturnBuffTracker:Debugf("ADDON", "Deactivating %s", bar_name)
        ReturnBuffTracker.db.profile.deactivatedBars[bar_name] = true
    end
    --LibStub("AceConfigRegistry-3.0"):NotifyChange("ReturnBuffTracker")
    ReturnBuffTracker.db.profile = defaults.profile
    --LibStub("AceConfigRegistry-3.0"):NotifyChange("ReturnBuffTracker")
    ReturnBuffTracker:UpdateBars()
end

function ReturnBuffTracker:ActivatePlayerClassOnly()
    ReturnBuffTracker:Debugf("ADDON", "ActivatePlayerClassOnly")

    local _, player_class, _ = UnitClass("player")

    ReturnBuffTracker:Debugf("ADDON", "ActivatePlayerClassOnly - deactivating all")

    for _, buff in ipairs(ReturnBuffTracker.Buffs) do
        ReturnBuffTracker.db.profile.deactivatedBars[buff.displayText] = (
                (buff.buffingClass and buff.buffingClass ~= player_class) or true)
    end

    ReturnBuffTracker:Debugf("ADDON", "ActivatePlayerClassOnly - my class: %s", player_class)

    for class, bar_names in pairs(ReturnBuffTracker.OptionBarClassesToBarNames) do
        if player_class == class then
            ReturnBuffTracker:Debugf("ADDON", "ActivatePlayerClassOnly - Matching class")
            for _, bar_name_to_activate in ipairs(bar_names) do
                ReturnBuffTracker:Debugf("ADDON", "ActivatePlayerClassOnly - Activating bar %s", bar_name_to_activate)
                ReturnBuffTracker.db.profile.deactivatedBars[bar_name_to_activate] = false
            end
        end
    end
    ReturnBuffTracker:UpdateBars()
end






















-- Taken from NWB

--DMF spawns the following monday after first friday of the month at daily reset time.
--Whole region shares time of day for spawn (I think).
--Realms within the region possibly don't all spawn at same moment though, realms may wait for their own monday.
--(Bug: US player reported it showing 1 day late DMF end time while on OCE realm, think this whole thing needs rewriting tbh).
function ReturnBuffTracker:getDmfStartEnd(month, nextYear)
    local startOffset, endOffset, validRegion, isDst;
    local minOffset, hourOffset, dayOffset = 0, 0, 0;
    local region                           = GetCurrentRegion();
    --I may change this to realm names later instead, region may be unreliable with US client on EU region if that issue still exists.
    if (NWB.realm == "Arugal" or NWB.realm == "Felstriker" or NWB.realm == "Remulos" or NWB.realm == "Yojamba") then
        --OCE Sunday 12pm UTC reset time (4am server time).
        dayOffset   = 2; --2 days after friday (sunday).
        hourOffset  = 18; -- 6pm.
        validRegion = true;
    elseif (NWB.realm == "Arcanite Reaper" or NWB.realm == "Old Blanchy" or NWB.realm == "Anathema" or NWB.realm == "Azuresong"
            or NWB.realm == "Kurinnaxx" or NWB.realm == "Myzrael" or NWB.realm == "Rattlegore" or NWB.realm == "Smolderweb"
            or NWB.realm == "Thunderfury" or NWB.realm == "Atiesh" or NWB.realm == "Bigglesworth" or NWB.realm == "Blaumeux"
            or NWB.realm == "Fairbanks" or NWB.realm == "Grobbulus" or NWB.realm == "Whitemane") then
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

function ReturnBuffTracker:isDMFActive()
    local dmfStart, dmfEnd = ReturnBuffTracker:getDmfStartEnd();
    --local timestamp, timeLeft, type;
    local isActive         = false
    --local zone
    --local locale = GetLocale();
    --OCE region only just for now.
    local cur_time         = GetServerTime()
    if (dmfStart and dmfEnd) then

        return cur_time >= dmfStart and cur_time <= dmfEnd
        --if (GetServerTime() < dmfStart) then
        --	--It's before the start of dmf.
        --	timestamp = dmfStart;
        --	type = "start";
        --	timeLeft = dmfStart - GetServerTime();
        --	--NWB.isDmfUp = nil;
        --    isActive = false
        --elseif (GetServerTime() < dmfEnd) then
        --	--It's after dmf started and before the end.
        --	timestamp = dmfEnd;
        --	type = "end";
        --	timeLeft = dmfEnd - GetServerTime();
        --	isActive = true
        --elseif (GetServerTime() > dmfEnd) then
        --	--It's after dmf ended so calc next months dmf instead.
        --	--local data = date("!*t", GetServerTime());
        --	--if (data.month == 12) then
        --	--	dmfStart, dmfEnd = NWB:getDmfStartEnd(1, true);
        --	--else
        --	--	dmfStart, dmfEnd = NWB:getDmfStartEnd(data.month + 1);
        --	--end
        --	--timestamp = dmfStart;
        --	--type = "start";
        --	--timeLeft = dmfStart - GetServerTime();
        --	isActive = false
        --end
        ----if (date("%m", dmfStart) % 2 == 0) then
        ----    zone = "Mulgore";
        ----else
        ----    zone = "Elwynn Forest";
        ----end
        ----NWB.dmfZone = zone;
        ---- --Timestamp of next start or end event, seconds left untill that event, and type of event.
        --return isActive -- timestamp, timeLeft, type;
    end
end
