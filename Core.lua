--[[
  BlizzTweaks
]]

---------------------------------------------------------
-- Addon declaration
BlizzTweaks = LibStub("AceAddon-3.0"):NewAddon("BlizzTweaks", "AceConsole-3.0", "AceEvent-3.0")
local BlizzTweaks = BlizzTweaks
local L = LibStub("AceLocale-3.0"):GetLocale("BlizzTweaks", false)

local options = {
    name = "BlizzTweaks",
    handler = BlizzTweaks,
    type = 'group',
    args = {
        enable = {
          name = "Enable",
          desc = "Enables / disables the addon",
          type = "toggle",
          set = function(info,val) BlizzTweaks.enabled = val end,
          get = function(info) return BlizzTweaks.enabled end
        }
    },
}

---------------------------------------------------------
-- Std Methods
function BlizzTweaks:OnInitialize()
    BlizzTweaks:Print(L["Initializing..."])
    BlizzTweaks:RegisterChatCommand("bt")
    LibStub("AceConfig-3.0"):RegisterOptionsTable("BlizzTweaks", options, {"bt"})

    BlizzTweaks:RegisterEvents()

    BlizzTweaks:Print(L["Done!"])
end

function BlizzTweaks:OnEnable()
    -- Called when the addon is enabled
end

function BlizzTweaks:OnDisable()
    -- Called when the addon is disabled
end

---------------------------------------------------------
-- Setup Methods
function BlizzTweaks:RegisterEvents()
    local id = 1
    local frame = _G["ContainerFrame"..id]
    while (frame and frame.Update) do
        hooksecurefunc(frame, "Update", function(args) BlizzTweaks:UpdateContainer(args) end)
        id = id + 1
        frame = _G["ContainerFrame"..id]
    end

    hooksecurefunc(ContainerFrameCombinedBags, "Update", function(args) BlizzTweaks:UpdateCombinedContainer(args) end)
    hooksecurefunc("PaperDollItemSlotButton_Update", function(btn) BlizzTweaks:UpdatePaperDollSlot(btn, "player") end)
    --hooksecurefunc("InspectPaperDollItemSlotButton_Update", function(btn) UpdateItemSlotButton(btn, "target") end)

    local AceEvent = LibStub("AceEvent-3.0")
    AceEvent:RegisterEvent("PLAYERBANKSLOTS_CHANGED", function(evt) BlizzTweaks:HandleBankSlotsChanged(evt) end)
    AceEvent:RegisterEvent("DELETE_ITEM_CONFIRM", function(evt) BlizzTweaks:HandleDeleteConfirm(evt) end)
    AceEvent:RegisterEvent("MERCHANT_SHOW", function(evt) BlizzTweaks:HandleMerchantShow(evt) end)
    AceEvent:RegisterEvent("UPDATE_MOUSEOVER_UNIT", function(evt) BlizzTweaks:HandleMouseOver(evt) end)
    AceEvent:RegisterEvent("INSPECT_READY", function(evt) BlizzTweaks:HandleInspect(evt) end)
    AceEvent:RegisterEvent("PLAYER_TARGET_CHANGED", function(evt) BlizzTweaks:HandleTargetChanged(evt) end)
    AceEvent:RegisterEvent("UNIT_SPELLCAST_START", function(evt, unitId) BlizzTweaks:HandleCastStart(evt, unitId) end)
    AceEvent:RegisterEvent("UNIT_SPELLCAST_CHANNEL_START", function(evt, unitId) BlizzTweaks:HandleCastStart(evt, unitId) end)
end

---------------------------------------------------------
-- Misc Tweaks
function BlizzTweaks:HandleMouseOver(evt)
    if UnitIsPlayer("mouseover") and not BlizzTweaks:IsInspecting() then
        BlizzTweaks:UpdatePlayerInspectTooltip()
    end
end

function BlizzTweaks:HandleInspect(evt)
    BlizzTweaks:RefreshInspectWindow()

    if UnitIsPlayer("mouseover") then
        BlizzTweaks:UpdatePlayerTooltipInspect()
    end
end

function BlizzTweaks:HandleTargetChanged(evt)
    if not BlizzTweaks:IsInspecting() then
        return
    end

    if CanInspect("target") then
        InspectUnit("target")
    end
end

function BlizzTweaks:IsInspecting()
    if InspectModelFrame == nil then
        return false
    end

    return InspectFrame:IsVisible()
end

function BlizzTweaks:HandleCastStart(evt, unitId)
    if not UnitIsEnemy("player", unitId) then
        return
    end

    C_Timer.After(0.05, function() BlizzTweaks:UpdateEnemyNameplateCastBar(unitId) end);
end