blacklist = Array(Range(UInt32, UInt32)).new
STDIN.gets_to_end.each_line do |line|
  if line.match(/(\d+)-(\d+)/)
    blacklist << Range.new($1.to_u32, $2.to_u32)
  else
    raise "Bad range"
  end
end

blacklist.sort_by { |range| range.begin }

guess = 0

while rule = blacklist.find { |range| range.includes?(guess) }
  guess = rule.end + 1
end

puts guess
