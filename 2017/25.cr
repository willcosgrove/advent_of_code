require "bit_array"

steps = ARGV[0].to_i

tape = BitArray.new((steps * 2) + 1)

position = steps + 1

state = :a

steps.times do
  state =
    case state
    when :a
      if tape[position]
        tape[position] = false
        position -= 1
        :d
      else
        tape[position] = true
        position += 1
        :b
      end
    when :b
      if tape[position]
        tape[position] = false
        position += 1
        :f
      else
        tape[position] = true
        position += 1
        :c
      end
    when :c
      if tape[position]
        tape[position] = true
        position -= 1
        :a
      else
        tape[position] = true
        position -= 1
        :c
      end
    when :d
      if tape[position]
        tape[position] = true
        position += 1
        :a
      else
        tape[position] = false
        position -= 1
        :e
      end
    when :e
      if tape[position]
        tape[position] = false
        position += 1
        :b
      else
        tape[position] = true
        position -= 1
        :a
      end
    when :f
      if tape[position]
        tape[position] = false
        position += 1
        :e
      else
        tape[position] = false
        position += 1
        :c
      end
    end
end

puts "simulation complete"

puts tape.count { |x| x }
