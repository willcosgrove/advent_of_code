registers = { "a" => 1, "b" => 0, "c" => 0, "d" => 0, "e" => 0, "f" => 0, "g" => 0, "h" => 0 }

compile_value = -> (val : String) { val.match(/\d+/) ? val.to_i32 : val }

instructions = STDIN.each_line.map do |instruction|
  command, x, y = instruction.split(" ")
  [command, compile_value.call(x), compile_value.call(y)]
end.to_a
position = 0

alias CommandArgument = (String | Int32)

parse_value = -> (val : CommandArgument) {
  case val
  when Int32 then val
  when String then registers[val]
  else
    raise "Don't know what this is"
  end
}


commands = {
  "set" => -> (x : CommandArgument, y : CommandArgument) { registers[x.as(String)] = parse_value.call(y) },
  "sub" => -> (x : CommandArgument, y : CommandArgument) { registers[x.as(String)] -= parse_value.call(y) },
  "mul" => -> (x : CommandArgument, y : CommandArgument) { registers[x.as(String)] *= parse_value.call(y) },
  "jnz" => -> (x : CommandArgument, y : CommandArgument) { position += (parse_value.call(y) - 1) if parse_value.call(x) != 0 },
}

until position >= instructions.size
  current_instruction = instructions[position]
  commands[current_instruction[0]].call(current_instruction[1], current_instruction[2])
  position += 1
end

puts registers["h"]
