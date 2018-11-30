spinlock = Deque(Int32).new(50_000_001)
rotation_count = ARGV[0].to_i + 1

spinlock.unshift(0)

50_000_000.times do |i|
  spinlock.rotate!(rotation_count)
  spinlock.unshift(i + 1)
end

# i = spinlock.index(0)

# raise "BLARGH" unless i

puts spinlock[(i + 1) % spinlock.size]
