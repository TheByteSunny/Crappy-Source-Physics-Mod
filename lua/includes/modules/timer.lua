--- Copyright © 2026, YourLocalCappy, all rights reserved ---

module("timer", package.seeall)

local PAUSED  = -1
local STOPPED = 0
local RUNNING = 1

local Timers = {}
local SimpleTimers = {}

local function CurTime()
    if gpGlobals and gpGlobals.curtime then
        return gpGlobals.curtime()
    end
    if _G.CurTime then
        return _G.CurTime()
    end
    return os.clock()
end

local function isfunction(v) return type(v) == "function" end
local function isstring(v) return type(v) == "string" end
local function isnumber(v) return type(v) == "number" end

function Exists(name)
    return Timers[name] ~= nil
end

function Create(name, delay, reps, func)
    if not isstring(name) or not isfunction(func) or not isnumber(delay) or not isnumber(reps) then
        error("timer.Create - bad arguments!")
        return
    end

    Timers[name] = {
        Delay = delay,
        Repetitions = reps,
        Func = func,
        Status = RUNNING,
        Last = CurTime(),
        n = 0
    }
end

-- HL2SB++ compatibility because I want
function Add(name, delay, reps, func)
  Create(name, delay, reps, func)
end

function Start(name)
    if not Exists(name) then return false end
    local t = Timers[name]
    t.n = 0
    t.Status = RUNNING
    t.Last = CurTime()
    return true
end

function Stop(name)
    if not Exists(name) then return false end
    Timers[name].Status = STOPPED
    return true
end

function Destroy(name)
    Timers[name] = nil
end

function Remove(name)
  Destroy(name)
end

function Pause(name)
    if not Exists(name) then return false end
    local t = Timers[name]
    if t.Status == RUNNING then
        t.Diff = CurTime() - t.Last
        t.Status = PAUSED
        return true
    end
    return false
end

function UnPause(name)
    if not Exists(name) then return false end
    local t = Timers[name]
    if t.Status == PAUSED then
        t.Last = CurTime() - (t.Diff or 0)
        t.Diff = nil
        t.Status = RUNNING
        return true
    end
    return false
end

function Simple(delay, func)
    if not isfunction(func) or not isnumber(delay) then
        error("timer.Simple - bad arguments!")
        return
    end

    table.insert(SimpleTimers, {
        Finish = CurTime() + delay,
        Func = func
    })
end

function Check()
    local now = CurTime()

    for name, t in pairs(Timers) do
        if t.Status == RUNNING and (t.Last + t.Delay) <= now then
            t.Last = now
            t.n = t.n + 1
            t.Func()
            if t.Repetitions ~= 0 and t.n >= t.Repetitions then
                Stop(name)
            end
        end
    end

    for i = #SimpleTimers, 1, -1 do
        local t = SimpleTimers[i]
        if t.Finish <= now then
            t.Func()
            table.remove(SimpleTimers, i)
        end
    end
end

function Think()
  Check()
end

hook.add("Think", "TimerThink2", function()
  if timer.Think then
     timer.Think()
  elseif timer.Check() then
     timer.Check()
  end
end)