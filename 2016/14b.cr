require "crypto/md5"

class PotentialKey
  @character : String
  REGEX = /(.)\1{2}/
  getter :index, :verified, :hash

  def initialize(@hash : String, @index : Int32)
    @verified = false
    if @hash.match(REGEX)
      @character = $1
    else
      raise "error"
    end
    @verify_regex = /#{@character}{5}/
  end

  def self.match?(hash)
    !!hash.match(REGEX)
  end

  def verify(hash)
    if hash.match(@verify_regex)
      @verified = true
    end
  end
end

index = 0
salt = STDIN.gets_to_end.chomp

potential_keys = [] of PotentialKey
verified_keys = [] of PotentialKey

until verified_keys.size >= 64 && potential_keys.size == 0
  print "\r#{index}"
  potential_keys.reject! { |key| key.verified || index - key.index > 1000 }
  hash = Crypto::MD5.hex_digest("#{salt}#{index}")
  2016.times do
    hash = Crypto::MD5.hex_digest(hash)
  end
  potential_keys.each do |key|
    if key.verify(hash)
      verified_keys << key
    end
  end
  if PotentialKey.match?(hash) && verified_keys.size < 64
    potential_keys << PotentialKey.new(hash, index)
  end
  index += 1
end

sixty_fourth_key = verified_keys.sort_by(&.index)[63]

puts ""
puts ""
puts "Verified Key: #{sixty_fourth_key.hash}"
puts "       Index: #{sixty_fourth_key.index}"
