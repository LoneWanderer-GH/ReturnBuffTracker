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
local BUFF_MAX_DISPLAY                    = BUFF_MAX_DISPLAY
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
    Relaxed    = L["Relaxed"],
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

--local defaults                            = {
--    profile = {
--        enabled                = true,
--        position               = nil,
--        width                  = 180,
--        hideFrameWhenNotInRaid = true,
--        deactivatedBars        = {  },
--        reportChannel          = RBT.Constants.ReportChannel["RAID_WARNING"],
--        refresh_rate           = 1.0,
--        version                = { major = 1, minor = 0, fix = 0 },
--        --@debug@
--        logLevel               = LoggingLib.TRACE,
--        logging                = true,
--        mem_profiling          = false,
--        --@end-debug@
--    },
--}
--defaults.char                             = defaults.profile

function RBT:RaidOrGroupChanged()
    if not self.mainFrame then return end
    if not self.profile.enabled then self.mainFrame:Hide() end
    
    if IsInRaid() then
        self.mainFrame:Show()
    else
        if self.profile.hideFrameWhenNotInRaid then
            self.mainFrame:Hide()
        else
            self.mainFrame:Show()
        end
    end
end

function RBT:ResetPlayerCache()
    self.raid_player_cache = {}
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
--    self:RaidOrGroupChanged()
--end

local function RAID_ROSTER_UPDATE(...)
    RBT:RaidOrGroupChanged()
end

function RBT:OnEnable()
    self.profile.enabled = true
    self:RaidOrGroupChanged()
    self:UpdateBars()
    self.mainFrame:SetScript("OnUpdate", self.OnUpdate)
    -- register event with an explicit handler
    -- allows register another handler for some specific buffs
    self:RegisterEvent("GROUP_JOINED", GROUP_JOINED)
    self:RegisterEvent("GROUP_LEFT", GROUP_LEFT)
    self:RegisterEvent("GROUP_FORMED", GROUP_FORMED)
    self:RegisterEvent("PLAYER_ENTERING_WORLD", PLAYER_ENTERING_WORLD)
    self:RegisterEvent("RAID_ROSTER_UPDATE", RAID_ROSTER_UPDATE)
end

function RBT:OnDisable()
    self.profile.enabled = false
    self:ResetPlayerCache()
    self:RaidOrGroupChanged()
    self:UpdateBars()
    self.mainFrame:SetScript("OnUpdate", nil)
    --self.mainFrame:Hide()
    self:UnregisterEvent("GROUP_JOINED")
    self:UnregisterEvent("GROUP_LEFT")
    self:UnregisterEvent("GROUP_FORMED")
    self:UnregisterEvent("PLAYER_ENTERING_WORLD")
    self:UnregisterEvent("RAID_ROSTER_UPDATE")
end

