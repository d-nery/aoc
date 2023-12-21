require './commons/assert'

def initial_configuration(input)
  modules = input.split("\n").each_with_object({}) do |l, m|
    name, targets = l.split(' -> ')
    if name[0] == '%'
      # Flip Flop, state = HIGH (true) or LOW (false)
      m[name[1..]] = ['%', name[1..], targets.split(', '), false]
    elsif name[0] == '&'
      # Conjunction, state = { input name => pulse }
      m[name[1..]] = ['&', name[1..], targets.split(', '), {}]
    else
      m[name] = ['B', name, targets.split(', ')]
    end
  end

  # Need this to freeze the keys, as we might add new (output only) modules
  modules.each_key.to_a.each do |k|
    modules[k][2].each do |t|
      modules[t] ||= [t, t, []]
      modules[t][3][k] = false if modules[t][0] == '&'
    end
  end

  modules
end

def process_pulse(mod, pulse)
  case mod[0]
  when '%'
    return [] if pulse[1] == true

    mod[3] = !mod[3]
    mod[2].map { [_1, [mod[1], mod[3]]] }
  when '&'
    mod[3][pulse[0]] = pulse[1]
    mod[2].map { [_1, [mod[1], !mod[3].each_value.all?]] }
  when 'B'
    mod[2].map { [_1, [mod[1], pulse[1]]] }
  else
    []
  end
end

def part_one(input)
  modules = initial_configuration(input)

  highs = 0
  lows = 0
  1000.times do
    queue = [['broadcaster', ['button', false]]]
    until queue.empty?
      target, pulse = queue.shift
      queue.concat(process_pulse(modules[target], pulse))
      highs += 1 if pulse[1]
      lows += 1 unless pulse[1]
    end
  end
  highs * lows
end

def part_two(input)
  modules = initial_configuration(input)

  # rx will receive its low pulse when &jz receives all highs (4 inputs) -> Manual inspection of input file
  highs_in_jz = []
  presses = 0
  loop do
    presses += 1
    queue = [['broadcaster', ['button', false]]]
    until queue.empty?
      target, pulse = queue.shift
      queue.concat(process_pulse(modules[target], pulse))

      # We save when jz has a high pulse, then get the lcm of the four inputs to check when all 4 will cycle together
      if target == 'jz' && pulse[1]
        highs_in_jz << presses
        # p [target, pulse, presses]
      end

      return highs_in_jz.reduce(1, :lcm) if highs_in_jz.size == 4
    end
  end
end

def test
  example = %(broadcaster -> a, b, c
%a -> b
%b -> c
%c -> inv
&inv -> a)

  example2 = %(broadcaster -> a
%a -> inv, con
&inv -> b
%b -> con
&con -> output)

  assert part_one(example), 32_000_000
  assert part_one(example2), 11_687_500
  0
end
