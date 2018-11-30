spinlock = []
rotation_count = ARGV[0].to_i + 1

50_000_000.times do |i|
  spinlock.rotate!(rotation_count)
  spinlock.unshift(i)
end

i = spinlock.index(0)

puts spinlock[(i + 1) % spinlock.size]
