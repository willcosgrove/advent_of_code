require 'set'

puts STDIN.each_line.select { |passphrase|
  words = passphrase.split(" ")
  words.map! { |word| Set.new(word.split("")) }
  words.uniq.length == words.length
}.length
