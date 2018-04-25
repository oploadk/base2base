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
    ["M"] = "TQ==",
    ["Ma"] = "TWE=",
    ["Man"] = "TWFu",
    ["any carnal pleasure."] = "YW55IGNhcm5hbCBwbGVhc3VyZS4=",
    ["any carnal pleasure"] = "YW55IGNhcm5hbCBwbGVhc3VyZQ==",
    ["any carnal pleasur"] = "YW55IGNhcm5hbCBwbGVhc3Vy",
    ["any carnal pleasu"] = "YW55IGNhcm5hbCBwbGVhc3U=",
    ["any carnal pleas"] = "YW55IGNhcm5hbCBwbGVhcw==",
    [string.char(251)] = "+w==",
    [string.char(254)] = "/g==",
}

T:start("base64", 18); do
    for k, v in pairs(base64_examples) do
        T:eq( M.from_b64(v), k )
        T:eq( M.to_b64(k), v )
    end
end; T:done()

local base64url_examples = {}
for k,v in pairs(base64_examples) do base64url_examples[k] = v end
base64url_examples[string.char(251)] = "-w=="
base64url_examples[string.char(254)] = "_g=="

T:start("base64 URL", 18); do
    for k, v in pairs(base64url_examples) do
        T:eq( M.from_b64url(v), k )
        T:eq( M.to_b64url(k), v )
    end
end; T:done()

T:start("validation", 6); do
    T:yes( M.is_hex("") )
    T:yes( M.is_b36("f00b41") )
    T:no( M.is_hex("f00b4r") )
    T:yes( M.is_b36("") )
    T:yes( M.is_b36("f00b4r") )
    T:no( M.is_b36("f00+b4r") )
end; T:done()

T:exit()
