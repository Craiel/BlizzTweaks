--[[
  BlizzTweaks
]]

local L = LibStub("AceLocale-3.0"):GetLocale("BlizzTweaks", false)

---------------------------------------------------------
-- WoW API
local GetContainerItemInfo = GetContainerItemInfo
local C_Container_GetContainerItemInfo = C_Container and C_Container.GetContainerItemInfo
local GetItemInfo = GetItemInfo
local GetDetailedItemLevelInfo = GetDetailedItemLevelInfo

local Cache = GP_ItemButtonInfoFrameCache or {}
GP_ItemButtonInfoFrameCache = Cache

local _SCANNER = "GP_ScannerTooltip"
local Scanner = _G[_SCANNER] or CreateFrame("GameTooltip", _SCANNER, WorldFrame, "GameTooltipTemplate")

local k_ILVL = "^" .. string.gsub(ITEM_LEVEL, "%%d", "(%%d+)")

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

---------------------------------------------------------
-- Update Methods
function BlizzTweaks:ClearButtonMods(btn)
    BlizzTweaks:ClearOverlayText(btn)
    BlizzTweaks:ClearBoundText(btn)
    BlizzTweaks:ClearGarbageOverlay(btn)
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

function BlizzTweaks:ClearGarbageOverlay(btn)
    local cache = Cache[btn]
    if cache == nil or cache.garbage == nil then
        return
    end

    cache.garbage:Hide()
    cache.garbage.icon:SetDesaturated(locked)
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

function BlizzTweaks:SetGarbageOverlay(btn)
    local container = BlizzTweaks:GetContainer(btn)

    -- Retrieve of create the garbage overlay
    if (not container.garbage) then
        container.garbage = btn:CreateTexture()
        container.garbage.icon = btn.Icon or btn.icon or _G[btn:GetName().."IconTexture"]
        local layer,level = container.garbage.icon:GetDrawLayer()
        container.garbage:SetDrawLayer(layer, (level or 6) + 1)
        container.garbage:SetAllPoints(container.garbage.icon)
        container.garbage:SetColorTexture((51/255)*.2, (17/255)*.2, (6/255)*.2, .6)
    end

    container.garbage:Show()
    container.garbage.icon:SetDesaturated(true)
end

function BlizzTweaks:UpdateBagSlot(btn, bag)
    local slot = btn:GetID()
    local itemLink, locked, quality, isBound, _
    if (C_Container_GetContainerItemInfo) then
        local containerInfo = C_Container_GetContainerItemInfo(bag,slot)
        if (containerInfo) then
            isBound = containerInfo.isBound
            itemLink = containerInfo.hyperlink
        end
    else
        _, _, locked, quality, _, _, itemLink, _, _, _, isBound = GetContainerItemInfo(bag,slot)
    end

    if itemLink == nil then
        BlizzTweaks:ClearButtonMods(btn)
        return
    end

    local _, _, itemQuality, itemLevel, _, _, _, _, itemEquipLoc, _, _, _, _, bindType = GetItemInfo(itemLink)
    local overlayIsSet = false
    local bindIsSet = false

    if itemQuality == nil then
        -- Probably a key stone or another special item
        BlizzTweaks:ClearButtonMods(btn)
        return
    end

    if itemQuality == 0 and not locked then
        BlizzTweaks:SetGarbageOverlay(btn)
    else
        BlizzTweaks:ClearGarbageOverlay(btn)
    end

    -- Item Level overlay
    if itemQuality > 0 and itemEquipLoc ~= nil and _G[itemEquipLoc] ~= nil then
        Scanner.owner = btn
        Scanner.bag = bag
        Scanner.slot = slot
        Scanner:SetOwner(btn, "ANCHOR_NONE")
        Scanner:SetBagItem(bag,slot)

        local tipLevel
        for i = 2,3 do
            local line = _G[_SCANNER.."TextLeft"..i]
            if (line) then
                local msg = line:GetText()
                if msg ~= nil and string.find(msg, k_ILVL) then
                    local ilvl = string.match(msg, k_ILVL)
                    if (ilvl) and (tonumber(ilvl) > 0) then
                        tipLevel = ilvl
                    end
                    break
                end
            end
        end

        -- Set a threshold to avoid spamming the classics with ilvl 1 whites
        tipLevel = tonumber(tipLevel or GetDetailedItemLevelInfo(itemLink) or itemLevel)
        if (tipLevel and tipLevel > 1) then
            BlizzTweaks:SetOverlayText(btn, tipLevel, itemQuality)
            overlayIsSet = true
        end

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

    if overlayIsSet == false then
        BlizzTweaks:ClearOverlayText(btn)
    end

    if bindIsSet == false then
        BlizzTweaks:ClearBoundText(btn)
    end
end

function BlizzTweaks:UpdateContainer(args)
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
    for id,button in args:EnumerateItems() do
        if (button.hasItem) then
            -- The buttons retain their original bagID
            BlizzTweaks:UpdateBagSlot(button, button:GetBagID())
        else
            BlizzTweaks:ClearButtonMods(button)
        end
    end
end

function BlizzTweaks:HandleBankSlotsChanged(evt)

end