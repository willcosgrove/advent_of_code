require "crypto/md5"

HASH_CHECK = /^00000([0-7])(.)/

password = Array(String).new(8, "_")

index = 0
found_characters = 0
base = ARGV[0].chomp

until found_characters == 8
  if Crypto::MD5.hex_digest("#{base}#{index}").match(HASH_CHECK)
    if password[$1.to_i] == "_"
      password[$1.to_i] = $2
      found_characters += 1
      puts password.join("")
    end
  end
  index += 1
end

puts password.join("")
