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
local ACR                                 = LibStub("AceConfigRegistry-3.0")
local ADB                                 = LibStub("AceDB-3.0")

local tinsert, tconcat                    = table.insert, table.concat
local WARRIOR, MAGE, ROGUE, DRUID, HUNTER = "WARRIOR", "MAGE", "ROGUE", "DRUID", "HUNTER"
local SHAMAN, PRIEST, WARLOCK, PALADIN    = "SHAMAN", "PRIEST", "WARLOCK", "PALADIN"
local BUFF_MAX_DISPLAY = BUFF_MAX_DISPLAY
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
    ["ADDON"]                             = colors[GOLD],
    ["OnInitialize"]                      = colors[SEXGREEN],
    ["OnUpdate"]                          = colors[SEXPINK],
    ["UpdateBars"]                        = colors[YELLOW],
    ["ResetConfiguration"]                = colors[CYAN],
    ["ActivatePlayerClassOnly"]           = colors[LIGHTBLUE],
    ["compute_percent_string"]            = colors[ORANGEY],
    ["CheckAlive"]                        = colors[GOLD2],
    ["CheckCannotHelpRaid"]               = colors[GREY],
    ["CheckPowerType"]                    = colors[MAGE],
    ["CheckBuff"]                         = colors[PALADIN],
    ["AggregateAllRequiredRaidUnitBuffs"] = colors[PINK];
    ["ResetBuffData"]                     = colors[PALADIN],
    ["ClearBuffTooltipTable"]             = colors[PALADIN],
    ["OnEvent"]                           = colors[MAGE],
}
--@end-debug@

RBT.Constants                             = {}

RBT.Constants.BarOptionGroups             = {
    General    = L["General"],
    Player     = L["Player buffs"],
    World      = L["World"],
    Consumable = L["Consumables"],
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
    ["RAID_WARNING"]  = L["Raid warning"],
    ["SAY"]           = L["Say"],
    --"WHISPER",
    --"YELL"
}

local defaults                            = {
    profile = {
        enabled                = true,
        position               = nil,
        width                  = 180,
        hideFrameWhenNotInRaid = true,
        deactivatedBars        = {  },
        reportChannel          = RBT.Constants.ReportChannel["RAID_WARNING"],
        refresh_rate           = 5.0,
        --@debug@
        logLevel               = LoggingLib.TRACE,
        logging                = true,
        mem_profiling          = false,
        --@end-debug@
    },
}
defaults.char                             = defaults.profile

function RBT:RaidOrGroupChanged()
    if RBT.db.char.enabled then
        if IsInRaid() then
            RBT.mainFrame:Show()
        else
            if RBT.db.char.hideFrameWhenNotInRaid then
                RBT.mainFrame:Hide()
            else
                RBT.mainFrame:Show()
            end
        end
    else
        RBT.mainFrame:Hide()
    end
end

function RBT:ResetPlayerCache()
    RBT.raid_player_cache = {}
end

local function GROUP_JOINED(_)
    RBT:ResetPlayerCache()
    RBT:RaidOrGroupChanged()
end

local function GROUP_LEFT(_)
    RBT:ResetPlayerCache()
    RBT:RaidOrGroupChanged()
end

local function GROUP_FORMED(_)
    RBT:ResetPlayerCache()
    RBT:RaidOrGroupChanged()
end

local function PLAYER_ENTERING_WORLD(...)
    RBT:UpdateBars()
end

--function RBT:GROUP_ROSTER_UPDATE(...)
--    RBT:RaidOrGroupChanged()
--end

local function RAID_ROSTER_UPDATE(...)
    RBT:RaidOrGroupChanged()
end

