class Instruction
  PARSER = /(\w+)\s(.+)/
  def self.parse(line)
    match_data = line.match(PARSER)
    raise "Unparsable line: #{line}" unless match_data
    new(match_data[1], match_data[2])
  end

  def initialize(command, arguments)
    @command = command
    @proc    = compile(command, arguments)
  end

  def call(context)
    @proc.call(context)
  end

  private

  def wait
    Fiber.yield([:wait])
  end

  def send(data)
    Fiber.yield([:send, data])
  end

  def compile(command, arguments)
    arguments = wrap_arguments(arguments)
    case command.to_sym
    when :snd
      -> (ctx) {
        value, = arguments.call(ctx)
        send(value.call)
        ctx[:position] += 1
      }
    when :set
      -> (ctx) {
        register, new_value = arguments.call(ctx)
        register.call(new_value.call)
        ctx[:position] += 1
      }
    when :add
      -> (ctx) {
        register, additive = arguments.call(ctx)
        register.call(register.call + additive.call)
        ctx[:position] += 1
      }
    when :mul
      -> (ctx) {
        register, multiplier = arguments.call(ctx)
        register.call(register.call * multiplier.call)
        ctx[:position] += 1
      }
    when :mod
      -> (ctx) {
        register, divisor = arguments.call(ctx)
        register.call(register.call % divisor.call)
        ctx[:position] += 1
      }
    when :rcv
      -> (ctx) {
        register, = arguments.call(ctx)
        wait until received = ctx[:receive_buffer].pop
        register.call(received)
        ctx[:position] += 1
      }
    when :jgz
      -> (ctx) {
        register, offset = arguments.call(ctx)
        if register.call > 0
          ctx[:position] += offset.call
        else
          ctx[:position] += 1
        end
      }
    end
  end

  def wrap_arguments(arguments)
    args = arguments.split(" ").map { |arg|
      if arg.to_i.to_s == arg.chomp
        int_arg = arg.to_i
        -> (_) { -> { int_arg } }
      else
        register_key = arg.chomp.to_sym
        -> (ctx) {
          -> (new_val = nil) {
            if new_val
              ctx[:registers][register_key] = new_val
            else
              ctx[:registers][register_key]
            end
          }
        }
      end
    }

    -> (ctx) {
      args.map { |arg| arg.call(ctx) }
    }
  end
end

class Program
  attr_reader :id, :context

  def initialize(id, lines)
    @id = id
    @instructions = lines.map { |line| Instruction.parse(line) }

    @context = {
      position: 0,
      receive_buffer: [],
      registers: Hash.new(0),
    }

    @context[:registers][:p] = @id

    @execution = Fiber.new do |context|
      loop do
        break if context[:position] >= @instructions.size
        @instructions[context[:position]].call(context)
      end
      [:halt]
    end
  end

  def run
    @execution.resume(@context)
  end

  def receive(value)
    @context[:receive_buffer].unshift(value)
  end

  def buffer
    @context[:receive_buffer]
  end
end

class ProgramRuntime
  STOPPING_STATUSES = [:waiting, :halted].freeze
  def initialize(programs)
    @programs = programs
    @statuses = {}
    @statistics = Hash.new { |hash, key| hash[key] = Hash.new(0) }
    @programs.each { |p| @statuses[p.id] = :ready }
  end

  def run
    @programs.cycle.each do |program|
      next if @statuses[program.id] == :halted
      @statuses[program.id] = :ready if @statuses[program.id] == :waiting && program.buffer.any?
      break if @statuses.values.all? { |status| STOPPING_STATUSES.include? status }

      response = program.run
      handle_command(program, *response)
    end
    puts @statistics
  end

  private

  def handle_command(program, command, *arguments)
    case command
    when :wait
      @statuses[program.id] = :waiting
    when :halt
      @statuses[program.id] = :halted
    when :send
      broadcast(arguments.first, from: program)
    end
  end

  def broadcast(value, from:)
    @statistics[from.id][:send_count] += 1
    @programs.each do |program|
      next if program == from
      program.receive(value)
    end
  end
end

lines = STDIN.each_line.to_a
programs = [Program.new(0, lines.dup), Program.new(1, lines.dup)]
ProgramRuntime.new(programs).run
