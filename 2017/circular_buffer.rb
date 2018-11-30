class CircularBuffer < Array
  class Slice
    def initialize(buffer, range)
      raise if range.size > buffer.size
      @buffer = buffer
      @range  = range
    end

    def to_a
      @range.map { |index| @buffer[index] }
    end

    def chunk_indicies
      @range.chunk_while { |left, right|
        left % @buffer.size < right % @buffer.size
      }.map { |chunk|
        Range.new(chunk.first % @buffer.size, chunk.last % @buffer.size)
      }
    end

    def chunks
      chunk_indicies.map { |chunk_index| @buffer[chunk_index] }
    end

    def reverse!
      reversed = to_a.reverse
      chunk_indicies.each do |chunk_index|
        @buffer[chunk_index] = reversed.shift(chunk_index.size)
      end
    end
  end

  def [](indexer)
    case indexer
    when Integer then super(constrain_index(indexer))
    when Range
      Slice.new(self, indexer)
    end
  end

  def []=(indexer, settee)
    case indexer
    when Integer then super(constrain_index(indexer))
    when Range
      if indexer.size == settee.size
        super(indexer, settee)
      else
        raise "You cannot set a range to an array of a different size than the range"
      end
    end
  end

  private

  def constrain_index(index)
    index % size
  end
end
