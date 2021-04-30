local RBT          = LibStub("AceAddon-3.0"):GetAddon("ReturnBuffTracker")
local L            = LibStub("AceLocale-3.0"):GetLocale("ReturnBuffTracker")
local AC           = LibStub("AceConfig-3.0")
local ACR          = LibStub("AceConfigRegistry-3.0")
local ACD          = LibStub("AceConfigDialog-3.0")
local ADBO         = LibStub("AceDBOptions-3.0")
--@debug@
local LoggingLib   = LibStub("LoggingLib-0.1")
--@end-debug@

local cat_to_order = {
    [L["General"]]      = 100,
    [L["Relaxed"]]      = 150,
    [L["Player buffs"]] = 200,
    [L["World"]]        = 300,
    [L["Consumables"]]  = 400,
}

local options      = nil

local function SetAllChildMultiselect(info, is_active)
    local cur_option_args = options.args[info.options.name].args
    for option_table_key_name, sub_option_table in pairs(cur_option_args) do
        if sub_option_table.type and sub_option_table.type == "multiselect" then
            for bar, value in pairs(sub_option_table.values) do
                --print("Activating ==> " .. bar)
                RBT.profile.deactivatedBars[bar] = not is_active
            end
        elseif sub_option_table.type and sub_option_table.type == "group" then
            --for k, v in pairs(sub_option_table.args) do
            --
            --end
        end
    end
    ACR:NotifyChange("ReturnBuffTracker")
    RBT:UpdateBars()
end

local function ActivateAllChildMultiselect(info)
    SetAllChildMultiselect(info, true)
end
local function DeactivateAllChildMultiselect(info)
    SetAllChildMultiselect(info, false)
end

function RBT:AddBuffRelatedOptions()
    
    local no_sub_cat_infos
    local sub_order
    local sub_group_name
    
    self.OptionBarNamesOrdered = {}
    for k in pairs(self.OptionBarNames) do table.insert(self.OptionBarNamesOrdered, k) end
    
    --print(table.concat(self.OptionBarNamesOrdered, "> "))
    
    table.sort(self.OptionBarNamesOrdered, function(a, b)
        --print(format("%s (%s) < %s (%s)",
        --a, cat_to_order[a],
        --b, cat_to_order[b]))
        return cat_to_order[a] < cat_to_order[b]
    end)
    
    --print(table.concat(self.OptionBarNamesOrdered, "> "))
    
    --for upper_category, upper_category_data in pairs(self.OptionBarNames) do
    local upper_category_data
    for _, upper_category in ipairs(self.OptionBarNamesOrdered) do
        upper_category_data          = self.OptionBarNames[upper_category]
        options.args[upper_category] = {
            name     = upper_category,
            desc     = upper_category,
            type     = "group",
            --childGroups = "tree",
            order    = cat_to_order[upper_category],
            args     = {
                check_all   = {
                    name  = L["Activate all"],
                    type  = "execute",
                    func  = ActivateAllChildMultiselect,
                    order = 1,
                },
                uncheck_all = {
                    name  = L["Deactivate all"],
                    type  = "execute",
                    func  = DeactivateAllChildMultiselect,
                    order = 2,
                },
            },
            disabled = function() return not self.profile.enabled end,
        }
        
        no_sub_cat_infos             = nil
        sub_order                    = 3
        for sub_data_key, sub_data_value in pairs(upper_category_data) do
            if sub_data_key == sub_data_value then
                if not no_sub_cat_infos then
                    no_sub_cat_infos = {}
                end
                -- fill a legacy category [key,val] dict for options
                no_sub_cat_infos[sub_data_key] = sub_data_value
            elseif type(sub_data_value) == "table" then
                sub_group_name                                    = sub_data_key
                options.args[upper_category].args[sub_group_name] = {
                    type   = "multiselect",
                    name   = sub_group_name,
                    --desc   = "",
                    order  = sub_order,
                    values = sub_data_value,
                    get    = function(info, bar)
                        return not self.profile.deactivatedBars[bar]
                    end,
                    set    = function(info, bar, value)
                        self.profile.deactivatedBars[bar] = not value
                        self:UpdateBars()
                    end
                }
                sub_order                                         = sub_order + 1
            end
        end
        if no_sub_cat_infos then
            options.args[upper_category].args.no_sub_cat = {
                type   = "multiselect",
                name   = "",
                desc   = "",
                order  = sub_order,
                values = no_sub_cat_infos,
                get    = function(info, bar)
                    return not self.profile.deactivatedBars[bar]
                end,
                set    = function(info, bar, value)
                    self.profile.deactivatedBars[bar] = not value
                    self:UpdateBars()
                end
            }
        end
        --order = order + 1
    end
end

