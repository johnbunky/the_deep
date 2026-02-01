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
 
-- Stable hash per coordinate
local function hash(x, y, z)
  local n = x * 374761393 + y * 668265263 + z * 2147483647
  n = (n ~ (n >> 13)) * 1274126177
  return (n & 0x7fffffff) / 0x7fffffff
end

-- Star layers definition
Terrain.layers = {
  { z = -5,  parallax = 1.0, density = 0.9997, char = "✦" },  -- close, moves normal speed
  { z = -20, parallax = 0.6, density = 0.999, char = "o" },  -- mid, moves slower
  { z = -60, parallax = 0.3, density = 0.998, char = "." },  -- far, moves very slow
}

function Terrain.sample_parallax(screen_x, screen_y, camx, camy, camz)
  for _, layer in ipairs(Terrain.layers) do
    local dz = math.abs(layer.z - camz)
    
    -- Skip layers too far away (optional cutoff)
    if dz < 100 then
      -- APPLY PARALLAX: objects at different depths move at different speeds
      local wx = camx + screen_x * layer.parallax
      local wy = camy + screen_y * layer.parallax
      
      local r = hash(
        math.floor(screen_x + camx * layer.parallax),
        math.floor(screen_y + camy * layer.parallax),
        layer.z
      )
      
      if r > layer.density then
        return layer.char
      end
    end
  end
  
  return nil
end

return Terrain
