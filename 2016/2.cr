KEYPAD = StaticArray[
  StaticArray[1, 2, 3],
  StaticArray[4, 5, 6],
  StaticArray[7, 8, 9],
]

def keypad_num_to_coordinates(number) : Tuple(Int32, Int32)
  y = KEYPAD.index do |row|
    row.includes?(number)
  end
  raise "Number not in keypad" unless y
  x = KEYPAD[y].index do |key|
    key == number
  end
  raise "Number not in keypad" unless x
  {x, y}
end

def up(coordinates)
  x, y = coordinates
  {x, Math.max(0, y - 1)}
end

def down(coordinates)
  x, y = coordinates
  {x, Math.min(2, y + 1)}
end

def left(coordinates)
  x, y = coordinates
  {Math.max(0, x - 1), y}
end

def right(coordinates)
  x, y = coordinates
  {Math.min(2, x + 1), y}
end

position = {1, 1}

puts STDIN.gets_to_end.each_line.map { |line|
  line.chomp.each_char do |char|
    position = case char
               when 'U' then up(position)
               when 'D' then down(position)
               when 'L' then left(position)
               when 'R' then right(position)
               else
                 raise "Invalid character #{char}"
               end
    puts "#{char}: #{position}"
  end
  KEYPAD[position[1]][position[0]]
}.join("")
