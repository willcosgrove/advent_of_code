require './circular_buffer'

ROPE_HASH_SUFFIX = [17, 31, 73, 47, 23].freeze

def rope_hash(str)
  lengths   = str.bytes + ROPE_HASH_SUFFIX
  rope      = CircularBuffer[*(0..255)]
  position  = 0
  skip_size = 0

  64.times do
    lengths.each do |length|
      rope[position...(position + length)].reverse!
      position += length
      position += skip_size
      skip_size += 1
    end
  end

  rope
    .each_slice(16)
    .map { |slice| slice.reduce(&:^) }
    .map { |n| n.to_s(16).rjust(2, "0") }
    .join
end

input = ARGV[0]

grid =
  128.times.map do |row|
    hash = rope_hash("#{input}-#{row}")
    hash.each_char.map { |char| char.to_i(16).to_s(2).rjust(4, "0") }.join
  end

puts grid.sum { |row| row.each_char.count { |square| square == "1" } }
