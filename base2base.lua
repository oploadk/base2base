local next_power = function(p, base_from, base_to)
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
local add_times = function(a, n, b, base)
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

local s_to_t = function(self, s)
    local r, l = {}, #s
    for i = 1, l do r[i] = self.r_alpha_from[s:byte(l - i + 1)] end
    return r
end

local t_to_s = function(self, t)
    local r, l = {}, #t
    for i = l, 1, -1 do r[l - i + 1] = self.alpha_to:byte(t[i] + 1) end
    return string.char(table.unpack(r))
end

local get_power; get_power = function(self, n)
    return self.power[n] or next_power(
        get_power(self, n-1), self.base_from, self.base_to
    )
end

local base_convert = function(self, t)
    local r = {}
    for i = 1, #t do
        add_times(r, t[i], get_power(self, i - 1), self.base_to)
    end
    return r
end

local convert = function(self, s)
    return t_to_s(self, base_convert(self, s_to_t(self, s)))
end

local converter_mt = {
    __index = {convert = convert},
    __call = function(self, s) return self:convert(s) end,
}

local new_converter = function(alpha_from, alpha_to)
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

return {
    converter = new_converter,
    ALPHABET_B62 = figures .. letters .. letters:upper(),
    ALPHABET_B64 = ALPHABET_B64,
    ALPHABET_B64URL = ALPHABET_B64:sub(1, 62) .. "-_",
    ALPHABET_B256 = string.char(table.unpack(ascii)),
}
