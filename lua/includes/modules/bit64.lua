--- Copyright © 2026, YourLocalCappy, all rights deserved ---

module("bit64", package.seeall)

local bit = bit

local band = bit.band
local bor  = bit.bor
local bxor = bit.bxor
local bnot = bit.bnot
local lshift = bit.lshift
local rshift = bit.rshift

local UINT32 = 4294967296
local MASK32 = 0xFFFFFFFF

local function u32(x)
    x = tonumber(x) or 0
    x = x % UINT32
    if x < 0 then x = x + UINT32 end
    return x
end

local function new(hi, lo)
    return { u32(hi), u32(lo) }
end

local function fromNumber(x)
    x = tonumber(x) or 0

    local lo = u32(x)
    local hi = u32(math.floor(x / UINT32))

    return { hi, lo }
end

local function toNumber(x)
    return x[1] * UINT32 + x[2]
end

function band64(a, b)
    return {
        band(a[1], b[1]),
        band(a[2], b[2])
    }
end

function bor64(a, b)
    return {
        bor(a[1], b[1]),
        bor(a[2], b[2])
    }
end

function bxor64(a, b)
    return {
        bxor(a[1], b[1]),
        bxor(a[2], b[2])
    }
end

function bnot64(a)
    return {
        band(bnot(a[1]), MASK32),
        band(bnot(a[2]), MASK32)
    }
end

function lshift64(a, n)
    n = n % 64

    if n == 0 then return {a[1], a[2]} end

    if n < 32 then
        return {
            bor(
                lshift(a[1], n),
                rshift(a[2], 32 - n)
            ),
            band(lshift(a[2], n), MASK32)
        }
    else
        return {
            band(lshift(a[2], n - 32), MASK32),
            0
        }
    end
end

function rshift64(a, n)
    n = n % 64

    if n == 0 then return {a[1], a[2]} end

    if n < 32 then
        return {
            rshift(a[1], n),
            bor(
                rshift(a[2], n),
                lshift(a[1], 32 - n)
            )
        }
    else
        return {
            0,
            rshift(a[1], n - 32)
        }
    end
end

function arshift64(a, n)
    local sign = band(a[1], 0x80000000) ~= 0

    local r = rshift64(a, n)

    if sign then
        if n >= 32 then
            r[1] = 0xFFFFFFFF
        else
            r[1] = bor(r[1], lshift(0xFFFFFFFF, 32 - n))
        end
    end

    return r
end

function add64(a, b)
    local lo = a[2] + b[2]
    local carry = math.floor(lo / UINT32)

    lo = lo % UINT32

    local hi = (a[1] + b[1] + carry) % UINT32

    return {hi, lo}
end

function sub64(a, b)
    local lo = a[2] - b[2]
    local borrow = 0

    if lo < 0 then
        lo = lo + UINT32
        borrow = 1
    end

    local hi = (a[1] - b[1] - borrow) % UINT32

    return {hi, lo}
end

function tobit64(x)
    if type(x) == "table" then
        return x
    end
    return fromNumber(x)
end

function tohex64(x)
    return string.format("%08x%08x", x[1], x[2])
end

function tonumber64(x)
    return toNumber(x)
end

new64 = new
fromNumber64 = fromNumber