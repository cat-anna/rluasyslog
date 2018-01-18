local plpretty = require "pl.pretty"
local class = require("pl.class")
local syslog = require("syslog")

local ParserEspEasy = class()

function ParserEspEasy:_init()
end

function ParserEspEasy:Init(args)
end

local ESPEasyRegExp = [==[%<(%d+)%>ESP%s+Unit:%s+(%d+)%s*:%s*(%w+)%s*:%s*(.+)]==]
function ParserEspEasy:TryParse(data)
    local pri, unit, group, message = data.data:match(ESPEasyRegExp)

    if not pri then
        return false
    end

    local fac,prio = syslog.FromPRI(pri)

    local entry = {
        facility = fac,
        priority = prio,

        sender = data.source,--string.format("EspEasy-%d", unit),        
        message = message,
        group = group,

        timestamp = data.receiveTime,
        source = data.source,
    }

    return true, entry
end

return ParserEspEasy
