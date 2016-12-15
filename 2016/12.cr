class ProgramState
  property :registers, :position
  def initialize(@program : InstructionSequence)
    @registers = Hash(Symbol, Int64).new(0_i64)
    # @registers[:c] = 1_i64 # Part 2
    @position = 0
  end

  def run!
    until @position >= @program.size
      @program[@position].run(self)
    end
    @registers
  end
end

class InstructionSequence
  getter :sequence
  LINE_REGEX = /(\w+) (?:([\-\w\s]+))/
  def initialize(program_text)
    @sequence = Array(Instruction).new
    program_text.each_line do |line|
      match_data = line.match(LINE_REGEX)
      raise "Bad instruction on line: #{line}" unless match_data
      case match_data[1]
      when "cpy"
        args = match_data[2].split(' ')[0..1]
        @sequence << CopyInstruction.new(parse_arg(args[0]), parse_arg(args[1]))
      when "inc"
        @sequence << IncrementInstruction.new(parse_arg(match_data[2]))
      when "dec"
        @sequence << DecrementInstruction.new(parse_arg(match_data[2]))
      when "jnz"
        args = match_data[2].split(' ')[0..1]
        @sequence << JumpIfNotZeroInstruction.new(parse_arg(args[0]), args[1].to_i32)
      end
    end
  end

  def [](index)
    @sequence[index]
  end

  def size
    @sequence.size
  end

  private def parse_arg(arg)
    case arg.chomp
    when "a" then :a
    when "b" then :b
    when "c" then :c
    when "d" then :d
    else
      arg.to_i64
    end
  end
end

abstract struct Instruction
  abstract def run(state)
end

struct CopyInstruction < Instruction
  @to : Symbol
  def initialize(@from : (Symbol | Int64), to)
    if to.is_a? Int64
      raise "You can't copy to a value!"
    else
      @to = to
    end
  end

  def run(state)
    # puts "Copying #{@from.inspect} to #{@to.inspect}"
    from = @from
    if from.is_a? Int64
      state.registers[@to] = from
    else
      state.registers[@to] = state.registers[from]
    end
    state.position += 1
  end
end

struct IncrementInstruction < Instruction
  @register : Symbol
  def initialize(register)
    if register.is_a? Symbol
      @register = register
    else
      raise "Crazy"
    end
  end

  def run(state)
    # puts "Incrementing #{@register.inspect}"
    state.registers[@register] += 1_i64
    state.position += 1
  end
end

struct DecrementInstruction < Instruction
  @register : Symbol
  def initialize(register)
    if register.is_a? Symbol
      @register = register
    else
      raise "Crazy"
    end
  end

  def run(state)
    # puts "Decrementing #{@register.inspect}"
    state.registers[@register] -= 1_i64
    state.position += 1
  end
end

struct JumpIfNotZeroInstruction < Instruction
  def initialize(@zero_check : (Symbol | Int64), @position_delta : Int32)
  end

  def run(state)
    # puts "Checking #{@zero_check.inspect}"
    register = @zero_check
    if register.is_a? Symbol
      if state.registers[@zero_check] != 0_i64
        # puts "Jumping #{@position_delta}"
        state.position += @position_delta
      else
        # puts "Continuing"
        state.position += 1
      end
    else
      if register != 0_i64
        # puts "Jumping #{@position_delta}"
        state.position += @position_delta
      else
        # puts "Continuing"
        state.position += 1
      end
    end
  end
end

input = STDIN.gets_to_end

instructions = InstructionSequence.new(input)

# puts instructions.sequence

puts ProgramState.new(instructions).run!
