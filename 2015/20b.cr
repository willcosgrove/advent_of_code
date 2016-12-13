$elves = Hash(Int32, Int8).new

def presents_for_house(house_number)
  $elves[house_number] = 0_i8
  presents = 0
  $elves.each do |elf_number, gift_count|
    if house_number % elf_number == 0
      presents += elf_number * 11
      $elves[elf_number] += 1_i8
    end
  end
  $elves.delete_if { |elf, count| count >= 50 }
  presents
end

desired_presents = ARGV[0].to_i

n = 1
until presents_for_house(n) >= desired_presents
  n += 1
  print "#{n}\r"
end

puts n
