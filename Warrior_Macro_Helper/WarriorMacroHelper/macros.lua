-- macros.lua
WMH_Macros = {}

-- Returns list of all character macros (local only)
function WMH_Macros.GetCharacterMacros()
    local macros = {}
    local numMacros = GetNumMacros()
    for i = 1, numMacros do
        local name, icon, body = GetMacroInfo(i)
        if name and name ~= "" and body then
            table.insert(macros, {name = name, index = i})
        end
    end
    return macros
end

-- Updates only /equipslot 16/17 in macro by index
function WMH_Macros.UpdateMacro(index, mainHand, offHand)
    local name, icon, body = GetMacroInfo(index)
    if not body then return end

    local lines = {}
    local found16 = false
    local found17 = false

    for line in body:gmatch("[^\r\n]+") do
        if line:match("^/equipslot%s+16") then
            line = "/equipslot 16 " .. mainHand
            found16 = true
        elseif offHand and offHand ~= "" and line:match("^/equipslot%s+17") then
            line = "/equipslot 17 " .. offHand
            found17 = true
        end
        table.insert(lines, line)
    end

    -- Подсказка если слоты не найдены
    if not found16 then
        print("WMH: Warning: /equipslot 16 not found in this macro. Add it to update automatically.")
    end
    if offHand and offHand ~= "" and not found17 then
        print("WMH: Warning: /equipslot 17 not found in this macro. Add it to update automatically.")
    end

    local newBody = table.concat(lines, "\n")
    EditMacro(index, name, icon, newBody)

    -- Подробная подсказка о том, что обновлено
    local msg = "WMH: Macro '" .. name .. "' updated with " .. mainHand
    if offHand and offHand ~= "" and found17 then
        msg = msg .. " / " .. offHand
    elseif offHand and offHand ~= "" then
        msg = msg .. " / (off-hand slot not found)"
    end
    print(msg)
end
