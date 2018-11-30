require 'matrix'

VALID_PATH = /[-|+A-Z]/
MARKER = /[A-Z]/
MOVEMENTS = {
  up:    -> ((i, j)) { [i - 1, j] },
  down:  -> ((i, j)) { [i + 1, j] },
  left:  -> ((i, j)) { [i, j - 1] },
  right: -> ((i, j)) { [i, j + 1] },
}
NEXT_DIRECTIONS = {
  up:    [:left, :right],
  down:  [:left, :right],
  left:  [:up, :down],
  right: [:up, :down],
}

diagram = Matrix[*STDIN.each_line.map { |line| line.chomp.each_char.to_a }]

path = []
steps = 1
position = [0, diagram.row(0).to_a.index { |char| char.match?(VALID_PATH) }]

direction = :down

loop do
  break if direction.nil?
  next_position = MOVEMENTS[direction].call(position)
  if diagram[*next_position].match?(VALID_PATH)
    position = next_position
    steps += 1
    path << diagram[*position] if diagram[*position].match?(MARKER)
  else
    direction = NEXT_DIRECTIONS[direction].find(-> { break }) do |dir|
      diagram[*MOVEMENTS[dir].call(position)].match?(VALID_PATH)
    end
  end
end

puts path.join
puts steps
