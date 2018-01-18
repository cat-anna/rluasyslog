local plpretty = require "pl.pretty"
local class = require("pl.class")
local syslog = require("syslog")

local OutputStdout = class()

function OutputStdout:_init(config)
    self.config = config
    self.stdout = io.output()
end

function OutputStdout:Write(data)
    local stdout = self.stdout
    stdout:write(string.formatEx(self.config.lineFormat, data))
    stdout:write("\n")
    stdout:flush()
end

return OutputStdout
