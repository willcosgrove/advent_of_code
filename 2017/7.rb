require 'tsort'

class Program
  INPUT_REGEX = /(\w+) \((\d+)\)(?: -> (.+))?/
  attr_reader :name, :weight, :children

  def self.from_input(line)
    match = line.match(INPUT_REGEX)
    if match
      new(match[1], match[2], match[3]&.split(", ") || [])
    else
      raise
    end
  end

  def initialize(name, weight, children)
    @name = name
    @weight = weight
    @children = children
  end
end

programs = STDIN.each_line.map { |line|
  program = Program.from_input(line)
  [program.name, program]
}.to_h

each_node = -> (&b) { programs.each_key(&b) }
each_child = -> (name, &b) { programs[name].children.each(&b) }
sort = TSort.tsort(each_node, each_child)

puts sort.last
