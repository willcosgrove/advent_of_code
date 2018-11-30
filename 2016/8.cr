class Screen
  getter :canvas

  def initialize(@width : Int32, @height : Int32)
    @canvas = Array(Bool).new(@width * @height, false)
  end

  def print
    @canvas.each_with_index do |pixel, index|
      STDOUT << (pixel ? "#" : " ")
      STDOUT << "\r\n" if index % @width == @width - 1
    end
  end

  def draw_rectangle(width : Int32, height : Int32)
    height.times do |y|
      width.times do |x|
        draw(x, y)
      end
    end
  end

  def draw(x, y)
    @canvas[(y * @width) + x] = true
  end

  def rotate_column(column_index, count)
    count.times { rotate_column(column_index) }
  end

  def rotate_column(column_index)
    previous_value = nil
    @canvas.each_with_index do |value, index|
      next unless index % @width == column_index
      if previous_value.nil?
        previous_value = @canvas[index]
      else
        @canvas[index], previous_value = previous_value, @canvas[index]
      end
    end
    @canvas[column_index] = previous_value.as(Bool)
  end

  def rotate_row(row_index, count)
    count.times { rotate_row(row_index) }
  end

  def rotate_row(row_index)
    previous_value = nil
    @canvas.each_with_index do |value, index|
      next unless index / @width == row_index
      if previous_value.nil?
        previous_value = @canvas[index]
      else
        @canvas[index], previous_value = previous_value, @canvas[index]
      end
    end
    @canvas[row_index * @width] = previous_value.as(Bool)
  end
end

screen = Screen.new(50, 6)

RECTANGLE_REGEX = /rect (\d+)x(\d+)/
ROTATE_COLUMN_REGEX = /rotate column x=(\d+) by (\d+)/
ROTATE_ROW_REGEX = /rotate row y=(\d+) by (\d+)/

STDIN.each_line do |line|
  case line
  when RECTANGLE_REGEX
    screen.draw_rectangle($~[1].to_i, $~[2].to_i)
  when ROTATE_COLUMN_REGEX
    screen.rotate_column($~[1].to_i, $~[2].to_i)
  when ROTATE_ROW_REGEX
    screen.rotate_row($~[1].to_i, $~[2].to_i)
  else
    raise "Unknown command: #{line}"
  end
end

puts screen.canvas.count { |pixel| pixel }
screen.print
