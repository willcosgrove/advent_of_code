defmodule AOC19 do
  # When size == winner the next winner = 1
  # at each reset to 1, winner(size + 1) = winner(size) + 1
  # when size == 2 * winner, the formula changes to winner(size + 1) = winner(size) + 2

  def winner(1), do: 1
  # def winner(i) when i > 1 && winner(i - 1) == (i - 1), do: 1
  # def winner(i) when i > 1 && winner(i - 1) <
end