function RBT:OnEnable()
    RBT.db.char.enabled = true
    RBT:RaidOrGroupChanged()
    RBT:UpdateBars()
    RBT.mainFrame:SetScript("OnUpdate", self.OnUpdate)
    -- register event with an explicit handler
    -- allows register another handler for some specific buffs
    RBT:RegisterEvent("GROUP_JOINED", GROUP_JOINED)
    RBT:RegisterEvent("GROUP_LEFT", GROUP_LEFT)
    RBT:RegisterEvent("GROUP_FORMED", GROUP_FORMED)
    RBT:RegisterEvent("PLAYER_ENTERING_WORLD", PLAYER_ENTERING_WORLD)
    RBT:RegisterEvent("RAID_ROSTER_UPDATE", RAID_ROSTER_UPDATE)
end

function RBT:OnDisable()
    RBT.db.char.enabled = false
    RBT:ResetPlayerCache()
    RBT.mainFrame:SetScript("OnUpdate", nil)
    RBT:UnregisterEvent("GROUP_JOINED")
    RBT:UnregisterEvent("GROUP_LEFT")
    RBT:UnregisterEvent("GROUP_FORMED")
    RBT:UnregisterEvent("PLAYER_ENTERING_WORLD")
    RBT:UnregisterEvent("RAID_ROSTER_UPDATE")
end

function RBT:OnInitialize()
    --@debug@
    RBT:InitializeLogging(addonName,
                          nil,
                          logging_categories_colors,
                          LoggingLib.TRACE)
    RBT:Debug("OnInitialize", "OnInitialize")
    --@end-debug@
    
    self.OptionBarNames             = {}
    --self.OptionBarClassesToBarNames = {}
    local buff_name, rank
    local itemName--itemName --, link, quality, iLevel, reqLevel, class, subclass, maxStack, equipSlot, texture, vendorPrice
    self.buff_id_to_buff_count_data = {}
    for k, buff in pairs(self.Buffs) do
        
        --@debug@
        --RBT:Debugf("OnInitialize", "Treating buff at index: %d", k)
        --@end-debug@
        if buff then
            --@debug@
            -- RBT:Debugf("OnInitialize", "Preparing OptionbarNames - Initial data [" .. (buff.name or "no .name") .. "]")
            -- RBT:Debugf("OnInitialize", "Preparing OptionbarNames - Initial data [" .. (buff.buffOptionsGroup or "no .buffOptionsGroup") .. "]")
            -- RBT:Debugf("OnInitialize", "Preparing OptionbarNames - Initial data [" .. (buff.optionText or "no .optionText") .. "]")
            -- RBT:Debugf("OnInitialize", "Preparing OptionbarNames - Initial data [" .. (buff.text or "no .text") .. "]")
            --@end-debug@
            if buff.buffOptionsGroup then
                if not self.OptionBarNames[buff.buffOptionsGroup] then
                    self.OptionBarNames[buff.buffOptionsGroup] = {}
                end
                if type(buff.buffIDs) == "table" then
                    for _, id in ipairs(buff.buffIDs) do
                        if not self.buff_id_to_buff_count_data[id] then
                            RBT:Debugf("OnInitialize", "Tracking spellid: %s", id)
                            self.buff_id_to_buff_count_data[id] = { count   = 0,
                                                                    total   = 0,
                                                                    players = {},
                            }
                        end
                    end
                end
                -- try to put exact buff name if ID availabe and its a unique buff
                if not buff.shortName and not buff.buffOptionsGroup == L["Consumables"] then
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
                    else
                        --@debug@
                        RBT:Warningf("OnInitialize", "index=%d no sourceItemId, no buffIDs", k)
                        --@end-debug@
                    end
                end
            end
            --@debug@
            -- RBT:Debugf("OnInitialize", "Consolidated data:")
            -- if self == nil then
            --     RBT:Tracef("OnInitialize", " ||-- WTF ???????????????")
            -- end
            -- if self.OptionBarNames == nil then
            --     RBT:Tracef("OnInitialize", " ||-- WTF ???????????????")
            -- end
            -- if self.OptionBarNames[buff.buffOptionsGroup] == nil then
            --     RBT:Tracef("OnInitialize", " ||-- WTF ?? index=%d", k)
            -- end
            -- if buff.optionText == nil then
            --     RBT:Tracef("OnInitialize", " ||-- index=%d optionText is nil", k)
            -- end
            -- if buff.text == nil then
            --     RBT:Tracef("OnInitialize", " ||-- index=%d text is nil", k)
            -- end
            -- if buff.name == nil then
            --     RBT:Tracef("OnInitialize", " ||-- index=%d name is nil", k)
            -- end
            --@end-debug@
            
            local key
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
            local tmp        = self.OptionBarNames[buff.buffOptionsGroup]
            --if tmp then
            --    if key then
            
            buff.displayText = key
            
            -- if there is an option subgroup, store this hierarchical info
            if buff.buffOptionsSubGroup then
                if not tmp[buff.buffOptionsSubGroup] then
                    tmp[buff.buffOptionsSubGroup] = {}
                end
                tmp[buff.buffOptionsSubGroup][key] = key
            else
                tmp[key] = key
            end
            --    --@debug@
            --else
            --    RBT:Errorf("OnInitialize", "index=%d null key ?!", k)
            --    --@end-debug@
            --end
            --    --@debug@
            --else
            --    RBT:Errorf("OnInitialize", "index=%d WTF ?!!", k)
            --    --@end-debug@
            --end
        end
    end
    
    self.db = ADB:New("ReturnBuffTrackerDB", defaults, true)
    
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
    RBT.raid_player_cache = {}
    self.nextTime         = 0
    RBT.mainFrame:SetScript("OnUpdate", self.OnUpdate)
    RBT:UpdateBars()
    
    RBT:SendMessage("RBT-InitFinished")
