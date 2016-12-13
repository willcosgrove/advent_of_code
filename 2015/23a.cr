class Program
  def initialize(@instructions)
    @register = {"a" => 0, "b" => 0}
    @cursor = 0
  end

  def run!
    until @cursor < 0 || @cursor >= @instructions.size
      execute(@instructions[@cursor])
    end
  end

  private def execute(instruction)
    case instruction
    when /hlf (\w)/ then hlf($1)
    when /tpl (\w)/ then tpl($1)
    when /inc (\w)/ then inc($1)
    when /jmp (\+|\-)(\d+)/ then jmp($1, $2.to_i)
    when /jie (\w), (\+|\-)(\d+)/ then jie($1, $2, $3.to_i)
    when /jio (\w), (\+|\-)(\d+)/ then jio($1, $2, $3.to_i)
    else
      raise "Cannot handle instruction `#{instruction}`"
    end
  end

  def register_a
    @register["a"]
  end

  def register_b
    @register["b"]
  end

  private def hlf(register)
    @register[register] = @register[register] / 2
    @cursor += 1
  end

  private def tpl(register)
    @register[register] = @register[register] * 3
    @cursor += 1
  end

  private def inc(register)
    @register[register] += 1
    @cursor += 1
  end

  private def jmp(direction, magnitude)
    if direction == "+"
      @cursor += magnitude
    else
      @cursor -= magnitude
    end
  end

  private def jie(register, direction, magnitude)
    if @register[register] % 2 == 0
      if direction == "+"
        @cursor += magnitude
      else
        @cursor -= magnitude
      end
    else
      @cursor += 1
    end
  end

  private def jio(register, direction, magnitude)
    if @register[register] == 1
      if direction == "+"
        @cursor += magnitude
      else
        @cursor -= magnitude
      end
    else
      @cursor += 1
    end
  end
end

instructions = STDIN.gets_to_end.split("\n").reject { |s| s.empty? }

program = Program.new(instructions)
program.run!

puts "Register A: #{program.register_a}"
puts "Register B: #{program.register_b}"
