require "string_scanner"

EXPANDER_REGEX = /\((\d+)x(\d+)\)/

def decompress(str)
  decompressed_string = ""
  scanner = StringScanner.new(str)
  until scanner.eos?
    if match = scanner.scan(EXPANDER_REGEX)
      if (size = scanner[1]) && (count = scanner[2])
        repeater = scanner.scan(/.{#{size.to_i}}/)
        if repeater
          decompressed_string += (repeater * count.to_i)
        end
      else
        puts match
      end
    else
      next_char = scanner.scan(/\w/)
      decompressed_string += next_char if next_char
    end
  end
  decompressed_string
end

puts decompress(STDIN.gets_to_end.chomp).size
