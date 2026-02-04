local Render = {}
local Terrain = require("world.terrain")

function Render.clear()
  io.write("\27[H")  -- move cursor to top-left only
end 

function Render.draw(state) 
  Render.clear() 
  
  local sw = state.screen.width 
  local sh = state.screen.height 
  local cx = math.floor(sw / 2) + 1 
  local cy = math.floor(sh / 2) + 1

  local camx = state.camera.x 
  local camy = state.camera.y 
  local camz = state.camera.z

  -- BUILD FRAME IN MEMORY (no printing yet!)
  local frame_buffer = {}  -- array of strings (one per line)

  for sy = 1, sh do
    local line = "" -- build each line as a string

    for sx = 1, sw do
      if sx == cx and sy == cy then
        line = line .. "@" -- concatenate to string
      else
        -- Calculate screen offset from center
        local screen_x = sx - cx
        local screen_y = sy - cy
        local point = Terrain.sample_space(screen_x, screen_y, camx, camy, camz)
        line = line .. (point or " ") -- concatenate to string
      end
    end

    frame_buffer[sy] = line --store complete line
  end

  local speed = math.sqrt(
    state.player.vx^2 + state.player.vy^2 + state.player.vz^2
  )
  
  -- DEBUG: Show depth info for each layer
  -- local debug_layers = ""
  -- for i, layer in ipairs(Terrain.layers) do
  --   local dz = layer.z - camz
  --   debug_layers = debug_layers .. string.format("L%d: dz=%.1f ", i, dz)
  -- end
  --
  --   -- Get debug info from Terrain
  --
  -- local status  = string.format(
  --   "\nPos: x=%.2f y=%.2f z=%.2f\n",
  --   state.player.x,
  --   state.player.y,
  --   state.player.z
  -- )
   
  -- Get debug info from Terrain
  local debug_layers = Terrain.get_debug_info(camz)
  
  local status = string.format(
    "\nPos: x=%.2f y=%.2f z=%.2f | Speed: %.2f\n%s",
    state.player.x,
    state.player.y,
    state.player.z,
    speed,
    debug_layers
  )
  -- PRINT ENTIRE FRAME AT ONCE (single io.write call)
  io.write(table.concat(frame_buffer, "\n") .. status)
  io.flush()  -- force immediate output
end 

return Render
