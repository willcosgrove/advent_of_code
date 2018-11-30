class Room
  attr_reader :sector_id
  REGEX = /(\d+)\[([a-z]{5})\]/.freeze
  def initialize(data)
    chunked_data = data.split("-")
    @name = chunked_data[0..-2].join("-")
    _, @sector_id, @checksum = chunked_data.last.match(REGEX).to_a
    @sector_id = @sector_id.to_i
  end

  def valid?
    checksum == @checksum
  end

  def decrypted_name
    @name.each_char.map { |char|
      next " " if char == "-"
      [char].cycle(@sector_id + 1).reduce { |acc| acc.next[0] }
    }.join
  end

  private

  def checksum
    @name.each_char.reduce(Hash.new(0)) { |acc, char|
      next acc if char == "-"
      acc[char] += 1
      acc
    }.to_a.map(&:reverse).sort { |a, b|
      count_sort = b.first <=> a.first
      if count_sort != 0
        count_sort
      else
        a.last <=> b.last
      end
    }.map(&:last).take(5).join
  end
end

valid_rooms =
  STDIN.each_line.map { |room_data| Room.new(room_data) }.select(&:valid?)

sum = valid_rooms.sum(&:sector_id)

puts sum

valid_rooms.each do |room|
  puts "#{room.decrypted_name} - #{room.sector_id}"
end
