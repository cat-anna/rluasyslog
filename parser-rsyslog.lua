local plpretty = require "pl.pretty"
local class = require("pl.class")
local date = require("pl.Date")
local syslog = require("syslog")

local Parser = class()

function Parser:_init()
    self.dateParser = date.Format()
end

function Parser:Init(args)
end

local ShortDays = {
    mon=1,
    tues=1,
    weds=1,
    thurs=1,
    fri=1,
    sat=1,
    sun=1,
}
local ShortMonths = {
    jan = 1,
    feb = 2,
    mar = 3,
    apr = 4,
    may = 5,
    june = 6,
    july = 7,
    aug = 8,
    sept = 9,
    oct = 10,
    nov = 11,
    dec = 12,
}

--Jan 14 09:31:16

function Parser:ParseDate(date_month, date_day, date_hour)
    date_month = date_month:lower():split(" ")
    date_day = date_day:lower()
    date_hour = date_hour:lower()

    local day, month, hour, min, sec

    if ShortDays[date_month[1]] then
        table.remove(date_month, 1)
    end

    month = ShortMonths[date_month[1]]
    day = tonumber(date_day)
    hour, min, sec = table.unpack(date_hour:splitEx(":", tonumber))    
    
    if not day or not month or not hour or not min or not sec then
        return false
    end
    local d = date()
    d:day(day)
    d:month(month)
    d:hour(hour)
    d:min(min)
    d:sec(sec)

    return true, d.time
end

local RegExp = [==[%<(%d+)%>%s*(.-) (%d+) ([%d%:]+)%s+(%a-)%s*([%a%-]-)%-?%[?(%d*)%]?%s*:%s*(.+)]==]
function Parser:TryParse(data)
    local pri, date_month, date_day, date_hour, sender, service, pid, msg = data.data:match(RegExp)

    if not pri then
        return false
    end
    local fac, prio = syslog.FromPRI(pri)

    local succ, timestamp = self:ParseDate(date_month, date_day, date_hour)
    if not succ then
        return false
    end

    if sender:len() < 4 then
        sender = data.source
    end

    local entry = {
        facility = fac,
        priority = prio,

        sender = sender,
        message = msg,
        group = string.format("%s[%s]", service, tostring(pid)),

        timestamp = timestamp,
        source = data.source,
    }

    return true, entry
end

return Parser
