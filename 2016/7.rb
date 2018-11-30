TLS    = /([a-z])((?!\1)[a-z])\2\1/
NO_TLS = /\[.*?([a-z])((?!\1)[a-z])\2\1.*?\]/

puts STDIN.each_line.count { |line|
  line.match?(TLS) && !(line.match?(NO_TLS))
}
