local plpretty = require "pl.pretty"
local class = require("pl.class")

local Output = class()

function Output:_init(args)
    assert(args.config)
    -- assert(args.output)
    self.config = args.config
    self.outputs = { }

    for i,v in ipairs(args.config.modules) do
        local cfg
        if type(v) == "string" then
            cfg = { class = v, }
        else
            cfg = v
        end
        assert(cfg.class)
        self:LoadOutput(cfg)
    end
end

function Output:LoadOutput(output)
    local cl = require("output-" .. output.class)
    local instance = cl(output)
    table.insert(self.outputs, instance)
end

function Output:Write(data)
    if not data then
        return
    end
    for i,v in ipairs(self.outputs) do
        v:Write(data)
    end
end

function Output:GetInput()
    return function(data)
        return self:Write(data)
    end
end

return Output
