------------------------------------------------------------
-- | MalUI  											| --
-- | GUI Library                    					| --
-- | Copyright (c) 2014 Malakahh. All Rights Reserved.	| --
------------------------------------------------------------

local lib = LibStub("MalUI-1.0")
if not lib then return end

lib.ProfileManager = lib.ProfileManager or {}

function lib.ProfileManager.Create(savedVariables, OnProfileChangedCallback, default)
    if not savedVariables then return end
    savedVariables.Profiles = savedVariables.Profiles or {}

    local self = {}

    for k,v in pairs(lib.ProfileManager) do
        self[k] = v
    end

    self.profiles = savedVariables.Profiles
    self.OnProfileChangedCallback = OnProfileChangedCallback
    self.default = default or {}

    return self
end

function lib.ProfileManager:GetProfile(profileKey)
    if not profileKey or profileKey == "" then return end

    if self.profiles[profileKey] then return self.profiles[profileKey] end
end

function lib.ProfileManager:GetCurrentProfile()
    if self.currentProfileKey then
        return self:GetProfile(self.currentProfileKey)
    end
end

function lib.ProfileManager:GetCurrentProfileKey()
    if self.currentProfileKey then
        return self.currentProfileKey
    end
end

function lib.ProfileManager:SwitchProfile(profileKey)
    if profileKey == self.currentProfileKey then return end
    if not profileKey  or profileKey == "" then return end

    self.currentProfileKey = profileKey

    if self.OnProfileChangedCallback then
        self.OnProfileChangedCallback()
    end
end

function lib.ProfileManager:NewProfile(profileKey)
    if not profileKey or profileKey == "" then return end

    if not self.profiles[profileKey] then
        self.profiles[profileKey] = lib.Helper.CopyTable(self.default)
    end

    return self:GetProfile(profileKey)
end

function lib.ProfileManager:CopyProfile(profileKey)
    if not self.profiles then return end
    local currentKey = self.currentProfileKey

    lib.Helper.CopyTable(self.profiles[profileKey], self.profiles[self.currentProfileKey])
    --self.profiles[currentKey] = lib.Helper.CopyTable(self.profiles[profileKey])
end

function lib.ProfileManager:DeleteProfile(profileKey)
    if not self.profiles then return end

    self.profiles[profileKey] = nil

    if self.currentProfileKey == profileKey then
        self.currentProfileKey = nil
    end
end