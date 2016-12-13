TWO_PAIRS = /(\w)\1/
def no_confusing_letters?(password)
  !(password.includes?('i') || password.includes?('o') || password.includes?('l'))
end

def two_pairs?(password)
  if match = password.match(TWO_PAIRS)
    !!password.match(TWO_PAIRS, match.begin + 2)
  else
    false
  end
end

def contains_a_straight?(password)
  run = 1
  next_char = 'z'
  password.each_char do |char|
    if char == next_char
      run += 1
      next_char = next_char.succ
    else
      run = 1
      next_char = char.succ
    end
    if run >= 3
      return true
    end
  end
  return false
end

def valid_password?(password)
  no_confusing_letters?(password) &&
    two_pairs?(password) &&
    contains_a_straight?(password)
end

password = ARGV[0]
until valid_password?(password)
  password = password.succ
end

password = password.succ

until valid_password?(password)
  password = password.succ
end

puts password
