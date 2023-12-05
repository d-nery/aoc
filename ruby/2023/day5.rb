require './commons/assert'

def direct_map(input)
  map = input.split("\n")[1..].map do |l|
    l.split(' ').map(&:to_i)
  end
  lambda { |s|
    map.each do |m|
      dest, source, range = m
      return dest - source + s if s >= source && s <= source + range
    end
    return s
  }
end

def reverse_map(input)
  map = input.split("\n")[1..].map do |l|
    l.split(' ').map(&:to_i)
  end
  lambda { |s|
    map.each do |m|
      source, dest, range = m
      return dest - source + s if s >= source && s <= source + range
    end
    return s
  }
end

def build_seed_to_location_map(maps)
  seed_to_soil = direct_map(maps[0])
  soil_to_fertilizer = direct_map(maps[1])
  fertilizer_to_water = direct_map(maps[2])
  water_to_light = direct_map(maps[3])
  light_to_temperature = direct_map(maps[4])
  temperature_to_humidity = direct_map(maps[5])
  humidity_to_location = direct_map(maps[6])

  lambda { |s|
    humidity_to_location.call(temperature_to_humidity.call(light_to_temperature.call(water_to_light.call(fertilizer_to_water.call(soil_to_fertilizer.call(seed_to_soil.call(s)))))))
  }
end

def build_location_to_seed_map(maps)
  soil_to_seed = reverse_map(maps[0])
  fertilizer_to_soil = reverse_map(maps[1])
  water_to_fertilizer = reverse_map(maps[2])
  light_to_water = reverse_map(maps[3])
  temperature_to_light = reverse_map(maps[4])
  humidity_to_temperature = reverse_map(maps[5])
  location_to_humidity = reverse_map(maps[6])

  lambda { |s|
    soil_to_seed.call(fertilizer_to_soil.call(water_to_fertilizer.call(light_to_water.call(temperature_to_light.call(humidity_to_temperature.call(location_to_humidity.call(s)))))))
  }
end

def part_one(input)
  seed_info, *maps = input.split("\n\n")
  seeds = seed_info.split(': ')[1].split(' ').map(&:to_i)
  seed_to_location = build_seed_to_location_map(maps)

  seeds.map { |s| seed_to_location.call(s) }.min
end

def part_two(input)
  seed_info, *maps = input.split("\n\n")

  location_to_seed = build_location_to_seed_map(maps)

  seeds = seed_info.split(': ')[1].split(' ').map(&:to_i)
  has_seed = lambda { |value|
    seeds.each_slice(2) do |s|
      seed, amount = s
      return true if value >= seed && value <= seed + amount

      next
    end
    false
  }

  test_location = 0
  loop do
    found = location_to_seed.call(test_location)
    return test_location if has_seed.call(found)

    test_location += 1
  end
end

def test
  example = %(seeds: 79 14 55 13

seed-to-soil map:
50 98 2
52 50 48

soil-to-fertilizer map:
0 15 37
37 52 2
39 0 15

fertilizer-to-water map:
49 53 8
0 11 42
42 0 7
57 7 4

water-to-light map:
88 18 7
18 25 70

light-to-temperature map:
45 77 23
81 45 19
68 64 13

temperature-to-humidity map:
0 69 1
1 0 69

humidity-to-location map:
60 56 37
56 93 4)

  assert part_one(example), 35
  assert part_two(example), 46
  0
end
