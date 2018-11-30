require './circular_buffer'

rope      = CircularBuffer[*(0..255)]
lengths   = STDIN.gets.chomp.split(",").map(&:to_i)
position  = 0
skip_size = 0

lengths.each do |length|
  rope[position...(position + length)].reverse!
  position += length
  position += skip_size
  skip_size += 1
end

puts rope[0] * rope[1]
