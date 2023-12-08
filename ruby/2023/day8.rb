require './commons/assert'

def parse_map(input)
  map = {}
  input.split("\n").each do |n|
    k, v = n.split(' = ')
    map[k] = v[1..-2].split(', ')
  end
  map
end

def find_exit(start, map, instr, condition)
  steps = 0
  instr_idx = 0
  current = start
  while condition.call(current)
    current = map[current][instr[instr_idx]]
    instr_idx = (instr_idx + 1) % instr.length
    steps += 1
  end
  steps
end

def part_one(input)
  instr, nodes = input.split "\n\n"
  instr = instr.gsub('L', '0').gsub('R', '1').split('').map(&:to_i)

  map = parse_map(nodes)
  find_exit('AAA', map, instr, ->(c) { c != 'ZZZ' })
end

def part_two(input)
  instr, nodes = input.split "\n\n"
  instr = instr.gsub('L', '0').gsub('R', '1').split('').map(&:to_i)

  map = parse_map(nodes)

  current = map.keys.filter { |k| k[-1] == 'A' }
  steps = current.map do |c|
    find_exit(c, map, instr, ->(c) { c[-1] != 'Z' })
  end
  steps.reduce(1, :lcm)
end

def test
  example = %{RL

AAA = (BBB, CCC)
BBB = (DDD, EEE)
CCC = (ZZZ, GGG)
DDD = (DDD, DDD)
EEE = (EEE, EEE)
GGG = (GGG, GGG)
ZZZ = (ZZZ, ZZZ)}

  example2 = %{LLR

AAA = (BBB, BBB)
BBB = (AAA, ZZZ)
ZZZ = (ZZZ, ZZZ)}

  example3 = %{LR

11A = (11B, XXX)
11B = (XXX, 11Z)
11Z = (11B, XXX)
22A = (22B, XXX)
22B = (22C, 22C)
22C = (22Z, 22Z)
22Z = (22B, 22B)
XXX = (XXX, XXX)}

  assert part_one(example), 2
  assert part_one(example2), 6
  assert part_two(example3), 6
  0
end
