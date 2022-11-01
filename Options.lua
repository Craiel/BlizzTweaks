--[[
  BlizzTweaks
]]

-- option panel

local opanel = CreateFrame("Frame", "BlizzTweaksOptionsPanel", UIParent)


-- main titles
opanel.title = opanel:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
opanel.title:SetPoint("TOPLEFT", 16, -16)
opanel.title:SetText("BlizzTweaks")
opanel.title:SetJustifyH("LEFT")

opanel.title2 = opanel:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
opanel.title2:SetPoint("TOPLEFT", 16, -35)
opanel.title2:SetText("Author: Raika")
opanel.title2:SetJustifyH("LEFT")

-- ui title
opanel.uiTitle = opanel:CreateFontString(nil, "ARTWORK", "GameFontNormalMed3")
opanel.uiTitle:SetPoint("TOPLEFT",  opanel.title2, "BOTTOMLEFT", 0, -20)
opanel.uiTitle:SetText("UI")
opanel.uiTitle:SetJustifyH("LEFT")

-- ui option - Show Item Level on Gear in inventory, paper doll and inspect frame
opanel.checkShowItemLvlOnBagItems = CreateFrame("CheckButton", "BT_ShowItemLvlOnBagItems", opanel, "OptionsBaseCheckButtonTemplate")
opanel.checkShowItemLvlOnBagItems:SetPoint("TOPLEFT", opanel.uiTitle, "BOTTOMLEFT", 0, -10)
opanel.checkShowItemLvlOnBagItems:SetScript("OnClick", function()
    -- TODO: activate / deactivate tweak option here
end)
opanel.labelShowItemLvlOnBagItems = opanel:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
opanel.labelShowItemLvlOnBagItems:SetPoint("LEFT", opanel.checkShowItemLvlOnBagItems, "RIGHT", 2, 1)
opanel.labelShowItemLvlOnBagItems:SetJustifyH("LEFT")
opanel.labelShowItemLvlOnBagItems:SetText("Show Item Level on Gear in inventory, paper doll and inspect frame")

-- ui option - Show Item level and spec on tooltips on players
opanel.checkShowItemLvlSpecOnPlayers = CreateFrame("CheckButton", "BT_ShowItemLvlSpecOnPlayers", opanel, "OptionsBaseCheckButtonTemplate")
opanel.checkShowItemLvlSpecOnPlayers:SetPoint("TOPLEFT", opanel.checkShowItemLvlOnBagItems, "BOTTOMLEFT", 0, -8)
opanel.labelShowItemLvlSpecOnPlayers = opanel:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
opanel.labelShowItemLvlSpecOnPlayers:SetPoint("LEFT", opanel.checkShowItemLvlSpecOnPlayers, "RIGHT", 2, 1)
opanel.labelShowItemLvlSpecOnPlayers:SetJustifyH("LEFT")
opanel.labelShowItemLvlSpecOnPlayers:SetText("Show Item level and spec on tooltips on players")

-- ui option - Show Item level of target in inspect frame
opanel.checkShowTargetItemLvlInInspect = CreateFrame("CheckButton", "BT_checkShowTargetItemLvlInInspect", opanel, "OptionsBaseCheckButtonTemplate")
opanel.checkShowTargetItemLvlInInspect:SetPoint("TOPLEFT", opanel.checkShowItemLvlSpecOnPlayers, "BOTTOMLEFT", 0, -8)
opanel.labelShowTargetItemLvlInInspect = opanel:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
opanel.labelShowTargetItemLvlInInspect:SetPoint("LEFT", opanel.checkShowTargetItemLvlInInspect, "RIGHT", 2, 1)
opanel.labelShowTargetItemLvlInInspect:SetJustifyH("LEFT")
opanel.labelShowTargetItemLvlInInspect:SetText("Show Item level of target in inspect frame")

-- ui option - Show Number of Slots on Bag items
opanel.checkShowNumberOfSlots = CreateFrame("CheckButton", "BT_checkShowNumberOfSlots", opanel, "OptionsBaseCheckButtonTemplate")
opanel.checkShowNumberOfSlots:SetPoint("TOPLEFT", opanel.checkShowTargetItemLvlInInspect, "BOTTOMLEFT", 0, -8)
opanel.labelShowNumberOfSlots = opanel:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
opanel.labelShowNumberOfSlots:SetPoint("LEFT", opanel.checkShowNumberOfSlots, "RIGHT", 2, 1)
opanel.labelShowNumberOfSlots:SetJustifyH("LEFT")
opanel.labelShowNumberOfSlots:SetText("Show Number of Slots on Bag items")

-- functional title
opanel.functionalTitle = opanel:CreateFontString(nil, "ARTWORK", "GameFontNormalMed3")
opanel.functionalTitle:SetPoint("TOPLEFT",  opanel.checkShowNumberOfSlots, "BOTTOMLEFT", 0, -20)
opanel.functionalTitle:SetText("Functional")
opanel.functionalTitle:SetJustifyH("LEFT")

-- functional option - Auto Repair
opanel.checkAutoRepair = CreateFrame("CheckButton", "BT_checkAutoRepair", opanel, "OptionsBaseCheckButtonTemplate")
opanel.checkAutoRepair:SetPoint("TOPLEFT", opanel.functionalTitle, "BOTTOMLEFT", 0, -10)
opanel.labelAutoRepair = opanel:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
opanel.labelAutoRepair:SetPoint("LEFT", opanel.checkAutoRepair, "RIGHT", 2, 1)
opanel.labelAutoRepair:SetJustifyH("LEFT")
opanel.labelAutoRepair:SetText("Auto Repair")

-- functional option - Auto Sell Junk
opanel.checkAutoSellChunk = CreateFrame("CheckButton", "BT_checkAutoSellChunk", opanel, "OptionsBaseCheckButtonTemplate")
opanel.checkAutoSellChunk:SetPoint("TOPLEFT", opanel.checkAutoRepair, "BOTTOMLEFT", 0, -8)
opanel.labelAutoSellChunk = opanel:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
opanel.labelAutoSellChunk:SetPoint("LEFT", opanel.checkAutoSellChunk, "RIGHT", 2, 1)
opanel.labelAutoSellChunk:SetJustifyH("LEFT")
opanel.labelAutoSellChunk:SetText("Auto Sell Junk")

BlizzTweaks.opanel = opanel
BlizzTweaks.opanel.name = "BlizzTweaks";
InterfaceOptions_AddCategory(BlizzTweaks.opanel);
