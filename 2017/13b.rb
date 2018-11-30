class SecurityScanner
  def initialize(depth, range)
    @enumerator = Enumerator.new do |yielder|
      i = 0
      loop do
        if i % ((range * 2) - 2) == 0
          yielder << (depth * range) + 1
        else
          yielder << 0
        end
        i += 1
      end
    end
  end

  def next
    @enumerator.next
  end

  def peek
    @enumerator.peek
  end

  def rewind
    @enumerator.rewind
  end
end

NilScanner = Enumerator.new { |y| loop { y << 0 } }

firewall = STDIN
            .each_line
            .map { |line| line.split(": ").map(&:to_i) }
            .each_with_object([]) { |(depth, range), firewall|
              firewall[depth] = SecurityScanner.new(depth, range)
            }.map { |scanner| scanner || NilScanner }

delay = 0

loop do
  delay.times { firewall.each(&:next) }
  severity = firewall.sum do |scanner|
    scanner.peek.tap { firewall.each(&:next) }
  end
  break if severity == 0
  delay += 1
  firewall.each(&:rewind)
end

puts delay
