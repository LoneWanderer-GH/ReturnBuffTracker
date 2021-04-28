local RBT = LibStub("AceAddon-3.0"):GetAddon("ReturnBuffTracker")
local L   = LibStub("AceLocale-3.0"):GetLocale("ReturnBuffTracker")

--- Taken from NWB
--- DMF spawns the following monday after first friday of the month at daily reset time.
--- Whole region shares time of day for spawn (I think).
--- Realms within the region possibly don't all spawn at same moment though, realms may wait for their own monday.
--- (Bug: US player reported it showing 1 day late DMF end time while on OCE realm, think this whole thing needs rewriting tbh).
function RBT:getDmfStartEnd(month, nextYear)
    local validRegion
    local minOffset, hourOffset, dayOffset = 0, 0, 0
    local region                           = GetCurrentRegion()
    local realm                            = GetRealmName()

    --I may change this to realm names later instead, region may be unreliable with US client on EU region if that issue still exists.
    if (realm == "Arugal" or realm == "Felstriker" or realm == "Remulos" or realm == "Yojamba") then
        --OCE Sunday 12pm UTC reset time (4am server time).
        dayOffset   = 2 --2 days after friday (sunday).
        hourOffset  = 18 -- 6pm.
        validRegion = true
    elseif (realm == "Arcanite Reaper" or realm == "Old Blanchy" or realm == "Anathema" or realm == "Azuresong"
            or realm == "Kurinnaxx" or realm == "Myzrael" or realm == "Rattlegore" or realm == "Smolderweb"
            or realm == "Thunderfury" or realm == "Atiesh" or realm == "Bigglesworth" or realm == "Blaumeux"
            or realm == "Fairbanks" or realm == "Grobbulus" or realm == "Whitemane") then
        --US west Sunday 11am UTC reset time (4am server time).
        dayOffset   = 3 --3 days after friday (monday).
        hourOffset  = 11 -- 11am.
        validRegion = true
    elseif (region == 1) then
        --US east + Latin Monday 8am UTC reset time (4am server time).
        dayOffset   = 3 --3 days after friday (monday).
        hourOffset  = 8 -- 8am.
        validRegion = true
    elseif (region == 2) then
        --Korea 1am UTC monday (9am monday local) reset time.
        --(TW seems to be region 2 for some reason also? Hopefully they have same DMF spawn).
        --I can change it to server name based if someone from KR says this spawn time is wrong.
        dayOffset   = 3
        hourOffset  = 1
        validRegion = true
    elseif (region == 3) then
        --EU Monday 4am UTC reset time.
        dayOffset   = 3 --3 days after friday (monday).
        hourOffset  = 2 -- 4am.
        validRegion = true
    elseif (region == 4) then
        --Taiwan 1am UTC monday (9am monday local) reset time.
        dayOffset   = 3
        hourOffset  = 1
        validRegion = true
    elseif (region == 5) then
        --China 8pm UTC sunday (4am monday local) reset time.
        dayOffset   = 2
        hourOffset  = 20
        validRegion = true
    end
    --Create current UTC date table.
    local data          = date("!*t", GetServerTime())
    local dataLocalTime = date("*t", GetServerTime())
    --Spawns change with DST by 1 hour UTC to stay the same server time.
    if (dataLocalTime.isdst) then
        hourOffset = hourOffset - 1
    end
    --If month is specified then use that month instead (next dmf spawn is next month)
    if (month) then
        data.month = month
    end
    --If nextYear is true then next dmf spawn is next year (we're in december right now).
    if (nextYear) then
        data.year = data.year + 1
    end
    local dmfStartDay
    for i = 1, 7 do
        --Iterate the first 7 days in the month to find first friday.
        local time = date("!*t", time({ year = data.year, month = data.month, day = i }))
        if (time.wday == 6) then
            --If day of the week (wday) is 6 (friday) then set this as first friday of the month.
            dmfStartDay = i
        end
    end
    local timeTable   = { year = data.year, month = data.month, day = dmfStartDay + dayOffset, hour = hourOffset, min = minOffset, sec = 0 }
    local utcdate     = date("!*t", GetServerTime())
    local localdate   = date("*t", GetServerTime())
    localdate.isdst   = false
    local secondsDiff = difftime(time(utcdate), time(localdate))
    local dmfStart    = time(timeTable) - secondsDiff
    if (date("%w", dmfStart) == "0") then
        --Not sure if whole region spawns at the same moment or if each realm waits for their own monday.
        --All realms spawn same time of day, but possibly not same UTC day depending on timezone.
        --Just incase each realm waits for monday we can add a day here.
        dmfStart = dmfStart + 86400
    end
    --Add 7 days to get end timestamp.
    local dmfEnd = dmfStart + 604800
    --Only return if we have set daily reset offsets for this region.
    if (validRegion) then
        return dmfStart, dmfEnd
    end
end

--- Taken from NWB
function RBT:isDMFActive()
    local dmfStart, dmfEnd = RBT:getDmfStartEnd()
    local isActive         = false
    local cur_time         = GetServerTime()
    if (dmfStart and dmfEnd) then
        isActive = cur_time >= dmfStart and cur_time <= dmfEnd
    end
    return isActive
end
