------------------------------------------------------------
-- | MalUI  											| --
-- | GUI Library                    					| --
-- | Copyright (c) 2014 Malakahh. All Rights Reserved.	| --
------------------------------------------------------------

local lib = LibStub("MalUI-1.0")
if not lib then return end

lib.DropDown = lib.DropDown or {}
lib.DropDown.Menu = lib.DropDown.Menu or {}

lib.DropDown.Menu.__index = lib.DropDown.Menu

local c = lib.DropDown.MenuEntry.Constants

function lib.DropDown.Menu.Create(parent, text)
    if parent == nil or text == nil or text == "" then return end

    local self = lib.DropDown.MenuEntry.Create(parent, "menu", text)
    setmetatable(self, lib.DropDown.Menu)
    for k,v in pairs(lib.DropDown.MenuEntry) do
        self[k] = v
    end

    parent[self.numChild] = self

    return self
end

function lib.DropDown.Menu.Refresh(self, dropDown, menuFrame)
    local btn = lib.DropDown.WidgetFactory.AcquireButton()
    btn:SetParent(menuFrame)

    local sectionInset = 0
    if self.parent.type == "section" then
        sectionInset = self.parent:GetSectionInset()
    end

    local nestedPos = self:GetNestedPosition()
    local x,y
    x = c.ITEM_LEFT_INSET + sectionInset
    y = -c.ITEM_HEIGHT * (nestedPos - 1) - c.ITEM_TOP_INSET

    btn:SetPoint("TOPLEFT", menuFrame, "TOPLEFT", x, y)
    btn:SetWidth(menuFrame:GetWidth() - c.ITEM_LEFT_INSET - sectionInset - 10)

    btn:SetText(self.text)
    btn:SetScript("OnEnter", function(s)
        lib.DropDown.Menu.CloseMenus(self)
        self.frame:Show()
    end)

    btn:Show()
    btn.ExpandArrow:Show()

    self.btn = btn


    local frame = lib.DropDown.WidgetFactory.AcquireFrame()
    frame:SetParent(menuFrame)

    local fy = -c.ITEM_HEIGHT * (nestedPos - 1) - c.ITEM_TOP_INSET - c.MENU_TOP_PADDING
    frame:SetPoint("TOPLEFT", menuFrame, "TOPRIGHT", c.MENU_LEFT_PADDING, fy)
    frame:SetWidth(menuFrame:GetWidth())

    frame:Hide()

    self.frame = frame

    local height = #self
    for i = 1, #self do
        if self[i].type then
            self[i]:Refresh(dropDown, self.frame)

            if self[i].type == "section" then
                height = height + self[i]:GetNestedCount()
            end
        end
    end

    self.frame:SetHeight(height * c.ITEM_HEIGHT + c.MENU_BASE_HEIGHT)
end

local function rClose(list)
    for i = 1, #list do
        if list[i].type == "section" then
            rClose(list[i])
        elseif list[i].type == "menu" then
            rClose(list[i])
            list[i].frame:Hide()
        end
    end
end

function lib.DropDown.Menu.CloseMenus(self)
    local s = self.parent

    if s then
        while s.type == "section" do
            s = s.parent
        end
    end

    rClose(s)
end

function lib.DropDown.Menu.Release(self)
    lib.DropDown.WidgetFactory.ReleaseButton(self.btn)
    lib.DropDown.WidgetFactory.ReleaseFrame(self.frame)
    self.btn = nil
    self.frame = nil

    for i = 1, #self do
        if self[i].type then
            self[i]:Release()
        end
    end
end

function lib.DropDown.Menu.Remove(self)
    --Close menu (forcing an update next time it is open
    local s = self.parent
    while (s.parent) do s = s.parent end
    s.dropDown:CloseMenu()

    self:Release()
    self.parent[self.numChild] = nil
end

function lib.DropDown.Menu.GetNestedPosition(self)
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