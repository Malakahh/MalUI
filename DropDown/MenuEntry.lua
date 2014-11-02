------------------------------------------------------------
-- | MalUI  											| --
-- | GUI Library                    					| --
-- | Copyright (c) 2014 Malakahh. All Rights Reserved.	| --
------------------------------------------------------------

local lib = LibStub("MalUI-1.0")
if not lib then return end

lib.DropDown = lib.DropDown or {}
lib.DropDown.MenuEntry = lib.DropDown.MenuEntry or {}

lib.DropDown.MenuEntry.__index = lib.DropDown.MenuEntry

local c = {}
c.ITEM_HEIGHT = 16
c.ITEM_LEFT_INSET = 12
c.ITEM_TOP_INSET = 12
c.SECTION_INSET = c.ITEM_LEFT_INSET
c.MENU_LEFT_PADDING = 0
c.MENU_TOP_PADDING = -c.ITEM_TOP_INSET
c.MENU_BASE_HEIGHT = 24
lib.DropDown.MenuEntry.Constants = c

function lib.DropDown.MenuEntry.Create(parent, type, text, instantiateMethods)
    instantiateMethods = instantiateMethods or true

    local self = {}

    if instantiateMethods then
        setmetatable(self, lib.DropDown.MenuEntry)
        self.NewItem = lib.DropDown.Item.Create
        self.NewSection = lib.DropDown.Section.Create
        self.NewMenu = lib.DropDown.Menu.Create
    end

    self.parent = parent
    local k = 1
    for i = 1, #parent + 1 do
        if not parent[i] then
            k = i
            break
        end
    end
    self.numChild = k
    self.type = type
    self.text = text

    return self
end

function lib.DropDown.MenuEntry.Item(self, text)
    if self == nil or text == nil or text == "" then return end

    for i = 1, #self do
        if self[i].type == "item" and self[i].text == text then
            return self[i]
        end
    end
end

function lib.DropDown.MenuEntry.Section(self, text)
    if self == nil or text == nil or text == "" then return end

    for i = 1, #self do
        if self[i].type == "section" and self[i].text == text then
            return self[i]
        end
    end
end

function lib.DropDown.MenuEntry.Menu(self, text)
    if self == nil or text == nil or text == "" then return end

    for i = 1, #self do
        if self[i].type == "menu" and self[i].text == text then
            return self[i]
        end
    end
end
