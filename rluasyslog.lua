#!/usr/bin/lua

local plapp = require "pl.app"
local copas = require("copas")
local plpretty = require "pl.pretty"

plapp.require_here()

local opt = plapp.parse_args(nil, { config=true })

local rluasyslog = {}

if opt.config then
    print("using config file " .. opt.config)
    rluasyslog.config = dofile(opt.config)
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
