class Reindeer
  getter :position, :name

  def initialize(@name, @speed, @flight_time, @rest_time)
    @position = 0
    @remaining_flight_time = @flight_time
    @remaining_rest_time = 0
  end

  def tick
    if flying?
      fly!
    else
      rest!
    end
  end

  def flying?
    @remaining_flight_time > 0
  end

  def resting?
    @remaining_rest_time > 0
  end

  def fly!
    @position += @speed
    @remaining_flight_time -= 1
    if !flying?
      @remaining_rest_time = @rest_time
    end
  end

  def rest!
    @remaining_rest_time -= 1
    if !resting?
      @remaining_flight_time = @flight_time
    end
  end
end

def parse_line(line)
  if match = line.match(/(\w+) can fly (\d+) km\/s for (\d+) seconds, but then must rest for (\d+) seconds./)
    Reindeer.new($1, $2.to_i, $3.to_i, $4.to_i)
  end
end

reindeer = Array(Reindeer).new

STDIN.each_line do |line|
  if r = parse_line(line)
    reindeer << r
  end
end

race_duration = ARGV[0].to_i

race_duration.times do
  reindeer.each do |r|
    r.tick
  end
end

reindeer.each do |r|
  puts "#{r.name} #{r.position}"
end
