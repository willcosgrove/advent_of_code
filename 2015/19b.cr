$replacements = Array(Tuple(String, String)).new
molecules = Set(String).new

input = STDIN.gets_to_end
input = input.split("\n")
input.pop
molecule = input.pop
input.pop

input.each do |replacement|
  if replacement.match(/(\w+) => (\w+)/)
    $replacements << {$1, $2}
  end
end

class String
  def truncate(truncate_at)
    return "#{self}" unless size > truncate_at

    omission = "..."
    stop = truncate_at - omission.size

    "#{self[0, stop]}#{omission}"
  end
end

def indicies_of_scan(str, substr)
  start = 0
  result = [] of Int32
  until (index = str.index(substr, start)) == nil
    if index
      result << index
      break if index + 1 > str.size - 1
      start = index + 1
    end
  end
  return result
end

def tr(string, range, replacement)
  if range.covers?(0)
    beginning = ""
  else
    beginning = string[0...range.begin]
  end
  if range.covers?(string.size - 1)
    ending = ""
  else
    ending = string[(range.end+1)..-1]
  end
  beginning + replacement + ending
end

def transform_molecule(start, goal, moves)
  # sleep 0.1
  print "#{moves} #{start}".truncate(79) + "\r"
  # puts "Move: #{moves}, Size: #{start.size}, Goal: #{goal.size}"
  $replacements.each do |replacement|
    indicies_of_scan(start, replacement[0]).each do |loc|
      transformed = tr(start, Range.new(loc, loc + replacement[0].size, true), replacement[1])
      if transformed == goal
        # puts moves
        # minimum_moves.value = moves.to_i32 if moves.to_i32 < minimum_moves.value
        return true
      end
      if transformed.size > goal.size
        return false
      elsif start == transformed
        next
      else
        # puts "Using replacement #{replacement}"
        # puts "#{start} => #{transformed}"
        # return false
        transform_molecule(transformed, goal, moves + 1)#, minimum_moves)
      end
    end
  end
end

# min = Int32::MAX

transform_molecule("e", molecule, 1_u64)#, min)

# puts min
