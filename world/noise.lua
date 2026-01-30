local Noise = {}

function sample_world(x, y)
  local n =
    math.sin(x * 0.12) +
    math.cos(y * 0.15) +
    math.sin((x + y) * 0.05)

  if n > 1.3 then
    return "#"
  elseif n > 0.9 then
    return "+"
  elseif n > 0.5 then
    return "."
  else
    return " "
  end
end

return Noise
