SPIN     = -> (x : Int32, state : Array(Char)) { state.rotate(-x) }
EXCHANGE = -> (a : Int32, b : Int32, state : Array(Char)) {
  state[a], state[b] = state[b], state[a]
  state
}
PARTNER = -> (a : Char, b : Char, state : Array(Char)) {
  EXCHANGE.call(state.index(a).as(Int32), state.index(b).as(Int32), state)
}

SPIN_REGEX     = /s(\d+)/
EXCHANGE_REGEX = /x(\d+)\/(\d+)/
PARTNER_REGEX  = /p([a-z])\/([a-z])/

state = ('a'..'p').to_a

instruction_tokens =
  STDIN
    .gets
    .as(String)
    .chomp
    .split(",")

instructions = instruction_tokens.map do |instruction|
  case instruction
  when SPIN_REGEX
    x = $1.as(String).to_i
    -> (s : Array(Char)) { SPIN.call(x, s.dup) }
  when EXCHANGE_REGEX
    a, b = $1.as(String).to_i, $2.as(String).to_i
    -> (s : Array(Char)) { EXCHANGE.call(a.as(Int32), b.as(Int32), s.dup) }
  when PARTNER_REGEX
    a, b = $1.as(String).chars[0].as(Char), $2.as(String).chars[0].as(Char)
    -> (s : Array(Char)) { PARTNER.call(a.as(Char), b.as(Char), s.dup) }
  else
    raise "This never happens"
  end
end

states = Hash(Array(Char), Array(Char)).new { |hash, key|
  hash[key] =
    instructions.reduce(key) { |state, instruction| instruction.call(state) }
}

1_000_000_000.times { state = states[state] }

puts state.join
