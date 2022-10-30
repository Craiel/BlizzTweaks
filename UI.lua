--[[
  BlizzTweaks
]]

local L = LibStub("AceLocale-3.0"):GetLocale("BlizzTweaks", false)

---------------------------------------------------------
-- UI Tweaks
function BlizzTweaks:HandleDeleteConfirm(evt)
    if StaticPopup1EditBox:IsShown() then
        StaticPopup1EditBox:Hide()
        StaticPopup1Button1:Enable()
    end
end