#!/usr/bin/lua

local plapp = require "pl.app"

plapp.require_here()
local opt = plapp.parse_args(nil, { config=true })

local rluasyslog = require("core")
rluasyslog:Start(opt)
