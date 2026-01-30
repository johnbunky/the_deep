local Render = {}

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
        io.write(" ")
      end 
    end 
    io.write("\n") 
  end 

  io.write(string.format(
    "\nPos: x=%.2f y=%.2f z=%.2f\n",
    state.player.x,
    state.player.y,
    state.player.z
  )) 
end 

return Render
