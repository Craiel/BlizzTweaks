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
opanel.title2:SetText("Author: " .. GetAddOnMetadata("BlizzTweaks", "Author") .. "\nVersion: " .. GetAddOnMetadata("BlizzTweaks", "Version"))
opanel.title2:SetJustifyH("LEFT")

-- ui title
opanel.uiTitle = opanel:CreateFontString(nil, "ARTWORK", "GameFontNormalMed3")
opanel.uiTitle:SetPoint("TOPLEFT",  opanel.title2, "BOTTOMLEFT", 0, -20)
opanel.uiTitle:SetText("UI")
opanel.uiTitle:SetJustifyH("LEFT")

-- ui option - Show Item Level on Gear in inventory
opanel.checkShowItemLvlOnBagItems = CreateFrame("CheckButton", "BT_checkShowItemLvlOnBagItems", opanel, "OptionsBaseCheckButtonTemplate")
opanel.checkShowItemLvlOnBagItems:SetPoint("TOPLEFT", opanel.uiTitle, "BOTTOMLEFT", 0, -10)
opanel.checkShowItemLvlOnBagItems:SetScript("OnClick", function() BlizzTweaks.db.profile.enableItemLevelDisplayOnItems = opanel.checkShowItemLvlOnBagItems:GetChecked() end)
opanel.labelShowItemLvlOnBagItems = opanel:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
opanel.labelShowItemLvlOnBagItems:SetPoint("LEFT", opanel.checkShowItemLvlOnBagItems, "RIGHT", 2, 1)
opanel.labelShowItemLvlOnBagItems:SetJustifyH("LEFT")
opanel.labelShowItemLvlOnBagItems:SetText("Show Item Level, Bound State and Slots on Gear and Bags in inventory")

-- ui option - Show Item Level on Gear in paper doll and inspect frame
opanel.checkShowItemLvlOnPaperDoll = CreateFrame("CheckButton", "BT_checkShowItemLvlOnPaperdoll", opanel, "OptionsBaseCheckButtonTemplate")
opanel.checkShowItemLvlOnPaperDoll:SetPoint("TOPLEFT", opanel.checkShowItemLvlOnBagItems, "BOTTOMLEFT", 0, -8)
opanel.checkShowItemLvlOnPaperDoll:SetScript("OnClick", function() BlizzTweaks.db.profile.enableItemLevelDisplayOnPaperDoll = opanel.checkShowItemLvlOnPaperDoll:GetChecked() end)
opanel.labelShowItemLvlOnPaperDoll = opanel:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
opanel.labelShowItemLvlOnPaperDoll:SetPoint("LEFT", opanel.checkShowItemLvlOnPaperDoll, "RIGHT", 2, 1)
opanel.labelShowItemLvlOnPaperDoll:SetJustifyH("LEFT")
opanel.labelShowItemLvlOnPaperDoll:SetText("Show Item Level, Bound State and Slots on Gear in paper doll and inspect frame")

-- ui option - Show Item level and spec on tooltips on players
opanel.checkShowItemLvlSpecOnPlayers = CreateFrame("CheckButton", "BT_checkShowItemLvlSpecOnPlayers", opanel, "OptionsBaseCheckButtonTemplate")
opanel.checkShowItemLvlSpecOnPlayers:SetPoint("TOPLEFT", opanel.checkShowItemLvlOnPaperDoll, "BOTTOMLEFT", 0, -8)
opanel.checkShowItemLvlSpecOnPlayers:SetScript("OnClick", function() BlizzTweaks.db.profile.enableTooltipItemLevelAndSpec = opanel.checkShowItemLvlSpecOnPlayers:GetChecked() end)
opanel.labelShowItemLvlSpecOnPlayers = opanel:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
opanel.labelShowItemLvlSpecOnPlayers:SetPoint("LEFT", opanel.checkShowItemLvlSpecOnPlayers, "RIGHT", 2, 1)
opanel.labelShowItemLvlSpecOnPlayers:SetJustifyH("LEFT")
opanel.labelShowItemLvlSpecOnPlayers:SetText("Show Item level and spec on tooltips on players")

