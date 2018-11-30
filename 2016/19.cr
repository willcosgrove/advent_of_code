elf_count = ARGV[0].to_i # 3014387

elves = Array.new(elf_count, 1)

position = 0

search_proc = ->(presents : Int32) { presents > 0 }

loop do
  next_index = (position + 1) % elves.size
  if elves[position] > 0
    left_elf = elves.index(next_index, &search_proc)
    left_elf = elves.index(&search_proc) if left_elf.nil?
    raise "No next elf" unless left_elf
    elves[position] += elves[left_elf]
    elves[left_elf] = 0
    if elves[position] == elf_count
      puts position + 1
      break
    end
  end
  position = next_index
end
