elf_count = ARGV[0].to_i # 3014387

class Elf
  property number, presents

  def initialize(@number : Int32, @presents : Int32)
  end

  def to_s(io)
    io << "<Elf #{@number}: #{@presents}>"
  end
end

elves = Array.new(elf_count) { |index| Elf.new(index + 1, 1) }

position = 0

# search_proc = ->(elf : Elf) { elf.presents > 0 }

loop do
  elf = elves[position]
  next_index = (position + 1) % elves.size
  if elf.presents > 0
    across_elf_index = ((elves.size / 2) + position) % elves.size
    elf.presents += elves[across_elf_index].presents
    if elf.presents == elf_count
      puts elves[position].number
      break
    end
    elves.delete_at(across_elf_index)
    position = elves.bsearch_index { |an_elf| an_elf.number >= elf.number }
    next_index = (position.as(Int32) + 1) % elves.size
  end
  puts elves.size
  puts elf
  position = next_index
end
