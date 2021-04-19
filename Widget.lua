local addonName, T      = ...;
local ReturnBuffTracker = LibStub("AceAddon-3.0"):GetAddon("ReturnBuffTracker")
--local AceGUI            = LibStub("AceGUI-3.0")
local L                 = LibStub("AceLocale-3.0"):GetLocale("ReturnBuffTracker")
local GameTooltip       = GameTooltip
local gsub, format      = gsub, format
local IsShiftKeyDown    = IsShiftKeyDown
local SendChatMessage   = SendChatMessage
local CreateFrame       = CreateFrame
local UIParent          = UIParent
local floor             = floor
-- taken from NWB
--Strip escape strings from chat msgs.
local function stripColors(str)
    local escapes = {
        ["|c%x%x%x%x%x%x%x%x"] = "", --Color start.
        ["|r"]                 = "", --Color end.
        --["|H.-|h(.-)|h"] = "%1", --Links.
        ["|T.-|t"]             = "", --Textures.
        --["{.-}"]               = "", --Raid target icons.
    };
    if (str) then
        for k, v in pairs(escapes) do
            str = gsub(str, k, v);
        end
    end
    return str;
end

local function stripSymbols(str)
    local escapes = {
        ["{.-}"] = "", --Raid target icons.
    };
    if (str) then
        for k, v in pairs(escapes) do
            str = gsub(str, k, v);
        end
    end
    return str;
end

local default_bar_height = 14

--function ReturnBuffTracker:CreateMainFrame()
--    local frame = AceGUI:Create("Window")
--    --local frame = AceGUI:Create("SimpleGroup")
--    frame:SetTitle("ReturnBuffTracker")
--    --frame:SetMinResize(100,50)
--    frame:SetLayout("List")
--    frame:SetWidth(180)
--    --frame:SetHeight(80)
--    --frame:SetAutoAdjustHeight(true)
--    --frame:SetResizable(false)
--    frame:EnableResize(false)
--    frame.closebutton:Hide()
--    ReturnBuffTracker.mainFrame = frame
--    ReturnBuffTracker.mainFrame:Show()
--end


--function ReturnBuffTracker:CreateBuffInfoBar(buff)
--    local button = AceGUI:Create("Icon")
--
--    --button:SetDisabled(true)
--    button:SetHeight(12)
--    button:SetWidth(115)
--    button:SetCallback("OnClick", function() print("Click!") end)
--
--    --button.text:ClearAllPoints()
--    button.text = nil
--    button.text = button.frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
--    button.text:SetPoint("LEFT", button.frame, "LEFT")
--    button:SetText(buff.optionText or buff.text or buff.shortName or "FOOOOO?")
--
--    button.right_text = button.frame:GetFontString()
--    button.right_text:ClearAllPoints()
--    button.right_text:SetPoint("RIGHT", button.frame, "RIGHT")
--    button.right_text:SetText("TBD %")
--
--    ReturnBuffTracker.mainFrame:AddChild(button)
--    ReturnBuffTracker.mainFrame:DoLayout()
--end



