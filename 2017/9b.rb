require 'strscan'

stream = StringScanner.new(STDIN.gets.chomp)

def begin_garbage(stream)
  garbage = ""
  loop do
    raise if stream.eos?
    garbage <<
      case char = stream.getch
      when "!" then "!" + stream.getch
      when ">" then return garbage
      else
        char
      end
  end
end

def begin_group(stream)
  group = []
  loop do
    raise if stream.eos?
    case stream.getch
    when "}" then return group
    when "{" then group << begin_group(stream)
    when "<" then group << begin_garbage(stream)
    end
  end
end

def score_group(group, level = 1)
  level + group.select { |el| el.is_a? Array }.sum { |g| score_group(g, level + 1) }
end

def count_garbage(garbage)
  while garbage.match?(/!./)
    garbage = garbage.sub(/!./, "")
  end
  garbage.size
end

def count_garbage_within(group)
  group.sum do |el|
    case el
    when String
      count_garbage(el)
    when Array
      count_garbage_within(el)
    end
  end
end

stream.getch
group = begin_group(stream)

puts count_garbage_within(group)
