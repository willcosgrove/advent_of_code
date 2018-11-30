DIVIDEND = 2147483647

GeneratorA = Enumerator.new { |yielder|
  last_value = 873
  factor     = 16807
  loop do
    last_value = (last_value * factor) % DIVIDEND
    yielder << last_value
  end
}.lazy

GeneratorB = Enumerator.new { |yielder|
  last_value = 583
  factor     = 48271
  loop do
    last_value = (last_value * factor) % DIVIDEND
    yielder << last_value
  end
}.lazy

LAST_16 = (-16..-1).freeze

def values_match?(val1, val2)
  val1.to_s(2)[LAST_16] == val2.to_s(2)[LAST_16]
end

times_matched = 0

40_000_000.times do
  times_matched += 1 if values_match?(GeneratorA.next, GeneratorB.next)
end

puts times_matched
