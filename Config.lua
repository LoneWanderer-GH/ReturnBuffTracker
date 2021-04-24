local RBT        = LibStub("AceAddon-3.0"):GetAddon("ReturnBuffTracker")
local L          = LibStub("AceLocale-3.0"):GetLocale("ReturnBuffTracker")
local AC         = LibStub("AceConfig-3.0")
local ACR        = LibStub("AceConfigRegistry-3.0")
local ACD        = LibStub("AceConfigDialog-3.0")
--@debug@
local LoggingLib = LibStub("LoggingLib-0.1")
--@end-debug@

local options    = nil
local function getOptions()
    if options then return options end

    options                   = {
        type = "group",
        name = "Return Buff Tracker",
        --childGroups = "tree",
        args = {
            --buff_groups = {
            --    type        = "group",
            --    name        = L["Bars to show"],
            --    --inline      = true,
            --    --childGroups = "tab",
            --    childGroups = "tree",
            --    order       = 0,
            --    args        = {
            --        --headerBars   = {
            --        --    name  = L["Bars to show"],
            --        --    type  = "header",
            --        --    width = "double",
            --        --    order = 4
            --        --},
            --        --generalBuffs = general_buffs,
            --        --playerBuffs  = player_buffs,
            --        --worldBuffs   = world_buffs,
            --        --consumables  = consumables,
            --    }
            --},
            general = {
                order = 100,
                type  = "group",
                name  = L["Main Options"],
                --inline = true,
                args  = {
                    description            = {
                        name        = "",
                        type        = "description",
                        image       = "Interface\\AddOns\\ReturnBuffTracker\\media\\return",
                        imageWidth  = 64,
                        imageHeight = 64,
                        width       = "half",
                        order       = 1
                    },
                    descriptiontext        = {
                        --name  = L["Return Buff Tracker by Irpa\nDiscord: https://discord.gg/SZYAKFy\nGithub: https://github.com/zorkqz/ReturnBuffTracker\n"],
                        name  = "Return Buff Tracker by Irpa - Enhanced by LoneWanderer-GH",
                        type  = "description",
                        width = "full",
                        order = 2
                    },
                    resetConf              = {
                        name  = "reset Configuration",
                        desc  = "reset to default",
                        type  = "execute",
                        func  = RBT.ResetConfiguration,
                        order = 3
                    },
                    showFrame              = {
                        name      = "Show frame",
                        desc      = "Force frame to show. Caution : it may show/hide again if you join/leave a raid depending on other options",
                        descStyle = "inline",
                        order     = 4,
                        type      = "execute",
                        func      = function() RBT.mainFrame:Show() end
                    },
                    hideFrame              = {
                        name      = "Hide frame",
                        descStyle = "inline",
                        desc      = "Force frame to hide. Caution : it may show/hide again if you join/leave a raid depending on other options",
                        order     = 5,
                        type      = "execute",
                        func      = function() RBT.mainFrame:Hide() end
                    },
                    --set_my_class_only    = {
                    --    name = "my class only",
                    --    desc = "only select buffs applicable to my class",
                    --    type = "execute",
                    --    func = RBT.ActivatePlayerClassOnly,
                    --},
                    headerGlobalSettings   = {
                        name  = L["Global Settings"],
                        type  = "header",
                        width = "double",
                        order = 6
                    },
                    hideFrameWhenNotInRaid = {
                        name  = L["Hide when not in raid"],
                        desc  = L["The buff tracker does not work outside of raids."],
                        type  = "toggle",
                        order = 7,
                        get   = function(self)
                            return RBT.db.char.hideFrameWhenNotInRaid
                        end,
                        set   = function(self, value)
                            RBT.db.char.hideFrameWhenNotInRaid = value
                            RBT:RaidOrGroupChanged()
                        end
                    },
                    reportConfig           = {
                        name   = L["Report config"],
                        type   = "select",
                        desc   = "Report channel",
                        order  = 8,
                        values = RBT.Constants.ReportChannel,
                        get    = function(self)
                            return RBT.db.char.reportChannel
                        end,
                        set    = function(self, v)
                            RBT.db.char.reportChannel = v
                        end
                    },
                    refresh_rate           = {
                        name      = L["Raid buffs data refresh rate"],
                        type      = "range",
                        min       = 0.1,
                        max       = 5.0,
                        softMin   = 0.2,
                        --softMax = 5.0
                        step      = 0.1,
                        bigStep   = 0.2,
                        order     = 9,
                        get       = function(self) return RBT.db.char.refresh_rate end,
                        set       = function(self, v)
                            RBT.db.char.refresh_rate = v
                        end,
                        isPercent = false,
                    },
                    --@debug@
                    debug_group            = {
                        type   = "group",
                        name   = "Debug options",
                        inline = true,
                        order  = 20,
                        args   = {
                            logging           = {
                                name  = "Addon logging",
                                type  = "toggle",
                                desc  = "Activate Logging",
                                order = 6,
                                get   = function(self)
                                    return RBT.db.char.logging
                                end,
                                set   = function(self, v)
                                    RBT.db.char.logging = v
                                    if not v then
                                        RBT.db.char.mem_profiling = false
                                        RBT:SetLogLevel(LoggingLib.INACTIVE)
                                    end
                                end
                            },
                            mem_profiling     = {
                                name  = "Addon memory profiling (depends on logging)",
                                type  = "toggle",
                                desc  = "Activate Logging",
                                order = 6,
                                get   = function(self)
                                    return RBT.db.char.mem_profiling
                                end,
                                set   = function(self, v)
                                    RBT.db.char.mem_profiling = v
                                end
                            },
                            addonLoggerConfig = {
                                name   = L["Addon logging level"],
                                type   = "select",
                                desc   = "Log level threshold",
                                order  = 6,
                                --values = RBT.Constants.LoggingConfig,
                                values = LoggingLib.logging_level_to_string,
                                get    = function(self)
                                    return RBT.db.char.logLevel
                                end,
                                set    = function(self, v)
                                    RBT:SetLogLevel(v)
                                    RBT.db.char.logLevel = v
                                end
                            },
                        },
                    },
                    --@end-debug@

                }
            }
        }
    }
    --local root_conf           = config_buff_groups.args
    --local root_conf           = options.args -- .buff_groups.args
    local category_conf
    local order               = 1
    local no_sub_cat_infos    = nil
    local sub_categories_conf = nil
    local sub_cat_infos       = nil
    local sub_order           = 1
    local sub_group_name      = nil
    for upper_category, upper_category_data in pairs(RBT.OptionBarNames) do
        options.args[upper_category] = {
            name  = upper_category,
            desc  = upper_category,
            type  = "group",
            --childGroups = "tree",
            order = order,
            args  = {},
        }

        no_sub_cat_infos             = nil
        sub_categories_conf          = nil
        sub_order                    = 1
        for sub_data_key, sub_data_value in pairs(upper_category_data) do
            sub_group_name = nil
            if sub_data_key == sub_data_value then
                if not no_sub_cat_infos then
                    no_sub_cat_infos = {}
                end
                -- fill a legacy category [key,val] dict for options
                no_sub_cat_infos[sub_data_key] = sub_data_value
            elseif type(sub_data_value) == "table" then
                sub_group_name = sub_data_key
                print(format("SubGroup name: %s", sub_group_name))
                options.args[upper_category].args[sub_group_name] = {
                    type   = "multiselect",
                    name   = sub_group_name,
                    --desc   = "",
                    order  = sub_order,
                    values = sub_data_value,
                    get    = function(self, bar)
                        return not RBT.db.char.deactivatedBars[bar]
                    end,
                    set    = function(self, bar, value)
                        RBT.db.char.deactivatedBars[bar] = not value
                        RBT:UpdateBars()
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
                order  = 1,
                values = no_sub_cat_infos,
                get    = function(self, bar)
                    return not RBT.db.char.deactivatedBars[bar]
                end,
                set    = function(self, bar, value)
                    RBT.db.char.deactivatedBars[bar] = not value
                    RBT:UpdateBars()
                end
            }
        end
        order = order + 1
    end
    return options
