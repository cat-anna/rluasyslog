local plpretty = require "pl.pretty"
local class = require("pl.class")
local syslog = require("syslog")

local OutputFile = class()

function OutputFile:_init(config)
    assert(type(config.lineFormat) == "string")
    self.config = config
    self.handle = io.open(config.fileName, "a+")
end

function OutputFile:Write(data)
    self.handle:write(string.formatEx(self.config.lineFormat, data) .. "\n")
    self.handle:flush()
end

return OutputFile
