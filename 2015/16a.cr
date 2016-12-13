struct Sue
  property :number
  property :facts

  def initialize(@number, @facts : Hash(String, Int32))
  end

  macro meta_property(bucket, *properties)
    {% for prop in properties %}
      def {{prop.id}}
        @{{bucket.id}}.fetch("{{prop.id}}") { nil }
      end
    {% end %}
  end

  meta_property :facts, :children, :cats, :samoyeds, :pomeranians, :akitas, :vizslas, :goldfish, :trees, :cars, :perfumes

end

sues = STDIN.each_line.compact_map { |line|
  if match = line.match(/Sue (\d+): (\w+): (\d+), (\w+): (\d+), (\w+): (\d+)/)
    Sue.new($1, {$2 => $3.to_i, $4 => $5.to_i, $6 => $7.to_i})
  end
}.to_a

macro filter(prop, val)
  sues.select! { |sue| sue.{{prop.id}} == {{val}} || sue.{{prop.id}} == nil }
end

filter :children, 3
filter :cats, 7
filter :samoyeds, 2
filter :pomeranians, 3
filter :akitas, 0
filter :vizslas, 0
filter :goldfish, 5
filter :trees, 3
filter :cars, 2
filter :perfumes, 1

puts sues[0].number
