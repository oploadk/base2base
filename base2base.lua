local fmt = string.format

local function next_power(p, base_from, base_to)
    local r, j, t = {}
    for i = 1, #p do
        j, t = i, p[i] * base_from
        while true do
            t = (r[j] or 0) + t
            r[j] = t % base_to
            t = t // base_to
            if t == 0 then break end
            j = j + 1
        end
    end
    return r
end

-- a = a + n * b
local function add_times(a, n, b, base)
    local j, t
    for i = 1, #b do
        j, t = i, n * (b[i] or 0)
        while true do
            t = (a[j] or 0) + t
            a[j] = t % base
            t = t // base
            if t == 0 then break end
            j = j + 1
        end
    end
end

local function s_to_t(self, s)
    local r, l = {}, #s
    for i = 1, l do r[i] = self.r_alpha_from[s:byte(l - i + 1)] end
    return r
end

local function t_to_s(self, t)
    local r, l = {}, #t
    for i = l, 1, -1 do r[l - i + 1] = self.alpha_to:byte(t[i] + 1) end
    return string.char(table.unpack(r))
end

local function get_power(self, n)
    return self.power[n] or next_power(
        get_power(self, n-1), self.base_from, self.base_to
    )
end

local function base_convert(self, t)
    local r = {}
    for i = 1, #t do
        add_times(r, t[i], get_power(self, i - 1), self.base_to)
    end
    return r
end

local function convert(self, s)
    return t_to_s(self, base_convert(self, s_to_t(self, s)))
end

local function validate(self, s)
    for i = 1, #s do
        if not self.r_alpha_from[s:byte(i)] then
            return false
        end
    end
    return true
end

local converter_mt = {
    __index = {convert = convert, validate = validate},
    __call = function(self, s) return self:convert(s) end,
}

local function new_converter(alpha_from, alpha_to)
    local self = {
        alpha_to = alpha_to,
        base_from = #alpha_from,
        base_to = #alpha_to,
    }
    local v = {}
    for i = 1, #alpha_from do v[alpha_from:byte(i)] = i - 1 end
    self.r_alpha_from = v
    self.power = { [0] = {1} }
    return setmetatable(self, converter_mt)
end

local letters = "abcdefghijklmnopqrstuvwxyz"
local figures = "0123456789"
local ascii = {}; for i = 1, 256 do ascii[i] = i - 1 end
local ALPHABET_B64 = letters:upper() .. letters .. figures .. "+/"
local ALPHABET_B256 = string.char(table.unpack(ascii))
local ALPHABET_B64URL = ALPHABET_B64:sub(1, 62) .. "-_"

local function _byte_to_hex(x) return fmt("%02x", x:byte()) end
local function to_hex(s) return (s:gsub("(.)", _byte_to_hex)) end
local function _byte_from_hex(x) return string.char(tonumber(x, 16)) end
local function from_hex(s) return (s:gsub("(..)", _byte_from_hex)) end

local function is_hex(s) return not not s:match("^[0-9a-f]*$") end

local function _from_b64(alphabet)
    local c = new_converter(alphabet, ALPHABET_B256)
    return function(s)
        local n = 0
        if s:sub(-2, -1) == "==" then
            n = 2
            s = s:sub(1, -3) .. "00"
        elseif s:sub(-1) == "=" then
            n = 1
            s = s:sub(1, -2) .. "0"
        end
        return c(s):sub(1, -(n+1))
    end
end

local function _to_b64(alphabet)
    local c = new_converter(ALPHABET_B256, alphabet)
    return function(s)
        local l, n = #s, 0
        if l % 3 == 1 then
            n = 2
            s = s .. "\0\0"
        elseif l % 3 == 2 then
            n = 1
            s = s .. "\0"
        end
        local r = c(s)
        if n == 2 then
            return r:sub(1, -3) .. "=="
        elseif n == 1 then
            return r:sub(1, -2) .. "="
        else return r end
    end
end

local mt = {
    __index = function(t, k)
        if k == "ALPHABET_B36" then
            t[k] = t.ALPHABET_B62:sub(1,36)
        elseif k == "to_b36" then
            t[k] = t.converter(t.ALPHABET_B256, t.ALPHABET_B36)
        elseif k == "from_b36" then
            t[k] = t.converter(t.ALPHABET_B36, t.ALPHABET_B256)
        elseif k == "is_b36" then
            t[k] = function(s) return t.from_b36:validate(s) end
        end
        return rawget(t, k)
    end
}

local M = {
    converter = new_converter,
    ALPHABET_B62 = figures .. letters .. letters:upper(),
    ALPHABET_B64 = ALPHABET_B64,
    ALPHABET_B64URL = ALPHABET_B64URL,
    ALPHABET_B256 = ALPHABET_B256,
    to_hex = to_hex, from_hex = from_hex, is_hex = is_hex,
    to_b64 = _to_b64(ALPHABET_B64), from_b64 = _from_b64(ALPHABET_B64),
    to_b64url = _to_b64(ALPHABET_B64URL), from_b64url = _from_b64(ALPHABET_B64URL),
}

return setmetatable(M, mt)
