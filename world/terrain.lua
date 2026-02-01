local Terrain = {}

local function hash(x, y)
  local n = x * 374761393 + y * 668265263
  n = (n ~ (n >> 13)) * 1274126177
  return (n & 0x7fffffff) / 0x7fffffff
end

function Terrain.sample_world(x, y)
  local r = hash(math.floor(x), math.floor(y))

  -- density control (smaller = rarer)
  if r > 0.9995 then
    return "+"
  else
    return nil
  end
end

function Terrain.sample_blobs(x, y)
  local n =
    math.sin(x * 0.12) +
    math.cos(y * 0.15) +
    math.sin((x + y) * 0.05)

  if n > 1.3 then
    return "X"
  elseif n > 0.9 then
    return "+"
  elseif n > 0.5 then
    return "."
  else
    return nil
  end
end

return Terrain
