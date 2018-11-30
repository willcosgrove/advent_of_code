require "crypto/md5"

HASH_CHECK = /^00000(.)/

password = [] of String

index = 0
base = ARGV[0].chomp

until password.size == 8
  if Crypto::MD5.hex_digest("#{base}#{index}").match(HASH_CHECK)
    password << $1
    puts password.join("")
  end
  index += 1
end

puts password.join("")
