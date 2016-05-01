local cwtest = require "cwtest"
local M = require "base2base"

local T = cwtest.new()

T:start("hex", 4); do
    T:eq( M.to_hex(""), "" )
    T:eq( M.from_hex(""), "" )
    T:eq( #M.from_hex("1234dead"), 4 )
    T:eq( M.to_hex(M.from_hex("1234dead")), "1234dead" )
end; T:done()

T:start("base36", 3); do
    T:eq( M.to_hex(""), "" )
    T:eq( M.from_hex(""), "" )
    T:eq( M.to_b36(M.from_b36("yolo42")), "yolo42" )
end; T:done()

local base64_examples = {
    [""] = "",
    ["TQ=="] = "M",
    ["TWE="] = "Ma",
    ["TWFu"] = "Man",
    ["YW55IGNhcm5hbCBwbGVhc3VyZS4="] = "any carnal pleasure.",
    ["YW55IGNhcm5hbCBwbGVhc3VyZQ=="] = "any carnal pleasure",
    ["YW55IGNhcm5hbCBwbGVhc3Vy"] = "any carnal pleasur",
    ["YW55IGNhcm5hbCBwbGVhc3U="] = "any carnal pleasu",
    ["YW55IGNhcm5hbCBwbGVhcw=="] = "any carnal pleas",
}

T:start("base64", 18); do
    for k, v in pairs(base64_examples) do
        T:eq( M.from_b64(k), v )
        T:eq( M.to_b64(v), k )
    end
end; T:done()

T:exit()
