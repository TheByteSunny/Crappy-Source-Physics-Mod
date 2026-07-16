--- Copyright © 2026, YourLocalCappy, all rights deserved ---

-- should be implemented in APK
-- but here I have more control

local floor = math.floor
local ldexp = math.ldexp

local MAX_UINT32 = 4294967296
local MAX_INT32  = 2147483648

local function to_uint32(x)
    x = tonumber(x) or 0
    x = x % MAX_UINT32
    if x < 0 then
        x = x + MAX_UINT32
    end
    return x
end

local function to_int32(x)
    x = tonumber(x) or 0
    x = to_uint32(x)
    if x >= MAX_INT32 then
        return x - MAX_UINT32
    end
    return x
end

module( "bit" )

function band(a, b)
    a = to_uint32(a)
    b = to_uint32(b)
    local r = 0
    local bitval = 1
    while a > 0 and b > 0 do
        local abit = a % 2
        local bbit = b % 2
        if abit == 1 and bbit == 1 then
            r = r + bitval
        end
        a = (a - abit) / 2
        b = (b - bbit) / 2
        bitval = bitval * 2
    end
    return to_int32(r)
end

function bor(a, b)
    a = to_uint32(a)
    b = to_uint32(b)
    local r = 0
    local bitval = 1
    while a > 0 or b > 0 do
        local abit = a % 2
        local bbit = b % 2
        if abit == 1 or bbit == 1 then
            r = r + bitval
        end
        a = (a - abit) / 2
        b = (b - bbit) / 2
        bitval = bitval * 2
    end
    return to_int32(r)
end

function bxor(a, b)
    a = to_uint32(a)
    b = to_uint32(b)
    local r = 0
    local bitval = 1
    while a > 0 or b > 0 do
        local abit = a % 2
        local bbit = b % 2
        if abit ~= bbit then
            r = r + bitval
        end
        a = (a - abit) / 2
        b = (b - bbit) / 2
        bitval = bitval * 2
    end
    return to_int32(r)
end

function bnot(a)
    return to_int32(MAX_UINT32 - 1 - to_uint32(a))
end

function lshift(a, n)
    return to_int32(ldexp(to_uint32(a), n) % MAX_UINT32)
end

function rshift(a, n)
    return to_int32(floor(to_uint32(a) / ldexp(1, n)))
end

function arshift(a, n)
    a = to_int32(a)
    if a < 0 then
        return to_int32(floor((a + MAX_UINT32) / ldexp(1, n)))
    end
    return to_int32(floor(a / ldexp(1, n)))
end

function tobit(x)
    return to_int32(x)
end

function tohex(x, digits)
    x = to_uint32(x)
    local hex = ""
    local chars = "0123456789abcdef"
    repeat
        local d = x % 16
        hex = chars:sub(d + 1, d + 1) .. hex
        x = (x - d) / 16
    until x == 0
    if digits and #hex < digits then
        hex = string.rep("0", digits - #hex) .. hex
    end
    return hex
end

function btest(a, b)
    return band(a, b) ~= 0
end