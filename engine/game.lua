local Game = {} 

local ACCELERATION = 0.05 -- how fast you accelerate 
local MAX_SPEED = 1.1 -- maximum velocity 
local FRICTION = 0.92 -- deceleration (0.9 = more slide, 0.95 = less slide) 


function Game.update(state, keys, dt)
  if keys["q"] then
    state.running = false 
    return 
  end 

  local dx, dy, dz = 0, 0, 0 

  if keys["h"] then dx = dx - 1 end
  if keys["l"] then dx = dx + 1 end
  if keys["k"] then dy = dy - 1 end
  if keys["j"] then dy = dy + 1 end
  if keys["i"] then dz = dz + 1 end
  if keys["o"] then dz = dz - 1 end 

  -- normalize diagonal input (for 3D)
  local input_mag = math.sqrt(dx*dx + dy*dy + dz*dz)
  if input_mag > 0 then
    dx = dx / input_mag
    dy = dy / input_mag
    dz = dz / input_mag
  end

  -- apply acceleration 
  state.player.vx = state.player.vx + dx * ACCELERATION
  state.player.vy = state.player.vy + dy * ACCELERATION 
  state.player.vz = state.player.vz + dz * ACCELERATION 

  -- apply friction (smooth deceleration) 
  state.player.vx = state.player.vx * FRICTION 
  state.player.vy = state.player.vy * FRICTION 
  state.player.vz = state.player.vz * FRICTION 

  -- clamp to max speed 
  local speed = math.sqrt(state.player.vx^2 + state.player.vy^2 + state.player.vz^2) 
  if speed > MAX_SPEED then 
      state.player.vx = state.player.vx * (MAX_SPEED / speed)
      state.player.vy = state.player.vy * (MAX_SPEED / speed) 
      state.player.vz = state.player.vz * (MAX_SPEED / speed) 
  end

  -- stop tiny movements (prevent endless drift) 
  if math.abs(state.player.vx) < 0.001 then
      state.player.vx = 0 
  end 
  if math.abs(state.player.vy) < 0.001 then
      state.player.vy = 0 
  end 
  if math.abs(state.player.vz) < 0.001 then
      state.player.vz = 0 
  end 

  -- update position based on velocity 
  state.player.x = state.player.x + state.player.vx
  state.player.y = state.player.y + state.player.vy 
  state.player.z = state.player.z + state.player.vz 

  -- camera follows player (centered) 
  state.camera.x = state.player.x 
  state.camera.y = state.player.y 
  state.camera.z = state.player.z 
end 

return Game
