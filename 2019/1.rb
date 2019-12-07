masses = STDIN.each_line.map(&:to_i)

# Part 1
fuel_requirements = masses.map { |mass| (mass / 3) - 2 }
total_fuel = fuel_requirements.sum
puts "Part 1: #{total_fuel}"

# Part 2
fuel_requirements = []
masses.each do |mass|
  fuel_requirement = (mass / 3) - 2
  if fuel_requirement > 0
    fuel_requirements << fuel_requirement
    masses << fuel_requirement
  end
end
total_fuel = fuel_requirements.sum
puts "Part 2: #{total_fuel}"
