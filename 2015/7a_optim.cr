class WireSignal
  getter :output

  def initialize(value : UInt16)
    @output = value
  end
end

class WireID
  def initialize(str)
    @id = str
  end

  def output
    ifdef memoize
      @output ||= Wire.find(@id).output
    else
      Wire.find(@id).output
    end
  end
end

class Wire
  @@wires = Hash(String, Wire).new
  def initialize(id, input)
    @input = input
    @@wires[id] = self
  end

  def self.find(id)
    @@wires[id]
  end

  def self.all
    @@wires
  end

  def output
    @input.output
  end
end

class Gate
  def initialize(*inputs)
    @inputs = inputs
  end

  def output
    raise "Override #output"
  end
end

class OpGate
  def initialize(input : Wire | WireID, shift : Int)
    @input = input
    @shift = shift
  end

  def output
    raise "Override #output"
  end
end

class NotGate
  def initialize(@input)
  end

  def output
    ~@input.output
  end
end

class AndGate < Gate
  def output
    @inputs[0].output & @inputs[1].output
  end
end

class OrGate < Gate
  def output
    @inputs[0].output | @inputs[1].output
  end
end

class LeftShiftGate < OpGate
  def output
    @input.output << @shift
  end
end

class RightShiftGate < OpGate
  def output
    @input.output >> @shift
  end
end

BINARY_OP_REGEX = /(?<i1>\w+) \w+ (?<i2>\w+) -> (?<wire>\w+)/
UNARY_OP_REGEX = /(?<i>[\d\w]+) -> (?<wire>\w+)/

def exec_line(line)
  case line
  when /AND/
    match = line.match(BINARY_OP_REGEX)
    if match
      if match["i1"] =~ /\d+/
        Wire.new(match["wire"], AndGate.new(WireSignal.new(match["i1"].to_u16), WireID.new(match["i2"])))
      else
        Wire.new(match["wire"], AndGate.new(WireID.new(match["i1"]), WireID.new(match["i2"])))
      end
    end
  when /OR/
    match = line.match(BINARY_OP_REGEX)
    if match
      Wire.new(match["wire"], OrGate.new(WireID.new(match["i1"]), WireID.new(match["i2"])))
    end
  when /LSHIFT/
    match = line.match(BINARY_OP_REGEX)
    if match
      Wire.new(match["wire"], LeftShiftGate.new(WireID.new(match["i1"]), match["i2"].to_i))
    end
  when /RSHIFT/
    match = line.match(BINARY_OP_REGEX)
    if match
      Wire.new(match["wire"], RightShiftGate.new(WireID.new(match["i1"]), match["i2"].to_i))
    end
  when /NOT/
    match = line.match(UNARY_OP_REGEX)
    if match
      Wire.new(match["wire"], NotGate.new(WireID.new(match["i"])))
    end
  else
    match = line.match(UNARY_OP_REGEX)
    if match
      if match["i"] =~ /\d+/
        Wire.new(match["wire"], WireSignal.new(match["i"].to_u16))
      else
        Wire.new(match["wire"], WireID.new(match["i"]))
      end
    end
  end
end

STDIN.each_line do |line|
  exec_line(line)
end

puts Wire.find("a").output
