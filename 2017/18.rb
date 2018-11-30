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

  def compile(command, arguments)
    arguments = wrap_arguments(arguments)
    case command.to_sym
    when :snd
      -> (ctx) {
        frequency, = arguments.call(ctx)
        ctx[:last_played_sound] = frequency.call
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
        Fiber.yield(ctx[:last_played_sound]) if register.call != 0
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
  def initialize(lines)
    @instructions = lines.map { |line| Instruction.parse(line) }

    @context = {
      position: 0,
      last_played_sound: nil,
      registers: Hash.new(0),
    }

    @execution = Fiber.new do |context|
      loop do
        @instructions[context[:position]].call(context)
      end
    end
  end

  def run
    @execution.resume(@context)
  end
end

program = Program.new(STDIN.each_line)
puts program.run
