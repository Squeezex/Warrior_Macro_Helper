local button = CreateFrame("Button", "WMH_MinimapButton", Minimap)
button:SetSize(32,32)
button:SetNormalTexture("Interface\\Icons\\Ability_Warrior_DefensiveStance")
button:SetHighlightTexture("Interface\\Minimap\\UI-Minimap-ZoomButton-Highlight")
button:SetPoint("TOPLEFT", Minimap, "TOPLEFT")
button:RegisterForClicks("LeftButtonUp")

-- Tooltip при наведении
button:SetScript("OnEnter", function(self)
    GameTooltip:SetOwner(self, "ANCHOR_LEFT")
    GameTooltip:SetText("Warrior Macro Helper", 1, 1, 1)
    GameTooltip:AddLine("Click to change macros", 0.8, 0.8, 0.8)
    GameTooltip:Show()
end)

button:SetScript("OnLeave", function()
    GameTooltip:Hide()
end)

button:SetScript("OnClick", function()
    if WMH_UI.frame:IsShown() then
        WMH_UI.frame:Hide()
    else
        -- Populate weapon dropdown
        UIDropDownMenu_Initialize(WMH_UI.weaponDropdown, function(self)
            local weapons = WMH_Items.GetWeapons()
            local info = UIDropDownMenu_CreateInfo()
            for i, w in ipairs(weapons) do
                local weaponName = w
                info.text = weaponName
                info.icon = select(10, GetItemInfo(w)) -- иконка предмета
                info.func = function()
                    WMH_UI.selectedWeapon = weaponName
                    UIDropDownMenu_SetSelectedID(WMH_UI.weaponDropdown, i)
                    UIDropDownMenu_SetText(weaponName, WMH_UI.weaponDropdown)
                end
                UIDropDownMenu_AddButton(info)
            end
        end)

        -- Populate shield dropdown
        UIDropDownMenu_Initialize(WMH_UI.offDropdown, function(self)
            local shields = WMH_Items.GetShields()
            local info = UIDropDownMenu_CreateInfo()
            for i, s in ipairs(shields) do
                local shieldName = s
                info.text = shieldName
                info.icon = select(10, GetItemInfo(s)) -- иконка предмета
                info.func = function()
                    WMH_UI.selectedOff = shieldName
                    UIDropDownMenu_SetSelectedID(WMH_UI.offDropdown, i)
                    UIDropDownMenu_SetText(shieldName, WMH_UI.offDropdown)
                end
                UIDropDownMenu_AddButton(info)
            end
        end)

        WMH_UI.frame:Show()
    end
end)
