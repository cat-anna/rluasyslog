local socket = require("socket")
local copas = require("copas")

local port = 514
local server = socket.udp()
server:setsockname("*",port)

function handler(skt)
  skt = copas.wrap(skt)
  print("UDP connection handler")

  while true do
    local s, err
    s, err = skt:receive(2048)
    if not s then
      print("Receive error: ", err)
      return
    end
    print("Received data, bytes:" , #s, "\n", s)
  end
end

copas.addserver(server, handler, 1)
copas.loop()

