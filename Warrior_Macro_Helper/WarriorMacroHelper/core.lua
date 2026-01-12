-- core.lua
local frame = CreateFrame("Frame")
frame:RegisterEvent("PLAYER_LOGIN")

frame:SetScript("OnEvent", function()
    print("WMH: Warrior Macro Helper loaded")
end)
