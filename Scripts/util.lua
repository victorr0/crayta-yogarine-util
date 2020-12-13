--[[
Copyright © 2020 Alwin Garside

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

 1. Redistributions of source code must retain the above copyright notice, this
    list of conditions and the following disclaimer.
 2. Redistributions in binary form must reproduce the above copyright notice,
    this list of conditions and the following disclaimer in the documentation
    and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
]]--

------------------------------------------------------------------------------------------------------------------------
-- @module    Yogarine.Util
-- @author    Alwin "Yogarine" Garside <alwin@garsi.de>
-- @copyright 2020 Alwin Garside
-- @license   https://opensource.org/licenses/BSD-2-Clause 2-Clause BSD License
------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------------
-- A collection of useful Utility functions.
--
-- You can use this by attaching this script to an entity and retrieving it from other scripts through
-- self:GetEntity().util
--
-- @type Util
------------------------------------------------------------------------------------------------------------------------

---
-- @field properties Properties: Holds the values that have been set on an instance of a script.
---
Util = {}

---
-- Script properties are defined here
---
Util.Properties = {
    --	{ name = "globalName", type = "string", tooltip = "Name for Util class in the global scope.", default = "Util"},
}

---
-- Get average of all the values in the given table.
--
-- @tparam  table  collection
-- @return Averaged value.
---
function Util.Average(collection)
    local sum = nil

    for _,value in ipairs(collection) do
        if nil == sum then
            sum = value
        else
            sum = sum + value
        end
    end

    return sum / #collection
end

---
-- Inject a value into the global scope.
--
-- @param                value
-- @tparam[opt]  string  namespace
-- @tparam       string  name
---
function Util.InjectGlobal(value, ...)
    Printf("Util: InjectGlobal {1}", table.concat({...}, ","))

    local args = {...}
    local name = table.remove(args)

    local G = _G
    for _,namespace in ipairs(args) do
        if not G[namespace] then
            G[namespace] = {}
        end
        G = G[namespace]
    end

    G[name] = value
end


function Util.DumpVar(data)
    -- cache of tables already printed, to avoid infinite recursive loops
    local tablecache = {}
    local buffer = ""
    local padder = "    "

    local function _dumpvar(d, depth)
        local t   = type(d)
        local str = tostring(d)

        if (t == "table") then
            if (tablecache[str]) then
                -- table already dumped before, so we dont
                -- dump it again, just mention it
                buffer = buffer .. "<" .. str .. ">\n"
            else
                tablecache[str] = (tablecache[str] or 0) + 1
                buffer = buffer .. "(" .. str .. ") {\n"
                for k, v in pairs(d) do
                    buffer = buffer .. string.rep(padder, depth + 1) .. "[" .. k .. "] => "
                    _dumpvar(v, depth + 1)
                end
                buffer = buffer..string.rep(padder, depth).."}\n"
            end
        elseif (t == "number") then
            buffer = buffer .. "(" .. t .. ") " .. str .. "\n"
        else
            buffer = buffer .. "(" .. t .. ") \"" .. str .. "\"\n"
        end
    end

    _dumpvar(data, 0)

    Print(buffer)
end

-- Util.InjectGlobal(Util, "Yogarine", "Util")
-- Util.InjectGlobal(Util, "Util")

return Util
