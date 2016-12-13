encoded_string_literal_sum = 0
string_literal_sum = 0

STDIN.each_line do |line|
  line = line.chomp
  string_literal_sum += line.size
  encoded_string_literal_sum += line.inspect.size
  puts "#{line} | #{line.size} | #{line.inspect} | #{line.inspect.size}"
end

puts "Encoded String Literal Sum: #{encoded_string_literal_sum}"
puts "String Literal Sum: #{string_literal_sum}"
puts encoded_string_literal_sum - string_literal_sum
