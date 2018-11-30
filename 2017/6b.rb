class MemoryManager
  def initialize(banks)
    @banks = banks
  end

  def defrag!
    _, index_to_defrag = @banks.each_with_index.max_by { |(blocks, _index)| blocks }
    blocks_to_reallocate = @banks[index_to_defrag]
    @banks[index_to_defrag] = 0
    index_to_distribute_to = index_to_defrag
    until blocks_to_reallocate == 0
      index_to_distribute_to += 1
      index_to_distribute_to %= @banks.size

      @banks[index_to_distribute_to] += 1
      blocks_to_reallocate -= 1
    end
  end

  def state
    @banks.dup
  end
end

seen_states = []
memory = MemoryManager.new(STDIN.gets.chomp.split("\t").map(&:to_i))
current_state = memory.state

until seen_states.include? current_state do
  seen_states << current_state
  memory.defrag!
  current_state = memory.state
end

puts seen_states.length - seen_states.index(current_state)
