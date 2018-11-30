def valid_triangle?(triangle)
  triangle[0] + triangle[1] > triangle[2] &&
  triangle[1] + triangle[2] > triangle[0] &&
  triangle[2] + triangle[0] > triangle[1]
end

puts STDIN.gets_to_end.each_line.map { |line|
  if line.match(/(\d+)\s+(\d+)\s+(\d+)/)
    if valid_triangle?([$1.to_i, $2.to_i, $3.to_i])
      1
    else
      0
    end
  else
    raise "Invalid Line: #{line}"
  end
}.sum