function RBT:ParseBuffsDefinition()
    local buff_name, rank
    local itemName--itemName --, link, quality, iLevel, reqLevel, class, subclass, maxStack, equipSlot, texture, vendorPrice
    for k, buff in pairs(self.Buffs) do
        
        --@debug@
        --self:Debugf("OnInitialize", "Treating buff at index: %d", k)
        --@end-debug@
        if buff then
            --@debug@
            -- self:Debugf("OnInitialize", "Preparing OptionbarNames - Initial data [" .. (buff.name or "no .name") .. "]")
            -- self:Debugf("OnInitialize", "Preparing OptionbarNames - Initial data [" .. (buff.buffOptionsGroup or "no .buffOptionsGroup") .. "]")
            -- self:Debugf("OnInitialize", "Preparing OptionbarNames - Initial data [" .. (buff.optionText or "no .optionText") .. "]")
            -- self:Debugf("OnInitialize", "Preparing OptionbarNames - Initial data [" .. (buff.text or "no .text") .. "]")
            --@end-debug@
            if buff.buffOptionsGroup then
                if not self.OptionBarNames[buff.buffOptionsGroup] then
                    self.OptionBarNames[buff.buffOptionsGroup] = {}
                end
                if type(buff.buffIDs) == "table" then
                    for _, id in ipairs(buff.buffIDs) do
                        if not self.buff_id_to_buff_count_data[id] then
                            self:Debugf("OnInitialize", "Tracking spellid: %s", id)
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
                    self:Debugf("OnInitialize", "Buff has no shortName")
                    --@end-debug@
                    if buff.sourceItemId ~= nil then
                        --if #buff.sourceItemId == 1 then
                        --@debug@
                        self:Debugf("OnInitialize", "Using source item ID")
                        --@end-debug@
                        itemName, _, _, _, _, _, _, _, _, _, _ = GetItemInfo(buff.sourceItemId[1])
                        buff.optionText                        = itemName
                        buff.name                              = itemName
                        --end
                    elseif buff.buffIDs ~= nil then
                        --@debug@
                        self:Debugf("OnInitialize", "Using buff ID")
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
                        self:Warningf("OnInitialize", "index=%d no sourceItemId, no buffIDs", k)
                        --@end-debug@
                    end
                end
            end
            --@debug@
            -- self:Debugf("OnInitialize", "Consolidated data:")
            -- if self == nil then
            --     self:Tracef("OnInitialize", " ||-- WTF ???????????????")
            -- end
            -- if self.OptionBarNames == nil then
            --     self:Tracef("OnInitialize", " ||-- WTF ???????????????")
            -- end
            -- if self.OptionBarNames[buff.buffOptionsGroup] == nil then
            --     self:Tracef("OnInitialize", " ||-- WTF ?? index=%d", k)
            -- end
            -- if buff.optionText == nil then
            --     self:Tracef("OnInitialize", " ||-- index=%d optionText is nil", k)
            -- end
            -- if buff.text == nil then
            --     self:Tracef("OnInitialize", " ||-- index=%d text is nil", k)
            -- end
            -- if buff.name == nil then
            --     self:Tracef("OnInitialize", " ||-- index=%d name is nil", k)
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
                self:Errorf("OnInitialize", "index=%d no option text, no text no name (%s)", k, buff.shortName)
                --@end-debug@
            end
            --@debug@
            self:Tracef("OnInitialize", "index=%d effective option bar name is [%s]", k, key)
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
            --    self:Errorf("OnInitialize", "index=%d null key ?!", k)
            --    --@end-debug@
            --end
            --    --@debug@
            --else
            --    self:Errorf("OnInitialize", "index=%d WTF ?!!", k)
            --    --@end-debug@
            --end
        end
    end
end

function RBT:CheckExistingSavedVariablesVersion()
    self:Print("CheckExistingSavedVariablesVersion")
    if self.db and self.db.char then
        if not self.profile.version then
            self:Print("Addon version info not found, resetting config")
            self:ResetConfiguration()
        elseif self.profile.version.major < self.defaults.profile.version.major then
            self:Print("Major addon version changed, resetting config")
            self:ResetConfiguration()
        elseif self.profile.version.minor < self.defaults.profile.version.minor then
            self:Print("Minor addon version changed, resetting config")
            self:ResetConfiguration()
        elseif self.profile.version.fix < self.defaults.profile.version.fix then
            --self:Printf("Minor addon version changed, resetting config")
            --self:ResetConfiguration()
        else
            --
        end
    end
end

