class LightGrid
  def initialize(width, height)
    @grid = [] of Array(Bool)
    width.times do
      row = [] of Bool
      height.times do
        row << false
      end
      @grid << row
    end
  end

  def total_on
    @grid.flatten.count { |light| light }
  end

  def turn_on(x1, y1, x2, y2)
    each_light(x1, y1, x2, y2) do |x, y|
      @grid[x][y] = true
    end
  end

  def turn_off(x1, y1, x2, y2)
    each_light(x1, y1, x2, y2) do |x, y|
      @grid[x][y] = false
    end
  end

  def toggle(x1, y1, x2, y2)
    each_light(x1, y1, x2, y2) do |x, y|
      @grid[x][y] = !@grid[x][y]
    end
  end

  def each_light(x1, y1, x2, y2)
    [((x1..x2).to_a * (y2 - y1 + 1)).sort, ((y1..y2).to_a * (x2 - x1 + 1))].transpose.each do |coord|
      yield coord[0], coord[1]
    end
  end
end

def exec_line(line, lights)
  coords = line.match(/(?<x1>\d+),(?<y1>\d+) through (?<x2>\d+),(?<y2>\d+)/)
  if coords
    case line
    when /off/ then lights.turn_off(coords["x1"].to_i, coords["y1"].to_i, coords["x2"].to_i, coords["y2"].to_i)
    when /on/ then lights.turn_on(coords["x1"].to_i, coords["y1"].to_i, coords["x2"].to_i, coords["y2"].to_i)
    when /toggle/ then lights.toggle(coords["x1"].to_i, coords["y1"].to_i, coords["x2"].to_i, coords["y2"].to_i)
    end
  end
end


lights = LightGrid.new(1000, 1000)

STDIN.each_line do |line|
  exec_line(line, lights)
end

puts lights.total_on
