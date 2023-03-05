-- getting important frames and objects

local CollectionsFrame = _G["Collections"] -- The Collections Frame with talents, mystic enchants, hero architect, etc.
local mysticRuneId = 98462
local mysticExtractId = 98463
local mysticRuneCount = GetItemCount(mysticRuneId) -- counts the current amount of Mystic Runes
local mysticExtractCount = GetItemCount(mysticExtractId) -- counts the current amount of Mystic Extracts
local mysticEnchantReforgeOnceButton = _G["MysticEnchantingFrameControlFrameRollButton"] -- the reforge button from the main UI
local mysticEnchantingFameToken = _G["MysticEnchantingFrameControlFrameTokenFrameTokenButton"] -- the check token for enabling mysticEnchantReforgeTenTimes and mysticEnchantReforgeAll

-- reverse engineering tool to get frame names

--[[
UIParent:HookScript("OnUpdate", function()
    local mouseFocus = GetMouseFocus():GetName()
    if mouseFocus then
        print(mouseFocus)
    else
        print("Mouse not over any frame")
    end
end)
]]--

-- checks if the player casts anything or not. currently not in use in this addon

--[[
local playerCasts = false
if UnitCastingInfo("player") or UnitChannelInfo("player") then
    -- player is casting or channeling a spell
    local playerCasts = true
else
    -- player is not casting or channeling a spell
    local playerCasts = false
end
]]--

-- creating the frame for the additional reforging options

local frame = CreateFrame("Frame", "MultiReforgingFrame", UIParent)
frame:SetSize(220, 120)
frame:SetPoint("TOPRIGHT", CollectionsFrame, "TOPRIGHT", 205, -5)

local frameHeading = CreateFrame("Frame", "MultiReforgingHeadingFrame", frame)
frameHeading:SetSize(140, 35)
frameHeading:SetPoint("TOP", frame, "TOP", 0, 20)
frameHeading:SetBackdrop({
    bgFile = "Interface/PVPFrame/UI-Character-PVP-Elements",
	edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
    tile = true,
    tileSize = 150,
    edgeSize = 16,
    insets = { left = 0, right = 0, top = 0, bottom = 0 }
})
frameHeading:SetBackdropColor(1, 1, 1, 1)
frameHeading:SetBackdropBorderColor(1, 1, 1, 1)


local heading = frameHeading:CreateFontString(nil, "OVERLAY", "GameFontNormal")
heading:SetText("Multi Reforging")
heading:SetPoint("TOP", frameHeading, "TOP", 0, -10)


local closeButton = CreateFrame("Button", "MultiReforgingCloseButton", frame, "UIPanelCloseButton")
closeButton:SetPoint("TOPRIGHT", frame, "TOPRIGHT", 2, 2)
closeButton:SetScript("OnClick", function()
    frame:Hide()
end)

-- changing the backdrop texture of the frame
frame:SetBackdrop({
    -- bgFile = "Interface/QuestFrame/UI-QuestGreeting-BotLeft",
    bgFile = "Interface/Spellbook/UI-SpellbookPanel-BotLeft",
	edgeFile = "Interface/FriendsFrame/UI-Toast-Border",
    tile = true,
    tileSize = 230,
    edgeSize = 16,
    insets = { left = -30, right = 4, top = 4, bottom = 4 }
})
frame:SetBackdropColor(1, 1, 1, 1)
frame:SetBackdropBorderColor(1, 1, 1, 1)

frame:Hide()

-- function to show the frame
local function ShowMultiReforgingFrame()
    frame:Show()
end

SLASH_SHOWMULTI1 = "/show multi"
SlashCmdList["SHOW MULTI"] = ShowMultiReforgingFrame

-- creates a button that will reforge 10 times in a row

local mysticEnchantReforgeTenTimes = CreateFrame("Button", "ReforgeAction", frame, "UIPanelButtonTemplate")
mysticEnchantReforgeTenTimes:SetSize(120, 25)
mysticEnchantReforgeTenTimes:SetPoint("TOP", frame, "TOP", 0, -25)
mysticEnchantReforgeTenTimes:SetText("Reforge 10x")
mysticEnchantReforgeTenTimes:SetEnabled(false)

mysticEnchantReforgeTenTimes:SetScript("OnEnter", function(self)
    GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
    GameTooltip:SetText("Reforge 10x")
    GameTooltip:AddLine("Click this button to reforge |cffA600FF10 |cffFFFFFFtimes", 1, 1, 1)
    GameTooltip:Show()
end)

mysticEnchantReforgeTenTimes:SetScript("OnLeave", function(self)
    GameTooltip:Hide()
end)

-- creates a button that will reforge until receiving another mystic extract