function ReturnBuffTracker:CreateMainFrame()
    local theFrame = CreateFrame("Frame", "ReturnBuffTrackerUI", UIParent)

    theFrame:ClearAllPoints()
    if ReturnBuffTracker.db.profile.position then
        theFrame:SetPoint("BOTTOMLEFT", ReturnBuffTracker.db.profile.position.x, ReturnBuffTracker.db.profile.position.y)
    else
        theFrame:SetPoint("CENTER", UIParent)
    end

    --theFrame:SetHeight(80)
    theFrame:SetWidth(ReturnBuffTracker.db.profile.width)
    --theFrame:SetMinResize(100, 0)
    --theFrame:SetMaxResize(1000, 1000)

    theFrame:SetFrameStrata("BACKGROUND")
    theFrame:SetBackdrop({
                             bgFile   = "Interface\\DialogFrame\\UI-DialogBox-Background",
                             tile     = true,
                             tileSize = 16,
                             edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
                             edgeSize = 16,
                             insets   = { left = 4, right = 4, top = 4, bottom = 4 },
                         })
    theFrame:SetBackdropBorderColor(1.0, 1.0, 1.0)
    theFrame:SetBackdropColor(24 / 255, 24 / 255, 24 / 255)

    theFrame:EnableMouse(true)
    theFrame:SetMovable(true)
    theFrame:SetClampedToScreen(true)
    theFrame:SetResizable(true)

    local resizeButton = CreateFrame("Button", nil, theFrame)
    resizeButton:SetSize(16, 16)
    resizeButton:SetPoint("BOTTOMRIGHT")
    resizeButton:SetNormalTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Up")
    resizeButton:SetHighlightTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Highlight")
    resizeButton:SetPushedTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Down")

    -- use hooks instead ?
    resizeButton:SetScript("OnMouseDown", function(self, button)
        theFrame:StartSizing("RIGHT")
        theFrame:SetUserPlaced(true)
    end)
    resizeButton:SetScript("OnMouseUp", function(self, button)
        theFrame:StopMovingOrSizing()
        ReturnBuffTracker.db.profile.width = theFrame:GetWidth()
    end)

    theFrame:SetScript("OnMouseDown", function(self) self:StartMoving() end)
    theFrame:SetScript("OnMouseUp", function(self)
        self:StopMovingOrSizing()
        if not ReturnBuffTracker.db.profile.position then
            ReturnBuffTracker.db.profile.position = {}
        end
        ReturnBuffTracker.db.profile.position.x = theFrame:GetLeft()
        ReturnBuffTracker.db.profile.position.y = theFrame:GetBottom()
    end)

    theFrame:Show()
    ReturnBuffTracker.mainFrame = theFrame
end

function ReturnBuffTracker:SetNumberOfBarsToDisplay(numOfBars)
    numOfBars = numOfBars - 1
    if numOfBars <= 0 then numOfBars = 0 end
    local height = 5 + 16 + (numOfBars * default_bar_height) + 5
    ReturnBuffTracker.mainFrame:SetHeight(height)
end

--function ReturnBuffTracker:CreateHeaderBar(text, r, g, b)
--    local theBar              = CreateFrame("Frame", text, ReturnBuffTracker.mainFrame)
--    theBar.buffNameTextString = theBar:CreateFontString(nil, "OVERLAY", "GameFontNormal")
--    theBar.buffNameTextString:SetPoint("CENTER", ReturnBuffTracker.mainFrame, "TOP", 0, -7)
--    theBar.buffNameTextString:SetText(text)
--end

