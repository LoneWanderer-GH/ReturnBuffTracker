local RBT          = LibStub("AceAddon-3.0"):GetAddon("ReturnBuffTracker")
local L            = LibStub("AceLocale-3.0"):GetLocale("ReturnBuffTracker")
local AC           = LibStub("AceConfig-3.0")
local ACR          = LibStub("AceConfigRegistry-3.0")
local ACD          = LibStub("AceConfigDialog-3.0")
--@debug@
local LoggingLib   = LibStub("LoggingLib-0.1")
--@end-debug@

local cat_to_order = {
    [L["General"]]      = 100,
    [L["Player buffs"]] = 200,
    [L["World"]]        = 300,
    [L["Consumables"]]  = 400,
}

local options      = nil
local function getOptions()
    if options then
        return options
    end

    options                   = {
        type = "group",
        name = "Return Buff Tracker",
        args = {
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
                    enable_disable_toggle  = {
                        name  = L["Enable"],
                        desc  = L["Activate/deactivate completly RBT"],
                        type  = "toggle",
                        order = 3,
                        get   = function(self)
                            return RBT.db.char.enabled
                        end,
                        set   = function(self, value)
                            RBT.db.char.enabled = value
                            if RBT.db.char.enabled then
                                RBT:OnEnable()
                            else
                                RBT:OnDisable()
                            end
                        end
                    },
                    resetConf              = {
                        name  = "reset Configuration",
                        desc  = "reset to default",
                        type  = "execute",
                        func  = RBT.ResetConfiguration,
                        order = 4,
                    },
                    showFrame              = {
                        name      = "Show frame",
                        desc      = "Force frame to show. Caution : it may show/hide again if you join/leave a raid depending on other options",
                        descStyle = "inline",
                        order     = 5,
                        type      = "execute",
                        func      = function() RBT.mainFrame:Show()
                        end,
                        disabled  = function() return not RBT.db.char.enabled
                        end,
                    },
                    hideFrame              = {
                        name      = "Hide frame",
                        descStyle = "inline",
                        desc      = "Force frame to hide. Caution : it may show/hide again if you join/leave a raid depending on other options",
                        order     = 6,
                        type      = "execute",
                        func      = function() RBT.mainFrame:Hide()
                        end,
                        disabled  = function() return not RBT.db.char.enabled
                        end,
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
                        order = 7,
                    },
                    hideFrameWhenNotInRaid = {
                        name     = L["Hide when not in raid"],
                        desc     = L["The buff tracker does not work outside of raids."],
                        type     = "toggle",
                        order    = 8,
                        get      = function(self)
                            return RBT.db.char.hideFrameWhenNotInRaid
                        end,
                        set      = function(self, value)
                            RBT.db.char.hideFrameWhenNotInRaid = value
                            RBT:RaidOrGroupChanged()
                        end,
                        disabled = function() return not RBT.db.char.enabled
                        end,
                    },
                    reportConfig           = {
                        name     = L["Report config"],
                        type     = "select",
                        desc     = "Report channel",
                        order    = 9,
                        values   = RBT.Constants.ReportChannel,
                        get      = function(self)
                            return RBT.db.char.reportChannel
                        end,
                        set      = function(self, v)
                            RBT.db.char.reportChannel = v
                        end,
                        disabled = function() return not RBT.db.char.enabled
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
                        order     = 10,
                        get       = function(self) return RBT.db.char.refresh_rate
                        end,
                        set       = function(self, v)
                            RBT.db.char.refresh_rate = v
                        end,
                        isPercent = false,
                        disabled  = function() return not RBT.db.char.enabled
                        end,
                    },
                    --@debug@
                    debug_group            = {
                        type     = "group",
                        name     = "Debug options",
                        inline   = true,
                        order    = 20,
                        disabled = function() return not RBT.db.char.enabled end,
                        args     = {
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
                                name     = "Addon memory profiling (depends on logging)",
                                type     = "toggle",
                                desc     = "Activate Logging",
                                order    = 6,
                                get      = function(self)
                                    return RBT.db.char.mem_profiling
                                end,
                                set      = function(self, v)
                                    RBT.db.char.mem_profiling = v
                                end,
                                disabled = function() return not RBT.db.char.enabled or not RBT.db.char.logging
                                end,
                            },
                            addonLoggerConfig = {
                                name     = L["Addon logging level"],
                                type     = "select",
                                desc     = "Log level threshold",
                                order    = 6,
                                --values = RBT.Constants.LoggingConfig,
                                values   = LoggingLib.logging_level_to_string,
                                get      = function(self)
                                    return RBT.db.char.logLevel
                                end,
                                set      = function(self, v)
                                    RBT:SetLogLevel(v)
                                    RBT.db.char.logLevel = v
                                end,
                                disabled = function() return not RBT.db.char.logging end,
                            },
                        },
                    },
                    --@end-debug@

                }
            }
        }
    }

    local no_sub_cat_infos
    local sub_order
    local sub_group_name

    RBT.OptionBarNamesOrdered = {}
    for k in pairs(RBT.OptionBarNames) do table.insert(RBT.OptionBarNamesOrdered, k) end

    --print(table.concat(RBT.OptionBarNamesOrdered, "> "))

    table.sort(RBT.OptionBarNamesOrdered, function(a, b)
        print(format("%s (%s) < %s (%s)",
                     a, cat_to_order[a],
                     b, cat_to_order[b]))
        return cat_to_order[a] < cat_to_order[b]
    end)

    --print(table.concat(RBT.OptionBarNamesOrdered, "> "))

    --for upper_category, upper_category_data in pairs(RBT.OptionBarNames) do
    local upper_category_data
    for _, upper_category in ipairs(RBT.OptionBarNamesOrdered) do
        upper_category_data          = RBT.OptionBarNames[upper_category]
        options.args[upper_category] = {
            name  = upper_category,
            desc  = upper_category,
            type  = "group",
            --childGroups = "tree",
            order = cat_to_order[upper_category],
            args  = {},
        }

        no_sub_cat_infos             = nil
        sub_order                    = 1
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
        --order = order + 1
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
    --for upper_category, _ in pairs(RBT.OptionBarNames) do
    for _, upper_category in ipairs(RBT.OptionBarNamesOrdered) do
        menu_option_name = "ReturnBuffTracker-" .. upper_category
        AC:RegisterOptionsTable(menu_option_name, options.args[upper_category])
        ACD:AddToBlizOptions(menu_option_name, options.args[upper_category].name, "Return Buff Tracker")
    end

    RBT:RegisterChatCommand("ReturnBuffTracker", "ChatCommand")
    RBT:RegisterChatCommand("rbt", "ChatCommand")
end
