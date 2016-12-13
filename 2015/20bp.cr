module House
  @@elves = Array(Int8).new
  @@elf_locks = Array(Mutex).new

  def self.presents_for(house_number)
    presents = 0
    presents += elf_give_presents(1)
    2.upto(house_number / 2).each do |n|
      presents += elf_give_presents(n) if house_number % n == 0
    end
    presents += elf_give_presents(house_number) unless house_number == 1
    presents
  end

  def self.elf_give_presents(number)
    index = number - 1
    @@elf_locks[index] ||= Mutex.new
    @@elf_locks[index].synchronize do
      @@elves[index] ||= 0_i8
      if @@elves[index] >= 50_i8
        return 0
      else
        @@elves[index] += 1_i8
        return number * 11
      end
    end
  end
end

def worker(jobs, desired_presents, result_channel)
  loop do
    house_number = jobs.receive
    if House.presents_for(house_number) >= desired_presents
      result_channel.send(house_number)
      break
    end
  end
end

desired_presents = ARGV[0].to_i

job_channel = Channel(Int32).new(4)
result_channel = Channel(Int32).new

spawn do
  loop do |i|
    job_channel.send(i + 1)
  end
end

spawn worker(job_channel, desired_presents, result_channel)
spawn worker(job_channel, desired_presents, result_channel)
spawn worker(job_channel, desired_presents, result_channel)
spawn worker(job_channel, desired_presents, result_channel)

n = result_channel.receive

puts n
