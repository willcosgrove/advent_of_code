class City
  @@cities = Hash(String, City).new

  getter :destinations
  getter :name

  def initialize(@name)
    @destinations = Hash(City, Int32).new
    @@cities[@name] = self
  end

  def add_destination(name, time)
    @destinations[City.find(name)] = time
  end

  def self.find(name)
    @@cities.fetch(name) do |name|
      City.new(name)
    end
  end

  def self.all
    @@cities.values.sort_by &.name
  end
end

class Trip
  def initialize(@cities)
  end

  def total_time
    cities = @cities.dup
    start = cities.shift
    cities.inject(0) do |total_time, dest|
      total_time += start.destinations[dest]
      start = dest
      total_time
    end
  end
end

LINE_REGEX = /(\w+) to (\w+) = (\d+)/

def parse_line(line)
  if line.match(LINE_REGEX)
    City.find($1).add_destination($2, $3.to_i)
    City.find($2).add_destination($1, $3.to_i)
  end
end

STDIN.each_line do |line|
  parse_line(line)
end

City.all.each do |city|
  puts city.name
  city.destinations.to_a.sort_by { |dest| dest[0].name }.each do |dest|
    dest, time = dest
    puts "  to #{dest.name} = #{time}"
  end
end

slowest_time = 0

City.all.each_permutation do |cities|
  travel_time = Trip.new(cities).total_time
  if travel_time > slowest_time
    slowest_time = travel_time
  end
end

puts slowest_time
