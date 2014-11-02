------------------------------------------------------------
-- | MalUI  											| --
-- | GUI Library                    					| --
-- | Copyright (c) 2014 Malakahh. All Rights Reserved.	| --
------------------------------------------------------------

local lib = LibStub("MalUI-1.0")
if not lib then return end

lib.DropDown = lib.DropDown or {}
lib.DropDown.WidgetFactory = lib.DropDown.WidgetFactory or {}

local c = lib.DropDown.MenuEntry.Constants

local framePool = {}
local buttonPool = {}
local totalButtonCount = 0

-----
---Frames
-----

--Acquires a frame and cleans it up from last use
function lib.DropDown.WidgetFactory.AcquireFrame()
    local f = table.remove(framePool)

    if f == nil then
        f = CreateFrame("Frame")
    end

    f:UnregisterAllEvents()
    f:Hide()
    f:SetPoint("CENTER")
    f:SetSize(0, c.MENU_BASE_HEIGHT)
    f:SetParent(UIParent)
    f:SetBackdrop({
        bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background-Dark",
        edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
        tile = true,
        tileSize = 32,
        edgeSize = 32,
        insets = {
            left = 11,
            right = 12,
            top = 12,
            bottom = 9
        }
    })
    f:SetBackdropColor(0.09, 0.09, 0.09);
    f:SetScript("OnEnter", nil)
    f:SetScript("OnLeave", nil)

    if f.OnUpdate == nil then
        function f.OnUpdate(s, elapsed)
            s.total = s.total + elapsed
            if s.total >= 1 then
                s:Hide()
            end
        end
    end

    if f.OnEnter == nil then
        function f.OnEnter(self)
            self.total = 0
            self:SetScript("OnUpdate", nil)
            self:Show()
        end
    end

    if f.OnLeave == nil then
        function f.OnLeave(self)
            self.total = 0
            self:SetScript("OnUpdate", f.OnUpdate)
        end
    end

    return f
end

--Releases a frame for future uses
function lib.DropDown.WidgetFactory.ReleaseFrame(f)
    f:Hide()
    f:SetScript("OnUpdate", nil)
    table.insert(framePool, f)
end

-----
---Buttons
-----

--Acquires a button and cleans it up from last use
function lib.DropDown.WidgetFactory.AcquireButton()
    local btn = table.remove(buttonPool)

    if btn == nil then
        totalButtonCount = totalButtonCount + 1
        btn = CreateFrame("Button", "DropDownButton"..totalButtonCount)
        btn:SetHighlightTexture("Interface\\QuestFrame\\UI-QuestTitleHighlight")
    end

    btn:Enable()

    btn:SetParent(UIParent)
    btn:SetSize(0, 16)
    btn:SetPoint("CENTER")

    btn:SetScript("OnClick", nil)
    btn:SetScript("OnEnter", nil)
    btn:SetScript("OnLeave", nil)

    btn:Hide()

    if btn.CheckTex == nil then
        local checkTex = btn:CreateTexture(btn:GetName().."Check", "ARTWORK")
        checkTex:SetTexture("Interface\\Common\\UI-DropDownRadioChecks")
        checkTex:SetSize(16, 16)
        checkTex:SetTexCoord(0.0, 0.5, 0.5, 1.0)
        btn.CheckTex = checkTex
    end

    btn.CheckTex:SetPoint("LEFT")
    btn.CheckTex:Hide()

    if btn.UnCheckTex == nil then
        local unCheckTex = btn:CreateTexture(btn:GetName().."UnCheck", "ARTWORK")
        unCheckTex:SetTexture("Interface\\Common\\UI-DropDownRadioChecks")
        unCheckTex:SetSize(16, 16)
        unCheckTex:SetTexCoord(0.5, 1.0, 0.5, 1.0)
        btn.UnCheckTex = unCheckTex
    end

    btn.UnCheckTex:SetPoint("LEFT")
    btn.UnCheckTex:Hide()

    if btn.ExpandArrow == nil then
        local expArrowBtn = CreateFrame("Button", btn:GetName().."ExpandArrow", btn)
        expArrowBtn:SetSize(16, 16)
        expArrowBtn:SetNormalTexture("Interface\\ChatFrame\\ChatFrameExpandArrow")
        btn.ExpandArrow = expArrowBtn
    end

    btn.ExpandArrow:SetPoint("RIGHT")
    btn.ExpandArrow:Hide()

    local fString = btn:GetFontString()
    if fString == nil then
        fString = btn:CreateFontString(btn:GetName().."Label", "ARTWORK", "GameFontHighlightSmall")
    end
    fString:SetNonSpaceWrap(false)
    fString:SetJustifyH("RIGHT")
    fString:SetTextColor(1, 1, 1)

    fString:SetSize(0, 10)
    fString:SetPoint("LEFT", 16, 0)

    btn:SetFontString(fString)

    return btn
end

--Releases a button for future uses
function lib.DropDown.WidgetFactory.ReleaseButton(btn)
    btn:Hide()
    table.insert(buttonPool, btn)
end