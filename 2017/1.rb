captcha =
  gets
    .chomp
    .split("")
    .map(&:to_i)

puts captcha.select.with_index { |number, index|
  number == captcha[(index + 1) % captcha.size]
}.sum
