require "set"

abstract class Radioisotopic
  include Comparable(Radioisotopic)
  getter :element

  def initialize(@element : Symbol)
  end

  def <=>(other)
    comparable <=> other.comparable
  end

  def ==(other)
    comparable == other.comparable
  end

  def hash
    comparable.hash
  end

  abstract def type

  def comparable
    [type, element]
  end

  def generator?
    false
  end

  def microchip?
    false
  end
end

class Generator < Radioisotopic
  def generator?
    true
  end

  def type
    :generator
  end
end

class Microchip < Radioisotopic
  def microchip?
    true
  end

  def type
    :microchip
  end
end

class State
  @hash : Int32
  getter :elevator, :floors
  def initialize(elevator : Int8, floors : Array(FloorState))
    @elevator = elevator
    @floors = floors
    @hash = {@elevator, @floors}.hash
  end

  def hash
    @hash
  end

  def eql?(other)
    hash == other.hash
  end

  def ==(other)
    @elevator == other.elevator &&
      @floors == other.floors
  end

  def valid?
    @floors.all?(&.valid?)
  end

  def next_moves
    moving_one_item = @floors[@elevator].items.permutations(1).map { |items_in_elevator|
      [move_items_up(items_in_elevator), move_items_down(items_in_elevator)]
    }.flatten
    moving_two_items = @floors[@elevator].items.permutations(2).map { |items_in_elevator|
      [move_items_up(items_in_elevator), move_items_down(items_in_elevator)]
    }.flatten
    (moving_one_item + moving_two_items).flatten.compact.select(&.valid?).to_set.to_a
  end

  def end?
    @floors[0..-2].all?(&.empty?) && !@floors.last.empty?
    END_STATE.hash == hash
  end

  def move_items_up(items)
    return nil if @elevator + 1 == @floors.size
    new_floors = @floors.dup
    new_floors[@elevator] = new_floors[@elevator] - items
    new_floors[@elevator + 1] = new_floors[@elevator + 1] + items
    State.new(@elevator + 1, new_floors)
  end

  def move_items_down(items)
    return nil if @elevator - 1 < 0
    new_floors = @floors.dup
    new_floors[@elevator] = new_floors[@elevator] - items
    new_floors[@elevator - 1] = new_floors[@elevator - 1] + items
    State.new(@elevator - 1, new_floors)
  end
end

class FloorState
  @items : Array(Radioisotopic)
  getter :items

  def initialize(items : Array(Radioisotopic))
    @items = items.sort
  end

  def hash
    @items.hash
  end

  def valid?
    @items.none?(&.generator?) ||
      @items.none?(&.microchip?) ||
      all_microchips_powered?
  end

  def ==(other)
    @items == other.items
  end

  def -(other)
    FloorState.new(@items - other)
  end

  def +(other)
    FloorState.new(@items + other)
  end

  def empty?
    @items.empty?
  end

  private def all_microchips_powered?
    generator_elements = generators.map(&.element)
    microchips.all? { |microchip|
      generator_elements.includes?(microchip.element)
    }
  end

  private def microchips
    @items.select(&.microchip?)
  end

  private def generators
    @items.select(&.generator?)
  end
end

class BreadthFirstSolver
  def initialize(state)
    @search_tree = SolveTree.new(state)
    @searched_states = Set(State).new
  end

  def solve!
    @search_tree.breadth_first_search do |node|
      if @searched_states.includes? node.state
        node.dead!
        false
      else
        @searched_states.add(node.state)
        node.state.end?
      end
    end
  end
end

class SolveNode
  getter :state
  def initialize(state : State)
    @state = state
    @dead = false
  end

  def dead?
    @dead
  end

  def dead!
    @dead = true
  end

  def children
    @state.next_moves.map { |state| SolveNode.new(state) }
  end
end

class SolveTree
  def initialize(root)
    @root = SolveNode.new(root)
  end

  def breadth_first_search(&block : SolveNode -> Bool)
    perform_breadth_first_search(0, [@root], &block)
  end

  private def perform_breadth_first_search(depth_index, current_depth, &block : SolveNode -> Bool)
    puts ""
    puts "Starting search of depth: #{depth_index}"
    puts "  Nodes: #{current_depth.size}"
    puts ""
    next_depth = [] of SolveNode
    current_depth.each do |node|
      if yield node
        return depth_index, node
      end
      next_depth.concat(node.children) unless node.dead?
      # if node.dead?
      #   print "x"
      # else
      #   next_depth.concat(node.children)
      #   print "."
      # end
    end
    current_depth = nil
    perform_breadth_first_search(depth_index + 1, next_depth, &block)
  end
end

def generator(element)
  Generator.new(element)
end

def microchip(element)
  Microchip.new(element)
end

initial_state = State.new(0_i8, [
  FloorState.new([generator(:polonium), generator(:thulium), microchip(:thulium), generator(:promethium), generator(:ruthenium), microchip(:ruthenium), generator(:cobalt), microchip(:cobalt), generator(:elerium), microchip(:elerium), generator(:dilithium), microchip(:dilithium)]),
  FloorState.new([microchip(:polonium), microchip(:promethium)] of Radioisotopic),
  FloorState.new([] of (Radioisotopic)),
  FloorState.new([] of (Radioisotopic)),
])

END_STATE = State.new(3_i8, [
  FloorState.new([] of (Radioisotopic)),
  FloorState.new([] of (Radioisotopic)),
  FloorState.new([] of (Radioisotopic)),
  FloorState.new([generator(:polonium), microchip(:polonium), microchip(:promethium), generator(:thulium), microchip(:thulium), generator(:promethium), generator(:ruthenium), microchip(:ruthenium), generator(:cobalt), microchip(:cobalt), generator(:elerium), microchip(:elerium), generator(:dilithium), microchip(:dilithium)]),
])

puts BreadthFirstSolver.new(initial_state).solve!.inspect
