b = 0
c = 0
d = 0
e = 0
f = 0
g = 0
h = 0

b = (84 * 100) + 100_000
c = b + 17_000
loop do
  f = false
  d = 2_i64
  half_b = b / 2
  until d >= half_b
    e = 2_i64
    until (d * e) > b
      if (d * e) == b
        f = true
        break
      end
      e += 1
    end
    break if f
    d += 1
  end
  if f
    h += 1
  else
    puts b
  end
  break if b == c
  b += 17
end

puts
puts h
