puts STDIN.gets_to_end.each_line.map { |line|
  line.chars
}.to_a.transpose.map { |col|
  col.reduce(Hash(Char, Int32).new(0)) { |hash, char|
    hash[char] += 1
    hash
  }.min_by { |(char, count)| count }[0]
}.join
