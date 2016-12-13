struct Ingredient
  # property :name
  property :capacity
  property :durability
  property :flavor
  property :texture
  property :calories

  def initialize(_name, @capacity, @durability, @flavor, @texture, @calories)
  end
end

struct Recipe
  property :ingredients

  def initialize(@ingredients)
  end

  def score
    capacity * durability * flavor * texture
  end

  def capacity
    Math.max(@ingredients.map(&.capacity).sum, 0)
  end

  def durability
    Math.max(@ingredients.map(&.durability).sum, 0)
  end

  def flavor
    Math.max(@ingredients.map(&.flavor).sum, 0)
  end

  def texture
    Math.max(@ingredients.map(&.texture).sum, 0)
  end

  def calories
    @ingredients.map(&.calories).sum
  end
end

ingredients = Array(Ingredient).new

def parse_line(line)
  if match = line.match(/(\w+): capacity (-?\d+), durability (-?\d+), flavor (-?\d+), texture (-?\d+), calories (-?\d+)/)
    Ingredient.new($1, $2.to_i, $3.to_i, $4.to_i, $5.to_i, $6.to_i)
  end
end

STDIN.each_line do |line|
  if ingredient = parse_line(line)
    ingredients << ingredient
  end
end

set = [0_i16, 0_i16, 0_i16, 0_i16]
sets_that_sum_to_100 = Array(Array(Int16)).new

while true
  if set.sum == 100_i16
    sets_that_sum_to_100 << set.dup
  end
  if set[-1] < 100_i16
    set[-1] += 1_i16
  elsif set[-2] < 100_i16
    set[-1] = 0_i16
    set[-2] += 1_i16
  elsif set[-3] < 100_i16
    set[-1] = 0_i16
    set[-2] = 0_i16
    set[-3] += 1_i16
  elsif set[-4] < 100_i16
    set[-1] = 0_i16
    set[-2] = 0_i16
    set[-3] = 0_i16
    set[-4] += 1_i16
  else
    break
  end
end

top_score = 0

sets_that_sum_to_100.each do |set|
  recipie = Recipe.new(Array.new(set[0], ingredients[0]) + Array.new(set[1], ingredients[1]) + Array.new(set[2], ingredients[2]) + Array.new(set[3], ingredients[3]))
  if recipie.calories == 500 && recipie.score > top_score
    top_score = recipie.score
  end
end

puts top_score
