adapters = STDIN.each_line.to_a.map(&.to_i)

joltage_differences = {
  1 => 0,
  2 => 0,
  3 => 0,
}

adapters.sort!

adapters.each_with_index do |joltage, index|
  if index == 0
    joltage_differences[joltage] += 1
    next
  end

  prior_joltage = adapters[index - 1]
  difference = joltage - prior_joltage
  joltage_differences[difference] += 1
end

joltage_differences[3] += 1

puts "Part 1: #{joltage_differences[1] * joltage_differences[3]}"

# ---

wall = 0
device_joltage = adapters.last + 3

possible_arrangements = 0_u64

def find_next_adapter(chain, all_adapters, ending, &block)
  tail = chain.last

  if tail == ending
    yield
    return
  end

  tail_index = all_adapters.bsearch_index do |el, _i|
    el >= tail
  end

  possible_next_adapters = all_adapters[tail_index.as(Int32) + 1, 3].select { |adapter|
    adapter - tail > 0 && adapter - tail <= 3
  }

  if ending - tail <= 3
    possible_next_adapters << ending
  end

  possible_next_adapters.each do |possible_next_adapter|
    next_chain = chain.dup
    next_chain << possible_next_adapter
    find_next_adapter(next_chain, all_adapters, ending, &block)
  end
end

find_next_adapter([0], adapters, device_joltage) do
  possible_arrangements += 1
end

puts "Part 2: #{possible_arrangements}"
