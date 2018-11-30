def valid_triangle?(triangle)
  triangle[0] + triangle[1] > triangle[2] &&
  triangle[1] + triangle[2] > triangle[0] &&
  triangle[2] + triangle[0] > triangle[1]
end

puts STDIN.gets_to_end.each_line.map { |line|
  if line.match(/(\d+)\s+(\d+)\s+(\d+)/)
    [$1.to_i, $2.to_i, $3.to_i]
  else
    raise "Invalid Line: #{line}"
  end
}.to_a.transpose.flatten.in_groups_of(3, 0).map { |triangle|
  valid_triangle?(triangle) ? 1 : 0
}.sum
