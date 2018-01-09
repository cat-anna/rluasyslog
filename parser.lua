local plpretty = require "pl.pretty"
local class = require("pl.class")
local utils = require("utils")

local Parser = class()

function Parser:_init(args)
    assert(args.config)
    assert(args.output)
    self.config = args.config
    self.output = args.output
    self.parsers = { }

    for i,v in ipairs(args.config.modules) do
        local cfg
        if type(v) == "string" then
            cfg = { class = v, }
        else
            cfg = v
        end
        assert(cfg.class)
        self:LoadParser(cfg)
    end
end

function Parser:LoadParser(parser)
    local cl = require("parser-" .. parser.class)
    local instance = cl(parser)
    table.insert(self.parsers, instance)
end

function Parser:Parse(data)
    if not data then
        return false
    end
    for i,v in ipairs(self.parsers) do
        local success, output = v:TryParse(data)
        if success then
            self.output(utils.MakeRO(output))
            return true
        end
    end
    return false, nil
end

function Parser:GetInput()
    return function(data)
        return self:Parse(data)
    end
end

return Parser
