local socket = require("socket")
local copas = require("copas")
local class = require("pl.class")
local plpretty = require "pl.pretty"

local UDP = class()

function UDP:_init(args, output)
    assert(args)
    self.args = args
    self.output = output
end

function UDP:Start()
    self.server = socket.udp()
    self.server:setsockname(self.args.host, self.args.port)

    local handler = function(...)
        return self:SocketHandler(...)
    end
    copas.addserver(self.server, handler, self.args.timeout or 1)
end

function UDP:Stop()
end

function UDP:SocketHandler(skt)
    skt = copas.wrap(skt)
    while true do
      local data, sourceIP, sourcePort = skt:receivefrom(4096)
      if not data then
        print("UDP Receive error: ", err)
        return
      end
      local hostname = socket.dns.tohostname(sourceIP) or sourceIP
      self.output{
          data = data,
          source = hostname,--string.format("%s:%d", hostname, sourcePort),
          receiveTime = os.time(),
      }
    end
end

return UDP
