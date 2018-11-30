puts STDIN.each_line.select { |passphrase|
  words = passphrase.split(" ")
  words.uniq.length == words.length
}.length
