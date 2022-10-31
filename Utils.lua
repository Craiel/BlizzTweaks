--[[
  BlizzTweaks
]]

local L = LibStub("AceLocale-3.0"):GetLocale("BlizzTweaks", false)

---------------------------------------------------------
-- Utility Functions
function BlizzTweaks:GetILvlColor(ilvl)
    if ilvl == nil then
        return GetItemQualityColor(1)
    end

    if ilvl > 300 then
        return GetItemQualityColor(5) --Legendary
    elseif ilvl > 260 then
        return GetItemQualityColor(4) --Epic
    elseif ilvl > 230 then
        return GetItemQualityColor(3) --Rare
    elseif ilvl > 180 then
        return GetItemQualityColor(2) --Uncommon
    else
        return GetItemQualityColor(1) --Common
    end
end

function BlizzTweaks:GetClassColor(classId)
    if (classId == 1) then --Warrior
        return 0.78, 0.61, 0.43
    elseif (classId == 2) then --Paladin
        return 0.96, 0.55, 0.73
    elseif (classId == 3) then --Hunter
        return 0.67, 0.83, 0.45
    elseif (classId == 4) then --Rogue
        return 1.00, 0.96, 0.41
    elseif (classId == 5) then --Priest
        return 1.00, 1.00, 1.00
    elseif (classId == 6) then --Death Knight
        return 0.77, 0.12, 0.23
    elseif (classId == 7) then --Shaman
        return 0.00, 0.44, 0.87
    elseif (classId == 8) then --Mage
        return 0.25, 0.78, 00.92
    elseif (classId == 9) then --Warlock
        return 0.53, 0.53, 0.93
    elseif (classId == 10) then --Monk
        return 0.00, 1.00, 0.59
    elseif (classId == 11) then --Druid
        return 1.00, 0.49, 0.04
    elseif (classId == 12) then --Demon Hunter
        return 0.64, 0.19, 0.79
    elseif (classId == 13) then --Evoker
        return 0.2, 0.58, 0.50
    end
end