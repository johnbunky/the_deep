local Input = {}

function Input.read()
  local char = io.read(1)
  if char == "" then
    return nil
  end
  return char
end

return Input