-- ui option - Show Item level of target in inspect frame
opanel.checkShowTargetItemLvlInInspect = CreateFrame("CheckButton", "BT_checkShowTargetItemLvlInInspect", opanel, "OptionsBaseCheckButtonTemplate")
opanel.checkShowTargetItemLvlInInspect:SetPoint("TOPLEFT", opanel.checkShowItemLvlSpecOnPlayers, "BOTTOMLEFT", 0, -8)
opanel.checkShowTargetItemLvlInInspect:SetScript("OnClick", function() BlizzTweaks.db.profile.enableItemLevelOnInspect = opanel.checkShowTargetItemLvlInInspect:GetChecked() end)
opanel.labelShowTargetItemLvlInInspect = opanel:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
opanel.labelShowTargetItemLvlInInspect:SetPoint("LEFT", opanel.checkShowTargetItemLvlInInspect, "RIGHT", 2, 1)
opanel.labelShowTargetItemLvlInInspect:SetJustifyH("LEFT")
opanel.labelShowTargetItemLvlInInspect:SetText("Show Item level of target in inspect frame")

-- ui option - Grey out Junk Items
opanel.checkGreyOutJunkItems = CreateFrame("CheckButton", "BT_checkGreyOutJunkItems", opanel, "OptionsBaseCheckButtonTemplate")
opanel.checkGreyOutJunkItems:SetPoint("TOPLEFT", opanel.checkShowTargetItemLvlInInspect, "BOTTOMLEFT", 0, -8)
opanel.checkGreyOutJunkItems:SetScript("OnClick", function() BlizzTweaks.db.profile.enableJunkItemGreyOverlay = opanel.checkGreyOutJunkItems:GetChecked() end)
opanel.labelGreyOutJunkItems = opanel:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
opanel.labelGreyOutJunkItems:SetPoint("LEFT", opanel.checkGreyOutJunkItems, "RIGHT", 2, 1)
opanel.labelGreyOutJunkItems:SetJustifyH("LEFT")
opanel.labelGreyOutJunkItems:SetText("Grey out Junk Items in Bags")

-- ui option - Color Missing Enchants
opanel.checkHighlightMissingEnchants = CreateFrame("CheckButton", "BT_checkHighlightMissingEnchants", opanel, "OptionsBaseCheckButtonTemplate")
opanel.checkHighlightMissingEnchants:SetPoint("TOPLEFT", opanel.checkGreyOutJunkItems, "BOTTOMLEFT", 0, -8)
opanel.checkHighlightMissingEnchants:SetScript("OnClick", function() BlizzTweaks.db.profile.enableMissingEnchantOverlay = opanel.checkHighlightMissingEnchants:GetChecked() end)
opanel.labelHighlightMissingEnchants = opanel:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
opanel.labelHighlightMissingEnchants:SetPoint("LEFT", opanel.checkHighlightMissingEnchants, "RIGHT", 2, 1)
opanel.labelHighlightMissingEnchants:SetJustifyH("LEFT")
opanel.labelHighlightMissingEnchants:SetText("Highlight Missing Enchants on equipped gear")

-- functional title
opanel.functionalTitle = opanel:CreateFontString(nil, "ARTWORK", "GameFontNormalMed3")
opanel.functionalTitle:SetPoint("TOPLEFT",  opanel.checkHighlightMissingEnchants, "BOTTOMLEFT", 0, -20)
opanel.functionalTitle:SetText("Functional")
opanel.functionalTitle:SetJustifyH("LEFT")

-- functional option - Auto Repair
opanel.checkAutoRepair = CreateFrame("CheckButton", "BT_checkAutoRepair", opanel, "OptionsBaseCheckButtonTemplate")
opanel.checkAutoRepair:SetPoint("TOPLEFT", opanel.functionalTitle, "BOTTOMLEFT", 0, -10)
opanel.checkAutoRepair:SetScript("OnClick", function() BlizzTweaks.db.profile.enableAutoRepair = opanel.checkAutoRepair:GetChecked() end)
opanel.labelAutoRepair = opanel:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
opanel.labelAutoRepair:SetPoint("LEFT", opanel.checkAutoRepair, "RIGHT", 2, 1)
opanel.labelAutoRepair:SetJustifyH("LEFT")
opanel.labelAutoRepair:SetText("Auto Repair")

