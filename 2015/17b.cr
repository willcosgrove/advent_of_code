containers = STDIN.each_line.map { |line|
  line.to_i
}.to_a

minimum_container_count = 0
(1..containers.size).each do |n|
  containers.each_combination(n) do |combo|
    if combo.sum == 150
      minimum_container_count = n if minimum_container_count == 0
    end
  end
end

combos = 0

containers.each_combination(minimum_container_count) do |combo|
  combos += 1 if combo.sum == 150
end

puts combos
