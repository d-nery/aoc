require './commons/assert'
require 'set'

def part_one(input)
  wires = {}

  input.split("\n").each do |line|
    component, targets = line.split(': ')
    wires[component] ||= []

    targets.split(' ').each do |t|
      wires[component] << t
      wires[t] ||= []
      wires[t] << component
    end
  end

  a = Set[]
  wires.each_key do |k|
    a.add(k)
    wires[k].each do |v|
      puts "#{k}-#{v}" unless a.include? v
    end
  end
end

def part_two(input)
  0
end

def test
  example = %(jqt: rhn xhk nvd
rsh: frs pzl lsr
xhk: hfx
cmg: qnr nvd lhk bvb
rhn: xhk bvb hfx
bvb: xhk hfx
pzl: lsr hfx nvd
qnr: nvd
ntq: jqt hfx bvb xhk
nvd: lhk
lsr: lhk
rzs: qnr cmg lsr rsh
frs: qnr lhk lsr)

  assert part_one(example), 54
  assert part_two(example), 0
  0
end
