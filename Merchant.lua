--[[
  BlizzTweaks
]]

local L = LibStub("AceLocale-3.0"):GetLocale("BlizzTweaks", false)

---------------------------------------------------------
-- Merchant Tweaks
function BlizzTweaks:HandleMerchantShow(evt)
    BlizzTweaks:HandleAutoSellJunk()
    BlizzTweaks:HandleAutoRepair()
end

function BlizzTweaks:HandleAutoRepair()
    if BlizzTweaks.db.profile.enableAutoRepair == false or not CanMerchantRepair() then
        return
    end

    repairAllCost, canRepair = GetRepairAllCost()
    if not canRepair then
        return
    end

    money = GetMoney()
    if( IsInGuild() and CanGuildBankRepair() ) then
        BlizzTweaks:Print("Repairing Items using Guild Funds: "..GetCoinTextureString(repairAllCost));
        RepairAllItems(true)
        return
    end

    if(repairAllCost > money) then
        BlizzTweaks:Print("Insufficient Money to Repair: "..GetCoinTextureString(repairAllCost));
        return
    end

    BlizzTweaks:Print("Repairing Items for "..GetCoinTextureString(repairAllCost));
    RepairAllItems(false);
end

function BlizzTweaks:HandleAutoSellJunk()
    if BlizzTweaks.db.profile.enableAutoSellJunk == false then
        return
    end

    totalPrice = 0
    for myBags = 0,4 do
        for bagSlots = 1, GetContainerNumSlots(myBags) do
            CurrentItemLink = GetContainerItemLink(myBags, bagSlots)
            if CurrentItemLink then
                _, _, itemRarity, _, _, _, _, _, _, _, itemSellPrice = GetItemInfo(CurrentItemLink)
                _, itemCount = GetContainerItemInfo(myBags, bagSlots)
                if itemRarity == 0 and itemSellPrice ~= 0 then
                    totalPrice = totalPrice + (itemSellPrice * itemCount)
                    PickupContainerItem(myBags, bagSlots)
                    PickupMerchantItem(0)
                end
            end
        end
    end
    if totalPrice ~= 0 then
        BlizzTweaks:Print("Junk sold for "..GetCoinTextureString(totalPrice))
    end
end