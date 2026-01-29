local Game = {} 

local ACCELERATION = 0.05  -- how fast you accelerate
local MAX_SPEED = 1.1      -- maximum velocity
local FRICTION = 0.92      -- deceleration (0.9 = more slide, 0.95 = less slide)

function Game.update(state, keys, dt) 
  if keys["q"] then 
    state.running = false 
    return 
  end 

  local dx, dy = 0, 0 

  if keys["h"] then dx = dx - 1 end 
  if keys["l"] then dx = dx + 1 end 
  if keys["k"] then dy = dy - 1 end 
  if keys["j"] then dy = dy + 1 end 

  -- normalize diagonal input
  if dx ~= 0 and dy ~= 0 then 
    dx = dx * 0.7071 
    dy = dy * 0.7071 
  end 

  -- apply acceleration
  state.player.vx = state.player.vx + dx * ACCELERATION
  state.player.vy = state.player.vy + dy * ACCELERATION

  -- apply friction (smooth deceleration)
  state.player.vx = state.player.vx * FRICTION
  state.player.vy = state.player.vy * FRICTION

  -- clamp to max speed
  local speed = math.sqrt(state.player.vx^2 + state.player.vy^2)
  if speed > MAX_SPEED then
    state.player.vx = state.player.vx * (MAX_SPEED / speed)
    state.player.vy = state.player.vy * (MAX_SPEED / speed)
  end

  -- stop tiny movements (prevent endless drift)
  if math.abs(state.player.vx) < 0.001 then state.player.vx = 0 end
  if math.abs(state.player.vy) < 0.001 then state.player.vy = 0 end

  -- update position based on velocity
  state.player.x = state.player.x + state.player.vx
  state.player.y = state.player.y + state.player.vy

  -- camera follows player (centered)
  state.camera.x = state.player.x 
  state.camera.y = state.player.y 
end 

return Game

