class Program
  INPUT_REGEX = /(\w+) \((\d+)\)(?: -> (.+))?/
  attr_reader :name, :weight

  @@programs = {}

  def self.from_input(line)
    match = line.match(INPUT_REGEX)
    if match
      new(match[1], match[2], match[3]&.split(", ") || [])
    else
      raise
    end
  end

  def initialize(name, weight, children_names)
    @name = name
    @weight = weight.to_i
    @children_names = children_names
    @@programs[name] = self
  end

  def total_weight
    @total_weight ||= children.sum(&:total_weight) + weight
  end

  def children
    @children_names.map(&@@programs)
  end

  def parent
    @@programs.values.find { |p| p.children.include?(self) }
  end

  def siblings
    parent.children - [self]
  end
end

programs = STDIN.each_line.map { |line| Program.from_input(line) }

programs.each do |program|
  if !program.siblings.map(&:total_weight).include?(program.total_weight)
    difference = program.siblings.first.total_weight - program.total_weight
    puts program.weight + difference
    break
  end
end
