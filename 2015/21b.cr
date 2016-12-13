class Fighter
  getter   :name
  property :health

  def initialize(@name, @health, @damage = 0, @armor = 0)
    @items = [] of Item
  end

  def attack(player)
    player.health -= Math.max((damage - player.armor), 0)
  end

  def equip!(items)
    if items.select(&.type.weapon?).size == 1 && items.select(&.type.armor?).size <= 1 && items.select(&.type.ring?).size <= 2
      @items = items
      return true
    else
      return false
    end
  end

  def worth
    @items.map(&.cost).sum
  end

  def armor
    Math.max(@armor, @items.map(&.armor).sum)
  end

  def damage
    Math.max(@damage, @items.map(&.damage).sum)
  end

  def dead?
    @health <= 0
  end

  def alive?
    !dead?
  end
end

class Battle
  def initialize(@player1, @player2)
  end

  def fight!
    round = 0
    until @player1.dead? || @player2.dead? || round > 500
      @player1.attack(@player2)
      @player2.attack(@player1) if @player2.alive?
      round += 1
    end
    if @player1.dead?
      # puts "#{@player2.name} wins"
      return @player2
    else
      # puts "#{@player1.name} wins"
      return @player1
    end
  end
end


struct Item
  enum Type
    Weapon
    Armor
    Ring
  end

  getter :type, :cost, :damage, :armor

  def initialize(@type, @cost, @damage, @armor)
  end
end

store = [
  Item.new(Item::Type::Weapon,  8, 4, 0),
  Item.new(Item::Type::Weapon, 10, 5, 0),
  Item.new(Item::Type::Weapon, 25, 6, 0),
  Item.new(Item::Type::Weapon, 40, 7, 0),
  Item.new(Item::Type::Weapon, 74, 8, 0),
  Item.new(Item::Type::Armor,  13, 0, 1),
  Item.new(Item::Type::Armor,  31, 0, 2),
  Item.new(Item::Type::Armor,  53, 0, 3),
  Item.new(Item::Type::Armor,  75, 0, 4),
  Item.new(Item::Type::Armor, 102, 0, 5),
  Item.new(Item::Type::Ring,   25, 1, 0),
  Item.new(Item::Type::Ring,   50, 2, 0),
  Item.new(Item::Type::Ring,  100, 3, 0),
  Item.new(Item::Type::Ring,   20, 0, 1),
  Item.new(Item::Type::Ring,   40, 0, 2),
  Item.new(Item::Type::Ring,   80, 0, 3)
]

gold = 0
count = 1

1.upto(4) do |i|
  store.each_combination(i) do |items|
    print "#{count}/2516\r"
    count += 1
    player = Fighter.new("Player", 100)
    boss = Fighter.new("Boss", 104, 8, 1)

    if player.equip!(items)
      if boss == Battle.new(player, boss).fight!
        if player.worth > gold
          gold = player.worth
        end
      end
    end
  end
end
puts

puts gold
