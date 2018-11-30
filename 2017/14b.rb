require 'matrix'
require 'set'
require 'pry'
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

module RegionScout
  extend self

  def call(grid, starting_position)
    return nil unless occupied?(grid[*starting_position])

    region = Set[starting_position]
    exausted_positions = Set[]

    until exausted_positions == region
      position = (region - exausted_positions).first
      region << up(position)    if occupied?(grid[*up(position)])
      region << down(position)  if occupied?(grid[*down(position)])
      region << left(position)  if occupied?(grid[*left(position)])
      region << right(position) if occupied?(grid[*right(position)])
      exausted_positions << position
    end

    region
  end

  private

  def occupied?(grid_value)
    grid_value == "1"
  end

  def up((x, y))
    [x, [y - 1, 0].max]
  end

  def down((x, y))
    [x, [y + 1, 127].min]
  end

  def left((x, y))
    [[x - 1, 0].max, y]
  end

  def right((x, y))
    [[x + 1, 127].min, y]
  end
end

input = ARGV[0]

grid =
  Matrix[
    *128.times.map do |row|
      hash = rope_hash("#{input}-#{row}")
      hash
        .each_char
        .map { |char| char.to_i(16).to_s(2).rjust(4, "0") }
        .join
        .each_char
        .to_a
    end
  ]

puts grid

regions = Set[]
grid.each_with_index do |_, x, y|
  position = [x, y]
  next if regions.any? { |region| region.include?(position) }
  region = RegionScout.call(grid, position)
  regions << region if region
end

puts regions.size
