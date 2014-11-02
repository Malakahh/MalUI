------------------------------------------------------------
-- | MalUI  											| --
-- | GUI Library                    					| --
-- | Copyright (c) 2014 Malakahh. All Rights Reserved.	| --
------------------------------------------------------------

local lib = LibStub("MalUI-1.0")
if not lib then return end

lib.DropDown = lib.DropDown or {}
lib.DropDown.Section = lib.DropDown.Section or {}

lib.DropDown.Section.__index = lib.DropDown.Section

local c = lib.DropDown.MenuEntry.Constants

function lib.DropDown.Section.Create(parent, text)
    if parent == nil or text == nil or text == "" then return end

    local self = lib.DropDown.MenuEntry.Create(parent, "section", text)
    setmetatable(self, lib.DropDown.Section)
    for k,v in pairs(lib.DropDown.MenuEntry) do
        self[k] = v
    end

    parent[self.numChild] = self

    return self
end

function lib.DropDown.Section.Refresh(self, dropDown, menuFrame)
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

    local fString = btn:GetFontString()
    fString:SetTextColor(0.8, 0.656, 0)
    btn:SetFontString(fString)
    btn:SetText(self.text)

    btn:Disable()
    btn:Show()

    btn:SetScript("OnEnter", function(s)
        lib.DropDown.Menu.CloseMenus(self)
    end)

    self.btn = btn

    for i = 1, #self do
        if self[i].type then
            self[i]:Refresh(dropDown, menuFrame)
        end
    end
end

function lib.DropDown.Section.Release(self)
    lib.DropDown.WidgetFactory.ReleaseButton(self.btn)
    self.btn = nil

    for i = 1, #self do
        if self[i].type then
            self[i]:Release()
        end
    end
end

function lib.DropDown.Section.GetSectionInset(self)
    local ret = c.SECTION_INSET
    if self.parent.type == "section" then
        ret = ret + self.parent:GetSectionInset()
    end
    return ret
end

function lib.DropDown.Section.GetNestedCount(self)
    local ret = #self
    for i = 1, #self do
        if self[i].type == "section" then
            ret = ret + self[i]:GetNestedCount()
        end
    end

    return ret
end

function lib.DropDown.Section.Remove(self)
    --Close menu (forcing an update next time it is open
    local s = self.parent
    while (s.parent) do s = s.parent end
    s.dropDown:CloseMenu()

    self:Release()
    self.parent[self.numChild] = nil
end

function lib.DropDown.Section.GetNestedPosition(self)
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