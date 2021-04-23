local addonName, T    = ...;
local RBT             = LibStub("AceAddon-3.0"):GetAddon("ReturnBuffTracker")
--local AceGUI            = LibStub("AceGUI-3.0")
local L               = LibStub("AceLocale-3.0"):GetLocale("ReturnBuffTracker")
local GameTooltip     = GameTooltip
local gsub, format    = gsub, format
local IsShiftKeyDown  = IsShiftKeyDown
local SendChatMessage = SendChatMessage
local CreateFrame     = CreateFrame
local UIParent        = UIParent
local floor           = floor
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

--function RBT:CreateMainFrame()
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
--    RBT.mainFrame = frame
--    RBT.mainFrame:Show()
--end


--function RBT:CreateBuffInfoBar(buff)
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
--    RBT.mainFrame:AddChild(button)
--    RBT.mainFrame:DoLayout()
--end



function RBT:CreateMainFrame()
    local theFrame          = CreateFrame("Frame", "ReturnBuffTrackerUI", UIParent)
    RBT.mainFrame           = theFrame
    RBT.mainFrame.buff_bars = {}

    theFrame:ClearAllPoints()
    if RBT.db.char.position then
        theFrame:SetPoint("BOTTOMLEFT", RBT.db.char.position.x, RBT.db.char.position.y)
    else
        theFrame:SetPoint("CENTER", UIParent)
    end

    --theFrame:SetHeight(80)
    theFrame:SetWidth(RBT.db.char.width)
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
        RBT.db.char.width = theFrame:GetWidth()
        --local totalWidth     = theFrame:GetWidth() - 10
        for _, b in ipairs(theFrame.buff_bars) do
            b:UpdateWidth()
        end
    end)

    theFrame:SetScript("OnMouseDown", function(self) self:StartMoving() end)
    theFrame:SetScript("OnMouseUp", function(self)
        self:StopMovingOrSizing()
        if not RBT.db.char.position then
            RBT.db.char.position = {}
        end
        RBT.db.char.position.x = theFrame:GetLeft()
        RBT.db.char.position.y = theFrame:GetBottom()
        --local totalWidth          = theFrame:GetWidth() - 10
        for _, b in ipairs(theFrame.buff_bars) do
            b:UpdateWidth()
        end
    end)

    theFrame:Show()

end

function RBT:SetNumberOfBarsToDisplay(numOfBars)
    numOfBars = numOfBars - 1
    if numOfBars <= 0 then numOfBars = 0 end
    local height = 5 + 16 + (numOfBars * default_bar_height) + 5
    RBT.mainFrame:SetHeight(height)
end

