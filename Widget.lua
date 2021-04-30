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
    local theFrame           = CreateFrame("Frame", "ReturnBuffTrackerUI", UIParent)
    self.mainFrame           = theFrame
    self.mainFrame.buff_bars = {}
    
    theFrame:ClearAllPoints()
    if self.profile.position then
        theFrame:SetPoint("BOTTOMLEFT", self.profile.position.x, self.profile.position.y)
    else
        theFrame:SetPoint("CENTER", UIParent)
    end
    
    --theFrame:SetHeight(80)
    theFrame:SetWidth(self.profile.width)
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
    resizeButton:SetScript("OnMouseDown", function(self_frame, button)
        self.mainFrame:StartSizing("RIGHT")
        self.mainFrame:SetUserPlaced(true)
    end)
    resizeButton:SetScript("OnMouseUp", function(self_frame, button)
        self.mainFrame:StopMovingOrSizing()
        self.profile.width = self.mainFrame:GetWidth()
        --local totalWidth     = theFrame:GetWidth() - 10
        for _, b in ipairs(self.mainFrame.buff_bars) do
            b:UpdateWidth()
        end
    end)
    
    theFrame:SetScript("OnMouseDown", function(self_frame) self_frame:StartMoving() end)
    theFrame:SetScript("OnMouseUp", function(self_frame)
        self_frame:StopMovingOrSizing()
        if not self.profile.position then
            self.profile.position = {}
        end
        self.profile.position.x = self_frame:GetLeft()
        self.profile.position.y = self_frame:GetBottom()
        --local totalWidth          = theFrame:GetWidth() - 10
        for _, b in ipairs(self_frame.buff_bars) do
            b:UpdateWidth()
        end
    end)
    
    theFrame:Show()

end

function RBT:SetNumberOfBarsToDisplay(numOfBars)
    if not self.mainFrame then return end
    numOfBars = numOfBars - 1
    if numOfBars <= 0 then numOfBars = 0 end
    local height = 5 + 16 + (numOfBars * default_bar_height) + 5
    self.mainFrame:SetHeight(height)
end

--function RBT:CreateHeaderBar(text, r, g, b)
--    local theBar              = CreateFrame("Frame", text, RBT.mainFrame)
--    theBar.buffNameTextString = theBar:CreateFontString(nil, "OVERLAY", "GameFontNormal")
--    theBar.buffNameTextString:SetPoint("CENTER", RBT.mainFrame, "TOP", 0, -7)
--    theBar.buffNameTextString:SetText(text)
--end


