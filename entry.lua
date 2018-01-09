#!/usr/bin/lua
-- local function buildpath(script)
-- 	local t = {
-- 		string.gsub(script, "daisyproject/linux/daisy.lua", "?.lua"),
-- 		string.gsub(script, "daisyproject/linux/daisy.lua", "?/init.lua")
-- 	}
-- 	return table.concat(t, ";")
-- end
-- package.path = package.path .. ";" .. buildpath(arg[0]) 


local plapp = require "pl.app"
local copas = require("copas")

plapp.require_here()

local opt = plapp.parse_args(nil, { config=true })

local rluasyslog = {}

if opt.config then
    print("using config file " .. opt.config)
    rluasyslog.config = require(opt.config)
else
    rluasyslog.config = require("config")
end

rluasyslog.output = require("output"){ 
    config = rluasyslog.config.output or {},
}

rluasyslog.parser = require("parser") { 
    config = rluasyslog.config.parser or {},
    output = rluasyslog.output:GetInput(),
}

rluasyslog.input = require("input") { 
    config = rluasyslog.config.input or {},
    output = rluasyslog.parser:GetInput(),
}

rluasyslog.input:Start()
copas.loop()
