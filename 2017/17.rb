spinlock = []
rotation_count = ARGV[0].to_i

2018.times do |i|
  spinlock.rotate!(rotation_count + 1)
  spinlock.unshift(i)
end

i = spinlock.index(2017)

puts spinlock[(i + 1) % spinlock.size]
