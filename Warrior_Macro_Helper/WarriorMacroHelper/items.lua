-- items.lua
WMH_Items = {}

local function IterateBags(callback)
    for bag = 0, NUM_BAG_SLOTS do
        local slots = GetContainerNumSlots(bag)
        for slot = 1, slots do
            local link = GetContainerItemLink(bag, slot)
            if link then callback(link) end
        end
    end
end

function WMH_Items.GetWeapons()
    local list = {}
    IterateBags(function(link)
        local name = GetItemInfo(link)
        if name then
            local _, _, _, _, _, itemType, itemSubType = GetItemInfo(link)
            if itemType == "Weapon" then
                table.insert(list, name)
            end
        end
    end)
    return list
end

function WMH_Items.GetShields()
    local list = {}
    IterateBags(function(link)
        local name = GetItemInfo(link)
        if name then
            local _, _, _, _, _, itemType, itemSubType = GetItemInfo(link)
            if itemType == "Armor" and itemSubType == "Shields" then
                table.insert(list, name)
            end
        end
    end)
    return list
end
