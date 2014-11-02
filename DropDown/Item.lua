------------------------------------------------------------
-- | MalUI  											| --
-- | GUI Library                    					| --
-- | Copyright (c) 2014 Malakahh. All Rights Reserved.	| --
------------------------------------------------------------

local lib = LibStub("MalUI-1.0")
if not lib then return end

lib.DropDown = lib.DropDown or {}
lib.DropDown.Item = lib.DropDown.Item or {}

lib.DropDown.Item.__index = lib.DropDown.Item

local c = lib.DropDown.MenuEntry.Constants

function lib.DropDown.Item.Create(parent, text, value)
    if parent == nil or text == nil or text == "" then return end
    if value == nil then value = text end

    local self = lib.DropDown.MenuEntry.Create(parent, "item", text, false)
    setmetatable(self, lib.DropDown.Item)
    for k,v in pairs(lib.DropDown.MenuEntry) do
        self[k] = v
    end

    self.value = value

    parent[self.numChild] = self

    return self
end

function lib.DropDown.Item.Refresh(self, dropDown, menuFrame)
    local btn = lib.DropDown.WidgetFactory.AcquireButton()
    btn:SetParent(menuFrame)

    local sectionInset = 0
    if self.parent.type == "section" then
        sectionInset = self.parent:GetSectionInset()
    end

    local x,y
    x = c.ITEM_LEFT_INSET + sectionInset
    y = -c.ITEM_HEIGHT * (self:GetNestedPosition() - 1) - c.ITEM_TOP_INSET

    btn:SetPoint("TOPLEFT", menuFrame, "TOPLEFT", x, y)
    btn:SetWidth(menuFrame:GetWidth() - c.ITEM_LEFT_INSET - sectionInset - 10)

    btn:SetText(self.text)
    btn:SetScript("OnClick", function(btn, mouseBtn, isDown)
        dropDown:SetSelected(self.text)
        dropDown:CloseMenu()
    end)

    btn:SetScript("OnEnter", function(s)
        lib.DropDown.Menu.CloseMenus(self)
    end)

    btn:Show()
    self.btn = btn
end

function lib.DropDown.Item.Release(self)
    lib.DropDown.WidgetFactory.ReleaseButton(self.btn)
    self.btn = nil
end

function lib.DropDown.Item.Remove(self)
    --Close menu (forcing an update next time it is open
    local s = self.parent
    while (s.parent) do s = s.parent end
    s.dropDown:CloseMenu()

    self.parent[self.numChild] = nil
end

function lib.DropDown.Item.GetNestedPosition(self)
    local num = self.numChild
    local parent = self.parent
    for i = 1, self.numChild-1 do
        if parent[i].type == "section" then
            num = num + parent[i]:GetNestedCount()
        end
    end

    if parent.GetNestedPosition and parent.type ~= "menu" then
        num = num + parent:GetNestedPosition()
    end
    return num
end