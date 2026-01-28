local State    = require("world.state")
local Render   = require("engine.render")
local Input    = require("engine.input")
local Game     = require("engine.game")
local Terminal = require("engine.terminal")
local Time     = require("engine.time")

Terminal.enable_raw()
Terminal.enter()

local last_time = Time.now()

while State.running do
  local now = Time.now()
  local dt = now - last_time
  last_time = now

  local key = Input.read()
  if key then
    Game.update(State, key)
  end

  Render.draw(State)
  os.execute("sleep 0.03")
end

Terminal.exit()
Terminal.disable_raw()
print("Game over.")