-- functional option - Auto Sell Junk
opanel.checkAutoSellChunk = CreateFrame("CheckButton", "BT_checkAutoSellChunk", opanel, "OptionsBaseCheckButtonTemplate")
opanel.checkAutoSellChunk:SetPoint("TOPLEFT", opanel.checkAutoRepair, "BOTTOMLEFT", 0, -8)
opanel.checkAutoSellChunk:SetScript("OnClick", function() BlizzTweaks.db.profile.enableAutoSellJunk = opanel.checkAutoSellChunk:GetChecked() end)
opanel.labelAutoSellChunk = opanel:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
opanel.labelAutoSellChunk:SetPoint("LEFT", opanel.checkAutoSellChunk, "RIGHT", 2, 1)
opanel.labelAutoSellChunk:SetJustifyH("LEFT")
opanel.labelAutoSellChunk:SetText("Auto Sell Junk")

-- functional option - Easy Delete
opanel.checkEasyDelete = CreateFrame("CheckButton", "BT_checkEasyDelete", opanel, "OptionsBaseCheckButtonTemplate")
opanel.checkEasyDelete:SetPoint("TOPLEFT", opanel.checkAutoSellChunk, "BOTTOMLEFT", 0, -8)
opanel.checkEasyDelete:SetScript("OnClick", function() BlizzTweaks.db.profile.enableEasyDelete = opanel.checkEasyDelete:GetChecked() end)
opanel.labelEasyDelete = opanel:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
opanel.labelEasyDelete:SetPoint("LEFT", opanel.checkEasyDelete, "RIGHT", 2, 1)
opanel.labelEasyDelete:SetJustifyH("LEFT")
opanel.labelEasyDelete:SetText("Delete items without having to type \"Delete\"")

-- functional option - Enemy Cast Target Display
opanel.checkEnemyCastTargetPlate = CreateFrame("CheckButton", "BT_checkEnemyCastTargetPlate", opanel, "OptionsBaseCheckButtonTemplate")
opanel.checkEnemyCastTargetPlate:SetPoint("TOPLEFT", opanel.checkEasyDelete, "BOTTOMLEFT", 0, -8)
opanel.checkEnemyCastTargetPlate:SetScript("OnClick", function() BlizzTweaks.db.profile.enableEnemyCastTargetDisplay = opanel.checkEnemyCastTargetPlate:GetChecked() end)
opanel.labelEnemyCastTargetPlate = opanel:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
opanel.labelEnemyCastTargetPlate:SetPoint("LEFT", opanel.checkEnemyCastTargetPlate, "RIGHT", 2, 1)
opanel.labelEnemyCastTargetPlate:SetJustifyH("LEFT")
opanel.labelEnemyCastTargetPlate:SetText("Show target of enemy spell casts in their nameplate")

BlizzTweaks.opanel = opanel
BlizzTweaks.opanel.name = "BlizzTweaks";
InterfaceOptions_AddCategory(BlizzTweaks.opanel);

function BlizzTweaks:RefreshOptions()
    opanel.checkShowItemLvlOnBagItems:SetChecked(BlizzTweaks.db.profile.enableItemLevelDisplayOnItems)
    opanel.checkShowItemLvlOnPaperDoll:SetChecked(BlizzTweaks.db.profile.enableItemLevelDisplayOnPaperDoll)
    opanel.checkShowItemLvlSpecOnPlayers:SetChecked(BlizzTweaks.db.profile.enableTooltipItemLevelAndSpec)
    opanel.checkShowTargetItemLvlInInspect:SetChecked(BlizzTweaks.db.profile.enableItemLevelOnInspect)
    opanel.checkGreyOutJunkItems:SetChecked(BlizzTweaks.db.profile.enableJunkItemGreyOverlay)
    opanel.checkHighlightMissingEnchants:SetChecked(BlizzTweaks.db.profile.enableMissingEnchantOverlay)
    opanel.checkAutoRepair:SetChecked(BlizzTweaks.db.profile.enableAutoRepair)
    opanel.checkAutoSellChunk:SetChecked(BlizzTweaks.db.profile.enableAutoSellJunk)
    opanel.checkEasyDelete:SetChecked(BlizzTweaks.db.profile.enableEasyDelete)
    opanel.checkEnemyCastTargetPlate:SetChecked(BlizzTweaks.db.profile.enableEnemyCastTargetDisplay)
end