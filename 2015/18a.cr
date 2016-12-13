require "bit_array"

class LightGrid
  def initialize(@width, @height)
    @grid = BitArray.new(@width * @height)
  end

  def initialize(@width, @height, @grid)
  end

  def tick
    @grid = @grid.map_with_index do |light, index|
      count_of_neighboring_lights = neighbors(index).map { |l| l ? 1 : 0 }.sum
      if light
        2 <= count_of_neighboring_lights <= 3
      else
        count_of_neighboring_lights == 3
      end
    end
  end

  def lights_on
    @grid.map { |light| light ? 1 : 0 }.sum
  end

  private def neighbors(i)
    neighbors = Array(Int32).new
    #                               1 2 3
    #                               4 X 5
    #                               6 7 8

    if i % @width > 0
      neighbors << (i - @width) - 1 # 1
      neighbors << i - 1 #            4
      neighbors << (i + @width) - 1 # 6
    end
    if i % @width < (@width - 1)
      neighbors << (i - @width) + 1 # 3
      neighbors << i + 1 #            5
      neighbors << (i + @width) + 1 # 8
    end
    neighbors << i - @width #       2
    neighbors << i + @width #       7

    neighbors.reject { |index|
      index < 0 || index > (@grid.size - 1)
    }.map { |index|
      @grid[index]
    }
  end
end

initial_grid = BitArray.new(100 * 100)
STDIN.gets_to_end.gsub("\n", "").each_char_with_index do |char, i|
  initial_grid[i] = true if char == '#'
end

yard = LightGrid.new(100, 100, initial_grid)

100.times do
  yard.tick
end

puts yard.lights_on
