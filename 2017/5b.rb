jumps = STDIN.each_line.map(&:to_i)

steps = 0
position = 0

until position < 0 || position >= jumps.size
  steps += 1
  old_position = position
  position += jumps[position]
  if jumps[old_position] >= 3
    jumps[old_position] -= 1
  else
    jumps[old_position] += 1
  end
end

puts steps
