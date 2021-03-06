require 'matrix'

class Particle
  attr_reader :id, :position

  @@id = -1
  REGEX = /p=<(?<position>.+?)>, v=<(?<velocity>.+?)>, a=<(?<acceleration>.+?)>/

  def self.parse_line(line)
    match_data = line.match(REGEX)
    raise "Invalid line #{line}" unless match_data

    new(
      position:     match_data[:position].split(",").map(&:to_i),
      velocity:     match_data[:velocity].split(",").map(&:to_i),
      acceleration: match_data[:acceleration].split(",").map(&:to_i),
    )
  end

  def initialize(position:, velocity:, acceleration:)
    @id           = (@@id += 1)
    @position     = Matrix[position]
    @velocity     = Matrix[velocity]
    @acceleration = Matrix[acceleration]
  end

  def step!
    @velocity += @acceleration
    @position += @velocity
  end
end

particles = STDIN.each_line.map { |line| Particle.parse_line(line) }

50_000.times do |i|
  particles.each(&:step!)
  particles.each do |particle|
    collided_particles = particles.select { |p| p.position == particle.position }
    particles -= collided_particles if collided_particles.length > 1
  end

  print "#{i}: "
  print "total particles: "
  puts particles.length
end
