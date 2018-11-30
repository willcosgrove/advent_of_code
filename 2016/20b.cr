blacklist = Array(Range(UInt32, UInt32)).new
STDIN.gets_to_end.each_line do |line|
  if line.match(/(\d+)-(\d+)/)
    blacklist << Range.new($1.to_u32, $2.to_u32)
  else
    raise "Bad range"
  end
end

blacklist.sort_by { |range| range.begin }

def overlapping?(range_1, range_2)
  range_1.includes?(range_2.begin) || range_1.includes?(range_2.end) || range_2.includes?(range_1.begin) || range_2.includes?(range_1.end)
end

def compact(range_1, range_2)
  raise "Ranges do not overlap" unless overlapping?(range_1, range_2)
  Range.new(Math.min(range_1.begin, range_2.begin), Math.max(range_1.end, range_2.end))
end

compacted_list = blacklist.clone
blacklist = Array(Range(UInt32, UInt32)).new

until compacted_list.size == blacklist.size
  blacklist = compacted_list.clone
  skiplist = Set(Range(UInt32, UInt32)).new
  compacted_list = blacklist.reduce(Array(Range(UInt32, UInt32)).new) { |compact_list, range|
    unless skiplist.includes?(range)
      skiplist << range
      remaining_blacklist = blacklist.reject { |range| skiplist.includes? range }
      if remaining_blacklist.none? { |other_range| overlapping?(range, other_range) }
        compact_list << range
      else
        remaining_blacklist.each do |other_range|
          if overlapping?(range, other_range)
            compact_list << compact(range, other_range)
            skiplist << other_range
          end
        end
      end
    end
    compact_list
  }
end

# puts compacted_list.size

puts compacted_list.reduce(UInt32::MAX) { |sum, range|
  sum - range.size
} + 1

puts Range.new(0,UInt32::MAX).size
