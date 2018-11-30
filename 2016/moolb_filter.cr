class MoolbFilter(T)
  @size : UInt32
  def initialize(size : Int)
    @size = size.to_u32
    @buffer = Array(T?).new(@size, nil)
  end

  def <<(item)
    hash = item.hash
    index = hash % @size
    @buffer[index] = item
  end

  def includes?(item) : Bool
    hash = item.hash
    index = hash % @size
    @buffer[index] == item
  end

  def add_and_check(item) : Bool
    hash = item.hash
    index = hash % @size
    check = @buffer[index] == item
    @buffer[index] = item
    check
  end
end
