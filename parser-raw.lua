local plpretty = require "pl.pretty"
local class = require("pl.class")
local syslog = require("syslog")

local Parser = class()

function Parser:_init()
end

function Parser:Init(args)
end

function Parser:TryParse(data)
    local entry = {
        facility = syslog.FAC_UNKNOWN,
        priority = syslog.PRI_UNKNOWN,

        sender = data.source,        
        message = data.data,
        group = "unknown",

        timestamp = data.receiveTime,
        source = data.source,
    }

    return true, entry
end

return Parser
