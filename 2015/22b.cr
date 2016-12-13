class SpellEffect
  getter :timer, :attribute, :magnitude, :disable

  def initialize(@timer, @attribute, @magnitude, @disable = nil)
  end

  def tick
    @timer -= 1
  end

  def finished?
    @timer <= 0
  end

  def dup
    self.class.new(@timer, @attribute, @magnitude, @disable)
  end
end

struct Spell
  getter :cost
  getter :immediate_self_effect
  getter :prolonged_self_effect
  getter :immediate_enemy_effect
  getter :prolonged_enemy_effect

  def initialize(@cost, @immediate_enemy_effect = nil, @prolonged_self_effect = nil, @immediate_self_effect = nil, @prolonged_enemy_effect = nil)
  end
end

module Healthy
  def dead?
    @health <= 0
  end

  def alive?
    !dead?
  end
end

class Player
  include Healthy
  getter   :name
  property :mana
  property :armor
  property :health
  getter   :mana_spent

  def initialize(@health, @mana)
    @armor = 0
    @mana_spent = 0
  end

  def spells
    {
      magic_missile: Spell.new(53, immediate_enemy_effect: SpellEffect.new(0, :health, -4)),
      drain: Spell.new(73,
          immediate_self_effect: SpellEffect.new(0, :health, 2),
          immediate_enemy_effect: SpellEffect.new(0, :health, -2)
        ),
      shield: Spell.new(113, prolonged_self_effect: SpellEffect.new(6, :armor, 7, :shield)),
      poison: Spell.new(173, prolonged_enemy_effect: SpellEffect.new(6, :health, -3, :poison)),
      recharge: Spell.new(229, prolonged_self_effect: SpellEffect.new(5, :mana, 101, :recharge))
    }
  end

  def spend_mana(amount)
    @mana -= amount
    @mana_spent += amount
  end
end


class Boss
  include Healthy
  property :health
  getter   :damage

  def initialize(@health, @damage)
  end
end

class Battle
  def initialize(@player, @boss)
    @player_effects = [] of SpellEffect
    @boss_effects = [] of SpellEffect
    @players_turn = true
  end

  def fight!
    until @player.dead? || @boss.dead?
      if @players_turn
        @player.health -= 1
        break if @player.dead?
      end
      @player_effects.each do |player_effect|
        apply_player_spell_effect(player_effect)
      end
      @boss_effects.each do |boss_effect|
        apply_boss_spell_effect(boss_effect)
      end
      @player_effects.reject!(&.finished?)
      @boss_effects.reject!(&.finished?)
      if @players_turn
        player_attack!
      else
        boss_attack!
      end
      @player.armor = 0
      @players_turn = !@players_turn
    end
    if @player.dead?
      return @boss
    else
      return @player
    end
  end

  private def player_attack!
    if available_player_spells.size > 0
      selected_spell = available_player_spells.sample
      cast!(@player.spells[selected_spell])
    else
      @player.health = 0
    end
  end

  private def available_player_spells
    @player.spells.keys.select { |spell_name|
      @player.spells[spell_name].cost <= @player.mana
    } - (@player_effects.compact_map(&.disable) + @boss_effects.compact_map(&.disable))
  end

  private def boss_attack!
    # puts "Boss does #{Math.max((@boss.damage - @player.armor), 1)} damage"
    @player.health -= Math.max((@boss.damage - @player.armor), 1)
  end

  private def cast!(spell)
    @player.spend_mana(spell.cost)
    if spell.immediate_self_effect
      apply_player_spell_effect(spell.immediate_self_effect)
    end
    if spell.immediate_enemy_effect
      apply_boss_spell_effect(spell.immediate_enemy_effect)
    end
    if spell.prolonged_self_effect
      add_player_effect(spell.prolonged_self_effect)
    end
    if spell.prolonged_enemy_effect
      add_boss_effect(spell.prolonged_enemy_effect)
    end
  end

  private def add_player_effect(effect)
    if effect
      @player_effects << effect.dup
    end
  end

  private def add_boss_effect(effect)
    if effect
      @boss_effects << effect.dup
    end
  end

  private def apply_player_spell_effect(spell_effect)
    if spell_effect
      case spell_effect.attribute
      when :health
        @player.health += spell_effect.magnitude
      when :armor
        @player.armor += spell_effect.magnitude
      when :mana
        @player.mana += spell_effect.magnitude
      end
      spell_effect.tick
    end
  end

  private def apply_boss_spell_effect(spell_effect)
    if spell_effect
      case spell_effect.attribute
      when :health
        @boss.health += spell_effect.magnitude
      end
      spell_effect.tick
    end
  end
end

least_mana_spent = Int32::MAX
games_played = 0
games_won = 0

loop do
  boss = Boss.new(51, 9)
  player = Player.new(50, 500)
  games_played += 1
  if player == Battle.new(player, boss).fight!
    games_won += 1
    if player.mana_spent < least_mana_spent
      least_mana_spent = player.mana_spent
    end
  end

  print "Played: #{games_played} | Won: #{games_won} | Minimum Mana Spent: #{least_mana_spent}\r"
end
