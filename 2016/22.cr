LINE_REGEX = /\/dev\/grid\/node-x(?<x>\d+)-y(?<y>\d+)\s+(?<size>\d+)T\s+(?<used>\d+)T\s+(?<available>\d+)T\s+(?<use>\d+)%/

class StorageNode
  getter :capacity, :used

  def self.blank
    new(0, 0)
  end

  def initialize(@capacity : Int32, @used : Int32)
  end

  def available
    @capacity - @used
  end

  def empty?
    @used == 0
  end
end

class StorageGrid
  include Enumerable(StorageNode)

  def initialize(width, height)
    @grid = Array(Array(StorageNode)).new(height) { Array(StorageNode).new(width) { StorageNode.blank } }
  end

  def [](x, y)
    @grid[y][x]
  end

  def []=(x, y, node)
    @grid[y][x]= node
  end

  def each
    @grid.each do |row|
      row.each do |node|
        yield node
      end
    end
  end
end

input = STDIN.gets_to_end.lines.map { |line| line.match(LINE_REGEX) }.compact

grid_width, grid_height = input.map { |match|
  [match["x"].to_i, match["y"].to_i]
}.transpose.map(&.max)

grid = StorageGrid.new(grid_width + 1, grid_height + 1)

input.each { |match|
  grid[match["x"].to_i, match["y"].to_i] = StorageNode.new(match["size"].to_i, match["used"].to_i)
}

viable_pairs = Set(Tuple(StorageNode, StorageNode)).new

grid.each do |node_a|
  next if node_a.empty?
  grid.each do |node_b|
    next if node_a == node_b
    viable_pairs << {node_a, node_b} if node_a.used <= node_b.available
  end
end

puts viable_pairs.size
