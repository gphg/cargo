-- cargo v0.1.1+simplfied
-- https://github.com/bjornbytes/cargo
-- MIT License
--
-- simplfied fork: https://github.com/gphg/cargo
-- As the name implied, it returns string to file. No loader involved.

local cargo = {}

local function merge(target, source, ...)
  if not target or not source then return target end
  for k, v in pairs(source) do target[k] = v end
  return merge(target, ...)
end

local lf = love.filesystem

cargo.processors = {}

function cargo.init(config)
  if type(config) == 'string' then
    config = { dir = config }
  end

  local processors = merge({}, cargo.processors, config.processors)

  local init

  local function halp(t, k, extension)
    local path = (t._path .. '/' .. k):gsub('^/+', '')
    local fileInfo = lf.getInfo(path, 'directory')
    if fileInfo then
      rawset(t, k, init(path))
      return t[k]
    else
      local file = extension and path .. '.' .. extension or path
      fileInfo = lf.getInfo(file, 'file')
      if fileInfo then
        rawset(t, k, file)
        for pattern, processor in pairs(processors) do
          if file:match(pattern) then
            processor(file, t)
          end
        end
        return file
      end
    end

    return rawget(t, k)
  end

  local function __call(t, recurse)
    for i, f in ipairs(lf.getDirectoryItems(t._path)) do
      local key, extension = f:match('(.-[^/]-)%.([^/]+)$')
      key = key ~= '' and key or f
      halp(t, key, extension)

      if recurse and lf.getInfo(t._path .. '/' .. f, 'directory') then
        t[key](recurse)
      end
    end

    return t
  end

  init = function(path)
    return setmetatable({ _path = path }, { __index = halp, __call = __call })
  end

  return init(config.dir)
end

return cargo
