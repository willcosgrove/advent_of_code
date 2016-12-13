def look_and_say(number)
  new_number = Array(Int32).new
  number.each_char do |n|
    n = n.to_i
    if new_number.size >= 2 && n == new_number[-1]
      new_number[-2] += 1
    else
      new_number << 1
      new_number << n
    end
  end
  new_number.join
end

puts ARGV[1].to_i.times.inject(ARGV[0]) { |num|
  look_and_say(num)
}.size
