class Disk
  @positions : Int32
  @initial_position : Int32

  def initialize(@positions, @initial_position)
  end

  def position_at(t)
    (t + @initial_position) % @positions
  end
end

d1 = Disk.new(17, 1)
d2 = Disk.new(7, 0)
d3 = Disk.new(19, 2)
d4 = Disk.new(5, 0)
d5 = Disk.new(3, 0)
d6 = Disk.new(13, 5)
d7 = Disk.new(11, 0)

shift = [1, 2, 3, 4, 5, 6, 7]
disks = [d1, d2, d3, d4, d5, d6, d7]
goal = [0, 0, 0, 0, 0, 0, 0]

time = 0

until disks.map_with_index { |disk, i| disk.position_at(time + shift[i]) } == goal
  time += 1
end

puts time
