local Render = {}

local function sample_world(x, y)
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

function Render.clear()
  io.write("\27[2J\27[H")
end

function Render.draw(state)
  Render.clear()

  local sw = state.screen.width
  local sh = state.screen.height

  local cx = math.floor(sw / 2) + 1
  local cy = math.floor(sh / 2) + 1

  local camx = state.camera.x
  local camy = state.camera.y

  for sy = 1, sh do
    for sx = 1, sw do
      if sx == cx and sy == cy then
        io.write("@")
      else
        local wx = camx + (sx - cx)
        local wy = camy + (sy - cy)
        io.write(sample_world(wx, wy))
      end
    end
    io.write("\n")
  end

  io.write(string.format(
    "\nPos: %.2f, %.2f\n",
    state.player.x,
    state.player.y
  ))
end

return Render

