input = STDIN.gets_to_end
input = input.split("\n")
input.pop
molecule = input.pop

element_count = molecule.scan(/([A-Z][a-z]?)/).size
paren_count = molecule.scan(/(Rn|Ar)/).size
comma_count = molecule.scan(/Y/).size

puts element_count - paren_count - (2 * comma_count) - 1
