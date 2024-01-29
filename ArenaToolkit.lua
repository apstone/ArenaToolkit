-- Default settings
ArenaToolkitDB = ArenaToolkitDB or
    { enableSmallPlates = true, enableArenaNumbers = true, nameplateWidth = 60 }

-- Main frame for event handling
local frame = CreateFrame("Frame")
frame:RegisterEvent("PLAYER_LOGIN")
frame:SetScript("OnEvent", function(self, event, ...)
    if event == "PLAYER_LOGIN" then
        -- Apply settings on login
        if ArenaToolkitDB.enableSmallPlates then
            C_NamePlate.SetNamePlateFriendlySize(ArenaToolkitDB.nameplateWidth, 30)
        end
        hooksecurefunc("CompactUnitFrame_UpdateName", UpdateArenaNameplates)
    end
end)

-- Update nameplates in arena
local function UpdateArenaNameplates(F)
    if ArenaToolkitDB.enableArenaNumbers and IsActiveBattlefieldArena() and F.unit:find("nameplate") then
        for i = 1, 5 do
            if UnitIsUnit(F.unit, "arena" .. i) then
                F.name:SetText(i)
                F.name:SetTextColor(1, 1, 0)
                break
            end
        end
    end
end

-- Create options panel
local function CreateOptionsPanel()
    local panel = CreateFrame("Frame", "ArenaToolkitOptionsPanel", InterfaceOptionsFramePanelContainer)
    panel.name = "Arena Toolkit"
    panel:Hide()

    local title = panel:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
    title:SetPoint("TOPLEFT", 16, -16)
    title:SetText(panel.name)

    -- Checkbox for small friendly nameplates
    local smallPlatesCheckbox = CreateFrame("CheckButton", "TFHB_SmallPlatesCheckbox", panel, "UICheckButtonTemplate")
    smallPlatesCheckbox:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -10)
    smallPlatesCheckbox.Text:SetText("Enable Small Friendly Nameplates")
    smallPlatesCheckbox:SetChecked(ArenaToolkitDB.enableSmallPlates)
    smallPlatesCheckbox:SetScript("OnClick", function(self)
        ArenaToolkitDB.enableSmallPlates = self:GetChecked()
        C_NamePlate.SetNamePlateFriendlySize(
            ArenaToolkitDB.enableSmallPlates and ArenaToolkitDB.nameplateWidth or 110, 30)
    end)

    -- Checkbox for arena number labels
    local arenaNumbersCheckbox = CreateFrame("CheckButton", "TFHB_ArenaNumbersCheckbox", panel, "UICheckButtonTemplate")
    arenaNumbersCheckbox:SetPoint("TOPLEFT", smallPlatesCheckbox, "BOTTOMLEFT", 0, -10)
    arenaNumbersCheckbox.Text:SetText("Enable Arena 1, 2, 3")
    arenaNumbersCheckbox:SetChecked(ArenaToolkitDB.enableArenaNumbers)
    arenaNumbersCheckbox:SetScript("OnClick", function(self)
        ArenaToolkitDB.enableArenaNumbers = self:GetChecked()
    end)

    -- Slider for nameplate width
    local widthSlider = CreateFrame("Slider", "TFHB_WidthSlider", panel, "OptionsSliderTemplate")
    widthSlider:SetPoint("TOPLEFT", arenaNumbersCheckbox, "BOTTOMLEFT", 0, -30)
    widthSlider:SetMinMaxValues(40, 120)
    widthSlider:SetValueStep(1)
    widthSlider:SetValue(ArenaToolkitDB.nameplateWidth)
    widthSlider.Text:SetText("Nameplate Width")
    widthSlider.Low:SetText("40")
    widthSlider.High:SetText("120")
    widthSlider:SetScript("OnValueChanged", function(self, value)
        ArenaToolkitDB.nameplateWidth = value
        C_NamePlate.SetNamePlateFriendlySize(value, 30)
    end)

    InterfaceOptions_AddCategory(panel)
end

-- Create the options panel when the addon is loaded
CreateOptionsPanel()