function RBT:getOptions()
    if options then
        return options
    end
    
    options              = {
        type = "group",
        name = "Return Buff Tracker",
    }
    options.args         = {}
    options.args.general = {
        order = 100,
        type  = "group",
        name  = L["Main Options"],
        --inline = true,
        args  = {
            description           = {
                name        = "",
                type        = "description",
                image       = "Interface\\AddOns\\ReturnBuffTracker\\media\\return",
                imageWidth  = 64,
                imageHeight = 64,
                width       = "half",
                order       = 10
            },
            descriptiontext       = {
                --name  = L["Return Buff Tracker by Irpa\nDiscord: https://discord.gg/SZYAKFy\nGithub: https://github.com/zorkqz/ReturnBuffTracker\n"],
                name  = "Return Buff Tracker by Irpa - Enhanced by LoneWanderer-GH",
                type  = "description",
                width = "full",
                order = 20
            },
            enable_disable_toggle = {
                name  = L["Enable"],
                desc  = L["Activate/deactivate completly RBT"],
                type  = "toggle",
                order = 30,
                get   = function(info)
                    return self.profile.enabled
                end,
                set   = function(info, value)
                    self.profile.enabled = value
                    if self.profile.enabled then
                        RBT:OnEnable()
                    else
                        RBT:OnDisable()
                    end
                end
            },
            resetConf             = {
                name  = L["reset Configuration"],
                desc  = L["reset to default"],
                type  = "execute",
                func  = RBT.ResetConfiguration,
                order = 40,
            },
            show_hide_group       = {
                name   = "Force show/hide",
                type   = "group",
                inline = true,
                order  = 50,
                args   = {
                    showFrame              = {
                        name      = "Show frame",
                        desc      = "Force frame to show. Caution : it may show/hide again if you join/leave a raid depending on other options",
                        descStyle = "inline",
                        order     = 1,
                        type      = "execute",
                        func      = function() self.mainFrame:Show()
                        end,
                        disabled  = function() return not self.profile.enabled
                        end,
                    },
                    hideFrame              = {
                        name      = "Hide frame",
                        descStyle = "inline",
                        desc      = "Force frame to hide. Caution : it may show/hide again if you join/leave a raid depending on other options",
                        order     = 2,
                        type      = "execute",
                        func      = function() self.mainFrame:Hide()
                        end,
                        disabled  = function() return not self.profile.enabled
                        end,
                    },
                    enable_disable_spark   = {
                        name     = L["Show spark on bars"],
                        desc     = L["Helps user to see the exact bar fill %"],
                        type     = "toggle",
                        order    = 3,
                        get      = function(info)
                            return self.profile.enable_spark
                        end,
                        set      = function(info, value)
                            self.profile.enable_spark = value
                            for _, buff in ipairs(self.Buffs) do
                                if buff.bar and buff.bar.spark then
                                    if self.profile.enable_spark then
                                        buff.bar.spark:Show()
                                    else
                                        buff.bar.spark:Hide()
                                    end
                                end
                            end
                        end,
                        disabled = function() return not self.profile.enabled end
                    },
                    
                    --set_my_class_only    = {
                    --    name = "my class only",
                    --    desc = "only select buffs applicable to my class",
                    --    type = "execute",
                    --    func = self.ActivatePlayerClassOnly,
                    --},
                    headerGlobalSettings   = {
                        name  = L["Global Settings"],
                        type  = "header",
                        width = "double",
                        order = 60,
                    },
                    report_slackers        = {
                        name     = L["Include report slackers in chat report"],
                        desc     = L["otherwise, they will only appear in tooltips"],
                        type     = "toggle",
                        order    = 70,
                        get      = function(info)
                            return self.profile.report_slackers
                        end,
                        set      = function(info, value)
                            self.profile.report_slackers = value
                        end,
                        disabled = function() return not self.profile.enabled
                        end,
                    },
                    hideFrameWhenNotInRaid = {
                        name     = L["Hide when not in raid"],
                        desc     = L["The buff tracker does not work outside of raids."],
                        type     = "toggle",
                        order    = 80,
                        get      = function(info)
                            return self.profile.hideFrameWhenNotInRaid
                        end,
                        set      = function(info, value)
                            self.profile.hideFrameWhenNotInRaid = value
                            RBT:RaidOrGroupChanged()
                        end,
                        disabled = function() return not self.profile.enabled
                        end,
                    },
                    reportConfig           = {
                        name     = L["Report config"],
                        type     = "select",
                        desc     = "Report channel",
                        order    = 90,
                        values   = self.Constants.ReportChannel,
                        get      = function(info)
                            return self.profile.reportChannel
                        end,
                        set      = function(info, v)
                            self.profile.reportChannel = v
                        end,
                        disabled = function() return not self.profile.enabled
                        end,
                    },
                    refresh_rate           = {
                        name      = L["Raid buffs data refresh rate"],
                        type      = "range",
                        min       = 0.1,
                        max       = 10.0,
                        softMin   = 0.2,
                        --softMax = 5.0
                        step      = 0.1,
                        bigStep   = 0.2,
                        order     = 100,
                        get       = function(info) return self.profile.refresh_rate
                        end,
                        set       = function(info, v)
                            self.profile.refresh_rate = v
                        end,
                        isPercent = false,
                        disabled  = function() return not self.profile.enabled
                        end,
                    },
                    percent_absolut_toggle = {
                        name   = L[""],
                        type   = "select",
                        order  = 200,
                        values = { [L["absolute"]] = "absolute",
                                   [L["percent"]]  = "percent" },
                        get    = function(info)
                            return self.profile.count_display_mode
                        end,
                        set    = function(info, v)
                            self.profile.count_display_mode = v
                        end,
                        style  = "radio",
                    },
                    --@debug@
                    debug_group            = {
                        type     = "group",
                        name     = "Debug options",
                        inline   = true,
                        order    = 400,
                        disabled = function() return not self.profile.enabled
                        end,
                        args     = {
                            logging           = {
                                name  = "Addon logging",
                                type  = "toggle",
                                desc  = "Activate Logging",
                                order = 6,
                                get   = function(info)
                                    return self.profile.logging
                                end,
                                set   = function(info, v)
                                    self.profile.logging = v
                                    if not v then
                                        self.profile.mem_profiling = false
                                        self:SetLogLevel(LoggingLib.INACTIVE)
                                    end
                                end
                            },
                            mem_profiling     = {
                                name     = "Addon memory profiling (depends on logging)",
                                type     = "toggle",
                                desc     = "Activate Logging",
                                order    = 6,
                                get      = function(info)
                                    return self.profile.mem_profiling
                                end,
                                set      = function(info, v)
                                    self.profile.mem_profiling = v
                                end,
                                disabled = function() return not self.profile.enabled or not self.profile.logging
                                end,
                            },
                            addonLoggerConfig = {
                                name     = L["Addon logging level"],
                                type     = "select",
                                desc     = "Log level threshold",
                                order    = 6,
                                --values = self.Constants.LoggingConfig,
                                values   = LoggingLib.logging_level_to_string,
                                get      = function(info)
                                    return self.profile.logLevel
                                end,
                                set      = function(info, v)
                                    self:SetLogLevel(v)
                                    self.profile.logLevel = v
                                end,
                                disabled = function() return not self.profile.enabled or not self.profile.logging
                                end,
                            },
                        },
                    },
                    --@end-debug@
                    
                }
            }
        }
    }
    self:AddBuffRelatedOptions()
    
    options.args.profile = {
        type  = "group",
        order = 500,
        name  = "Profile Options",
        args  = {
            desc = {
                order = 1,
                type  = "description",
                name  = "foo bar baz",
            },
            prof = ADBO:GetOptionsTable(self.db)
        }
    }
    return options
