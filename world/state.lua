local State = {
  running = true,

  player = {
    x = 0.0,
    y = 0.0,
    vx = 0.0,  -- velocity x
    vy = 0.0   -- velocity y
  },

  camera = {
    x = 0.0,
    y = 0.0
  },

  screen = {
    width = 61,
    height = 31
  }
}

return State


