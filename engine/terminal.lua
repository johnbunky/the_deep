local Terminal = {}

function Terminal.enter()
  io.write("\27[?1049h")  -- alternate screen
  io.write("\27[2J\27[H") -- clear + home
  io.write("\27[?25l")    -- hide cursor
  io.flush()
end

function Terminal.exit()
  io.write("\27[?25h")    -- show cursor
  io.write("\27[?1049l") -- back to normal screen
  io.flush()
end

function Terminal.enable_raw()
  os.execute("stty -icanon -echo min 0 time 0")
end

function Terminal.disable_raw()
  os.execute("stty sane")
end

return Terminal