end

function RBT:ChatCommand(input)
    if not input or input:trim() == "" then
        InterfaceOptionsFrame_OpenToCategory(
                self.optFrames.ReturnBuffTracker)
        -- Workaround: https://www.wowinterface.com/forums/showthread.php?t=54599
        InterfaceOptionsFrame_OpenToCategory(
                self.optFrames.ReturnBuffTracker)
    else
        LibStub("AceConfigCmd-3.0").HandleCommand(RBT,
                                                  "ReturnBuffTracker",
                                                  "ReturnBuffTracker",
                                                  input)
    end
end

function RBT:SetupOptions()
    self.optFrames = {}
    local opts     = self:getOptions()
    --ACR:RegisterOptionsTable("ReturnBuffTracker", getOptions)
    ACR:RegisterOptionsTable("ReturnBuffTracker", self.getOptions)
    self.optFrames.ReturnBuffTracker = ACD:AddToBlizOptions("ReturnBuffTracker",
                                                            "Return Buff Tracker",
                                                            nil, "general")
    
    local menu_option_name
    --for upper_category, _ in pairs(self.OptionBarNames) do
    for _, upper_category in ipairs(self.OptionBarNamesOrdered) do
        menu_option_name = "ReturnBuffTracker-" .. upper_category
        AC:RegisterOptionsTable(menu_option_name, opts.args[upper_category])
        ACD:AddToBlizOptions(menu_option_name, opts.args[upper_category].name, "Return Buff Tracker")
    end
    
    AC:RegisterOptionsTable("ReturnBuffTracker-Profiles", opts.args.profile.args.prof)
    ACD:AddToBlizOptions("ReturnBuffTracker-Profiles", opts.args.profile.args.prof.name, "Return Buff Tracker")
    
    self:RegisterChatCommand("ReturnBuffTracker", "ChatCommand")
    self:RegisterChatCommand("rbt", "ChatCommand")
end
