local Terrain = {}

function Terrain.sample_world(x, y)
  local n =
    math.sin(x * 0.92) +
    math.cos(y * 0.95) +
    math.sin((x + y) * 0.05)

  if n > 1.3 then
    return "+"
  -- elseif n > 0.9 then
  --   return "+"
  -- elseif n > 0.5 then
  --   return "."
  else
    return nil
  end
end

function Terrain.deep_point(x, y, z)
  -- Use 3D noise to determine if a point exists at this coordinate
  local n = 
    math.sin(x * 0.01 + z * 0.1) +
    math.cos(y * 0.09 - z * 0.12) +
    math.sin((x + y + z) * 0.04)
  
  -- Threshold - points appear randomly in 3D space
  if n > 1.5 then
    return "+"  -- dense point
  elseif n > 1.2 then
    return nil --"·"  -- sparse point
  else
    return nil  -- no point here
  end
end

return Terrain
