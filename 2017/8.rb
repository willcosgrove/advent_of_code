class Instruction
  REGEX = /(?<register>\w+) (?<op>inc|dec) (?<magnitude>[-0-9]+) if (?<cond_register>\w+) (?<cond_op><=|>=|==|!=|>|<) (?<cond_magnitude>[-0-9]+)/

  def initialize(line)
    match_data = line.match(REGEX)
    @register = match_data[:register].to_sym
    @op = match_data[:op].to_sym
    @magnitude = match_data[:magnitude].to_i
    @cond_register = match_data[:cond_register].to_sym
    @cond_op = match_data[:cond_op].to_sym
    @cond_magnitude = match_data[:cond_magnitude].to_i
  end

  def call(registers)
    if registers[@cond_register].send(@cond_op, @cond_magnitude)
      if @op == :inc
        registers[@register] += @magnitude
      else
        registers[@register] -= @magnitude
      end
    end
  end
end

instructions = STDIN.each_line.map { |line| Instruction.new(line) }

registers = Hash.new(0)

instructions.each { |ins| ins.call(registers) }

puts registers.values.max
