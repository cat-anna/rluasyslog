local plpretty = require "pl.pretty"
local class = require("pl.class")
local date = require("pl.Date")
local syslog = require("syslog")
local utils = require("utils")

local Output = class()

function Output:_init(args)
    assert(args.config)
    -- assert(args.output)
    self.config = args.config
    self.outputs = { }
    self.dateFormatter = date.Format("dd-mm-yyyy HH:MM:SS")

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

function Output:UpdateData(out)
    if not out.dateString then
        out.dateString = self.dateFormatter:tostring(out.timestamp or out.receiveTime)
    end
    out.facilityString = syslog.FacilityNames[out.facility]
    out.priorityString = syslog.PriorityNames[out.priority]
    return utils.MakeRO(out)
end

function Output:Write(data)
    if not data then
        return
    end

    data = self:UpdateData(data)
        
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
