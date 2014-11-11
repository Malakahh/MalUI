------------------------------------------------------------
-- | MalUI  											| --
-- | GUI Library                    					| --
-- | Copyright (c) 2014 Malakahh. All Rights Reserved.	| --
------------------------------------------------------------

local lib = LibStub("MalUI-1.0")
if not lib then return end

lib.Helper = lib.Helper or {}

function lib.Helper.RotateTexture(texture, angle)
    local Radian = math.pi*(45-angle)/180
    local Radian2 = math.pi*(45+90-angle)/180
    local Radius = 0.70710678118654752440084436210485

    local tx, ty, tx2, ty2
    tx = Radius*math.cos(Radian)
    ty = Radius*math.sin(Radian)
    tx2 =- ty
    ty2 = tx
    texture:SetTexCoord(0.5-tx, 0.5-ty, 0.5+tx2, 0.5+ty2, 0.5-tx2, 0.5-ty2, 0.5+tx, 0.5+ty)
end

function lib.Helper.AlphaHexColorToColor(color)
    local r, g, b, a

    a = bit.band(color, 0xFF) / 255
    b = bit.band(bit.rshift(color, 2*4), 0xFF) / 255
    g = bit.band(bit.rshift(color, 4*4), 0xFF) / 255
    r = bit.band(bit.rshift(color, 6*4), 0xFF) / 255

    return r,g,b,a
end

function lib.Helper.HexColorToColor(color)
    local r, g, b

    b = bit.band(color, 0xFF) / 255
    g = bit.band(bit.rshift(color, 2*4), 0xFF) / 255
    r = bit.band(bit.rshift(color, 4*4), 0xFF) / 255

    return r,g,b
end

function lib.Helper.CommaValue(amount)
    local formatted = amount
    local k
    while true do
        formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
        if (k==0) then
            break
        end
    end
    return formatted
end

function lib.Helper.CopyTable(source, destination)
    if destination then
        wipe(destination)
    else
        destination = {}
    end

    if source then
        for k,v in pairs(source) do
            if type(v) == "table" then
                destination[k] = {}
                lib.Helper.CopyTable(v, destination[k])
            else
                destination[k] = v
            end
        end
    end
    return destination
end

function lib.Helper.GetScreenResolution()
    local index = GetCurrentResolution();
    local resolution = select(index, GetScreenResolutions());
    local x = string.match(resolution, "(%d+)x")
    local y = string.match(resolution, "x(%d+)")
    return tonumber(x), tonumber(y)
end