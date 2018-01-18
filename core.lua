local plapp = require "pl.app"
local copas = require("copas")
local plpretty = require "pl.pretty"
local class = require("pl.class")

local App = class()

function App:_init()
    self.logger = require("logger")()
end

function App:Start(args)
    self:Init(args)

    self.input:Start()
    copas.loop()
end

function App:LoadConfig(fn)
    if type(fn) == "string" then
        LogInfo("using config file " .. fn)
        self.config = dofile(fn)
    else
        self.config = require("config")
    end
end

function App:Init(args)
    assert(args)
    self:LoadConfig(args.config)

    local config = self.config

    self.output = require("output"){ 
        config = config.output or {},
    }

    self.logger:SetOutput(self.output:GetInput())
    
    self.parser = require("parser") { 
        config = config.parser or {},
        output = self.output:GetInput(),
    }
    
    self.input = require("input") { 
        config = config.input or {},
        output = self.parser:GetInput(),
    }
end

return App()