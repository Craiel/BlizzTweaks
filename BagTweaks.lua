--[[
  BlizzTweaks
]]

local L = LibStub("AceLocale-3.0"):GetLocale("BlizzTweaks", false)

---------------------------------------------------------
-- WoW API
local GetItemInfo = GetItemInfo
local GetDetailedItemLevelInfo = GetDetailedItemLevelInfo

local Cache = GP_ItemButtonInfoFrameCache or {}
GP_ItemButtonInfoFrameCache = Cache

local k_BankBagSlots = 24

local k_RarityColors = {
    [0] = { 157/255, 157/255, 157/255 }, -- Poor
    [1] = { 240/255, 240/255, 240/255 }, -- Common
    [2] = { 30/255, 178/255, 0/255 }, -- Uncommon
    [3] = { 0/255, 112/255, 221/255 }, -- Rare
    [4] = { 163/255, 53/255, 238/255 }, -- Epic
    [5] = { 225/255, 96/255, 0/255 }, -- Legendary
    [6] = { 229/255, 204/255, 127/255 }, -- Artifact
    [7] = { 79/255, 196/255, 225/255 }, -- Heirloom
    [8] = { 79/255, 196/255, 225/255 } -- Blizzard
}

local k_SlotsWithEnchants = {
    [5] = true, -- Chest
    [8] = true, -- Feet
    [9] = true, -- Wrist
    [10] = true, -- Hands
    [11] = true, -- Ring1,
    [12] = true, -- Ring2
    [15] = true, -- Cloak
    [16] = true, -- Main Hand
}

local k_JunkColorOverlay = {
    ["r"] = (51/255)*.2,
    ["g"] = (17/255)*.2,
    ["b"] = (6/255)*.2,
    ["a"] = .6
}

local k_EnchantColorOverlay = {
    ["r"] = 255/255,
    ["g"] = 0,
    ["b"] = 0,
    ["a"] = 0.4
}

---------------------------------------------------------
-- Update Methods
function BlizzTweaks:ClearButtonMods(btn)
    BlizzTweaks:ClearOverlayText(btn)
    BlizzTweaks:ClearBoundText(btn)
    BlizzTweaks:ClearColorOverlay(btn)
end

function BlizzTweaks:ClearOverlayText(btn)
    local cache = Cache[btn]
    if cache == nil or cache.overlay == nil then
        return
    end

    cache.overlay:SetText("")
end

function BlizzTweaks:ClearBoundText(btn)
    local cache = Cache[btn]
    if cache == nil or cache.bind == nil then
        return
    end

    cache.bind:SetText("")
end

function BlizzTweaks:ClearColorOverlay(btn)
    local cache = Cache[btn]
    if cache == nil or cache.colOverlay == nil then
        return
    end

    cache.colOverlay:Hide()
    cache.colOverlay.icon:SetDesaturated(locked)
end

function BlizzTweaks:GetContainer(btn)
    local container = Cache[btn]
    if container == nil then
        container = CreateFrame("Frame", nil, btn)
        container:SetFrameLevel(btn:GetFrameLevel() + 5)
        container:SetAllPoints()
        Cache[btn] = container
    end

    return container
end

function BlizzTweaks:GetOverlayTextElement(container)
    local el = container:CreateFontString()
    el:SetDrawLayer("ARTWORK", 1)
    el:SetFontObject(NumberFont_Outline_Med or NumberFontNormal)
    el:SetShadowOffset(1, -1)
    el:SetShadowColor(0, 0, 0, .5)
    return el
end

function BlizzTweaks:MoveUpgradeIcon(container)
    local upgrade = container.UpgradeIcon
    if upgrade ~= nil then
        upgrade:ClearAllPoints()
        upgrade:SetPoint("BOTTOMRIGHT", 2, 0)
    end
end

function BlizzTweaks:SetBoundText(btn, text, rarity)
    local r, g, b = 240/255, 240/255, 240/255
    local container = BlizzTweaks:GetContainer(btn)

    if container.bind == nil then
        container.bind = BlizzTweaks:GetOverlayTextElement(container)
        container.bind:SetPoint("BOTTOMLEFT", 2, 2)
    end

    BlizzTweaks:MoveUpgradeIcon(container)

    -- Colorize.
    if rarity and k_RarityColors[rarity] then
        local col = k_RarityColors[rarity]
        r, g, b = col[1], col[2], col[3]
    end

    container.bind:SetTextColor(r, g, b)
    container.bind:SetText(text)
