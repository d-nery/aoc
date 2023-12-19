require './commons/assert'

def parse_workflow(raw)
  name = raw.match(/^(.*)\{/).captures[0]
  flow = raw.match(/{(.*)}$/).captures[0].split(',')

  wf = flow.map do |f|
    next [->(_p) { true }, f, f] unless f.include? ':'

    cond, target = f.split(':')
    feature = cond[0]
    op = cond[1]
    val = cond[2..].to_i

    next [->(p) { p[feature] < val }, target, f] if op == '<'

    next [->(p) { p[feature] > val }, target, f]
  end

  [name, wf]
end

def parse_workflow2(raw)
  name = raw.match(/^(.*)\{/).captures[0]
  flow = raw.match(/{(.*)}$/).captures[0].split(',')

  wf = flow.map do |f|
    next [f] unless f.include? ':'

    cond, target = f.split(':')
    feature = cond[0]
    op = cond[1]
    val = cond[2..].to_i
    next [feature, op, val, target]
  end

  [name, wf]
end

def process_wf(wf, parts)
  to_p = []
  xl, xu, ml, mu, al, au, sl, su = parts

  wf.each do |f|
    if f.length == 1
      to_p << [[xl, xu, ml, mu, al, au, sl, su], f[0]]
      next
    end

    feature, op, val, target = f
    if op == '<'
      to_p << [[xl, val - 1, ml, mu, al, au, sl, su], target] if feature == 'x'
      xl = val if feature == 'x'

      to_p << [[xl, xu, ml, val - 1, al, au, sl, su], target] if feature == 'm'
      ml = val if feature == 'm'

      to_p << [[xl, xu, ml, mu, al, val - 1, sl, su], target] if feature == 'a'
      al = val if feature == 'a'

      to_p << [[xl, xu, ml, mu, al, au, sl, val - 1], target] if feature == 's'
      sl = val if feature == 's'
    else
      to_p << [[val + 1, xu, ml, mu, al, au, sl, su], target] if feature == 'x'
      xu = val if feature == 'x'

      to_p << [[xl, xu, val + 1, mu, al, au, sl, su], target] if feature == 'm'
      mu = val if feature == 'm'

      to_p << [[xl, xu, ml, mu, val + 1, au, sl, su], target] if feature == 'a'
      au = val if feature == 'a'

      to_p << [[xl, xu, ml, mu, al, au, val + 1, su], target] if feature == 's'
      su = val if feature == 's'
    end
  end

  to_p
end

def parse_part(raw)
  features = raw[1..-2].split(',')
  part = {}
  features.each do |f|
    part[f[0]] = f[2..].to_i
  end
  part
end

def part_one(input)
  instructions, parts = input.split("\n\n").map { |i| i.split("\n") }
  workflows = {}
  instructions.map { parse_workflow(_1) }.each { workflows[_1[0]] = _1[1] }
  parts = parts.map { parse_part(_1) }

  score = 0
  parts.each do |p|
    wf = 'in'
    while wf != 'A' && wf != 'R'
      workflows[wf].each do |flow|
        result = flow[0].(p)
        if result
          wf = flow[1]
          break
        end
      end
    end
    score += p.each_value.sum if wf == 'A'
  end
  score
end

def part_two(input)
  instructions, = input.split("\n\n").map { |i| i.split("\n") }
  workflows = {}
  instructions.map { parse_workflow2(_1) }.each { workflows[_1[0]] = _1[1] }

  wf_A = []

  queue = [[[1, 4000, 1, 4000, 1, 4000, 1, 4000], 'in']]
  until queue.empty?
    p, wf = queue.pop
    if wf == 'A'
      wf_A << p
      next
    end

    next if wf == 'R'

    queue.concat(process_wf(workflows[wf], p))
  end

  wf_A.map { |w| (w[1] - w[0] + 1) * (w[3] - w[2] + 1) * (w[5] - w[4] + 1) * (w[7] - w[6] + 1) }.sum
end

def test
  example = %(px{a<2006:qkq,m>2090:A,rfg}
pv{a>1716:R,A}
lnx{m>1548:A,A}
rfg{s<537:gd,x>2440:R,A}
qs{s>3448:A,lnx}
qkq{x<1416:A,crn}
crn{x>2662:A,R}
in{s<1351:px,qqz}
qqz{s>2770:qs,m<1801:hdj,R}
gd{a>3333:R,R}
hdj{m>838:A,pv}

{x=787,m=2655,a=1222,s=2876}
{x=1679,m=44,a=2067,s=496}
{x=2036,m=264,a=79,s=2244}
{x=2461,m=1339,a=466,s=291}
{x=2127,m=1623,a=2188,s=1013})

  assert part_one(example), 19_114
  assert part_two(example), 167_409_079_868_000
  0
end