end

function RBT:ChatCommand(input)
    if not input or input:trim() == "" then
        InterfaceOptionsFrame_OpenToCategory(
                RBT.optFrames.ReturnBuffTracker)
        -- Workaround: https://www.wowinterface.com/forums/showthread.php?t=54599
        InterfaceOptionsFrame_OpenToCategory(
                RBT.optFrames.ReturnBuffTracker)
    else
        LibStub("AceConfigCmd-3.0").HandleCommand(RBT,
                                                  "ReturnBuffTracker",
                                                  "ReturnBuffTracker",
                                                  input)
    end
end

function RBT:SetupOptions()
    RBT.optFrames = {}
    options       = getOptions()
    --ACR:RegisterOptionsTable("ReturnBuffTracker", getOptions)
    ACR:RegisterOptionsTable("ReturnBuffTracker", getOptions)
    RBT.optFrames.ReturnBuffTracker = ACD:AddToBlizOptions("ReturnBuffTracker",
                                                           "Return Buff Tracker",
                                                           nil, "general")

    local menu_option_name
    for upper_category, _ in pairs(RBT.OptionBarNames) do
        menu_option_name = "ReturnBuffTracker-" .. upper_category
        AC:RegisterOptionsTable(menu_option_name, options.args[upper_category])
        ACD:AddToBlizOptions(menu_option_name, options.args[upper_category].name, "Return Buff Tracker")
    end

    RBT:RegisterChatCommand("ReturnBuffTracker", "ChatCommand")
    RBT:RegisterChatCommand("rbt", "ChatCommand")
end
