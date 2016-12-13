string_literal_sum = 0
in_memory_sum = 0

STDIN.each_line do |line|
  line = line.chomp
  string_literal_sum += line.size
  in_memory_line = line[1..-2].gsub(/\\x[\da-fA-F]{2}/, "e").gsub(/\\[\\\"]/, "e")
  in_memory_sum += in_memory_line.size
  puts "#{line} | #{line.size} | #{in_memory_line.size}"
end

puts "String Literal Sum: #{string_literal_sum}"
puts "In Memory Sum: #{in_memory_sum}"
puts string_literal_sum - in_memory_sum
