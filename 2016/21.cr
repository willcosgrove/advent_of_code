instructions = STDIN.gets_to_end.each_line.map { |instruction_text|
  case instruction_text
  when /rotate (right|left) (\d+) steps?/
    rotate(direction: $1, steps: $2.to_i)
  when /swap letter (\S) with letter (\S)/
    swap_letter(from: $1, to: $2)
  when /swap position (\d+) with position (\d+)/
    swap_position(from: $1.to_i, to: $2.to_i)
  when /move position (\d+) to position (\d+)/
    move(from: $1.to_i, to: $2.to_i)
  when /rotate based on position of letter (\S)/
    rotate_around_letter($1)
  when /reverse positions (\d+) through (\d+)/
    reverse_through(from: $1.to_i, to: $2.to_i)
  else
    raise "Unknown instruction: #{instruction_text}"
  end
}

def rotate(direction, steps)
  if direction == "left"
    ->(str : String) {
       steps.times do
         str = str[1..-1] + str[0]
       end
       str
    }
  else
    ->(str : String) {
       steps.times do
         str = str[-1] + str[0..-2]
       end
       str
    }
  end
end

def swap_letter(from, to)
  ->(str : String) { str.tr("#{from}#{to}", "#{to}#{from}")}
end

def swap_position(from, to)
  ->(str : String) { str.sub(from, str[to]).sub(to, str[from]) }
end

def move(from, to)
  ->(str : String) { str.sub(from, "").insert(to, str[from]) }
end

def reverse_through(from, to)
  ->(str : String) { str.sub(from..to, str[from..to].reverse) }
end

def rotate_around_letter(letter)
  ->(str : String) {
    index = str.index(letter)
    if index
      steps = 1 + index
      steps += 1 if index >= 4
      rotate(direction: "right", steps: steps).call(str)
    else
      puts str
      puts letter
      puts index
      raise "WTF"
    end
  }
end

input = ARGV[0].chomp

puts instructions.reduce(input) { |input, instruction|
  instruction.call(input)
}
