local plpretty = require "pl.pretty"
local class = require("pl.class")
local syslog = require("syslog")
local socket = require("socket")

local OutputFile = class()

function OutputFile:_init(config)
    self.config = config

    assert(type(config.filePattern) == "string")
    assert(type(config.lineFormat) == "string")

    self.patternFields = {
        hostname = socket.dns.gethostname(),
    }
end

function OutputFile:Write(data)
    local h = self:CheckRotate()
    h:write(string.formatEx(self.config.lineFormat, data) .. "\n")
    h:flush()
end

function OutputFile:CheckRotate()
    local fn = self:GenerateFileName()

    local reopen = false
    if not self.currentFileName or fn ~= self.currentFileName  then
        self.currentFileName = fn 
        reopen = true
    end
    
    if reopen then
        if self.handle then
            self.handle:close()
        end
        local h = io.open(fn, "a+")
        self.handle = h
        return h
    end

    return self.handle
end

function OutputFile:GenerateFileName()    
    local f = self.patternFields

    local d = os.date("*t")
    d["isdst"] = nil
    for k,v in pairs(d) do
        f[k] = string.format("%02d", tonumber(v))
    end
    return string.formatEx(self.config.filePattern, f)
end

return OutputFile