function RBT:CreateBuffInfoBar(buff_index, buff)
    -- text, r, g, b)
    local theBar = CreateFrame("Frame", nil, self.mainFrame)
    --theBar.text  = text
    theBar.buff  = buff
    
    theBar:SetHeight(default_bar_height)
    theBar:SetWidth(self.mainFrame:GetWidth() - 10)
    theBar:SetPoint("TOPLEFT", self.mainFrame, "TOPLEFT", 5, -5)
    
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
    
    theBar.spark = theBar:CreateTexture(nil, 'OVERLAY')
    theBar.spark:SetSize(default_bar_height / 2.0, 2.0 * default_bar_height)
    theBar.spark:SetBlendMode("ADD")
    theBar.spark:SetPoint("CENTER", theBar.texture, "RIGHT", 0, 0)
    theBar.spark:SetTexture([[Interface\CastingBar\UI-CastingBar-Spark]])
    if self.profile.enable_spark then
        theBar.spark:Show()
    else
        theBar.spark:Hide()
    end
    
    theBar.SetIndex    = function(self_bar_frame, index)
        if index then
            self_bar_frame:Show()
            self_bar_frame:SetPoint("TOPLEFT", RBT.mainFrame, "TOPLEFT", 5, -5 - (index * default_bar_height))
            --theBar.texture:SetPoint("TOPLEFT", RBT.mainFrame, "TOPLEFT", 5, -5 - (index * 16))
            --theBar.buffNameTextString:SetPoint("TOP", theBar, "TOP", 0, -7 - (index * 16))
            --theBar.percentTextString:SetPoint("RIGHT", theBar, "RIGHT", 0, 0)
        else
            self_bar_frame:Hide()
        end
    end
    
    theBar.UpdateWidth = function(self_bar_frame)
        local w = self.mainFrame:GetWidth() - 10
        if self_bar_frame.percentage_float then
            if self_bar_frame.percentage_float > 0.1 then
                self_bar_frame.texture:SetWidth(w * self_bar_frame.percentage_float)
                self_bar_frame.texture:Show()
            else
                self_bar_frame.texture:Hide()
            end
        else
            self_bar_frame.texture:Hide()
        end
        self_bar_frame:SetWidth(w)
    end
    
    theBar.Update      = function(self_bar_frame)
        local percentage_str, percentage_float = RBT:compute_percent_string(self_bar_frame.buff.count, self_bar_frame.buff.total)
        
        self_bar_frame.percentage_float        = percentage_float
        self_bar_frame.percentage_str          = percentage_str
        self_bar_frame.buff:SpecialBarDisplay()
        self_bar_frame:UpdateWidth()
        if self.profile.count_display_mode == "percent" then
            --, value, maxValue, tooltip_lines)
            --local percentage = buff.count / buff.total
            self_bar_frame.percentTextString:SetText(self_bar_frame.percentage_str)
        else
            self_bar_frame.percentTextString:SetText(format("%d/%d", self_bar_frame.buff.count, self_bar_frame.buff.total))
        end
    end
    
    --theBar:SetScript("OnUpdate", function(self, ...)
    --    --local totalWidth                       = RBT.mainFrame:GetWidth() - 10
    --    --self.percentTextString:SetText(self.percentTextString:GetText())
    --    local totalWidth = RBT.mainFrame:GetWidth() - 10
    --    self:SetWidth(totalWidth)
    --end)
    
    theBar:SetScript("OnEnter", function(self_bar_frame)
        GameTooltip:AddLine(format("%s %s", L["Missing"], self_bar_frame.buff.displayText), 1, 1, 1)
        GameTooltip:SetOwner(self_bar_frame, "ANCHOR_CURSOR")
        if self_bar_frame.buff.tooltip.main_text then
            for _, v in ipairs(self_bar_frame.buff.tooltip.main_text) do
                GameTooltip:AddLine(stripSymbols(v), 1, 1, 1)
            end
        
        end
        --if self.profile.report_slackers then
        if self_bar_frame.buff.tooltip.slacker_text then
            for _, v in ipairs(self_bar_frame.buff.tooltip.slacker_text) do
                GameTooltip:AddLine(stripSymbols(v), 1, 1, 1)
            end
        end
        --end
        GameTooltip:Show()
    end)
    theBar:SetScript("OnLeave", function(self_bar_frame)
        GameTooltip:Hide()
    end)
    
    theBar:SetScript("OnMouseDown", function(self_bar_frame)
        local shift_key = IsShiftKeyDown()
        if shift_key then
        else
            RBT.mainFrame:StartMoving()
        end
    end)
    theBar:SetScript("OnMouseUp", function(self_bar_frame)
        local shift_key = IsShiftKeyDown()
        local tmp_str
        if shift_key then
            if self_bar_frame.buff.tooltip.main_text then
                for k, v in ipairs(self_bar_frame.buff.tooltip.main_text) do
                    if k == 1 then
                        tmp_str = "ReturnBuffTracker: {rt7} " .. v
                    else
                        tmp_str = v
                    end
                    tmp_str = stripColors(tmp_str)
                    SendChatMessage(tmp_str, self.profile.reportChannel)
                end
            end
            if self.profile.report_slackers then
                if self_bar_frame.buff.tooltip.slacker_text then
                    for k, v in ipairs(self_bar_frame.buff.tooltip.slacker_text) do
                        tmp_str = stripColors(v)
                        SendChatMessage(tmp_str, self.profile.reportChannel)
                    end
                end
            end
        else
            RBT.mainFrame:StopMovingOrSizing()
            if not self.profile.position then
                self.profile.position = {}
            end
            self.profile.position.x = RBT.mainFrame:GetLeft()
            self.profile.position.y = RBT.mainFrame:GetBottom()
        end
    end)
    
    tinsert(self.mainFrame.buff_bars, theBar)
    
    return theBar
end
