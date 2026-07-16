--- Copyright © 2026, YourLocalCappy, all rights deserved ---

--[[


   NEEEEET

   HAHAHAHA

   oh man...

]]

local bit = _G.bit or bit or require("bit") or {}

local band   = bit.band
local bor    = bit.bor
local lshift = bit.lshift
local rshift = bit.rshift

local FIFO_IN  = "/tmp/hl2sbr_net_in"
local FIFO_OUT = "/tmp/hl2sbr_net_out"

local listeners = {}

local current = nil

local running = false

local function Exists(path)

    local f = io.open(path, "r")

    if f then
        f:close()
        return true
    end

    return false

end

local function UInt8(n)

    return string.char(
        band(n, 0xFF)
    )

end

local function UInt16(n)

    return string.char(
        band(n, 0xFF),
        band(rshift(n, 8), 0xFF)
    )

end

local function UInt32(n)

    return string.char(
        band(n, 0xFF),
        band(rshift(n, 8), 0xFF),
        band(rshift(n, 16), 0xFF),
        band(rshift(n, 24), 0xFF)
    )

end

local function ReadUInt16(data, pos)

    local a = string.byte(data, pos)
    local b = string.byte(data, pos + 1)

    return bor(
        a,
        lshift(b, 8)
    )

end

local function ReadUInt32(data, pos)

    local a = string.byte(data, pos)
    local b = string.byte(data, pos + 1)
    local c = string.byte(data, pos + 2)
    local d = string.byte(data, pos + 3)

    return bor(
        a,
        lshift(b, 8),
        lshift(c, 16),
        lshift(d, 24)
    )

end

module("net", package.seeall)

function Initialize()

    if not Exists(FIFO_IN) then
        os.execute("mkfifo " .. FIFO_IN)
    end

    if not Exists(FIFO_OUT) then
        os.execute("mkfifo " .. FIFO_OUT)
    end

end

function Start(name)

    current = {
        name = name,
        buffer = ""
    }

end

function WriteUInt8(n)

    current.buffer =
        current.buffer ..
        UInt8(n)

end

function WriteUInt16(n)

    current.buffer =
        current.buffer ..
        UInt16(n)

end

function WriteUInt32(n)

    current.buffer =
        current.buffer ..
        UInt32(n)

end

function WriteString(str)

    local len = #str

    current.buffer =
        current.buffer ..
        UInt16(len) ..
        str

end

function WriteBool(b)

    WriteUInt8(b and 1 or 0)

end

local function EncodePacket(name, payload)

    local nameLen = #name
    local totalLen = 1 + nameLen + #payload

    local packet =
        UInt32(totalLen) ..
        UInt8(nameLen) ..
        name ..
        payload

    return packet

end

function Send()

    if not current then
        return
    end

    local packet = EncodePacket(
        current.name,
        current.buffer
    )

    local f = io.open(FIFO_OUT, "wb")

    if f then

        f:write(packet)
        f:flush()
        f:close()

    end

    current = nil

end

function Receive(name, fn)

    listeners[name] = fn

end

local Reader = {}
Reader.__index = Reader

function Reader:new(data)

    return setmetatable({
        data = data,
        pos = 1
    }, self)

end

function Reader:ReadUInt8()

    local v = string.byte(
        self.data,
        self.pos
    )

    self.pos = self.pos + 1

    return v

end

function Reader:ReadUInt16()

    local v = ReadUInt16(
        self.data,
        self.pos
    )

    self.pos = self.pos + 2

    return v

end

function Reader:ReadUInt32()

    local v = ReadUInt32(
        self.data,
        self.pos
    )

    self.pos = self.pos + 4

    return v

end

function Reader:ReadString()

    local len = self:ReadUInt16()

    local str = self.data:sub(
        self.pos,
        self.pos + len - 1
    )

    self.pos = self.pos + len

    return str

end

function Reader:ReadBool()

    return self:ReadUInt8() ~= 0

end

local function ParsePacket(packet)

    local pos = 1

    local totalLen = ReadUInt32(packet, pos)
    pos = pos + 4

    local nameLen = string.byte(packet, pos)
    pos = pos + 1

    local name = packet:sub(
        pos,
        pos + nameLen - 1
    )

    pos = pos + nameLen

    local payload = packet:sub(pos)

    return name, payload

end

local function Dispatch(packet)

    local name, payload =
        ParsePacket(packet)

    local fn = listeners[name]

    if not fn then
        return
    end

    local reader = Reader:new(payload)

    fn(reader)

end

function Listen()

    if running then
        return
    end

    running = true

    local co

    co = coroutine.create(function()

        while running do

            local f = io.open(FIFO_IN, "rb")

            if f then

                local lenBytes = f:read(4)

                if lenBytes then

                    local totalLen =
                        ReadUInt32(lenBytes, 1)

                    local body =
                        f:read(totalLen)

                    if body then

                        local packet =
                            lenBytes .. body

                        Dispatch(packet)

                    end

                end

                f:close()

            end

            coroutine.yield()

        end

    end)

    _thread = co

end

function Tick()

    if not _thread then
        return
    end

    coroutine.resume(_thread)

end

function Shutdown()

    running = false

end

function StartBridge()

    os.execute([[
        sh -c '
        while true
        do
            cat /tmp/hl2sbr_net_out > /tmp/hl2sbr_net_in
        done
        ' &
    ]])

end

hook.add("Think", "NetThink", function()
  Tick()
end)