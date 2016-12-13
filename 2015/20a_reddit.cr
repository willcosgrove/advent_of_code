desired_presents = ARGV[0].to_i

houses = Array(Int32).new(desired_presents / 10, 0)
elves = Array(Int8).new(desired_presents / 10, 0_i8)

1.upto(desired_presents / 10) do |i|
  j = i
  until j >= desired_presents / 10
    if elves[j] < 50
      houses[j] += i * 11
      elves[j] += 1_i8
    end
    j += i
  end
end

_, house = houses.each_with_index.find({nil, nil}) do |count_and_house|
  count, house = count_and_house
  count >= desired_presents
end

puts house
