local plpretty = require "pl.pretty"
local class = require("pl.class")
local syslog = require("syslog")

local OutputFile = class()

function OutputFile:_init(config)
    self.config = config
    self.handle = io.open(config.fileName, "a+")
end

function OutputFile:Write(data)
    -- plpretty.dump(data)
    self.handle:write(string.formatEx(self.config.pattern, data) .. "\n")
    self.handle:flush()
end

return OutputFile
