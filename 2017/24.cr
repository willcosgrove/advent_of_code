struct Component
  left, right : Int32
end

struct Bridge
  components : Array(Tuple(Component, Bool))

  def strength
    @components.sum do |(component, _)|
      component.left + component.right
    end
  end

  def size
    @components.size
  end

  def next_required_connector
    return 0 if size.zero?
    last_component, reversed = @components.last
    return reversed ? last_component.left : last_component.right
  end
end

all_components = STDIN.each_line.map { |component|
  left, right = component.split("/")
  Component.new(left: left.to_i, right: right.to_i)
}

def construct_next_possible_bridge_layers(bridge : Bridge, available_components : Array(Copmonent))
  required_connector_type = bridge.next_required_connector
  available_components.each do |component|
    if component.left == required_connector_type
      yield Bridge.new(components: [*bridge.components, (component, false)])
    elsif component.right == required_connector_type
      yield Bridge.new(components: [*bridge.components, (component, true)])
    end
  end
end
