using Test
using DataStructures

function step(pair_counter, char_counter, instructions)
    new_counter = copy(pair_counter)

    for pair in keys(pair_counter)
        if haskey(instructions, pair)
            c = instructions[pair]
            (c1, c2) = pair

            char_counter[c] += pair_counter[pair]
            new_counter[pair] -= pair_counter[pair]
            new_counter[c1*c] += pair_counter[pair]
            new_counter[c*c2] += pair_counter[pair]
        end
    end

    return new_counter, char_counter
end

function part_one(input)
    return part_two(input, 10)
end

function part_two(input, steps = 40)
    (template, insertions) = split(input, "\n\n")

    d = Dict()
    for instruction in split(insertions, "\n")
        (pair, f) = split(instruction, " -> ")
        d[pair] = f[1]
    end

    pairs = counter([])
    chars = counter(template)

    for (c1, c2) in zip(template, template[2:end])
        pairs[c1*c2] += 1
    end

    for _ = 1:steps
        (pairs, chars) = step(pairs, chars, d)
    end

    v = values(chars)
    return max(v...) - min(v...)
end

function test()
    example = """NNCB

CH -> B
HH -> N
CB -> H
NH -> C
HB -> C
HC -> B
HN -> C
NN -> C
BH -> H
NC -> B
NB -> B
BN -> B
BB -> N
BC -> B
CC -> N
CN -> C"""

    @test part_one(example) == 1588
    @test part_two(example) == 2188189693529
end
