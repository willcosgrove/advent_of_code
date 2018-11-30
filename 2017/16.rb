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

instructions.each do |instruction|
  case instruction
  when SPIN_REGEX     then SPIN.($1.to_i, state)
  when EXCHANGE_REGEX then EXCHANGE.($1.to_i, $2.to_i, state)
  when PARTNER_REGEX  then PARTNER.($1, $2, state)
  end
end

puts state.join
