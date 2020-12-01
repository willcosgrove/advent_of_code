require 'set'
require 'pry'
pry_stdin = IO.new(IO.sysopen('/dev/tty'), 'r')
Pry.config.input = pry_stdin

Point = Struct.new(:x, :y) do
  def distance(other)
    (x - other.x).abs + (y - other.y).abs
  end

  def up
    self.class.new(x, y + 1)
  end

  def down
    self.class.new(x, y - 1)
  end

  def left
    self.class.new(x - 1, y)
  end

  def right
    self.class.new(x + 1, y)
  end
end

ORIGIN = Point.new(0,0)

class Wire
  attr_reader :positions

  def initialize(layout)
    @positions = []
    position = ORIGIN
    layout.each do |instruction|
      direction, magnitude = instruction.split("", 2)
      direction_method = case direction
                         when "U" then :up
                         when "D" then :down
                         when "L" then :left
                         when "R" then :right
                         end

      magnitude.to_i.times do
        position = position.send(direction_method)
        @positions << position
      end
    end
  end

  def distance(point)
    @positions.index(point) + 1
  end
end

puts "Compiling Wires..."
t = Time.now
wires = STDIN.each_line.map { |line| Wire.new(line.split(",")) }
puts "Done! (#{Time.now - t}s)"

overlay_points = wires[0].positions.to_set & wires[1].positions.to_set
closest_overlay_point = overlay_points.min_by { |point| ORIGIN.distance(point) }
puts "Part 1: #{closest_overlay_point.distance(ORIGIN)}"
shortest_overlay_distance = overlay_points.map { |point| wires[0].distance(point) + wires[1].distance(point) }.min
puts "Part 2: #{shortest_overlay_distance}"
