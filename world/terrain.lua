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
  x = math.floor(x)
  y = math.floor(y)
  z = math.floor(z)
  
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

Terrain.layer_spacing = 12    -- distance between depth layers
Terrain.layer_count   = 4     -- how many layers to render
Terrain.layer_template = {
  density = 0.9995,
  fov = 50,
}

function Terrain.sample_space(screen_x, screen_y, camx, camy, camz)
  local spacing = Terrain.layer_spacing
  local count   = Terrain.layer_count
  
  -- Snap to nearest layer grid
  local base_z  = math.floor(camz / spacing) * spacing
  
  for i = 1, count do
    -- Generate layers in front of camera
    local layer_z = base_z - i * spacing
    local dz = layer_z - camz
    
    if dz < -1 and dz > -200 then
      local abs_dz = -dz
      local clamped_dz = math.max(5, abs_dz)
      
      local perspective_scale = Terrain.layer_template.fov / clamped_dz

      local parallax = 0.3 + (abs_dz / 100) * 0.7  -- 0.3 to 1.0 based on depth

      local px = screen_x * perspective_scale * parallax
      local py = screen_y * perspective_scale * parallax
      
      local wx = camx + px
      local wy = camy + py
      
      local hash_x = math.floor(wx)
      local hash_y = math.floor(wy)
      
      -- Use layer_z directly (no stable_z needed - it's already repeating!)
      local r = hash(hash_x, hash_y, layer_z)
      
      if r > Terrain.layer_template.density then
        -- Dynamic character based on distance
        local char
        if abs_dz < 20 then
          char = "."  -- Close stars
        elseif abs_dz < 50 then
          char = "o"  -- Medium stars
        else
          char = "✦"  -- Far stars
        end
        
        return char
      end
    end
  end
  
  return nil
end

-- Debug helper
function Terrain.get_debug_info(camz)
  local spacing = Terrain.layer_spacing
  local base_z = math.floor(camz / spacing) * spacing
  local cycle = math.floor(camz / spacing)
  
  local info = string.format("camz=%.1f base=%.0f cycle=%d | Layers: ", camz, base_z, cycle)
  
  -- Show first few visible layers
  for i = 1, math.min(5, Terrain.layer_count) do
    local layer_z = base_z - i * spacing
    local dz = layer_z - camz
    if dz < -1 and dz > -50 then
      local char = (-dz < 15) and "✦" or "."
      info = info .. string.format("[%s@%.0f dz=%.1f] ", char, layer_z, dz)
    end
  end
  
  return info
end

return Terrain
