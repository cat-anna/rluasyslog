local class = require("pl.class")
local plpretty = require "pl.pretty"
local syslog = require("syslog")
local utils = require("utils")

local logger = class()

local instance

function logger:_init()
    assert(instance == nil)
    instance = self
    self.buffer = { }
    self.hostname = socket.dns.gethostname()
end

function logger:SetOutput(handler)        
    self.output = handler
    local buf = self.buffer
    self.buffer = nil

    for _,v in ipairs(buf) do
        self:Write(v)
    end
end

function logger:Write(data)  
    data.timestamp = os.time()
    if self.buffer then
        table.insert(self.buffer, data)
        return
    end

    local entry = {
        facility = data.facility,
        priority = data.priority,

        sender = self.hostname,
        message = table.concat(table.translate(data.args, tostring), "\t"),
        group = "rsyslog",

        timestamp = data.timestamp,
        source = self.hostname,
    }

    self.output(entry)
end

local org_print = print

local function GenerateHandler(name, prio)
    name = name .. " "
    return function (...)
        if not instance then
            org_print(name, ...)
        else            
            instance:Write {
                facility = syslog.FAC_SYSLOG,
                priority = prio,
                args = { ... },
            }
        end
    end
end

LogInfo = GenerateHandler("[Info]", syslog.PRI_INFO)
LogError = GenerateHandler("[Error]", syslog.PRI_ERR)
print = LogInfo

return logger
