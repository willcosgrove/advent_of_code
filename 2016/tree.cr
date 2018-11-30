require "./moolb_filter"

class Tree(S, SI)
  def initialize(root, @unfold : Proc(S, Array(S)), @state_identity : Proc(S, SI))
    @visited_states = Set(SI).new
    # @visited_states = MoolbFilter(SI).new(1_000_000)
    @root = TreeNode(S).new(root, 0)
  end

  def breadth_first_search(&block : TreeNode(S) -> Bool)
    do_breadth_first_search(0, [@root], &block)
  end

  private def do_breadth_first_search(depth, nodes, &block : TreeNode(S) -> Bool)
    next_depth = Set(TreeNode(S)).new
    nodes.each do |node|
      if yield node
        return node
      end
      next_depth.merge!(node.unfold(&@unfold)) unless node.dead || @visited_states.includes?(@state_identity.call(node.state))
      @visited_states << @state_identity.call(node.state) unless node.dead
    end
    return nil unless next_depth.size > 0
    puts next_depth.size
    do_breadth_first_search(depth + 1, next_depth, &block)
  end
end

class TreeNode(S)
  getter :state, :depth, :dead

  def initialize(@state : S, @depth : Int32)
    @dead = false
  end

  def dead!
    @dead = true
  end

  def unfold
    children = yield @state
    children.map { |state| TreeNode(S).new(state, @depth + 1) }
  end
end
