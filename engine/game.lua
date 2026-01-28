local Game = {}

function Game.update(state, command)
  command = command and command:lower()

  if command == "q" then
    state.running = false
    return
  end

  state.player.prev_x = state.player.x
  state.player.prev_y = state.player.y

  if command == "k" then
    state.player.y = math.max(1, state.player.y - 1)
  elseif command == "j" then
    state.player.y = math.min(state.map.height, state.player.y + 1)
  elseif command == "h" then
    state.player.x = math.max(1, state.player.x - 1)
  elseif command == "l" then
    state.player.x = math.min(state.map.width, state.player.x + 1)
  end
end

return Game


