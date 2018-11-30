require 'csv'

table = CSV.new(STDIN, col_sep: "\t")

puts table.map { |row|
  row = row.map(&:to_i)
  row.max - row.min
}.sum
