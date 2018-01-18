local bit = require("bit")

local syslog = {}

syslog.PRI_EMERG   =   0--system is unusable
syslog.PRI_ALERT   =   1--action must be taken immediately
syslog.PRI_CRIT    =   2--critical conditions
syslog.PRI_ERR     =   3--error conditions
syslog.PRI_WARNING =   4--warning conditions
syslog.PRI_NOTICE  =   5--normal but significant condition
syslog.PRI_INFO    =   6--informational
syslog.PRI_DEBUG   =   7--debug-level messages
syslog.PRI_UNKNOWN =   8

local PriorityNamesTable = {
    [syslog.PRI_EMERG  ] = "emerg",
    [syslog.PRI_ALERT  ] = "alert",
    [syslog.PRI_CRIT   ] = "crit",
    [syslog.PRI_ERR    ] = "err",
    [syslog.PRI_WARNING] = "warning",
    [syslog.PRI_NOTICE ] = "notice",
    [syslog.PRI_INFO   ] = "info",
    [syslog.PRI_DEBUG  ] = "debug",
    [syslog.PRI_UNKNOWN] = "unknown",
}

syslog.PriorityNames = setmetatable({}, {
    __index = function(t, value)
        local t = PriorityNamesTable[value]
        return t or PriorityNamesTable[syslog.PRI_UNKNOWN]
    end,
    __newindex = function(t,name,value)
        error("Attempt to modify syslog.PriorityNames")
    end
})

-- #define    LOG_NPRIORITIES    8    current number of priorities
syslog.PRIORITY_MASK = 0x7
--                 extract priority number
-- #define    LOG_PRI(p)    ((p) & LOG_PRIMASK)
-- #define    LOG_MAKEPRI(fac, pri)    (((fac) << 3) | (pri))
                        
-- #define    INTERNAL_NOPRI    0x10    the "no priority" priority
                        
-- facility codes 
syslog.FAC_KERN =        0 --kernel messages
syslog.FAC_USER =        1 --random user-level messages
syslog.FAC_MAIL =        2 --mail system
syslog.FAC_DAEMON =      3 --system daemons
syslog.FAC_AUTH =        4 --security/authorization messages
syslog.FAC_SYSLOG =      5 --messages generated internally by syslogd
syslog.FAC_LPR =         6 --line printer subsystem
syslog.FAC_NEWS =        7 --network news subsystem
syslog.FAC_UUCP =        8 --UUCP subsystem
syslog.FAC_CRON =        9 --clock daemon
syslog.FAC_AUTHPRIV =   10 --security/authorization messages (private)
syslog.FAC_FTP =        11 --ftp daemon
syslog.FAC_NTP =        12 --NTP subsystem
syslog.FAC_LOGAUDIT =   13 --log audit
syslog.FAC_LOGALERT =   14 --log alert
syslog.FAC_CLOCK  =     15 --clock daemon
syslog.FAC_LOCAL0 =     16 --reserved for local use
syslog.FAC_LOCAL1 =     17 --reserved for local use
syslog.FAC_LOCAL2 =     18 --reserved for local use
syslog.FAC_LOCAL3 =     19 --reserved for local use
syslog.FAC_LOCAL4 =     20 --reserved for local use
syslog.FAC_LOCAL5 =     21 --reserved for local use
syslog.FAC_LOCAL6 =     22 --reserved for local use
syslog.FAC_LOCAL7 =     23 --reserved for local use
syslog.FAC_UNKNOWN =    24

local FacilityNamesTable = {
    [syslog.FAC_KERN      ] = "kernel",
    [syslog.FAC_USER      ] = "user",
    [syslog.FAC_MAIL      ] = "mail",
    [syslog.FAC_DAEMON    ] = "daemon",
    [syslog.FAC_AUTH      ] = "auth",
    [syslog.FAC_SYSLOG    ] = "syslog",
    [syslog.FAC_LPR       ] = "lpr",
    [syslog.FAC_NEWS      ] = "news",
    [syslog.FAC_UUCP      ] = "uucp",
    [syslog.FAC_CRON      ] = "cron",
    [syslog.FAC_AUTHPRIV  ] = "authpriv",
    [syslog.FAC_FTP       ] = "ftp",
    [syslog.FAC_NTP       ] = "ntp",
    [syslog.FAC_LOGAUDIT  ] = "logaudit",
    [syslog.FAC_LOGALERT  ] = "logalert",
    [syslog.FAC_CLOCK     ] = "clock",
    [syslog.FAC_LOCAL0    ] = "local0",
    [syslog.FAC_LOCAL1    ] = "local1",
    [syslog.FAC_LOCAL2    ] = "local2",
    [syslog.FAC_LOCAL3    ] = "local3",
    [syslog.FAC_LOCAL4    ] = "local4",
    [syslog.FAC_LOCAL5    ] = "local5",
    [syslog.FAC_LOCAL6    ] = "local6",
    [syslog.FAC_LOCAL7    ] = "local7",
    [syslog.FAC_UNKNOWN   ] = "unknown",
}

syslog.FacilityNames = setmetatable({}, {
    __index = function(t, value)
        local t = FacilityNamesTable[value]
        return t or FacilityNamesTable[syslog.FAC_UNKNOWN]
    end,
    __newindex = function(t,name,value)
        error("Attempt to modify syslog.FacilityNames")
    end
})

syslog.FACILITY_BIT = 3
syslog.FACILITY_MASK = 0x03f8

--                 extract facility number
-- #define    LOG_FAC(p)    (((p) & LOG_FACMASK) >> 3)
--                 mark "facility"
-- #define    INTERNAL_MARK    LOG_MAKEPRI(LOG_NFACILITIES, 0)

function syslog.FromPRI(pri)
    pri = tonumber(pri)

    local facility = bit.band(pri, syslog.FACILITY_MASK)
    facility = bit.rshift(facility, syslog.FACILITY_BIT)

    local priority = bit.band(pri, syslog.PRIORITY_MASK)

    return facility, priority
end


return syslog