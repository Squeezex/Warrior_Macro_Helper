-- ui.lua
WMH_UI = {}

local frame = CreateFrame("Frame", "WMH_UI_Frame", UIParent, "BackdropTemplate")
frame:SetSize(400, 280)
frame:SetPoint("CENTER")
frame:SetBackdrop({
    bgFile = "Interface/Tooltips/UI-Tooltip-Background",
    edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
    edgeSize = 12
})
frame:SetBackdropColor(0,0,0,0.9)
frame:Hide()
WMH_UI.frame = frame

-- Title
local title = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
title:SetPoint("TOP", 0, -15)
title:SetText("Warrior Macro Helper")

-- Close button
local closeBtn = CreateFrame("Button", nil, frame, "UIPanelCloseButton")
closeBtn:SetSize(30, 30)
closeBtn:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -5, -5)
closeBtn:SetScript("OnClick", function() frame:Hide() end)

-- Macro EditBox
local macroLabel = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
macroLabel:SetPoint("TOPLEFT", 20, -50)
macroLabel:SetText("Macro Name:")

local macroEdit = CreateFrame("EditBox", nil, frame, "InputBoxTemplate")
macroEdit:SetSize(200, 25)
macroEdit:SetPoint("TOPLEFT", macroLabel, "BOTTOMLEFT", 0, -5)
macroEdit:SetAutoFocus(false)
WMH_UI.macroEdit = macroEdit

-- Weapon dropdown
local weaponLabel = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
weaponLabel:SetPoint("TOPLEFT", macroEdit, "BOTTOMLEFT", 0, -20)
weaponLabel:SetText("Main-Hand Weapon:")

local weaponDropdown = CreateFrame("Frame", "WMH_WeaponDropdown", frame, "UIDropDownMenuTemplate")
weaponDropdown:SetPoint("TOPLEFT", weaponLabel, "BOTTOMLEFT", -15, -5)
WMH_UI.weaponDropdown = weaponDropdown
WMH_UI.selectedWeapon = nil

-- Shield dropdown
local offLabel = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
offLabel:SetPoint("TOPLEFT", weaponDropdown, "BOTTOMLEFT", 15, -15)
offLabel:SetText("Off-Hand / Shield:")

local offDropdown = CreateFrame("Frame", "WMH_OffDropdown", frame, "UIDropDownMenuTemplate")
offDropdown:SetPoint("TOPLEFT", offLabel, "BOTTOMLEFT", -15, -5)
WMH_UI.offDropdown = offDropdown
WMH_UI.selectedOff = nil

-- Populate weapon dropdown
UIDropDownMenu_Initialize(weaponDropdown, function(self)
    local weapons = WMH_Items.GetWeapons()
    for i, w in ipairs(weapons) do
        local info = UIDropDownMenu_CreateInfo()
        info.text = w
        info.func = function()
            WMH_UI.selectedWeapon = w
            UIDropDownMenu_SetSelectedID(weaponDropdown, i)
            UIDropDownMenu_SetText(w, weaponDropdown)
        end
        UIDropDownMenu_AddButton(info)
    end
end)

-- Populate shield dropdown
UIDropDownMenu_Initialize(offDropdown, function(self)
    local shields = WMH_Items.GetShields()
    for i, s in ipairs(shields) do
        local info = UIDropDownMenu_CreateInfo()
        info.text = s
        info.func = function()
            WMH_UI.selectedOff = s
            UIDropDownMenu_SetSelectedID(offDropdown, i)
            UIDropDownMenu_SetText(s, offDropdown)
        end
        UIDropDownMenu_AddButton(info)
    end
end)

-- Apply button
local applyBtn = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
applyBtn:SetSize(140, 26)
applyBtn:SetPoint("BOTTOM", 0, 20)
applyBtn:SetText("Apply")
applyBtn:SetScript("OnClick", function()
    local macroName = WMH_UI.macroEdit:GetText()
    local mainHand = WMH_UI.selectedWeapon
    local offHand = WMH_UI.selectedOff

    if not macroName or macroName == "" or not mainHand then
        print("WMH: Enter macro name and main-hand weapon")
        return
    end

    -- Найти макрос персонажа в слотах 1–24
    local index = nil
    for i = 1, 24 do
        local name = GetMacroInfo(i)
        if name == macroName then
            index = i
            break
        end
    end

    if not index then
        print("WMH: Macro not found for this character:", macroName)
        return
    end

    WMH_Macros.UpdateMacro(index, mainHand, offHand)
    WMH_UI.frame:Hide()
end)
