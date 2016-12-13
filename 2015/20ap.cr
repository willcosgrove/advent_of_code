def presents_for_house(house_number)
  presents = 10
  presents += (house_number * 10) unless house_number == 1
  2.upto(house_number / 2).each do |n|
    presents += (n * 10) if house_number % n == 0
  end
  presents
end

def worker(jobs, desired_presents, result_channel)
  loop do
    house_number = jobs.receive
    if presents_for_house(house_number) >= desired_presents
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
