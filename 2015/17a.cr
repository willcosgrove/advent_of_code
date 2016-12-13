containers = STDIN.each_line.map { |line|
  line.to_i
}.to_a

combos = 0

(1..containers.size).each do |n|
  containers.each_combination(n) do |combo|
    combos += 1 if combo.sum == 150
  end
end

puts combos
