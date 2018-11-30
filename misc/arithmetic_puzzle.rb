require "bigdecimal"
require "bigdecimal/util"

class Puzzle
  attr_reader :target, :constituents

  ADD      = -> (x, y) { x + y }
  SUBTRACT = -> (x, y) { x - y }
  MULTIPLY = -> (x, y) { x * y }
  DIVIDE   = -> (x, y) { x / y }

  OPERATIONS = [ADD, SUBTRACT, MULTIPLY, DIVIDE].freeze
  POSITIONAL_OPERATIONS = [SUBTRACT, DIVIDE].freeze

  def initialize(target, *constituents)
    @target = target
    @constituents = constituents.map(&:to_d).sort
  end

  def ==(other)
    other.is_a?(Puzzle) &&
      @target == other.target && @constituents == other.constituents
  end

  def eql?(other)
    self == other
  end

  def hash
    [@target, @constituents].hash
  end

  def solved?
    @constituents.size == 1 && @target == @constituents.first.round(5)
  end

  def advance
    pairs = @constituents.combination(2).map(&:sort).uniq
    pairs.flat_map do |pair|
      OPERATIONS.flat_map do |op|
        remaining_constituents = ary_subtract(@constituents, pair)
        if POSITIONAL_OPERATIONS.include? op
          [
            Puzzle.new(@target, *op.call(*pair), *remaining_constituents),
            Puzzle.new(@target, *op.call(*pair.reverse), *remaining_constituents),
          ]
        else
          [Puzzle.new(@target, *op.call(*pair), *remaining_constituents)]
        end
      end
    end
  end

  private

  def ary_subtract(minuend, subtrahend)
    minuend.clone.tap do |result|
      subtrahend.each do |to_subtract|
        result.delete_at(result.index(to_subtract))
      end
    end
  end
end
