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
