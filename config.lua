
print "Loading default configuration"

local config = {}

config.input = {
    udp = {
        listen = { 
            "*:514" 
        },
    },
}

config.parser = {}
config.parser.modules = {
    "espeasy",
    "rsyslog",
    "raw",
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

local lineFormat = "{dateString} {facilityString}:{priorityString} {sender} {group}:{message}"

    -- hostname
    -- year (four digits), 
    -- month (1--12), 
    -- day (1--31), 
    -- hour (0--23), 
    -- min (0--59), 
    -- sec (0--61), 
    -- wday (weekday, Sunday is 1), 
    -- yday (day of the year), and 

config.output = {}
config.output.modules = {
    { class = "stdout", lineFormat = lineFormat, },
    -- { class = "websocket", port = 8082 },
    -- { class = "file", lineFormat = lineFormat, fileName = "/var/log/rluasys.log" },
    -- { 
    --     class = "file-rotate",
    --     lineFormat = lineFormat, 
    --     filePattern = "/var/log/{hostname}-{year}{month}{day}.log", 
    -- },
}

return config
