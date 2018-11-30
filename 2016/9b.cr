require "string_scanner"

EXPANDER_REGEX = /\((\d+)x(\d+)\)/

def decompress(str)
  decompressed_size = 0_u64
  scanner = StringScanner.new(str)
  until scanner.eos?
    if match = scanner.scan(EXPANDER_REGEX)
      if (size = scanner[1]) && (count = scanner[2])
        repeater = scanner.scan(/.{#{size.to_i}}/)
        if repeater
          decompressed_size += decompress(repeater * count.to_i)
        end
      else
        puts match
      end
    else
      next_char = scanner.scan(/\w/)
      decompressed_size += 1 if next_char
    end
  end
  decompressed_size
end

puts decompress(STDIN.gets_to_end.chomp)
