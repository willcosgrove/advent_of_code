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

memory_pointer = 347991

spiral = CartesianSpiraler.new

(memory_pointer - 1).times { spiral.next }

x,y = spiral.next

puts x.abs + y.abs
