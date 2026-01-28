local Terminal = {}

function Terminal.enable_raw()
  os.execute("stty -icanon -echo min 0 time 0")
end

function Terminal.disable_raw()
  os.execute("stty sane")
end

return Terminal

