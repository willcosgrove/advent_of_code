# First I made this class which acts kind of like an Enumerator.  It is
# responsible for generating a spiral and returning cartesian coordinates for
# the current position of the spiral.

class CartesianSpiraler
  SPIRAL = [:right, :up, :left, :down].cycle
  MOVEMENT = {
    right: -> (x,y) { [x + 1, y    ] },
    up:    -> (x,y) { [x    , y + 1] },
    left:  -> (x,y) { [x - 1, y    ] },
    down:  -> (x,y) { [x    , y - 1] },
  }

  def initialize
    @position = [0,0]
    @spiral_state = SPIRAL.dup
    @current_direction = @spiral_state.next
    @max_x = 0
    @max_y = 0
    @min_x = 0
    @min_y = 0
  end

  def next
    return_value = @position.dup
    move_position
    update_extremes
    return_value
  end

  private

  def move_position
    @position = MOVEMENT[@current_direction].call(*@position)
  end

  def update_extremes
    x,y = @position

    if x > @max_x
      @max_x = x
    elsif x < @min_x
      @min_x = x
    elsif y > @max_y
      @max_y = y
    elsif y < @min_y
      @min_y = y
    else
      return
    end

    @current_direction = @spiral_state.next
  end
end

# For part two, I also wrote this little helper method for returning a list of
# neighboring positions given a position

def neighbors(position)
  x,y = position
  [
    [x - 1, y + 1], [x    , y + 1], [x + 1, y + 1],
    [x - 1, y    ],                 [x + 1, y    ],
    [x - 1, y - 1], [x    , y - 1], [x + 1, y - 1],
  ]
end

# I pull in the input for the puzzle
limit = ARGV[0].to_i

# I use a hash to store the filled in squares.  The keys are coordinates, and
# the values are the sums.  I set the default value to be 0
memory = Hash.new(0)

# Instantiate the spiral
spiral = CartesianSpiraler.new
spiral.next # advance it off of the starting position
memory[[0,0]] = 1 # set the initial position's sum to 1

last_sum = 0

until last_sum > limit
  pos = spiral.next
  # I assign the last sum and the memory at the current position to the sum of
  # the values of all the neighbors
  last_sum = memory[pos] = neighbors(pos).map(&memory).sum
end

puts last_sum