end

function BlizzTweaks:SetOverlayText(btn, text, rarity)
    local r, g, b = 240/255, 240/255, 240/255
    local container = BlizzTweaks:GetContainer(btn)

    if container.overlay == nil then
        container.overlay = BlizzTweaks:GetOverlayTextElement(container)
        container.overlay:SetPoint("TOPLEFT", 2, -2)
    end

    BlizzTweaks:MoveUpgradeIcon(container)

    -- Colorize.
    if rarity and k_RarityColors[rarity] then
        local col = k_RarityColors[rarity]
        r, g, b = col[1], col[2], col[3]
    end

    container.overlay:SetTextColor(r, g, b)
    container.overlay:SetText(text)
end

function BlizzTweaks:SetColorOverlay(btn, rgba, desaturate)
    local container = BlizzTweaks:GetContainer(btn)

    -- Retrieve or create the color overlay
    if (not container.colOverlay) then
        container.colOverlay = btn:CreateTexture()
        container.colOverlay.icon = btn.Icon or btn.icon or _G[btn:GetName().."IconTexture"]
        local layer,level = container.colOverlay.icon:GetDrawLayer()
        container.colOverlay:SetDrawLayer(layer, (level or 6) + 1)
        container.colOverlay:SetAllPoints(container.colOverlay.icon)
        container.colOverlay:SetColorTexture(rgba.r, rgba.g, rgba.b, rgba.a)
    end

    container.colOverlay:Show()

    if desaturate == true then
        container.colOverlay.icon:SetDesaturated(true)
    end
end

function BlizzTweaks:GetAnimaValue(quality, stackCount)
    if stackCount == nil or stackCount == 0 then
        return 0
    end

    if quality == 2 then
        return stackCount * 5
    elseif quality == 3 then
        return stackCount * 35
    elseif quality == 4 then
        return stackCount * 250
    end

    return 0
end


function BlizzTweaks:UpdateSlotOverlay(btn, itemLink, itemCount)
    if itemLink == nil then
        BlizzTweaks:ClearOverlayText(btn)
        return
    end

    local itemName, _, itemQuality, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture, itemSellPrice, _, _, bindType = GetItemInfo(itemLink)
    local isAnimaItem = C_Item.IsAnimaItemByID(itemLink)
    local overlayIsSet = false

    if itemQuality == nil then
        -- Probably a key stone or another special item
        BlizzTweaks:ClearOverlayText(btn)
        return
    end

    if itemQuality == 0 and not locked and BlizzTweaks.db.profile.enableJunkItemGreyOverlay == true then
        BlizzTweaks:SetColorOverlay(btn, k_JunkColorOverlay, true)
    else
        BlizzTweaks:ClearColorOverlay(btn)
    end

    if isAnimaItem == true then
        -- Anima Overlay
        local animaValue = BlizzTweaks:GetAnimaValue(itemQuality, itemCount)
        if animaValue > 0 then
            BlizzTweaks:SetOverlayText(btn, animaValue, 8)
            overlayIsSet = true
        else
            print("Anima without Value: " .. itemCount)
        end
    elseif itemQuality > 0 and itemEquipLoc ~= nil and _G[itemEquipLoc] ~= nil then
        -- Item Level overlay
        -- Set a threshold to avoid spamming the classics with ilvl 1 whites
        local effectiveItemLevel, _, _ = GetDetailedItemLevelInfo(itemLink)
        itemLevel = tonumber(effectiveItemLevel)
        if (itemLevel and itemLevel > 1) then
            BlizzTweaks:SetOverlayText(btn, itemLevel, itemQuality)
            overlayIsSet = true
        end
    end

    if overlayIsSet == false then
        BlizzTweaks:ClearOverlayText(btn)
    end
end

