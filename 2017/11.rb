x, y, z = 0, 0, 0
max_distance = 0

def distance(x,y,z)
  (x.abs + y.abs + z.abs) / 2
end

STDIN.gets.chomp.split(",").each do |heading|
  case heading
  when "n"
    y += 1
    z -= 1
  when "ne"
    x += 1
    z -= 1
  when "se"
    x += 1
    y -= 1
  when "s"
    y -= 1
    z += 1
  when "sw"
    x -= 1
    z += 1
  when "nw"
    x -= 1
    y += 1
  end
  d = distance(x,y,z)
  max_distance = max_distance < d ? d : max_distance
end

puts max_distance
