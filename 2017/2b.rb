require 'csv'

table = CSV.new(STDIN, col_sep: "\t")

puts table.map { |row|
  a, b = row.map(&:to_i).permutation(2).find { |a, b| a % b == 0 }
  a / b
}.sum
