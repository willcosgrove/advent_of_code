elf_count = ARGV[0].to_i # 3014387

class Elf
  property number, dead

  def initialize(@number : Int32)
    @dead = false
  end

  def to_s(io)
    io << "<Elf #{@number}: #{@presents}>"
  end

  def kill!
    @dead = true
  end
end

# elves = Array.new(elf_count) { |index| Elf.new(index + 1) }


# search_proc = ->(elf : Elf) { elf.presents > 0 }
100.times do |i|
  size = i + 1
  position = 0
  elves = Array.new(size) { |index| Elf.new(index + 1) }
  until elves.size == 1
    elf = elves[position]
    across_elf_index = ((elves.size / 2) + position) % elves.size
    elves[across_elf_index].kill!
    elves.delete_at(across_elf_index)
    position = elves.bsearch_index { |an_elf| an_elf.number >= elf.number }
    next_index = (position.as(Int32) + 1) % elves.size
    position = next_index
  end
  puts "#{size}\t#{elves[0].number}\t#{size.to_s(2)}\t#{elves[0].number.to_s(2)}"
end
