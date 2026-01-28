local Game = {}

local MOVE_STEP = 0.5  -- world units per key press

function Game.update(state, command)
  command = command and command:lower()

  if command == "q" then
    state.running = false
    return
  end

  if command == "k" then
    state.player.y = state.player.y - MOVE_STEP
  elseif command == "j" then
    state.player.y = state.player.y + MOVE_STEP
  elseif command == "h" then
    state.player.x = state.player.x - MOVE_STEP
  elseif command == "l" then
    state.player.x = state.player.x + MOVE_STEP
  end

  -- camera follows player (centered)
  state.camera.x = state.player.x
  state.camera.y = state.player.y
end

return Game


