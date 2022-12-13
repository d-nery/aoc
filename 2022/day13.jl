using Test

# 1 -> in order
# -1 -> out of order
# 0 -> continue
function compare(left, right)
    if isa(left, Int64) && isa(right, Int64)
        return left < right ? 1 : left > right ? -1 : 0
    end

    if isa(left, Vector) && isa(right, Vector)
        for (l, r) in zip(left, right)
            result = compare(l, r)
            if result == 0
                continue
            end
            return result
        end

        len_l = length(left)
        len_r = length(right)
        return len_l < len_r ? 1 : len_l > len_r ? -1 : 0
    end

    if isa(left, Vector)
        return compare(left, [right])
    end

    return compare([left], right)
end

function part_one(input)
    packets = split(input, "\n\n")

    ans = 0

    for (idx, (p1, p2)) in enumerate(split.(packets, "\n"))
        pack1 = eval(Meta.parse(p1))
        pack2 = eval(Meta.parse(p2))

        result = compare(pack1, pack2)
        if result == 1
            ans += idx
        end
    end

    return ans
end

function part_two(input)
    packets = eval.(Meta.parse.(split(replace(input, "\n\n" => "\n"), "\n")))
    append!(packets, [[[2]], [[6]]])

    c = (l, r) -> compare(l, r) == 1
    sort!(packets; lt=c)

    return findfirst(p -> p == [[6]], packets) * findfirst(p -> p == [[2]], packets)
end

function test()
    example = """[1,1,3,1,1]
[1,1,5,1,1]

[[1],[2,3,4]]
[[1],4]

[9]
[[8,7,6]]

[[4,4],4,4]
[[4,4],4,4,4]

[7,7,7,7]
[7,7,7]

[]
[3]

[[[]]]
[[]]

[1,[2,[3,[4,[5,6,7]]]],8,9]
[1,[2,[3,[4,[5,6,0]]]],8,9]"""

    @test part_one(example) == 13
    @test part_two(example) == 140
end
