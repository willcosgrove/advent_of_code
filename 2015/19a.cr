replacements = Array(Tuple(String, String)).new
molecules = Set(String).new

input = STDIN.gets_to_end
input = input.split("\n")
molecule = input.pop
input.pop

input.each do |replacement|
  if replacement.match(/(\w+) => (\w+)/)
    replacements << {$1, $2}
  end
end

replacements.each do |replacement|
  from, to = replacement
  offset = 0
  while index = molecule.index(from, offset)
    if index == 0
      molecules << to + molecule[from.size..-1]
      offset = index + 1
    elsif (index + from.size) > (molecule.size - 1)
      molecules << molecule[0..index - 1] + to
      break
    else
      molecules << molecule[0..index - 1] + to + molecule[(index + from.size)..-1]
      offset = index + 1
    end
  end
end

puts molecules.size
