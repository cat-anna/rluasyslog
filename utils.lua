
local utils = { }

function utils.MakeRO(t)
    return setmetatable(t, {
        __newindex = function(t,name,value)
            error("Attempt to modify RO object")
        end
    })
end

function string.formatEx(pattern, args)
    for k,v in pairs(args) do
        pattern = pattern:gsub("{" .. k .. "}", v)
    end
    return pattern
end

return utils