require './commons/assert'

def _hash(str)
  v = 0
  str.chars.each do |c|
    v = ((v + c.ord) * 17) % 256
  end
  v
end

def part_one(input)
  input.split(',').map { _hash(_1) }.sum
end

def part_two(input)
  boxes = Array.new(256)
  input.split(',').each do |instr|
    label = instr.match(/\w+/)[0]
    op = instr.match(/[-=]/)[0]

    box = _hash(label)
    lens = boxes[box] || []

    if op == '-'
      lens.delete_if { |l| l[0] == label }
      boxes[box] = lens
      next
    end

    n = instr.match(/\d+/)[0].to_i

    idx = lens.find_index { |l| l[0] == label }
    if idx.nil?
      lens << [label, n]
    else
      lens[idx][1] = n.to_i
    end
    boxes[box] = lens
  end

  boxes.each_with_index.map do |b, i|
    next 0 if b.nil?

    b.each_with_index.map { |lens, j| (i + 1) * (j + 1) * lens[1] }.sum
  end.sum
end

def test
  example = %(rn=1,cm-,qp=3,cm=2,qp-,pc=4,ot=9,ab=5,pc-,pc=6,ot=7)

  assert part_one(example), 1320
  assert part_two(example), 145
  0
end