function ReturnBuffTracker:CreateBuffInfoBar(buff_index, buff)
    -- text, r, g, b)
    local theBar = CreateFrame("Frame", text, ReturnBuffTracker.mainFrame)
    --theBar.text  = text
    theBar.buff  = buff

    theBar:SetHeight(default_bar_height)
    theBar:SetWidth(120)
    theBar:SetPoint("TOPLEFT", ReturnBuffTracker.mainFrame, "TOPLEFT", 5, -5)

    theBar.texture = theBar:CreateTexture(nil, "BACKGROUND")
    theBar.texture:SetPoint("TOPLEFT", theBar, "TOPLEFT")
    theBar.texture:SetColorTexture(buff.color.r, buff.color.g, buff.color.b, 0.9)
    theBar.texture:SetHeight(default_bar_height)
    theBar.texture:Hide()

    theBar.buffNameTextString = theBar:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    --theBar.textString:SetPoint("CENTER", ReturnBuffTracker.mainFrame, "TOP", 0, -7)
    --theBar.buffNameTextString:SetPoint("LEFT", ReturnBuffTracker.mainFrame, "TOP", 0, -7)
    theBar.buffNameTextString:SetPoint("LEFT", theBar, "LEFT")
    theBar.buffNameTextString:SetText(buff.displayText)

    theBar.percentTextString = theBar:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    theBar.percentTextString:SetPoint("RIGHT", theBar, "RIGHT")
    --theBar.percentTextString:SetText(text)


    theBar.SetIndex = function(self, index)
        if index then
            theBar:Show()
            theBar:SetPoint("TOPLEFT", ReturnBuffTracker.mainFrame, "TOPLEFT", 5, -5 - (index * default_bar_height))
            --theBar.texture:SetPoint("TOPLEFT", ReturnBuffTracker.mainFrame, "TOPLEFT", 5, -5 - (index * 16))
            --theBar.buffNameTextString:SetPoint("TOP", theBar, "TOP", 0, -7 - (index * 16))
            --theBar.percentTextString:SetPoint("RIGHT", theBar, "RIGHT", 0, 0)
        else
            theBar:Hide()
        end
    end

    theBar.Update   = function(self)
        --, value, maxValue, tooltip_lines)
        local percentage = buff.count / buff.total
        local totalWidth = ReturnBuffTracker.mainFrame:GetWidth() - 10

        if theBar.buff.shortName and theBar.buff.shortName == L["DMF Damage"] then
            local DMF_specific = { [true] = "active", [false] = "inactive" }
            local is_active    = ReturnBuffTracker:isDMFActive()
            local tmp          = format("%s (%s)", theBar.buff.shortName, DMF_specific[is_active])
            theBar.texture:SetColorTexture(0.1, 0.1, 0.1, 1.0)
            theBar.buffNameTextString:SetText(tmp)
            percentage = 1.0
        end

        local width = floor(totalWidth * percentage)
        if width > 0 then
            theBar.texture:SetWidth(totalWidth * percentage)
            theBar.texture:Show()
        else
            theBar.texture:Hide()
        end

        theBar:SetWidth(totalWidth)
        --theBar.tooltip_lines = theBar.buff.tooltip -- tooltip_lines
        --theBar.percentTextString:SetText(format("%.0f%%", ((value / maxValue) * 100.0)))
        if percentage ~= percentage then
            theBar.percentTextString:SetText("NA")
        else
            theBar.percentTextString:SetText(format("%.0f%%", percentage * 100.0))
        end

    end

    theBar:SetScript("OnEnter", function(self)
        --GameTooltip:AddLine("Missing " .. self.text .. ": ", 1, 1, 1)
        GameTooltip:AddLine(format(L["Missing %s"], self.buff.displayText), 1, 1, 1)
        --if self.tooltip_lines then
        if self.buff.tooltip then
            GameTooltip:SetOwner(self, "ANCHOR_CURSOR")
            --for k, v in ipairs(self.tooltip_lines) do
            for k, v in ipairs(self.buff.tooltip) do
                GameTooltip:AddLine(v, 1, 1, 1)
            end
            GameTooltip:Show()
        end
    end)
    theBar:SetScript("OnLeave", function(self)
        GameTooltip:Hide()
    end)

    theBar:SetScript("OnMouseDown", function(self)
        local shift_key = IsShiftKeyDown()
        if shift_key then
        else
            ReturnBuffTracker.mainFrame:StartMoving()
        end
    end)
    theBar:SetScript("OnMouseUp", function(self)
        local shift_key = IsShiftKeyDown()
        local tmp_str
        if shift_key then
            --DEFAULT_CHAT_FRAME:AddMessage("Missing " .. self.text .. ": ")
            --if self.tooltip_lines then
            if self.buff.tooltip then
                --for k, v in ipairs(self.tooltip_lines) do
                for k, v in ipairs(self.buff.tooltip) do
                    tmp_str = stripColors(v)
                    SendChatMessage(tmp_str, ReturnBuffTracker.db.profile.reportChannel)
                end
            end
        else
            ReturnBuffTracker.mainFrame:StopMovingOrSizing()
            if not ReturnBuffTracker.db.profile.position then
                ReturnBuffTracker.db.profile.position = {}
            end
            ReturnBuffTracker.db.profile.position.x = ReturnBuffTracker.mainFrame:GetLeft()
            ReturnBuffTracker.db.profile.position.y = ReturnBuffTracker.mainFrame:GetBottom()
        end
    end)

    return theBar
end
