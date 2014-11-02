------------------------------------------------------------
-- | MalUI  											| --
-- | GUI Library                    					| --
-- | Copyright (c) 2014 Malakahh. All Rights Reserved.	| --
------------------------------------------------------------

local lib = LibStub("MalUI-1.0")
if not lib then return end

lib.DropDown = lib.DropDown or {}

function lib.DropDown.Create(parent, name, width, height)
    if name == nil then return end
    local self = CreateFrame("Button", name, parent)
    self:SetSize(width, height)

    local leftTex = self:CreateTexture(self:GetName().."Left", "ARTWORK")
    leftTex:SetTexture("Interface\\Glues\\CharacterCreate\\CharacterCreate-LabelFrame")
    leftTex:SetSize(25, 64)
    leftTex:SetPoint("TOPLEFT", 0, 17)
    leftTex:SetTexCoord(0, 0.1953125, 0, 1)
    leftTex:Show()

    local rightTex = self:CreateTexture(self:GetName().."Right", "ARTWORK")
    rightTex:SetTexture("Interface\\Glues\\CharacterCreate\\CharacterCreate-LabelFrame")
    rightTex:SetSize(25, 64)
    rightTex:SetPoint("TOPRIGHT", 0, 17)
    rightTex:SetTexCoord(0.8046875, 1, 0, 1)
    rightTex:Show()

    local middleTex = self:CreateTexture(self:GetName().."Middle", "ARTWORK")
    middleTex:SetTexture("Interface\\Glues\\CharacterCreate\\CharacterCreate-LabelFrame")
    middleTex:SetPoint("LEFT", leftTex, "RIGHT")
    middleTex:SetPoint("RIGHT", rightTex, "LEFT")
    middleTex:SetTexCoord(0.1953125, 0.8046875, 0, 1)
    middleTex:Show()

    local fString = self:CreateFontString(self:GetName().."Text", "ARTWORK", "GameFontHighlightSmall")
    fString:SetNonSpaceWrap(false)
    fString:SetJustifyH("RIGHT")
    fString:SetSize(0,10)
    fString:SetPoint("RIGHT", rightTex, -43, 2)

    local btn = CreateFrame("Button", self:GetName().."Button", self)
    btn:SetSize(24,24)
    btn:SetPoint("TOPRIGHT", rightTex, -16, -18)
    btn:SetScript("OnEnter", function(s)
        local parent = s:GetParent()
        local myscript = parent:GetScript("OnEnter")
        if myscript ~= nil then
            myscript(parent)
        end
    end)
    btn:SetScript("OnLeave", function(s)
        local parent = s:GetParent()
        local myscript = parent:GetScript("OnLeave")
        if myscript ~= nil then
            myscript(parent)
        end
    end)
    btn:SetScript("OnClick", function(b, mouseBtn, isDown)
        local parent = b:GetParent()
        parent:ToggleMenu()
        PlaySound("igMenuOptionCheckBoxOn")
    end)

    btn:SetNormalTexture("Interface\\ChatFrame\\UI-ChatIcon-ScrollDown-Up")
    btn:SetPushedTexture("Interface\\ChatFrame\\UI-ChatIcon-ScrollDown-Down")
    btn:SetDisabledTexture("Interface\\ChatFrame\\UI-ChatIcon-ScrollDown-Disabled")
    btn:SetHighlightTexture("Interface\\Buttons\\UI-Common-MouseHilight")

    for k,v in pairs(lib.DropDown) do
        if self[k] ~= nil then
            print("MalUI.DropDown error: cannot assign function "..k)
            return
        end

        self[k] = v
    end

    self:SpawnMenu()

    return self
end

function lib.DropDown.RefreshMenu(self)
    --reset from previous uses
    self.menu:SetWidth(self:GetWidth()+20)
    self.menu:SetPoint("TOPLEFT", self, "BOTTOMLEFT", -10, 2)

    local list = self.list

    local height = #list
    for i = 1, #list do
        if list[i].type then
            list[i]:Refresh(self, self.menu)

            if list[i].type == "section" then
                height = height + list[i]:GetNestedCount()
            end
        else
            return nil
        end
    end

    local c = lib.DropDown.MenuEntry.Constants
    self.menu:SetHeight(height * c.ITEM_HEIGHT + c.MENU_BASE_HEIGHT)

    self:SetSelected(_G[self:GetName().."Text"]:GetText())
end

function lib.DropDown.ReleaseMenu(self)
    local list = self.list
    for i = 1, #list do
        if list[i].type then
            list[i]:Release()
        end
    end
end

function lib.DropDown.SpawnMenu(self)
    local name = self:GetName()
    if name then name = name.."Menu" end

    self.menu = CreateFrame("Frame", name, self)
    self.menu:SetBackdrop({
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
    self.menu:SetBackdropBorderColor(1, 1, 1);
    self.menu:SetBackdropColor(0.09, 0.09, 0.09);

    --Make menus closable by pressing escape
    table.insert(UISpecialFrames, self.menu:GetName())
    self.menu:SetScript("OnHide", function()
        self:CloseMenu()
    end)

    --Add methods to initial list
    self.list = {}
    self.list.dropDown = self
    self.list.Item = lib.DropDown.MenuEntry.Item
    self.list.Section = lib.DropDown.MenuEntry.Section
    self.list.Menu = lib.DropDown.MenuEntry.Menu
    self.list.NewItem = lib.DropDown.Item.Create
    self.list.NewSection = lib.DropDown.Section.Create
    self.list.NewMenu = lib.DropDown.Menu.Create
end

function lib.DropDown.OpenMenu(self)
    if self.menu.isOpen then return end

    self.menu.isOpen = true

    self:RefreshMenu()
    self.menu:Show()
end

function lib.DropDown.CloseMenu(self)
    if not self.menu.isOpen then return end

    self.menu.isOpen = false

    self.menu:Hide()
    self:ReleaseMenu()
end

function lib.DropDown.ToggleMenu(self)
    if self.menu.isOpen then
        self:CloseMenu()
    else
        self:OpenMenu()
    end
end

--Sets function to be called after the selected item has changed
--function signature of func: function func(dropDown, selectedItem)
function lib.DropDown.SetOnSelectionChanged(self, func)
    self.OnSelectionChanged = func
end

local function SetSelectedHelper(self, text, list, checked)
    if list == nil then
        _G[self:GetName().."Text"]:SetText(text)
        list = self.list
        checked = false
    end

    local selectedItem

    for i = 1, #list do
        --menu is not refreshed
        if list[i].btn == nil then
            break
        end

        if list[i].type == "item" then
            if list[i].text ~= text or checked then
                list[i].btn.CheckTex:Hide()
                list[i].btn.UnCheckTex:Show()
            else
                checked = true
                selectedItem = list[i]
                selectedItem.btn.CheckTex:Show()
                selectedItem.btn.UnCheckTex:Hide()
            end
        elseif list[i].type == "section" or list[i].type == "menu" then
            self:SetSelected(text, list[i], checked)
        end
    end

    if selectedItem and self.OnSelectionChanged then
        self:OnSelectionChanged(selectedItem)
    end
end

function lib.DropDown.SetSelected(self, text, list)
   SetSelectedHelper(self, text, list, false)
end

function lib.DropDown:GetSelected()
    return _G[self:GetName().."Text"]:GetText()
end