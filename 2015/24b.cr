packages = [] of Int32

STDIN.each_line do |line|
  packages << line.to_i
end

sum = packages.sum

usable_first_groups = [] of Array(Int64)

1.upto(packages.size) do |group_size|
  packages.each_combination(group_size) do |group|
    if group.sum * 4 == sum
      usable_first_groups << group.map(&.to_i64)
    end
  end
  break unless usable_first_groups.empty?
end

usable_first_groups.sort_by!(&.size)
smallest_size = usable_first_groups.first.size
puts usable_first_groups.select { |group| group.size == smallest_size }.map { |group|
  group.inject { |acc, i| acc * i }
}.sort.first
