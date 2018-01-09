local plpretty = require "pl.pretty"
local class = require("pl.class")
local syslog = require("syslog")

local OutputStdout = class()

function OutputStdout:_init(config)
    self.config = config
end

function OutputStdout:Write(data)
    print(string.formatEx(self.config.lineFormat, data))
end

return OutputStdout
