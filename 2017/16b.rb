SPIN     = -> (x, state) { state.rotate!(-x) }
EXCHANGE = -> (a, b, state) { state[a], state[b] = state[b], state[a] }
PARTNER  = -> (a, b, state) { EXCHANGE.(state.index(a), state.index(b), state) }

SPIN_REGEX     = /s(\d+)/
EXCHANGE_REGEX = /x(\d+)\/(\d+)/
PARTNER_REGEX  = /p([a-z])\/([a-z])/

state = ("a".."p").to_a

instructions =
  STDIN
    .gets
    .chomp
    .split(",")

instructions.map! do |instruction|
  case instruction
  when SPIN_REGEX
    x = $1.to_i
    -> { SPIN.(x, state) }
  when EXCHANGE_REGEX
    a, b = $1.to_i, $2.to_i
    -> { EXCHANGE.(a, b, state) }
  when PARTNER_REGEX
    a, b = $1, $2
    -> { PARTNER.(a, b, state) }
  end
end

states = Hash.new { |hash, key|
  instructions.each(&:call)
  hash[key] = state
}

1_000_000_000.times { state = states[state] }

puts state.join
