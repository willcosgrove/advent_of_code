alias Microchip = Int32

OUTPUT = Hash(Int32, Microchip).new

class Bot
  @@bots = Hash(Int32, Bot).new do |hash, key|
    hash[key] = Bot.new(key)
  end

  @instruction : Proc(Microchip, Microchip, Void)

  def self.find(id : Int32)
    @@bots[id]
  end

  def initialize(@id : Int32)
    @microchips = Array(Microchip).new(2)
    @instruction = -> (_low : Microchip, _high : Microchip) {}
  end

  def call(microchip : Microchip)
    @microchips.push(microchip)
    if @microchips.size == 2
      @instruction.call(*@microchips.sort)
    end
  end

  def program(&block : Microchip, Microchip -> _)
    @instruction = block
  end
end

module InstructionParser
  BOT_REGEX = /bot (\d+)/
  OUTPUT_REGEX = /output (\d+)/
  BOT_OR_OUTPUT_REGEX = /#{BOT_REGEX}|#{OUTPUT_REGEX}/
  MICROCHIP_REGEX = /value \d+/

  BOT_PROGRAM_REGEX = /(?<target>#{BOT_REGEX}) gives low to (?<low>#{BOT_OR_OUTPUT_REGEX}) and high to (?<high>#{BOT_OR_OUTPUT_REGEX})/
  MICROCHIP_INSERTION_REGEX = /(?<microchip>#{MICROCHIP_REGEX}) goes to (?<bot>#{BOT_REGEX})/

  def parse_line(line)
    case line
    when BOT_PROGRAM_REGEX
      $~[:target]
  end
end
