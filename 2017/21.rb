require "matrix"

class ExpansionPattern
  def initialize(pattern)
    @pattern = pattern
  end

  def ===(other)
    @pattern == other || permutations.any? { |mutated_pattern| mutated_pattern == other }
  end

  def permutations
    @permutations ||= [
      mirror_x,
      mirror_y,
      rotate_cw,
      rotate_cw(times: 2),
      rotate_cw(times: 3),
      mirror_x(rotate_cw),
      mirror_y(rotate_cw),
    ]
  end

  def to_s
    # @pattern.map(&:join).join("\n")
    [@pattern, *permutations].map(&:inspect).join("\n")
  end

  private

  def mirror_x(pattern = @pattern)
    pattern.dup.tap do |mirror|
      (0...(mirror.size / 2)).each do |row|
        mirror[row], mirror[-1 - row] = mirror[-1 - row], mirror[row]
      end
    end
  end

  def mirror_y(pattern = @pattern)
    mirror_x(pattern.transpose).transpose
  end

  def rotate_cw(pattern = @pattern, times: 1)
    times.times.reduce(pattern) { |p| p.transpose.map(&:reverse) }
  end
end

class ExpansionRule
  LINE_REGEX = /([.\/#]+) => ([.\/#]+)/

  attr_reader :pattern, :mapping

  def self.from_line(line)
    raise "Malformed line" unless match = line.match(LINE_REGEX)
    pattern = match[1].split("/").map { |row| row.split("") }
    mapping = match[2].split("/").map { |row| row.split("") }
    new(pattern, mapping)
  end

  def initialize(pattern, mapping)
    @pattern = ExpansionPattern.new(pattern)
    @mapping = mapping
  end

  def ===(input)
    @pattern === input
  end
end

art_board = <<~ART.split("\n").map { |row| row.chomp.split("") }
  .#.
  ..#
  ###
ART

# ep = ExpansionPattern.new(art_board)
# puts ep
# ep.permutations.each do |permutation|
#   puts ""
#   puts ExpansionPattern.new(permutation)
# end

rules = STDIN.each_line.map { |line| ExpansionRule.from_line(line) }
ifnone = -> (pattern) { -> { puts "Nothing matches #{pattern.inspect}" } }

rules.each { |rule| puts rule.pattern; puts "" }

5.times do
  slice_size = art_board.size.odd? ? 3 : 2
  puts art_board
    .each_slice(slice_size)
    .map { |rows|
      rows
        .map { |row| row.each_slice(slice_size).to_a }
        .transpose
        .map { |sub_art_board| rules.find(ifnone.(sub_art_board)) { |rule| rule === sub_art_board }.mapping }
        .transpose
        .map(&:flatten)
    }.inspect
end
