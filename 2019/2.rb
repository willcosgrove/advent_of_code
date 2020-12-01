module IntcodeExecutor
  extend self

  def run(program)
    state = program.dup
    position = 0
    until state[position] == 99
      case state[position]
      when 1
        # adder
        lhs = state[state[position + 1]]
        rhs = state[state[position + 2]]
        state[state[position + 3]] = lhs + rhs
      when 2
        # multiplier
        lhs = state[state[position + 1]]
        rhs = state[state[position + 2]]
        state[state[position + 3]] = lhs * rhs
      end
      position += 4
    end

    return state
  end
end

program = STDIN.gets.chomp.split(",").map(&:to_i)

# Part 1
program[1] = 12
program[2] = 2
output = IntcodeExecutor.run(program)
puts "Part 1: #{output[0]}"

# Part 2
DESIRED_OUTPUT = 19690720
noun = 0
verb = 0
finished = false
100.times do |n|
  100.times do |v|
    program[1] = n
    program[2] = v
    output = IntcodeExecutor.run(program)
    if finished = (output[0] == DESIRED_OUTPUT)
      noun = n
      verb = v
      break
    end
  end
  break if finished
end
puts "Part 2: #{100 * noun + verb}"