end

function RBT:UpdateBars()
    --@debug@
    --RBT:Debugf("UpdateBars", "UpdateBars")
    --@end-debug@
    local nb_of_bars_to_display = 0
    for _, buff in ipairs(RBT.Buffs) do
        --if RBT.db.char.deactivatedBars[buff.optionText or buff.text or buff.name] then
        if RBT.db.char.deactivatedBars[buff.displayText] then
            --@debug@
            -- RBT:Debugf("UpdateBars", "UpdateBars - %s deactivated", buff.optionText or buff.text or buff.name)
            --@end-debug@
            buff.bar:SetIndex(nil)
        else
            --@debug@
            -- RBT:Debugf("UpdateBars", "UpdateBars - %s activated", buff.optionText or buff.text or buff.name)
            --@end-debug@
            buff.bar:SetIndex(nb_of_bars_to_display)
            nb_of_bars_to_display = nb_of_bars_to_display + 1
        end
    end
    RBT:SetNumberOfBarsToDisplay(nb_of_bars_to_display)
end

function RBT:AggregateAllRequiredRaidUnitBuffs()
    local buff_name, caster, spellId
    --RBT.raid_player_cache = {}
    if IsInRaid() then
        local player_name, player_group, player_class, isDead
        --local buff_id_data
        local slacker, disco, fd, low_level
        for raid_index = 1, 40 do
            player_name, _, player_group, _, _, player_class, _, _, isDead = GetRaidRosterInfo(raid_index)
            if player_name then
                
                slacker, disco, fd, low_level = RBT:CheckUnitCannotHelpRaid(player_name)
                --local unitPowerType, unitPowerTypeName = UnitPowerType(player_name)
                if not RBT.raid_player_cache[player_name] then
                    RBT.raid_player_cache[player_name] = {
                        colored_player_name = WrapTextInColorCode(player_name, RAID_CLASS_COLORS[player_class].colorStr),
                        slack_status        = { slacker, disco, fd, low_level },
                        class               = player_class,
                        group               = player_group,
                        raid_index          = raid_index,
                        dead                = isDead,
                        combat              = UnitAffectingCombat(player_name),
                        active_buff_ids     = {},
                    }
                end
                for buff_index = 1, BUFF_MAX_DISPLAY do
                    buff_name, _, _, _, _, _, caster, _, _, spellId = UnitBuff(player_name, buff_index)
                    if self.buff_id_to_buff_count_data[spellId] then
                        --@debug@
                        RBT:Debugf("AggregateAllRequiredRaidUnitBuffs", "AggregateAllRequiredRaidUnitBuffs - %s active on player", spellId)
                        --@end-debug@
                        RBT.raid_player_cache[player_name].active_buff_ids[spellId] = {
                            caster    = caster,
                            buff_name = buff_name,
                        }
                    end
                end -- end loop payer auras
            end
        end
    end
