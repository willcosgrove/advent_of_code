class Guest
  @@guests = Hash(String, Guest).new

  getter :name, :preferences

  def initialize(@name)
    @preferences = Hash(Guest, Int32).new
    @@guests[@name] = self
  end

  def add_preference(name, happiness)
    @preferences[Guest.find(name)] = happiness
  end

  def self.find(name)
    @@guests.fetch(name) do |name|
      Guest.new(name)
    end
  end

  def self.all
    @@guests.values
  end
end

class Table
  def initialize(@guests)
  end

  def happiness
    @guests.each_with_index.inject(0) do |happiness, guest_and_index|
      guest, index = guest_and_index
      happiness + guest.preferences[@guests[index - 1]] + guest.preferences[@guests[(index + 1) % @guests.size]]
    end
  end
end

def parse_line(line)
  if match = line.match(/(\w+) would (gain|lose) (\d+) happiness units by sitting next to (\w+)/)
    happiness = $3.to_i * ($2 == "gain" ? 1 : -1)
    Guest.find($1).add_preference($4, happiness)
  end
end

STDIN.each_line do |line|
  parse_line(line)
end

happiest_arrangement = 0
Guest.all.each_permutation do |arrangement|
  happiness = Table.new(arrangement).happiness
  if happiness > happiest_arrangement
    happiest_arrangement = happiness
  end
end

puts happiest_arrangement
