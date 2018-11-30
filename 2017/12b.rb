require 'set'

class Group
  def initialize
    @members = Set.new
  end

  def <<(member)
    @members << member
  end

  def count
    @members.count
  end
end

class Program
  attr_reader :name, :direct_neighbors

  @@programs = Hash.new

  def self.find(name)
    @@programs[name]
  end

  def initialize(name, direct_neighbors = [])
    @name = name
    @direct_neighbors = direct_neighbors
    @@programs[name] = self
  end

  def group
    @group ||= Group.new
  end

  def group=(group)
    @group = group
    @group << self
  end
end

programs = STDIN.each_line.map do |line|
  program_name, direct_neighbors = line.split(" <-> ")
  Program.new(program_name, direct_neighbors.split(", ").map(&:chomp))
end

def build_group(program, group = program.group, visited_programs = Set[program])
  program.group = group
  visited_programs << program
  program.direct_neighbors.each do |neighbor_name|
    neighbor = Program.find(neighbor_name)
    raise "Could not find #{neighbor_name.inspect}" unless neighbor
    build_group(neighbor, group, visited_programs) unless visited_programs.include? neighbor
  end
  group
end

groups = Set.new

programs.each do |program|
  groups << build_group(program) unless groups.include? program.group
end

puts groups.count
