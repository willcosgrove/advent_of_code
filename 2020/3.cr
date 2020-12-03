# --- Day 3: Toboggan Trajectory ---

# With the toboggan login problems resolved, you set off toward the airport.
# While travel by toboggan might be easy, it's certainly not safe: there's very
# minimal steering and the area is covered in trees. You'll need to see which
# angles will take you near the fewest trees.

# Due to the local geology, trees in this area only grow on exact integer
# coordinates in a grid. You make a map (your puzzle input) of the open
# squares (.) and trees (#) you can see. For example:

# ..##.......
# #...#...#..
# .#....#..#.
# ..#.#...#.#
# .#...##..#.
# ..#.##.....
# .#.#.#....#
# .#........#
# #.##...#...
# #...##....#
# .#..#...#.#

# These aren't the only trees, though; due to something you read about once
# involving arboreal genetics and biome stability, the same pattern repeats to
# the right many times:

# ..##.........##.........##.........##.........##.........##.......  --->
# #...#...#..#...#...#..#...#...#..#...#...#..#...#...#..#...#...#..
# .#....#..#..#....#..#..#....#..#..#....#..#..#....#..#..#....#..#.
# ..#.#...#.#..#.#...#.#..#.#...#.#..#.#...#.#..#.#...#.#..#.#...#.#
# .#...##..#..#...##..#..#...##..#..#...##..#..#...##..#..#...##..#.
# ..#.##.......#.##.......#.##.......#.##.......#.##.......#.##.....  --->
# .#.#.#....#.#.#.#....#.#.#.#....#.#.#.#....#.#.#.#....#.#.#.#....#
# .#........#.#........#.#........#.#........#.#........#.#........#
# #.##...#...#.##...#...#.##...#...#.##...#...#.##...#...#.##...#...
# #...##....##...##....##...##....##...##....##...##....##...##....#
# .#..#...#.#.#..#...#.#.#..#...#.#.#..#...#.#.#..#...#.#.#..#...#.#  --->

# You start on the open square (.) in the top-left corner and need to reach the
# bottom (below the bottom-most row on your map).

# The toboggan can only follow a few specific slopes (you opted for a cheaper
# model that prefers rational numbers); start by counting all the trees you
# would encounter for the slope right 3, down 1:

# From your starting position at the top-left, check the position that is right
# 3 and down 1. Then, check the position that is right 3 and down 1 from there,
# and so on until you go past the bottom of the map.

# The locations you'd check in the above example are marked here with O where
# there was an open square and X where there was a tree:

# ..##.........##.........##.........##.........##.........##.......  --->
# #..O#...#..#...#...#..#...#...#..#...#...#..#...#...#..#...#...#..
# .#....X..#..#....#..#..#....#..#..#....#..#..#....#..#..#....#..#.
# ..#.#...#O#..#.#...#.#..#.#...#.#..#.#...#.#..#.#...#.#..#.#...#.#
# .#...##..#..X...##..#..#...##..#..#...##..#..#...##..#..#...##..#.
# ..#.##.......#.X#.......#.##.......#.##.......#.##.......#.##.....  --->
# .#.#.#....#.#.#.#.O..#.#.#.#....#.#.#.#....#.#.#.#....#.#.#.#....#
# .#........#.#........X.#........#.#........#.#........#.#........#
# #.##...#...#.##...#...#.X#...#...#.##...#...#.##...#...#.##...#...
# #...##....##...##....##...#X....##...##....##...##....##...##....#
# .#..#...#.#.#..#...#.#.#..#...X.#.#..#...#.#.#..#...#.#.#..#...#.#  --->

# In this example, traversing the map using this slope would cause you to
# encounter 7 trees.

# Starting at the top-left corner of your map and following a slope of right 3
# and down 1, how many trees would you encounter?

require "bit_array"

class Map
  property map_data : Array(BitArray),
    wrap_x,
    wrap_y,
    height : Int32,
    width : Int32

  def initialize(map_data_string, *, @wrap_x = false, @wrap_y = false)
    @map_data = map_data_string.each_line.map { |line|
      line_data = BitArray.new(line.size)
      line.each_char_with_index do |ch, i|
        line_data[i] = ch == '#'
      end
      line_data
    }.to_a

    @height = @map_data.size
    @width = @map_data.first.size
  end

  def tree_at?(position : Vec2)
    tree_at?(position.x, position.y)
  end

  def tree_at?(x, y)
    @map_data[normalize_y(y)][normalize_x(x)]
  end

  private def normalize_x(x)
    @wrap_x ? x % @width : x
  end

  private def normalize_y(y)
    @wrap_y ? y % @height : y
  end
end

struct Vec2
  property x : Int32, y : Int32

  def initialize(@x, @y)
  end

  def +(other : Vec2)
    Vec2.new(@x + other.x, @y + other.y)
  end
end

map = Map.new(STDIN, wrap_x: true)
slope = Vec2.new(3, 1)

def trees_seen_on_slope(map, slope)
  position = Vec2.new(0, 0)
  trees_seen : Int64 = 0

  loop do
    trees_seen += 1 if map.tree_at?(position)
    position += slope
  rescue IndexError
    break
  end

  trees_seen
end

puts "Part 1: #{trees_seen_on_slope(map, slope)}"

# --- Part Two ---

# Time to check the rest of the slopes - you need to minimize the probability of
# a sudden arboreal stop, after all.

# Determine the number of trees you would encounter if, for each of the
# following slopes, you start at the top-left corner and traverse the map all
# the way to the bottom:

# Right 1, down 1.
# Right 3, down 1. (This is the slope you already checked.)
# Right 5, down 1.
# Right 7, down 1.
# Right 1, down 2.

# In the above example, these slopes would find 2, 7, 3, 4, and 2 tree
# (s) respectively; multiplied together, these produce the answer 336.

# What do you get if you multiply together the number of trees encountered on
# each of the listed slopes?

slopes = [
  Vec2.new(1, 1),
  Vec2.new(3, 1),
  Vec2.new(5, 1),
  Vec2.new(7, 1),
  Vec2.new(1, 2),
]

puts "Part 2: #{slopes.map { |slope| trees_seen_on_slope(map, slope) }.product}"