local mysticExtractReforge = CreateFrame("Button", "ReforgeExtract", frame, "UIPanelButtonTemplate")
mysticExtractReforge:SetSize(170, 25)
mysticExtractReforge:SetPoint("TOP", mysticEnchantReforgeTenTimes, "TOP", 0, -25)
mysticExtractReforge:SetText("Reforge until Extract")
mysticExtractReforge:SetEnabled(false)

mysticExtractReforge:SetScript("OnEnter", function(self)
    GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
    GameTooltip:SetText("Reforge Mystic Runes")
    GameTooltip:AddLine("|cffFFFFFFuntil receiving another |cffA600FFMystic Extract", 1, 1, 1)
    GameTooltip:Show()
end)

mysticExtractReforge:SetScript("OnLeave", function(self)
    GameTooltip:Hide()
end)

-- creates a button that will be the "reforgeall" button to reforge for all mystic runes you have and stop when you have 0 left

local mysticEnchantReforgeAll = CreateFrame("Button", "ReforgeAll", frame, "UIPanelButtonTemplate")
mysticEnchantReforgeAll:SetSize(160, 25)
mysticEnchantReforgeAll:SetPoint("TOP", mysticExtractReforge, "TOP", 0, -25)
mysticEnchantReforgeAll:SetText("Reforge All (" .. mysticRuneCount .. ")")
mysticEnchantReforgeAll:SetEnabled(false)

mysticEnchantReforgeAll:SetScript("OnEnter", function(self)
    local mysticRuneCount = GetItemCount(mysticRuneId)
    GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
    GameTooltip:SetText("|cffFF0000WARNING! " .. "|cffFFA500Reforge ALL")
    GameTooltip:AddLine("Click this button to reforge " .. "|cffA600FF" .. mysticRuneCount .. " |cffFFFFFFtimes", 1, 1, 1)
    GameTooltip:Show()
end)

mysticEnchantReforgeAll:SetScript("OnLeave", function(self)
    GameTooltip:Hide()
end)


-- Cancel button for mystic enchantment. currently disabled, because I couldn't find a "Stop all actions" method.

--[[
local mysticEnchantCancel = CreateFrame("Button", "Cancel", frame, "UIPanelButtonTemplate")
mysticEnchantCancel:SetSize(100, 25)
mysticEnchantCancel:SetPoint("TOP", mysticEnchantReforgeAll, "TOP", 0, -25)
mysticEnchantCancel:SetText("CANCEL")
]]--

-- counting variables for the number of clicks on the mysticEnchantReforgeOnceButton and also to count how many times the reforge action took place
local clicks = 0
local reforgeCount = 0

-- a wait for action helper funtion to delay the reforging click so that it's not spammed

local function WaitForAction(action, maxTime)
    local startTime = GetTime()
    while (GetTime() - startTime) < maxTime do
        if not action() then
            return true
        end
        coroutine.yield()
    end
    return false
end

-- shows the addonframe when the mysticEnchantReforgeOnceButton is shown

mysticEnchantReforgeOnceButton:HookScript("OnShow", function()
    if not frame:IsShown() then
        frame:Show()
    end
end)

-- hides the addonframe when the mysticEnchantReforgeOnceButton is hidden

mysticEnchantReforgeOnceButton:HookScript("OnHide", function()
    if frame:IsShown() then
        frame:Hide()
    end
end)

-- an update helper function to update mysticRuneCount whenever the frame is updated

local function OnUpdate(self, elapsed)
    local mysticRuneCount = GetItemCount(mysticRuneId)
    if frame:IsShown() then
        mysticEnchantReforgeAll:SetText("Reforge All (" .. mysticRuneCount .. ")")
        local mysticExtractCount = GetItemCount(mysticExtractId)
    end
    if (not frame:IsShown() and mysticEnchantingFameToken:IsShown()) then
        reforgeCount = 0
    end
end

frame:SetScript("OnUpdate", OnUpdate)

-- playerlogin register to only update and call the frame when the player actually is logged in.

frame:RegisterEvent("PLAYER_LOGIN")

local function OnEvent(self, event, ...)
    if event == "PLAYER_LOGIN" then
        local mysticRuneCount = GetItemCount(mysticRuneId)
        local mysticExtractCount = GetItemCount(mysticExtractId)
        print("|cffFE67D2MultiReforging v0.0.12 beta by " .. "|cff67FE93ptchblvck" .. "|cffFE67D2 loaded")
        C_Timer.After(5, function() -- wait 5 seconds before checking
            if CollectionsFrame:IsShown() and mysticEnchantReforgeOnceButton:IsShown() then
                frame:Show()
            else
                frame:Hide()
            end
            frame:UnregisterEvent("PLAYER_LOGIN")
        end)
    end
end

frame:SetScript("OnEvent", OnEvent)

-- the main function to make the multiReforging Addon work. This will be the callbackfuntion for the reforge 10 times button