end

function RBT:OnUpdate()
    local currentTime = GetTime()
    --@debug@
    --RBT:Infof("OnUpdate", "Start Current time %.3f", currentTime)
    --@end-debug@
    
    if RBT.nextTime and currentTime < RBT.nextTime then
        return
    end
    RBT.nextTime = currentTime + RBT.db.char.refresh_rate
    
    --if not RBT:CheckVisible() then
    --    return
    --end
    if RBT.mainFrame:IsVisible() then
        
        RBT:UpdateBars()
        
        --@debug@
        local mem_before_g, mem_after_g, mem_before, mem_after, diff
        if RBT.db.char.mem_profiling then
            mem_before_g = GetAddOnMemoryUsage(addonName)
        end
        --@end-debug@
        
        RBT:AggregateAllRequiredRaidUnitBuffs()
        
        
        
        --for _, buff in ipairs(RBT.Buffs) do
        --    buff.count = 0
        --    buff.total = 0
        --end
        --@debug@
        --RBT:Debugf("OnUpdate", "Buff index [ %d ]", RBT.current_buff_index)
        --@end-debug@
        --local buff             = RBT.Buffs[RBT.current_buff_index]
        --RBT.current_buff_index = ((RBT.current_buff_index + 1) % #RBT.Buffs) + 1
        for _, buff in ipairs(RBT.Buffs) do
            buff:ResetBuffData()
            if RBT.db.char.deactivatedBars[buff.displayText] then
                --@debug@
                -- RBT:Debugf("OnUpdate", "Ignoring deactivated buff %s", buff.displayText)
                --@end-debug@
                return
            end
            --@debug@
            if RBT.db.char.mem_profiling then
                mem_before = GetAddOnMemoryUsage(addonName)
            end
            --@end-debug@
            
            if buff.func then
                buff:func()
            end
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
        end -- end for loop
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
    
    --@debug@
    --currentTime = GetTime()
    --RBT:Infof("OnUpdate", "End Current time %.3f", currentTime)
    --@end-debug@
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

function RBT:ResetConfiguration()
    --@debug@
    RBT:Debug("ResetConfiguration", "ResetConfiguration")
    --@end-debug@
    --for bar_name, _ in pairs(RBT.db.char.deactivatedBars) do
    --    --@debug@
    --    RBT:Debugf("ResetConfiguration", "Deactivating %s", bar_name)
    --    --@end-debug@
    --    RBT.db.char.deactivatedBars[bar_name] = true
    --end
    RBT.db.char = defaults.char
    RBT:RaidOrGroupChanged()
    RBT:ResetPlayerCache()
    RBT:UpdateBars()
    ACR:NotifyChange()
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
    ACR:NotifyChange("ReturnBuffTracker")
end

-- register event with an explicit handler
-- allows register another handler for some specific buffs
RBT:RegisterEvent("GROUP_JOINED", GROUP_JOINED)
RBT:RegisterEvent("GROUP_LEFT", GROUP_LEFT)
RBT:RegisterEvent("GROUP_FORMED", GROUP_FORMED)
RBT:RegisterEvent("PLAYER_ENTERING_WORLD", PLAYER_ENTERING_WORLD)
RBT:RegisterEvent("RAID_ROSTER_UPDATE", RAID_ROSTER_UPDATE)
