def expand(string, size)
  a_string = string
  b_string = string.reverse.tr("01", "10")
  expanded_string = "#{a_string}0#{b_string}"
  if expanded_string.size > size
    return expanded_string[0...size]
  elsif expanded_string.size < size
    return expand(expanded_string, size)
  else
    return expanded_string
  end
end

def checksum(string)
  sum = ""
  position = 0
  while position < string.size
    case string[position...position + 2]
    when "11", "00" then sum += "1"
    when "01", "10" then sum += "0"
    end
    position += 2
  end
  if sum.size.even?
    return checksum(sum)
  else
    return sum
  end
end

input = ARGV[0].chomp

expanded_input = expand(input, 35651584)
check = checksum(expanded_input)
puts check
