require "bit_array"
require "./tree"

class Maze
  getter :goals
  @map : Array(BitArray)
  @goals : Hash(Int32, Tuple(Int32, Int32))
  @reverse_goals : Hash(Tuple(Int32, Int32), Int32)
  def initialize(@map, @goals)
    @reverse_goals = @goals.invert
  end

  def self.parse(string)
    map = Array(BitArray).new
    goals = Hash(Int32, Tuple(Int32, Int32)).new
    string.each_line.map(&.chomp).each.with_index do |line, y_index|
      bit_line = BitArray.new(line.size)
      line.each_char.with_object(bit_line).with_index { |(char, bit_array), x_index|
        bit_array[x_index] = char != '#'
        goals[char.to_i] = {x_index, y_index} if char.number?
      }
      map << bit_line
    end
    new(map, goals)
  end

  def to_s(overlay = Hash(Tuple(Int32, Int32), Int32).new)
    String.build do |str|
      @map.each.with_index do |line, y|
        line.each.with_index do |is_open, x|
          if override = overlay[{x, y}]?
            str << "\e[0;32;49m"
            str << override
          else
            if is_open
              if goal = is_goal?(x, y)
                str << "\e[0;32;49m"
                str << goal
              else
                str << ' '
              end
            else
              str << "\e[1;30;49m"
              str << '#'
            end
          end
        end
        str << '\n'
      end
    end
  end

  def is_goal?(x, y)
    # @reverse_goals.has_key?({x, y})
    @reverse_goals[{x, y}]?
  end

  def is_open?(x, y)
    @map[y][x]
  end
end

struct MazeState
  getter :maze, :position, :visited_goals

  def initialize(@maze : Maze, @position : Tuple(Int32, Int32), visited_goals : Array(Int32) = [] of Int32)
    if (goal = @maze.is_goal?(*@position)) && !visited_goals.includes?(goal)
      @visited_goals = visited_goals + [goal]
    else
      @visited_goals = visited_goals
    end
  end

  def next_steps
    [up, down, left, right].select(&.valid?)
  end

  def valid?
    @maze.is_open?(*@position)
  end

  def identity
    {@position, @visited_goals}
  end

  private def up
    MazeState.new(@maze, {@position[0], @position[1] - 1}, @visited_goals)
  end

  private def down
    MazeState.new(@maze, {@position[0], @position[1] + 1}, @visited_goals)
  end

  private def left
    MazeState.new(@maze, {@position[0] - 1, @position[1]}, @visited_goals)
  end

  private def right
    MazeState.new(@maze, {@position[0] + 1, @position[1]}, @visited_goals)
  end
end

alias StateIdentity = Tuple(Tuple(Int32, Int32), Array(Int32))

maze = Maze.parse(STDIN.gets_to_end)
# puts maze.to_s({ {7,1} => 'X'})

search_tree = Tree(MazeState, StateIdentity).new(
  MazeState.new(maze, maze.goals[0]),
  ->(state : MazeState) { state.next_steps },
  ->(state : MazeState) { state.identity },
)

all_goals = maze.goals.keys

winning_node = search_tree.breadth_first_search do |node|
  node.state.visited_goals.size == all_goals.size
end

if winning_node
  puts winning_node.depth
else
  puts "Not possible"
end
