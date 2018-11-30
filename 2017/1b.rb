string_of_digits = STDIN.gets.chomp

array_of_digits = string_of_digits.split("")

array_of_numbers = array_of_digits.map do |digit|
  digit.to_i
end

length = array_of_numbers.size
half_length = length / 2

puts array_of_numbers.select.with_index { |number, index|
  number == array_of_numbers[(index + half_length) % length]
}.sum
