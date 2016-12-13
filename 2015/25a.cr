def code_number(row, col)
  code_number = 1
  until row == 1 && col == 1
    if col == 1
      col = row - 1
      row = 1
    else
      col -= 1
      row += 1
    end
    code_number += 1
  end
  code_number
end

def next_code(prev)
  (prev * 252533_i64) % 33554393_i64
end

previous_code = 20151125_i64
(code_number(2947,3029) - 1).times do
  previous_code = next_code(previous_code)
end

puts previous_code
