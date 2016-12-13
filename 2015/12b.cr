require "json"

def any_red?(parsed_json : Array(JSON::Type))
  parsed_json.each do |val|
    if val.is_a?(String) && val == "red"
      return true
    end
  end
  return false
end

def sum_numbers(parsed_json : Nil | String | Bool)
  0
end

def sum_numbers(parsed_json : Array(JSON::Type))
  parsed_json.map { |json| sum_numbers(json) }.sum
end

def sum_numbers(parsed_json : Hash(String, JSON::Type))
  if any_red?(parsed_json.values)
    0
  else
    sum_numbers(parsed_json.values)
  end
end

def sum_numbers(parsed_json : Int64 | Float64)
  parsed_json
end

def sum_json_numbers(json)
  parsed_json = JSON.parse(json)
  sum_numbers(parsed_json)
end

puts sum_json_numbers(STDIN.gets_to_end)
