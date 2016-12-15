class Elf
  getter :x, :y, :direction

  def initialize
    @x = 0
    @y = 0
    @direction = :north
    @places_weve_been = Set(Tuple(Int32, Int32)).new
  end

  def right(distance)
    turn_right
    distance.times do
      move_forward
    end
  end

  def left(distance)
    turn_left
    distance.times do
      move_forward
    end
  end

  def move_forward
    @places_weve_been.add({@x, @y})
    case @direction
    when :north
      @y += 1
    when :east
      @x +=1
    when :south
      @y -= 1
    when :west
      @x -= 1
    end
    if been_here_before?
      puts "We've been here before!"
      puts "Elf X: #{@x}"
      puts "Elf Y: #{@y}"
    end
  end

  def turn_left
    case @direction
    when :north
      @direction = :west
    when :east
      @direction = :north
    when :south
      @direction = :east
    when :west
      @direction = :south
    end
  end

  def turn_right
    case @direction
    when :north
      @direction = :east
    when :east
      @direction = :south
    when :south
      @direction = :west
    when :west
      @direction = :north
    end
  end

  def been_here_before?
    @places_weve_been.includes?({@x, @y})
  end
end

elf = Elf.new

input = STDIN.gets_to_end.chomp

instructions = input.split(", ") # => ["R2", "L2", "L5", "R1"]

instructions.each do |instruction|
  match_data = instruction.match(/(?<direction>\D)(?<distance>\d+)/)
  if match_data
    case match_data["direction"]
    when "L"
      # go left
      elf.left(match_data["distance"].to_i)
    when "R"
      # go right
      elf.right(match_data["distance"].to_i)
    end
  else
    raise "Instruction not formatted properly"
  end
end
