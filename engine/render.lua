local Render = {}

function Render.clear()
  io.write("\27[2J\27[H")
end

function Render.draw(state)
  Render.clear()

  for y = 1, state.map.height do
    for x = 1, state.map.width do
      if x == state.player.x and y == state.player.y then
        io.write("@")
      else
        io.write(".")
      end
    end
    io.write("\n")
  end

  io.write("\nHP: " .. state.player.hp .. "\n")
end

return Render


