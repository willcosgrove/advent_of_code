class SecurityScanner
  include Iterator(Int32)

  def initialize(@depth : Int32, @range : Int32)
    @i = 0
  end

  def next
    if @i % ((@range * 2) - 2) == 0
      (@depth * @range) + 1
    else
      0
    end
  ensure
    @i += 1
  end

  def rewind
    @i = 0
  end

  def skip(n : Int32)
    @i += n
  end
end

module NilScanner
  extend Iterator(Int32)
  extend self

  def next
    0
  end

  def skip(n : Int32)
    self
  end

  def rewind
    self
  end
end

depth_and_ranges = STDIN
                    .each_line
                    .map { |line| line.split(": ").map(&.to_i) }
                    .to_a
max_depth = depth_and_ranges.max_by { |(depth, _range)| depth }.first

firewall = Array(Iterator(Int32)).new(max_depth + 1, NilScanner)

depth_and_ranges.each_with_object(firewall) { |(depth, range), firewall|
  firewall[depth] = SecurityScanner.new(depth, range)
}

delay = 0

loop do
  firewall.each(&.skip(delay))
  uncaught = firewall.none? do |scanner|
    scanner.next.tap { firewall.each(&.next) } > 0
  end
  break if uncaught
  delay += 1
  firewall.each(&.rewind)
end

puts delay
