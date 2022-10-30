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

    local AceEvent = LibStub("AceEvent-3.0")
    AceEvent:RegisterEvent("PLAYERBANKSLOTS_CHANGED", function(evt) BlizzTweaks:HandleBankSlotsChanged(evt) end)
    AceEvent:RegisterEvent("DELETE_ITEM_CONFIRM", function(evt) BlizzTweaks:HandleDeleteConfirm(evt) end)
    AceEvent:RegisterEvent("MERCHANT_SHOW", function(evt) BlizzTweaks:HandleAutoRepair(evt) end)
end

---------------------------------------------------------
-- Misc Tweaks
function BlizzTweaks:HandleAutoRepair(evt)
    if not CanMerchantRepair() then
        return
    end

    repairAllCost, canRepair = GetRepairAllCost()
    money = GetMoney()
    if( IsInGuild() and CanGuildBankRepair() ) then
        BlizzTweaks:Print("Repairing Items using Guild Funds: "..GetCoinText(repairAllCost,", "));
        RepairAllItems(true)
        return
    end

    if(repairAllCost > money) then
        BlizzTweaks:Print("Insufficient Money to Repair: "..GetCoinText(repairAllCost,", "));
        return
    end

    BlizzTweaks:Print("Repairing Items for "..GetCoinText(repairAllCost,", "));
    RepairAllItems(false);
end