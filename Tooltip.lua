--[[
  BlizzTweaks
]]

local L = LibStub("AceLocale-3.0"):GetLocale("BlizzTweaks", false)

local k_IsInspectPending = false
local k_InspectName, k_InspectRealm = nil

---------------------------------------------------------
-- Tooltip Tweaks
function BlizzTweaks:UpdatePlayerInspectTooltip()
    if BlizzTweaks.db.profile.enableTooltipItemLevelAndSpec == false or k_IsInspectPending == true then
        return
    end

    name, realm = BlizzTweaks:GetMouseOverPlayerInfo()

    if k_InspectName == nil then
        k_InspectName = name
        k_InspectRealm = realm
    end

    if k_InspectName ~= name or k_InspectRealm ~= realm then
        k_InspectName = name
        k_InspectRealm = realm
        k_IsInspectPending = true
        C_Timer.After(0.5, function() k_IsInspectPending = false; BlizzTweaks:UpdatePlayerInspectTooltip() end);
        return
    end

    NotifyInspect("mouseover");
end

function BlizzTweaks:UpdatePlayerTooltipInspect()
    if BlizzTweaks.db.profile.enableTooltipItemLevelAndSpec == false then
        return
    end

    name, realm = BlizzTweaks:GetMouseOverPlayerInfo()
    if not name or not realm then
        return
    end

    if name ~= k_InspectName or realm ~= k_InspectRealm then
        return
    end

    _, _, class = UnitClass("mouseover");
    _, spec = GetSpecializationInfoByID(GetInspectSpecialization("mouseover"));
    iLvl = C_PaperDollInfo.GetInspectItemLevel("mouseover");
    if not class or not spec or not iLvl then
        return
    end

    BlizzTweaks:AddILevelTooltip(class, spec, iLvl)
end

function BlizzTweaks:GetMouseOverPlayerInfo()
    name, realm = UnitName("mouseover");
    if name == nil then
        return
    end

    if realm == nil then
        realm = GetRealmName();
    end

    return name, realm
end