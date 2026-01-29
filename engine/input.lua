local Input = {}

function Input.read_frame()
  local keys = {}
  local char

  repeat
    char = io.read(1)
    if char and char ~= "" then
      keys[char:lower()] = true
    end
  until not char or char == ""

  return keys
end

return Input

