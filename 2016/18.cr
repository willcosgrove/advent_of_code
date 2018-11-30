require "bit_array"

starting_row = STDIN.gets_to_end.chomp

map = Array.new(1000000) { BitArray.new(starting_row.size) }

starting_row.each_char.with_index do |char, index|
  map[0][index] = char == '^'
end


map.each_with_index { |row, row_index|
  next if row_index == 0
  row.each_index { |col_index|
    left = col_index - 1 >= 0 ? map[row_index - 1][col_index - 1] : false
    right = col_index + 1 < row.size ? map[row_index - 1][col_index + 1] : false
    row[col_index] = left ^ right
  }
}

# map.each do |row|
#   row.each do |trap_tile|
#     if trap_tile
#       print "^"
#     else
#       print "."
#     end
#   end
#   print "\n"
# end

puts map.map { |row|
  row.reduce(0) { |sum, is_trap|
    sum += is_trap ? 0 : 1
  }
}.sum
