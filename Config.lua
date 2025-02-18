local RBT        = LibStub("AceAddon-3.0"):GetAddon("ReturnBuffTracker")
local L          = LibStub("AceLocale-3.0"):GetLocale("ReturnBuffTracker")
--@debug@
local LoggingLib = LibStub("LoggingLib-0.1")
--@end-debug@

local options    = nil
local function getOptions()
    if options then return options end

    options = {
        type = "group",
        name = "Return Buff Tracker",
        args = {
            general = {
                type   = "group",
                name   = L["General"],
                inline = true,
                args   = {
                    description          = {
                        name        = "",
                        type        = "description",
                        image       = "Interface\\AddOns\\ReturnBuffTracker\\media\\return",
                        imageWidth  = 64,
                        imageHeight = 64,
                        width       = "half",
                        order       = 1
                    },
                    descriptiontext      = {
                        --name  = L["Return Buff Tracker by Irpa\nDiscord: https://discord.gg/SZYAKFy\nGithub: https://github.com/zorkqz/ReturnBuffTracker\n"],
                        name  = "Return Buff Tracker by Irpa - Enhanced by LoneWanderer-GH",
                        type  = "description",
                        width = "full",
                        order = 1
                    },
                    resetConf            = {
                        name = "reset Configuration",
                        desc = "reset to default",
                        type = "execute",
                        func = RBT.ResetConfiguration,
                    },
                    --set_my_class_only    = {
                    --    name = "my class only",
                    --    desc = "only select buffs applicable to my class",
                    --    type = "execute",
                    --    func = RBT.ActivatePlayerClassOnly,
                    --},
                    headerGlobalSettings = {
                        name  = L["Global Settings"],
                        type  = "header",
                        width = "double",
                        order = 2
                    },
                    hideNotInRaid        = {
                        name  = L["Hide when not in raid"],
                        desc  = L["The buff tracker does not work outside of raids."],
                        type  = "toggle",
                        order = 3,
                        get   = function(self)
                            return RBT.db.profile.hideNotInRaid
                        end,
                        set   = function(self, value)
                            RBT.db.profile.hideNotInRaid = value
                            RBT:CheckVisible()
                        end
                    },
                    reportConfig         = {
                        name   = L["Report config"],
                        type   = "select",
                        desc   = "Report channel",
                        order  = 6,
                        values = RBT.Constants.ReportChannel,
                        get    = function(self)
                            return RBT.db.profile.reportChannel
                        end,
                        set    = function(self, v)
                            RBT.db.profile.reportChannel = v
                        end
                    },
                    --@debug@
                    debug_group          = {
                        type   = "group",
                        name   = "Debug options",
                        inline = true,
                        args   = {
                            logging           = {
                                name  = "Addon logging",
                                type  = "toggle",
                                desc  = "Activate Logging",
                                order = 6,
                                get   = function(self)
                                    return RBT.db.profile.logging
                                end,
                                set   = function(self, v)
                                    RBT.db.profile.logging = v
                                    if not v then
                                        RBT.db.profile.mem_profiling = false
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
                                    return RBT.db.profile.mem_profiling
                                end,
                                set   = function(self, v)
                                    RBT.db.profile.mem_profiling = v
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
                                    return RBT.db.profile.logLevel
                                end,
                                set    = function(self, v)
                                    RBT:SetLogLevel(v)
                                    RBT.db.profile.logLevel = v
                                end
                            },
                        },
                    },
                    --@end-debug@
                    buff_groups          = {
                        type        = "group",
                        name        = L["Bars to show"],
                        inline      = true,
                        childGroups = "tab",
                        args        = {
                            --headerBars   = {
                            --    name  = L["Bars to show"],
                            --    type  = "header",
                            --    width = "double",
                            --    order = 4
                            --},
                            generalBuffs = {
                                name  = L["General Buffs"],
                                type  = "group",
                                order = 5,
                                args  = {
                                    bars = {
                                        type   = "multiselect",
                                        name   = "",
                                        desc   = "",
                                        order  = 6,
                                        values = RBT.OptionBarNames[L["General"]],
                                        get    = function(self, bar)
                                            return not RBT.db.profile.deactivatedBars[bar]
                                        end,
                                        set    = function(self, bar, value)
                                            RBT.db.profile.deactivatedBars[bar] = not value
                                            RBT:UpdateBars()
                                        end
                                    },
                                },
                                --check_all = {
                                --    name = "check all",
                                --    desc = "check all buffs",
                                --    type = "execute",
                                --    func = function()
                                --        for bar, value in pairs(RBT.OptionBarNames[L["General"]]) do
                                --            RBT.db.profile.deactivatedBars[bar] = false
                                --        end
                                --        RBT:UpdateBars()
                                --    end,
                                --},
                                --uncheck_all = {
                                --    name = "uncheck all",
                                --    desc = "uncheck all buffs",
                                --    type = "execute",
                                --    func = function()
                                --        for bar, value in pairs(RBT.OptionBarNames[L["General"]]) do
                                --            RBT.db.profile.deactivatedBars[bar] = true
                                --        end
                                --        RBT:UpdateBars()
                                --    end,
                                --},

                            },
                            playerBuffs  = {
                                name  = L["Player buffs"],
                                type  = "group",
                                order = 6,
                                args  = {

                                    bars = {
                                        type   = "multiselect",
                                        name   = "",
                                        desc   = "",
                                        order  = 6,
                                        values = RBT.OptionBarNames[L["Player buffs"]],
                                        get    = function(self, bar)
                                            return not RBT.db.profile.deactivatedBars[bar]
                                        end,
                                        set    = function(self, bar, value)
                                            RBT.db.profile.deactivatedBars[bar] = not value
                                            RBT:UpdateBars()
                                        end
                                    },
                                }
                            },
                            worldBuffs   = {
                                name  = L["World Buffs"],
                                type  = "group",
                                order = 7,
                                args  = {

                                    bars = {
                                        type   = "multiselect",
                                        name   = "",
                                        desc   = "",
                                        order  = 6,
                                        values = RBT.OptionBarNames[L["World"]],
                                        get    = function(self, bar)
                                            return not RBT.db.profile.deactivatedBars[bar]
                                        end,
                                        set    = function(self, bar, value)
                                            RBT.db.profile.deactivatedBars[bar] = not value
                                            RBT:UpdateBars()
                                        end
                                    },
                                }
                            },
                            consumables  = {
                                name  = L["Consumables"],
                                type  = "group",
                                order = 8,
                                args  = {

                                    bars = {
                                        type   = "multiselect",
                                        name   = "",
                                        desc   = "",
                                        order  = 6,
                                        values = RBT.OptionBarNames[L["Consumable"]],
                                        get    = function(self, bar) return not RBT.db.profile.deactivatedBars[bar]
                                        end,
                                        set    = function(self, bar, value)
                                            RBT.db.profile.deactivatedBars[bar] = not value
                                            RBT:UpdateBars()
                                        end
                                    },
                                }
                            }
                        }
                    }
                }
            }
        }
    }

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
        LibStub("AceConfigCmd-3.0").HandleCommand(ReturnBuffTracker,
                                                  "ReturnBuffTracker",
                                                  "ReturnBuffTracker", input)
    end
end

function RBT:SetupOptions()
    RBT.optFrames = {}
    LibStub("AceConfigRegistry-3.0"):RegisterOptionsTable("ReturnBuffTracker",
                                                          getOptions)
    RBT.optFrames.ReturnBuffTracker = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("ReturnBuffTracker",
                                                                                      "Return Buff Tracker",
                                                                                      nil, "general")
    RBT:RegisterChatCommand("ReturnBuffTracker", "ChatCommand")
    RBT:RegisterChatCommand("rbt", "ChatCommand")
end
