
print "Loading default configuration"

local config = {}

config.input = {}
config.input.udp = {
    listen = { "*:514" },
}

config.parser = {}
config.parser.modules = {
    "espeasy",
    -- "generic",
}

-- facility = fac,
-- facilityString = syslog.FacilityNames[fac],
-- priority = prio,
-- priorityString = syslog.PriorityNames[prio],
-- sender = string.format("EspEasy %d", unit),        
-- message = message,
-- group = group,
-- time = data.reciveTime,
-- dateString = os.date("%c", data.reciveTime),
-- source = data.source,

local pat = "{dateString} {facilityString}:{priorityString} {source} {group}:{message}"

config.output = {}
config.output.modules = {
    { class = "stdout", pattern = pat, },
    { class = "file", pattern = pat, fileName = "/home/banshee/localsyslog.txt" },
    { class = "websocket", port = 8082 },
}

return config
