def nice?(str)
  any_pairs?(str) && repeating_letter?(str)
end

# ieodomkazucvgmuy
def any_pairs?(str)
  (str.size - 1).times do |i|
    pair = str[i, 2]
    if str.split(pair, 2).any? { |substr| substr.index(pair) }
      return true
    end
  end
  return false
end

def repeating_letter?(str)
  !!str.match(/(.{1}).{1}\1/)
end

puts STDIN.each_line.inject(0) do |acc, line|
  acc + (nice?(line) ? 1 : 0)
end