--function RBT:CreateHeaderBar(text, r, g, b)
--    local theBar              = CreateFrame("Frame", text, RBT.mainFrame)
--    theBar.buffNameTextString = theBar:CreateFontString(nil, "OVERLAY", "GameFontNormal")
--    theBar.buffNameTextString:SetPoint("CENTER", RBT.mainFrame, "TOP", 0, -7)
--    theBar.buffNameTextString:SetText(text)
--end
--local DMF_specific = { [true] = "active", [false] = "inactive" }
function RBT:CreateBuffInfoBar(buff_index, buff)
    -- text, r, g, b)
    local theBar = CreateFrame("Frame", nil, RBT.mainFrame)
    --theBar.text  = text
    theBar.buff  = buff

    theBar:SetHeight(default_bar_height)
    theBar:SetWidth(RBT.mainFrame:GetWidth() - 10)
    theBar:SetPoint("TOPLEFT", RBT.mainFrame, "TOPLEFT", 5, -5)

    theBar.texture = theBar:CreateTexture(nil, "BACKGROUND")
    theBar.texture:SetPoint("TOPLEFT", theBar, "TOPLEFT")
    theBar.texture:SetColorTexture(buff.color.r, buff.color.g, buff.color.b, 0.9)
    theBar.texture:SetHeight(default_bar_height)
    theBar.texture:Hide()
    theBar.texture:SetParent(theBar)

    theBar.buffNameTextString = theBar:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    --theBar.textString:SetPoint("CENTER", RBT.mainFrame, "TOP", 0, -7)
    --theBar.buffNameTextString:SetPoint("LEFT", RBT.mainFrame, "TOP", 0, -7)
    theBar.buffNameTextString:SetPoint("LEFT", theBar, "LEFT")
    theBar.buffNameTextString:SetText(buff.displayText)
    theBar.buffNameTextString:SetParent(theBar)

    theBar.percentTextString = theBar:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    theBar.percentTextString:SetPoint("RIGHT", theBar, "RIGHT")
    theBar.percentTextString:SetParent(theBar)
    --theBar.percentTextString:SetText(text)


    theBar.SetIndex    = function(self, index)
        if index then
            theBar:Show()
            theBar:SetPoint("TOPLEFT", RBT.mainFrame, "TOPLEFT", 5, -5 - (index * default_bar_height))
            --theBar.texture:SetPoint("TOPLEFT", RBT.mainFrame, "TOPLEFT", 5, -5 - (index * 16))
            --theBar.buffNameTextString:SetPoint("TOP", theBar, "TOP", 0, -7 - (index * 16))
            --theBar.percentTextString:SetPoint("RIGHT", theBar, "RIGHT", 0, 0)
        else
            theBar:Hide()
        end
    end

    theBar.UpdateWidth = function(self)
        local w = RBT.mainFrame:GetWidth() - 10
        if self.percentage_float then
            if self.percentage_float > 0.1 then
                self.texture:SetWidth(w * self.percentage_float)
                self.texture:Show()
            else
                self.texture:Hide()
            end
        else
            self.texture:Hide()
        end
        self:SetWidth(w)
    end

    theBar.Update      = function(self)
        --, value, maxValue, tooltip_lines)
        --local percentage = buff.count / buff.total
        local percentage_str, percentage_float = RBT:compute_percent_string(self.buff.count, self.buff.total)
        self.percentage_float = percentage_float
        self.percentage_str   = percentage_str
        --local totalWidth                       = RBT.mainFrame:GetWidth() - 10
        self.buff:SpecialBarDisplay()
        --if self.buff.shortName and self.buff.shortName == L["DMF Damage"] then
        --    local is_active = RBT:isDMFActive()
        --    local tmp       = format("%s (%s)", self.buff.shortName, DMF_specific[is_active])
        --    self.texture:SetColorTexture(0.1, 0.1, 0.1, 1.0)
        --    self.buffNameTextString:SetText(tmp)
        --    self.percentage_str = "0%"
        --elseif self.displayText == L["Loot Method"] then
        --
        --end

        self:UpdateWidth()
        --if percentage_float then
        --    self.percentage_float = percentage_float
        --    local width           = floor(totalWidth * percentage_float)
        --    if width > 0 then
        --        self.texture:SetWidth(totalWidth * percentage_float)
        --        self.texture:Show()
        --    else
        --        self.texture:Hide()
        --    end
        --else
        --    self.texture:Hide()
        --end
        --self:SetWidth(totalWidth)

        --self.tooltip_lines = theBar.buff.tooltip -- tooltip_lines
        --theBar.percentTextString:SetText(format("%.0f%%", ((value / maxValue) * 100.0)))
        --if percentage ~= percentage then
        --    theBar.percentTextString:SetText("NA")
        --else
        --    theBar.percentTextString:SetText(format("%.0f%%", percentage * 100.0))
        --end

        self.percentTextString:SetText(self.percentage_str)
    end

    --theBar:SetScript("OnUpdate", function(self, ...)
    --    --local totalWidth                       = RBT.mainFrame:GetWidth() - 10
    --    --self.percentTextString:SetText(self.percentTextString:GetText())
    --    local totalWidth = RBT.mainFrame:GetWidth() - 10
    --    self:SetWidth(totalWidth)
    --end)

    theBar:SetScript("OnEnter", function(self)
        --GameTooltip:AddLine("Missing " .. self.text .. ": ", 1, 1, 1)
        GameTooltip:AddLine(format("%s %s", L["Missing"], self.buff.displayText), 1, 1, 1)
        --if self.tooltip_lines then
        --self.buff:BuildToolTipText()
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
            RBT.mainFrame:StartMoving()
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
                    SendChatMessage(tmp_str, RBT.db.char.reportChannel)
                end
            end
        else
            RBT.mainFrame:StopMovingOrSizing()
            if not RBT.db.char.position then
                RBT.db.char.position = {}
            end
            RBT.db.char.position.x = RBT.mainFrame:GetLeft()
            RBT.db.char.position.y = RBT.mainFrame:GetBottom()
        end
    end)

    tinsert(RBT.mainFrame.buff_bars, theBar)

    return theBar
end
