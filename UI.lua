--[[
  BlizzTweaks
]]

local L = LibStub("AceLocale-3.0"):GetLocale("BlizzTweaks", false)

local k_ItemSlots = {
    "HeadSlot","NeckSlot","ShoulderSlot","BackSlot","ChestSlot","WristSlot",
    "HandsSlot","WaistSlot","LegsSlot","FeetSlot","Finger0Slot","Finger1Slot",
    "Trinket0Slot","Trinket1Slot","MainHandSlot", "SecondaryHandSlot"
}
local k_SlotIDLookup  = {}
for _, slotName in ipairs(k_ItemSlots) do
    local id = GetInventorySlotInfo(slotName)
    k_SlotIDLookup[slotName] = id
end

local m_InspectFontStringAvg = nil
local k_NamePlateSpellNameSize = 0.60

---------------------------------------------------------
-- UI Tweaks
function BlizzTweaks:HandleDeleteConfirm(evt)
    if StaticPopup1EditBox:IsShown() and BlizzTweaks.db.profile.enableEasyDelete == true then
        StaticPopup1EditBox:Hide()
        StaticPopup1Button1:Enable()
    end
end

function BlizzTweaks:AddILevelTooltip(class, spec, ilvl)
    if not class or not spec or not ilvl or ilvl <= 0 then
        return
    end

    local sR, sG, sB = BlizzTweaks:GetClassColor(class);
    for i = 1, GameTooltip:NumLines() do
        local line = _G["GameTooltipTextLeft"..i]:GetText()
        if (line == spec or line == "iLvl: " .. iLvl) then
            return
        end
    end

    GameTooltip:AddLine(spec, sR, sG, sB, 1);
    local iR, iG, iB = BlizzTweaks:GetILvlColor(ilvl)
    GameTooltip:AddLine("iLvl: " .. ilvl, iR, iG, iB, 1);
    GameTooltip:Show();
end

function BlizzTweaks:GetInspectAverageItemLevel()
    if InspectModelFrame == nil then
        return 0
    end

    local items = 0
    local ilvlAggregate = 0
    for _, slotName in ipairs(k_ItemSlots) do
        local slot = _G["Inspect" .. slotName]
        local ilvl = BlizzTweaks:GetSlotItemLevel(slot, "target")
        if ilvl ~= nil then
            items = items + 1
            ilvlAggregate = ilvlAggregate + ilvl
        end
    end

    if items > 0 then
        return math.floor(ilvlAggregate / items);
    end

    return 0
end

function BlizzTweaks:RefreshInspectWindow()
    if InspectModelFrame == nil then
        return false
    end

    if m_InspectFontStringAvg == nil then
        m_InspectFontStringAvg = InspectModelFrame:CreateFontString(nil, "OVERLAY")
        m_InspectFontStringAvg:SetPoint("TOP", 4, -8)
        m_InspectFontStringAvg:SetFont("Fonts\\FRIZQT__.ttf", 24, "OUTLINE")
    end

    for _, slotName in ipairs(k_ItemSlots) do
        local slot = _G["Inspect" .. slotName]
        BlizzTweaks:UpdatePaperDollSlot(slot, "target")
    end

    if BlizzTweaks.db.profile.enableItemLevelOnInspect == true then
        local averageItemLevel = BlizzTweaks:GetInspectAverageItemLevel()
        r, g, b = BlizzTweaks:GetILvlColor(averageItemLevel)
        m_InspectFontStringAvg:SetTextColor(r, g, b)
        m_InspectFontStringAvg:SetText(averageItemLevel)
    end
end

function BlizzTweaks:UpdateEnemyNameplateCastBar(unitId)
    if BlizzTweaks.db.profile.enableEnemyCastTargetDisplay == false then
        return
    end

    local targetUnitId = unitId .."target";
    if not UnitExists(targetUnitId) then
        return
    end

    local targetName = UnitName(targetUnitId)
    local plate = C_NamePlate.GetNamePlateForUnit(unitId)
    if plate == nil then
        return
    end

    local _, _, targetClassId = UnitClass (targetUnitId)
    targetName = BlizzTweaks:GetClassColoredText(targetClassId, targetName)

    local unitFrame = plate.UnitFrame
    if unitFrame == nil then
        return
    end

    local castBar = unitFrame.castBar
    if castBar == nil then
        return
    end

    local channelName = UnitChannelInfo(unitId);
    local spellName = channelName or UnitCastingInfo(unitId);
    if spellName == nil then
        return
    end

    castBar.Text:SetText(spellName)
    local castBarWidth = castBar:GetWidth()
    if DetailsFramework ~= nil then
        DetailsFramework:TruncateText(castBar.Text, castBarWidth * k_NamePlateSpellNameSize)
    end

    castBar.Text:SetText(castBar.Text:GetText().." ["..targetName.."]")
end