function RBT:ReloadOptions()
    -- This handles the reloading of all options
    self.profile = self.db.profile
    self:RaidOrGroupChanged()
    self:SetNumberOfBarsToDisplay(#self.Buffs or 0)
    self.raid_player_cache = {}
    self.nextTime          = 0
    self:UpdateBars()
end

function RBT:OnInitialize()
    --@debug@
    -- initialize logging lib
    self:InitializeLogging(addonName,
                           nil,
                           logging_categories_colors,
                           LoggingLib.TRACE)
    self:Debug("OnInitialize", "OnInitialize")
    --@end-debug@
    
    -- set default config
    self.defaults                   = {
        profile = {
            enabled                = true,
            position               = nil,
            width                  = 180,
            hideFrameWhenNotInRaid = true,
            deactivatedBars        = {  },
            reportChannel          = RBT.Constants.ReportChannel["RAID_WARNING"],
            refresh_rate           = 1.0,
            version                = { major = 1, minor = 0, fix = 0 },
            --@debug@
            logLevel               = LoggingLib.TRACE,
            logging                = true,
            mem_profiling          = false,
            --@end-debug@
        },
    }
    -- bar names for options display and bars display
    self.OptionBarNames             = {}
    -- all possible managed buff ids table
    self.buff_id_to_buff_count_data = {}
    
    self:ParseBuffsDefinition()
    
    self.db = ADB:New("ReturnBuffTrackerDB", self.defaults, "Default")
    self.db.RegisterCallback(self, "OnProfileChanged", "ReloadOptions")
    self.db.RegisterCallback(self, "OnProfileCopied", "ReloadOptions")
    self.db.RegisterCallback(self, "OnProfileReset", "ReloadOptions")
    
    self:ReloadOptions()
    
    self:SetupOptions()
    
    local buffbars = {}
    for _, group in pairs(self.Constants.BarOptionGroups) do
        buffbars[group] = {}
    end
    
    self:CreateMainFrame()
    self:SetNumberOfBarsToDisplay(#self.Buffs)
    for index, buff in ipairs(self.Buffs) do
        tinsert(buffbars[buff.buffOptionsGroup], buff)
        --buff.bar = self:CreateInfoBar(buff.text or buff.shortName, buff.color.r, buff.color.g, buff.color.b)
        buff.bar = self:CreateBuffInfoBar(index, buff)
    end
    
    self:CheckExistingSavedVariablesVersion()
    
    self.raid_player_cache = {}
    self.nextTime          = 0
    self.mainFrame:SetScript("OnUpdate", self.OnUpdate)
    self:UpdateBars()
    
    self:SendMessage("RBT-InitFinished")
end

function RBT:UpdateBars()
    if not self.profile.deactivatedBars then return end
    --@debug@
    --self:Debugf("UpdateBars", "UpdateBars")
    --@end-debug@
    local nb_of_bars_to_display = 0
    for _, buff in ipairs(self.Buffs) do
        if buff.bar then
            --if self.profile.deactivatedBars[buff.optionText or buff.text or buff.name] then
            if self.profile.deactivatedBars[buff.displayText] then
                --@debug@
                -- self:Debugf("UpdateBars", "UpdateBars - %s deactivated", buff.optionText or buff.text or buff.name)
                --@end-debug@
                buff.bar:SetIndex(nil)
            else
                --@debug@
                -- self:Debugf("UpdateBars", "UpdateBars - %s activated", buff.optionText or buff.text or buff.name)
                --@end-debug@
                buff.bar:SetIndex(nb_of_bars_to_display)
                nb_of_bars_to_display = nb_of_bars_to_display + 1
            end
        end
    end
    self:SetNumberOfBarsToDisplay(nb_of_bars_to_display)
end

function RBT:AggregateAllRequiredRaidUnitBuffs()
    local buff_name, caster, spellId
    --self.raid_player_cache = {}
    if IsInRaid() then
        local player_name, player_group, player_class, isDead
        --local buff_id_data
        local slacker, disco, fd, low_level
        for raid_index = 1, 40 do
            player_name, _, player_group, _, _, player_class, _, _, isDead = GetRaidRosterInfo(raid_index)
            if player_name then
                
                slacker, disco, fd, low_level = self:CheckUnitCannotHelpRaid(player_name)
                --local unitPowerType, unitPowerTypeName = UnitPowerType(player_name)
                if not self.raid_player_cache[player_name] then
                    self.raid_player_cache[player_name] = {
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
                        -- self:Debugf("AggregateAllRequiredRaidUnitBuffs", "AggregateAllRequiredRaidUnitBuffs - %s active on player", spellId)
                        --@end-debug@
                        self.raid_player_cache[player_name].active_buff_ids[spellId] = {
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
    
    if not self.profile then return end
    
    --@debug@
    --self:Infof("OnUpdate", "Start Current time %.3f", currentTime)
    --@end-debug@
    
    if self.nextTime and currentTime < self.nextTime then
        return
    end
    self.nextTime = currentTime + self.profile.refresh_rate
    
    if self.mainFrame:IsVisible() then
        
        self:UpdateBars()
        
        --@debug@
        local mem_before_g, mem_after_g, mem_before, mem_after, diff
        if self.profile.mem_profiling then
            mem_before_g = GetAddOnMemoryUsage(addonName)
        end
        --@end-debug@
        
        self:AggregateAllRequiredRaidUnitBuffs()
        
        for _, buff in ipairs(self.Buffs) do
            buff:ResetBuffData()
            if self.profile.deactivatedBars[buff.displayText] then
                --@debug@
                -- self:Debugf("OnUpdate", "Ignoring deactivated buff %s", buff.displayText)
                --@end-debug@
                return
            end
            --@debug@
            if self.profile.mem_profiling then
                mem_before = GetAddOnMemoryUsage(addonName)
            end
            --@end-debug@
            
            if buff.func then
                buff:func()
            end
            buff:BuildToolTipText()
            
            --@debug@
            if self.profile.mem_profiling then
                UpdateAddOnMemoryUsage()
                mem_after = GetAddOnMemoryUsage(addonName)
                diff      = (mem_after - mem_before)
            end
            --@end-debug@
            
            --@debug@
            if self.profile.mem_profiling and diff > 2.0 then
                self:Infof("OnUpdate", "Memory increase for %s : %.1f -> %.1f (%.1f)",
                           buff.displayText,
                           mem_before,
                           mem_after,
                           diff)
            end
            --@end-debug@
            
            if buff.bar then
                buff.bar:Update()
            end
        end -- end for loop
        -- --@debug@
        -- if self.profile.mem_profiling then
        --     UpdateAddOnMemoryUsage()
        --     mem_after_g = GetAddOnMemoryUsage(addonName)
        --     self:Infof("OnUpdate", "Memory increase ----> : %.1f -> %.1f (%.1f)",
        --               mem_before_g,
        --               mem_after_g,
        --               (mem_after_g - mem_before_g))
        --
        -- end
        -- --@end-debug@
    end -- end frame visible
    
    --@debug@
    --currentTime = GetTime()
    --self:Infof("OnUpdate", "End Current time %.3f", currentTime)
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
    self:Debug("ResetConfiguration", "ResetConfiguration")
    --@end-debug@
    --for bar_name, _ in pairs(self.profile.deactivatedBars) do
    --    --@debug@
    --    self:Debugf("ResetConfiguration", "Deactivating %s", bar_name)
    --    --@end-debug@
    --    self.profile.deactivatedBars[bar_name] = true
    --end
    --self.db.char = defaults.char
    self:RaidOrGroupChanged()
    self:ResetPlayerCache()
    self:UpdateBars()
    ACR:NotifyChange()
end

function RBT:ActivatePlayerClassOnly()
    --@debug@
    self:Debugf("ActivatePlayerClassOnly", "ActivatePlayerClassOnly")
    --@end-debug@
    local _, player_class, _ = UnitClass("player")
    
    self:Debugf("ActivatePlayerClassOnly", "ActivatePlayerClassOnly - deactivating all")
    
    for _, buff in ipairs(self.Buffs) do
        self.profile.deactivatedBars[buff.displayText] = (
                (buff.buffingClass and buff.buffingClass ~= player_class) or true)
    end
    --@debug@
    self:Debugf("ActivatePlayerClassOnly", "ActivatePlayerClassOnly - my class: %s", player_class)
    --@end-debug@
    for class, bar_names in pairs(self.OptionBarClassesToBarNames) do
        if player_class == class then
            --@debug@
            self:Debugf("ActivatePlayerClassOnly", "ActivatePlayerClassOnly - Matching class")
            --@end-debug@
            for _, bar_name_to_activate in ipairs(bar_names) do
                --@debug@
                self:Debugf("ActivatePlayerClassOnly", "ActivatePlayerClassOnly - Activating bar %s", bar_name_to_activate)
                --@end-debug@
                self.profile.deactivatedBars[bar_name_to_activate] = false
            end
        end
    end
    self:UpdateBars()
    ACR:NotifyChange("ReturnBuffTracker")
end

-- register event with an explicit handler
-- allows register another handler for some specific buffs
RBT:RegisterEvent("GROUP_JOINED", GROUP_JOINED)
RBT:RegisterEvent("GROUP_LEFT", GROUP_LEFT)
RBT:RegisterEvent("GROUP_FORMED", GROUP_FORMED)
RBT:RegisterEvent("PLAYER_ENTERING_WORLD", PLAYER_ENTERING_WORLD)
RBT:RegisterEvent("RAID_ROSTER_UPDATE", RAID_ROSTER_UPDATE)
