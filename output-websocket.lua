local plpretty = require "pl.pretty"
local class = require("pl.class")
local syslog = require("syslog")
local websocket = require("websocket")
local JSON = require("JSON")

local OutputWS = class()

function OutputWS:_init(config)
    self.config = config

    self.conectionCounter = 0
    self.activeConnections = { }

    self.server = websocket.server.copas.listen {
        port = self.config.port,
        protocols = {
            rsyslog = function(socket)
                self:ServeClient(socket)
            end,
        }
    }    
end

function OutputWS:Write(data)
    local message = JSON:encode(data) 
    for k,v in pairs(self.activeConnections) do
        v.socket:send(message)
    end
end

function OutputWS:ServeClient(wsock)
    self.conectionCounter = self.conectionCounter + 1

    local connection = {
      socket = wsock,
      Name = tostring(self.conectionCounter)
    }
  
    self.activeConnections[connection.Name] = connection
  
    while true do
      local message = wsock:receive()
      if message then
        --ignore
      else
        break
      end
    end
  
    connection.socket = nil
    wsock:close()
    self.activeConnections[connection.Name] = nil
  end
  

return OutputWS
