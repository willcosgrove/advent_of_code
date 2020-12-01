require 'set'
require 'pry'
pry_stdin = IO.new(IO.sysopen('/dev/tty'), 'r')
Pry.config.input = pry_stdin

input_range = 137683..596253

def valid?(pin)
  spin = pin.to_s
  spin.match?(/(\d)\1/) &&
    spin.split("") == spin.split("").sort
end

valid_pins = Set.new
input_range.each do |pin|
  valid_pins << pin if valid?(pin)
end

puts "Part 1: #{valid_pins.size}"

def valid?(pin)
  spin = pin.to_s
  multiple_adjacent_nums = spin.scan(/(\d)\1/).flatten
  multiple_adjacent_nums.any? { |num| spin.scan(/#{num}+/).any? { |group| group.length == 2 } } &&
    spin.split("") == spin.split("").sort
end

binding.pry

valid_pins = Set.new
input_range.each do |pin|
  valid_pins << pin if valid?(pin)
end

puts "Part 2: #{valid_pins.size}"
