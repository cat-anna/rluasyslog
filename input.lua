
local class = require("pl.class")
local plpretty = require "pl.pretty"
local utils = require("utils")

local Input = class()

function Input:_init(args)
    assert(args.config)
    assert(args.output)
    self.inputs = {}

    self.output = args.output

    if args.config.udp then
        self:LoadUDP(args.config.udp)
    end
end

function Input:LoadUDP(udpcfg)
    local UDPClass = require("input-udp")
   
    for i,v in ipairs(udpcfg.listen) do
        local host, port = v:match("([*%w%.]+):(%d+)")
        if not host then
            error("Invalid udp bind address: " .. v)
        end
        local cfg = {
            port = port,
            host = host,
            timeout = udpcfg.timeout,
        }
        local input = UDPClass(cfg, function(data)
            return self:HandleInput(data)
        end)
        table.insert(self.inputs, input)
    end
end

function Input:Start()
    for i,v in ipairs(self.inputs) do   
        v:Start()
    end
end

function Input:Stop()
    for i,v in ipairs(self.inputs) do   
        v:Start()
    end
end

function Input:HandleInput(data)
    return self.output(utils.MakeRO(data))
end

return Input
