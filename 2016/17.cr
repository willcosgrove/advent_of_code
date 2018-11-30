require "crypto/md5"

PASSCODE = ARGV[0].chomp
puts PASSCODE.inspect
OPEN_CHARS = ['b', 'c', 'd', 'e', 'f']

struct Position
  @x : Int32
  @y : Int32
  @path : String
  @hash : String

  getter :x, :y, :path

  def initialize(@x, @y, @path)
    @hash = Crypto::MD5.hex_digest(PASSCODE + @path)
  end

  def hash
    {@x, @y}.hash
  end

  def ==(other)
    @x == other.x && @y == other.y
  end

  def open_adjacent_positions
    positions = [] of Position
    positions << Position.new(@x, @y - 1, @path + "U") if OPEN_CHARS.includes?(@hash[0]) && @y - 1 >= 0
    positions << Position.new(@x, @y + 1, @path + "D") if OPEN_CHARS.includes?(@hash[1]) && @y + 1 < 4
    positions << Position.new(@x - 1, @y, @path + "L") if OPEN_CHARS.includes?(@hash[2]) && @x - 1 >= 0
    positions << Position.new(@x + 1, @y, @path + "R") if OPEN_CHARS.includes?(@hash[3]) && @x + 1 < 4
    positions
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
    return nil unless next_depth.size > 0
    puts "Going another level deep: #{depth}, #{next_depth.size}"
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

tree = Tree.new(Position.new(0, 0, ""))
# visited_positions = Set(Position).new
goal = Position.new(3, 3, "")
last_goal = nil

tree.search_breadth_first do |node|
  if node.position == goal
    last_goal = node
    node.dead!
  end
  false
end

if last_goal
  puts "Longest path: #{last_goal.as(TreeNode).depth}"
end