local function OnClick()
    if mysticEnchantReforgeOnceButton:IsShown() then
        -- Code to click the other button
        mysticEnchantReforgeOnceButton:Click()
        WaitForAction(function() return not mysticEnchantReforgeOnceButton:IsEnabled() end, 3)
        clicks = clicks + 1
        reforgeCount = reforgeCount + 1
        local mysticRuneCount = GetItemCount(mysticRuneId)
        if clicks < 10 then
            C_Timer.After(1.5, function() mysticEnchantReforgeTenTimes:Click() end)
        else
            clicks = 0
            C_Timer.After(1.5, function() print("|cff00FFFFReforged " .. "|cffA600FF" .. reforgeCount .. "|cff00FFFF times") end)
        end
        -- print("|cffFA9BFFMystic Rune count: " .. "|cffA600FF" .. mysticRuneCount) -- this is not needed for now
    else
        print("|cffFF0000Button is disabled, action can not be performed.")
    end
end

mysticEnchantReforgeTenTimes:SetScript("OnClick", OnClick)

-- this is the main callback function on the reforge all button

local function OnClickAllRunes()
    if mysticEnchantReforgeOnceButton:IsShown() then
        -- Code to click the other button
        mysticEnchantReforgeOnceButton:Click()
        WaitForAction(function() return not mysticEnchantReforgeOnceButton:IsEnabled() end, 3)
        clicks = clicks + 1
        reforgeCount = reforgeCount + 1
        local mysticRuneCount = GetItemCount(mysticRuneId)
        if clicks < mysticRuneCount then
            C_Timer.After(1.5, function() mysticEnchantReforgeAll:Click() end)
        else
            clicks = 0
            C_Timer.After(1.5, function() print("|cff00FFFFReforged " .. "|cffA600FF" .. reforgeCount .. "|cff00FFFF times") end)
        end
        -- print("|cffFA9BFFMystic Rune count: " .. "|cffA600FF" .. mysticRuneCount) -- this is not needed for now
    else
        mysticEnchantReforgeAll:SetEnabled(false)
        print("|cffFF0000Button is disabled, action can not be performed.")
    end
end

mysticEnchantReforgeAll:SetScript("OnClick", OnClickAllRunes)

-- this is the main callback function for reforging until you get another mystic extract

local currentExtracts = mysticExtractCount

local function OnClickExtract()
    if mysticEnchantReforgeOnceButton:IsShown() then
        -- Code to click the other button
        mysticEnchantReforgeOnceButton:Click()
        WaitForAction(function() return not mysticEnchantReforgeOnceButton:IsEnabled() end, 3)
        clicks = clicks + 1
        reforgeCount = reforgeCount + 1
        local mysticRuneCount = GetItemCount(mysticRuneId)
        local mysticExtractCount = GetItemCount(mysticExtractId)
        if mysticExtractCount == currentExtracts and clicks < mysticRuneCount then
            C_Timer.After(1.5, function() mysticExtractReforge:Click() end)
        else
            clicks = 0
            C_Timer.After(1.5, function() print("|cff00FFFFReforged " .. "|cffA600FF" .. reforgeCount .. "|cff00FFFF times")
            print("|cff00FFFFReceived 1 additional |cffA600FFMystic Extract") end)
        end
        currentExtracts = mysticExtractCount
        -- print("|cffFA9BFFMystic Rune count: " .. "|cffA600FF" .. mysticRuneCount) -- this is not needed for now
    else
        mysticExtractReforge:SetEnabled(false)
        print("|cffFF0000Button is disabled, action can not be performed.")
    end
end

mysticExtractReforge:SetScript("OnClick", OnClickExtract)

-- if the token is shown sets buttons to enabled and also updates the mysticRuneCount variable

mysticEnchantingFameToken:HookScript("OnShow", function()
    local mysticRuneCount = GetItemCount(mysticRuneId)
    if mysticEnchantReforgeOnceButton:IsEnabled() then
        mysticEnchantReforgeTenTimes:SetEnabled(true)
        mysticExtractReforge:SetEnabled(true)
        mysticEnchantReforgeAll:SetEnabled(true)
    end
    if mysticRuneCount < 1 then
        mysticEnchantReforgeTenTimes:SetEnabled(false)
        mysticExtractReforge:SetEnabled(false)
        mysticEnchantReforgeAll:SetEnabled(false)
    end
end)

mysticEnchantingFameToken:HookScript("OnHide", function()
    local mysticRuneCount = GetItemCount(mysticRuneId)
        mysticEnchantReforgeTenTimes:SetEnabled(false)
        mysticExtractReforge:SetEnabled(false)
        mysticEnchantReforgeAll:SetEnabled(false)
end)

-- currently not working

--[[
mysticEnchantCancel:SetScript("OnClick", function()
    local playerCasts = false
    clicks = 0
end)
]]--