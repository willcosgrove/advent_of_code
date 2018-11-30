MAGIC_NUMBER = ARGV[0].to_i

struct Position
  @x : Int32
  @y : Int32
  @open : Bool

  getter :x, :y, :open

  def initialize(@x, @y)
    @open = ((@x*@x) + (3*@x) + (2*@x*@y) + @y + (@y*@y) + MAGIC_NUMBER).popcount.even?
  end

  def hash
    {@x, @y}.hash
  end

  def ==(other)
    @x == other.x && @y == other.y
  end

  def open_adjacent_positions
    adjacent_positions.select(&.open)
  end

  private def adjacent_positions
    positions = [Position.new(@x + 1, @y), Position.new(@x, @y + 1)]
    positions << Position.new(@x - 1, @y) if @x > 0
    positions << Position.new(@x, @y - 1) if @y > 0
    return positions
  end
end

class Tree
  def initialize(position)
    @root = TreeNode.new(position, 0)
  end

  def search_breadth_first(max_depth = Float32::INFINITY, &block : TreeNode -> Bool)
    do_breadth_first_search(0, [@root], max_depth, &block)
  end

  private def do_breadth_first_search(depth, nodes, max_depth, &block : TreeNode -> Bool)
    next_depth = [] of TreeNode
    nodes.each do |node|
      return node if yield node
      next_depth.concat(node.children) unless node.dead
    end
    do_breadth_first_search(depth + 1, next_depth, max_depth, &block) unless depth + 1 > max_depth
  end
end

class TreeNode
  @position : Position
  @depth : Int32
  @children : Array(TreeNode)?
  @dead : Bool

  getter :position, :depth, :dead

  def initialize(@position, @depth)
    @dead = false
  end

  def children : Array(TreeNode)
    @children ||= @position.open_adjacent_positions.map { |position|
      TreeNode.new(position, @depth + 1)
    }
  end

  def dead!
    @dead = true
  end
end

tree = Tree.new(Position.new(1, 1))
visited_positions = Set(Position).new
goal = Position.new(31, 39)

target_node = tree.search_breadth_first do |node|
  node.dead! if visited_positions.includes?(node.position)
  reached_goal = node.position == goal
  unless reached_goal
    visited_positions.add(node.position)
  end
  reached_goal
end

if target_node
  puts "Depth: #{target_node.depth}"
end
