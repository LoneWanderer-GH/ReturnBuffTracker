local ReturnBuffTracker = LibStub("AceAddon-3.0"):GetAddon("ReturnBuffTracker")
local L                 = LibStub("AceLocale-3.0"):GetLocale("ReturnBuffTracker")
--@debug@
local LoggingLib        = LibStub("LoggingLib-0.1")
--@end-debug@

local options           = nil
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
                        func = ReturnBuffTracker.ResetConfiguration,
                    },
                    --set_my_class_only    = {
                    --    name = "my class only",
                    --    desc = "only select buffs applicable to my class",
                    --    type = "execute",
                    --    func = ReturnBuffTracker.ActivatePlayerClassOnly,
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
                            return ReturnBuffTracker.db.profile.hideNotInRaid
                        end,
                        set   = function(self, value)
                            ReturnBuffTracker.db.profile.hideNotInRaid = value
                            ReturnBuffTracker:CheckHideIfNotInRaid()
                        end
                    },
                    reportConfig         = {
                        name   = L["Report config"],
                        type   = "select",
                        desc   = "Report channel",
                        order  = 6,
                        values = ReturnBuffTracker.Constants.ReportChannel,
                        get    = function(self)
                            return ReturnBuffTracker.db.profile.reportChannel
                        end,
                        set    = function(self, v)
                            ReturnBuffTracker.db.profile.reportChannel = v
                        end
                    },
                    --@debug@
                    addonLoggerConfig    = {
                        name   = L["Addon logging level"],
                        type   = "select",
                        desc   = "Log level threshold",
                        order  = 6,
                        --values = ReturnBuffTracker.Constants.LoggingConfig,
                        values = LoggingLib.logging_level_to_string,
                        get    = function(self)
                            return ReturnBuffTracker.db.profile.logLevel
                        end,
                        set    = function(self, v)
                            ReturnBuffTracker.db.profile.logLevel = v
                        end

                    },
                    --@end-debug@
                    headerBars           = {
                        name  = L["Bars to show"],
                        type  = "header",
                        width = "double",
                        order = 4
                    },
                    generalBuffs         = {
                        name  = L["General Buffs"],
                        type  = "group",
                        order = 5,
                        args  = {
                            bars = {
                                type   = "multiselect",
                                name   = "",
                                desc   = "",
                                order  = 6,
                                values = ReturnBuffTracker.OptionBarNames[L["General"]],
                                get    = function(self, bar)
                                    return not ReturnBuffTracker.db.profile.deactivatedBars[bar]
                                end,
                                set    = function(self, bar, value)
                                    ReturnBuffTracker.db.profile.deactivatedBars[bar] = not value
                                    ReturnBuffTracker:UpdateBars()
                                end
                            },
                        },
                        --check_all = {
                        --    name = "check all",
                        --    desc = "check all buffs",
                        --    type = "execute",
                        --    func = function()
                        --        for bar, value in pairs(ReturnBuffTracker.OptionBarNames[L["General"]]) do
                        --            ReturnBuffTracker.db.profile.deactivatedBars[bar] = false
                        --        end
                        --        ReturnBuffTracker:UpdateBars()
                        --    end,
                        --},
                        --uncheck_all = {
                        --    name = "uncheck all",
                        --    desc = "uncheck all buffs",
                        --    type = "execute",
                        --    func = function()
                        --        for bar, value in pairs(ReturnBuffTracker.OptionBarNames[L["General"]]) do
                        --            ReturnBuffTracker.db.profile.deactivatedBars[bar] = true
                        --        end
                        --        ReturnBuffTracker:UpdateBars()
                        --    end,
                        --},

                    },
                    playerBuffs          = {
                        name  = L["Player buffs"],
                        type  = "group",
                        order = 6,
                        args  = {

                            bars = {
                                type   = "multiselect",
                                name   = "",
                                desc   = "",
                                order  = 6,
                                values = ReturnBuffTracker.OptionBarNames[L["Player buffs"]],
                                get    = function(self, bar)
                                    return not ReturnBuffTracker.db.profile.deactivatedBars[bar]
                                end,
                                set    = function(self, bar, value)
                                    ReturnBuffTracker.db.profile.deactivatedBars[bar] = not value
                                    ReturnBuffTracker:UpdateBars()
                                end
                            },
                        }
                    },
                    worldBuffs           = {
                        name  = L["World Buffs"],
                        type  = "group",
                        order = 7,
                        args  = {

                            bars = {
                                type   = "multiselect",
                                name   = "",
                                desc   = "",
                                order  = 6,
                                values = ReturnBuffTracker.OptionBarNames[L["World"]],
                                get    = function(self, bar)
                                    return not ReturnBuffTracker.db.profile.deactivatedBars[bar]
                                end,
                                set    = function(self, bar, value)
                                    ReturnBuffTracker.db.profile.deactivatedBars[bar] = not value
                                    ReturnBuffTracker:UpdateBars()
                                end
                            },
                        }
                    },
                    consumables          = {
                        name  = L["Consumables"],
                        type  = "group",
                        order = 8,
                        args  = {

                            bars = {
                                type   = "multiselect",
                                name   = "",
                                desc   = "",
                                order  = 6,
                                values = ReturnBuffTracker.OptionBarNames[L["Consumable"]],
                                get    = function(self, bar) return not ReturnBuffTracker.db.profile.deactivatedBars[bar]
                                end,
                                set    = function(self, bar, value)
                                    ReturnBuffTracker.db.profile.deactivatedBars[bar] = not value
                                    ReturnBuffTracker:UpdateBars()
                                end
                            },
                        }
                    }

                }
            }
        }
    }

    return options
end

function ReturnBuffTracker:ChatCommand(input)
    if not input or input:trim() == "" then
        InterfaceOptionsFrame_OpenToCategory(
                ReturnBuffTracker.optFrames.ReturnBuffTracker)
        -- Workaround: https://www.wowinterface.com/forums/showthread.php?t=54599
        InterfaceOptionsFrame_OpenToCategory(
                ReturnBuffTracker.optFrames.ReturnBuffTracker)
    else
        LibStub("AceConfigCmd-3.0").HandleCommand(ReturnBuffTracker,
                                                  "ReturnBuffTracker",
                                                  "ReturnBuffTracker", input)
    end
end

function ReturnBuffTracker:SetupOptions()
    ReturnBuffTracker.optFrames = {}
    LibStub("AceConfigRegistry-3.0"):RegisterOptionsTable("ReturnBuffTracker",
                                                          getOptions)
    ReturnBuffTracker.optFrames.ReturnBuffTracker = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("ReturnBuffTracker",
                                                                                                    "Return Buff Tracker",
                                                                                                    nil, "general")
    ReturnBuffTracker:RegisterChatCommand("ReturnBuffTracker", "ChatCommand")
    ReturnBuffTracker:RegisterChatCommand("rbt", "ChatCommand")
end
