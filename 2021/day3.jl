using Test
using DataStructures

function input_to_bits_vector(input)
    numbers = split(input, "\n")
    bits = length(numbers[1])
    return (parse.(UInt64, numbers; base = 2), bits)
end

function find_most_common(numbers, bits, position)::UInt64
    bits = @. numbers >> (bits - position) & 0x1
    c = counter(bits)
    return c[1] >= c[0] ? 1 : 0
end

function find_with_filter(arr, bits, op)
    i = 1
    while length(arr) > 1
        common = find_most_common(arr, bits, i)
        arr = filter(o -> op((o >> (bits - i)) & 0x1, common), arr)
        i += 1
    end

    return arr[1]
end

function part_one(input)
    numbers, bits = input_to_bits_vector(input)
    γ, ϵ = reduce(1:bits; init = (0, 0)) do (g, e), pos
        most_common = find_most_common(numbers, bits, pos)
        g |= most_common << (bits - pos)
        e |= (~most_common & 0x1) << (bits - pos)
        return (g, e)
    end

    return γ * ϵ
end

function part_two(input)
    numbers, bits = input_to_bits_vector(input)

    o = find_with_filter(numbers, bits, ==)
    c = find_with_filter(numbers, bits, !=)

    return o * c
end

function test()
    example = """00100
11110
10110
10111
10101
01111
00111
11100
10000
11001
00010
01010"""

    @test part_one(example) == 198
    @test part_two(example) == 230
end
