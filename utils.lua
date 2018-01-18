
local utils = { }

function utils.MakeRO(t)
    return setmetatable(t, {
        __newindex = function(t,name,value)
            LogError(debug.traceback())
            LogError("Attempt to modify RO object")
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

function string:split(sep)
    local sep, fields = sep or ":", {}
    local pattern = string.format("([^%s]+)", sep)
    self:gsub(pattern, function(c) fields[#fields+1] = c end)
    return fields
end

function string:splitEx(sep, translate)
    local sep, fields = sep or ":", {}
    local pattern = string.format("([^%s]+)", sep)
    self:gsub(pattern, function(c) fields[#fields+1] = translate(c) end)
    return fields
end

if not table.unpack then
    table.unpack = unpack
end

function table.translate(t, func, itfunc)
    local out = {}
    itfunc = itfunc or ipairs
    for _,v in itfunc(t) do
        table.insert(out, func(v))
    end
    return out
end

return utils