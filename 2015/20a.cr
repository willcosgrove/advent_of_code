def presents_for_house(house_number)
  presents = 10
  presents += (house_number * 10) unless house_number == 1
  2.upto(house_number / 2).each do |n|
    presents += (n * 10) if house_number % n == 0
  end
  presents
end

desired_presents = ARGV[0].to_i

n = 1
until presents_for_house(n) >= desired_presents
  n += 1
  print "#{n}\r"
end

puts n