function BlizzTweaks:UpdateSlotBoundState(btn, itemLink, isBound)
    if itemLink == nil then
        BlizzTweaks:ClearBoundText(btn)
        return
    end

    local _, _, itemQuality, _, _, _, _, _, itemEquipLoc, _, _, _, _, bindType = GetItemInfo(itemLink)
    local bindIsSet = false

    if itemQuality == nil then
        -- Probably a key stone or another special item
        BlizzTweaks:ClearBoundText(btn)
        return
    end

    -- Item Level overlay
    if itemQuality > 0 and itemEquipLoc ~= nil and _G[itemEquipLoc] ~= nil then
        if not isBound then
            if bindType == 2 then
                BlizzTweaks:SetBoundText(btn, L["BoE"], itemQuality)
                bindIsSet = true
            elseif bindType == 3 then
                BlizzTweaks:SetBoundText(btn, L["BoU"], itemQuality)
                bindIsSet = true
            end
        end
    end

    if bindIsSet == false then
        BlizzTweaks:ClearBoundText(btn)
    end
end

function BlizzTweaks:UpdatePaperDollSlot(btn, unit)
    if BlizzTweaks.db.profile.enableItemLevelDisplayOnItems == false then
        return
    end

    local slot = btn:GetID()
    if slot < INVSLOT_FIRST_EQUIPPED or slot > INVSLOT_LAST_EQUIPPED then
        return
    end

    local itemLink = GetInventoryItemLink(unit, slot)
    if itemLink == nil then
        BlizzTweaks:ClearButtonMods(btn);
        return
    end

    BlizzTweaks:UpdateSlotOverlay(btn, itemLink)

    if BlizzTweaks.db.profile.enableMissingEnchantOverlay == true then
        local shouldHaveEnchant = k_SlotsWithEnchants[slot] == true
        if shouldHaveEnchant then
            local enchantId, gemId = string.match(itemLink,'item:(%d+):(%d+)')
            if enchantId == nil then
                BlizzTweaks:SetColorOverlay(btn, k_EnchantColorOverlay)
            end
        end
    end
end

function BlizzTweaks:GetSlotItemLevel(btn, unit)
    local slot = btn:GetID()
    if slot < INVSLOT_FIRST_EQUIPPED or slot > INVSLOT_LAST_EQUIPPED then
        return
    end
    local itemLink = GetInventoryItemLink(unit, slot)
    if itemLink == nil then
        return nil
    end

    local _, _, _, itemLevel, _, _, _, _, _, _, _, _, _, _ = GetItemInfo(itemLink)
    return itemLevel
end

function BlizzTweaks:UpdateBagSlot(btn, bag)
    local slot = btn:GetID()
    local itemLink, isBound, itemCount, _
    local containerInfo = C_Container.GetContainerItemInfo(bag,slot)
    if (containerInfo) then
        --[[for key, val in pairs(containerInfo) do
            print(key..': ')
        end]]--
        isBound = containerInfo.isBound
        itemLink = containerInfo.hyperlink
        itemCount = containerInfo.stackCount
    end

    if itemLink == nil then
        BlizzTweaks:ClearButtonMods(btn)
        return
    end

    BlizzTweaks:UpdateSlotOverlay(btn, itemLink, itemCount)
    BlizzTweaks:UpdateSlotBoundState(btn, itemLink, isBound)
end

function BlizzTweaks:UpdateContainer(args)
    if BlizzTweaks.db.profile.enableItemLevelDisplayOnItems == false then
        return
    end

    local bag = args:GetID()
    local name = args:GetName()
    local id = 1
    local button = _G[name.."Item"..id]
    while (button) do
        if (button.hasItem) then
            BlizzTweaks:UpdateBagSlot(button, bag)
        else
            BlizzTweaks:ClearButtonMods(button)
        end
        id = id + 1
        button = _G[name.."Item"..id]
    end
end

function BlizzTweaks:UpdateCombinedContainer(args)
    if BlizzTweaks.db.profile.enableItemLevelDisplayOnItems == false then
        return
    end

    for id,button in args:EnumerateItems() do
        if (button.hasItem) then
            -- The buttons retain their original bagID
            BlizzTweaks:UpdateBagSlot(button, button:GetBagID())
        else
            BlizzTweaks:ClearButtonMods(button)
        end
    end
end

function BlizzTweaks:UpdateBankSlots(evt)
    if BlizzTweaks.db.profile.enableItemLevelDisplayOnItems == false then
        return
    end

    for slot = 1, C_Container.GetContainerNumSlots(-1) do
        local btn = _G["BankFrameItem"..slot]
        if btn then
            local itemLink = C_Container.GetContainerItemLink(-1, slot)
            if itemLink then
                BlizzTweaks:UpdateSlotOverlay(btn, itemLink)
            else
                BlizzTweaks:ClearButtonMods(btn)
            end
        end
    end
end