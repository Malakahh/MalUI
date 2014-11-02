------------------------------------------------------------
-- | MalUI  											| --
-- | GUI Library                    					| --
-- | Copyright (c) 2014 Malakahh. All Rights Reserved.	| --
------------------------------------------------------------

local lib = LibStub("MalUI-1.0")
if not lib then return end

lib.DialogMessage = lib.DialogMessage or {}


local isAcquired = false

--For holding OK and Cancel scripts
local scripts = {}

--frame
local frame = CreateFrame("Frame", nil, UIParent)
frame:SetBackdrop({
    bgFile = "Interface/Tooltips/UI-Tooltip-Background",
    edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
    tile = true,
    tileSize = 16,
    edgeSize = 16,
    insets = { left = 4, right = 4, top = 4, bottom = 4 },
})
frame:SetBackdropColor(0, 0, 0, 1)
frame:SetFrameStrata("TOOLTIP")

--dragging
frame:SetMovable(true)
frame:EnableMouse(true)
frame:RegisterForDrag("LeftButton", "RightButton")
frame:SetScript("OnDragStart", function(self)
    self:StartMoving()
end)
frame:SetScript("OnDragStop", function(self)
    self:StopMovingOrSizing()
end)

--Headline
local headline = frame:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")

--Description
local description = frame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
description:SetWordWrap(true)

--OK Btn
local OKBtn = CreateFrame("Button", "OKBtn", frame, "UIPanelButtonTemplate")
OKBtn:SetScript("OnClick", function(self, mouseBtn, isPressed)
    local ret
    if scripts.OK then
        ret = scripts.OK()
    end

    lib.DialogMessage.Reset()

    return ret
end)

--Cancel Btn
local cancelBtn = CreateFrame("Button", "cancelBtn", frame, "UIPanelButtonTemplate")
cancelBtn:SetScript("OnClick", function(self, mouseBtn, isPressed)
    local ret
    if scripts.Cancel then
        ret = scripts.Cancel()
    end

    lib.DialogMessage.Reset()

    return ret
end)

function lib.DialogMessage.Reset()
    --scripts
    wipe(scripts)

    --frame
    frame:SetSize(400, 200)
    frame:SetPoint("CENTER")
    frame:Hide()

    --headline
    headline:SetPoint("TOP", 0, -10)
    headline:SetText("This is a headline")

    --description
    description:SetPoint("TOP", headline, "BOTTOM", 0, -15)
    description:SetText("This is an even longer description, jajajajajaj")
    description:SetWidth(frame:GetWidth() - 10)

    --OK Btn
    OKBtn:SetSize(120, 24)
    OKBtn:SetText("OK")
    OKBtn:SetPoint("RIGHT", frame, "BOTTOM", -5, 20)

    --cancel Btn
    cancelBtn:SetSize(120, 24)
    cancelBtn:SetText("Canecl")
    cancelBtn:SetPoint("LEFT", frame, "BOTTOM", 5, 20)
end

function lib.DialogMessage.Acquire(Headline, Description, okCallback, cancelCallback)
    if not isAcquired then
        isAcquired = true

        headline:SetText(Headline)
        description:SetText(Description)
        scripts.OK = okCallback
        scripts.Cancel = cancelCallback

        return frame
    end
end

function lib.DialogMessage.Release()
    isAcquired = false
    lib.DialogMessage.Reset()
end

lib.DialogMessage.Reset()