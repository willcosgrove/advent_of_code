registers = { a: 1, b: 0, c: 0, d: 0, e: 0, f: 0, g: 0, h: 0 }

compile_value = -> (val) { val.match?(/\d+/) ? val.to_i : val.to_sym }

instructions = STDIN.each_line.map do |instruction|
  command, x, y = instruction.split(" ")
  [command.to_sym, compile_value[x], compile_value[y]]
end
position = 0

parse_value = -> (val) {
  case val
  when Integer then val
  when Symbol then registers[val]
  end
}

commands = {
  set: -> (x, y) { registers[x] = parse_value[y] },
  sub: -> (x, y) { registers[x] -= parse_value[y] },
  mul: -> (x, y) { registers[x] *= parse_value[y] },
  jnz: -> (x, y) { position += (parse_value[y] - 1) if parse_value[x] != 0 },
}

until position >= instructions.length
  current_instruction = instructions[position]
  commands[current_instruction[0]][*current_instruction[1..2]]
  position += 1
end

puts registers[:h]
