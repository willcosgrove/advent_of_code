require "crypto/md5"

class PotentialKey
  @character : String
  REGEX = /(.)\1{2}/
  getter :index, :verified

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

until verified_keys.size == 64
  print "\r#{index}"
  hash = Crypto::MD5.hex_digest("#{salt}#{index}")
  potential_keys.reject! { |key| key.verified || index - key.index > 1000 }
  potential_keys.each do |key|
    if key.verify(hash)
      verified_keys << key
      if verified_keys.size == 64
        puts ""
        puts key.index
        break
      end
    end
  end
  if PotentialKey.match?(hash)
    potential_keys << PotentialKey.new(hash, index)
  end
  index += 1
end
