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

T:exit()
