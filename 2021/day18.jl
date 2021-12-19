using Test
using Combinatorics

function input_to_number(input)
    number = []
    depth = 0

    for c in input
        if c == '['
            depth += 1
        elseif c == ']'
            depth -= 1
        elseif c != ','
            push!(number, (parse(Int, c), depth))
        end
    end

    return number
end

function add(lhs, rhs)
    a = map(n -> (n[1], n[2] + 1), lhs)
    b = map(n -> (n[1], n[2] + 1), rhs)

    return append!(a, b)
end

function explode!(number, idx)
    if idx >= 2
        number[idx-1] = (number[idx-1][1] + number[idx][1], number[idx-1][2])
    end

    if idx <= length(number) - 2
        number[idx+2] = (number[idx+2][1] + number[idx+1][1], number[idx+2][2])
    end

    number[idx] = (0, number[idx][2] - 1)
    if idx < length(number)
        deleteat!(number, idx + 1)
    end
    return number
end

function split!(number, idx)
    (a, b) = Int(floor(number[idx][1] / 2)), Int(ceil(number[idx][1] / 2))

    number[idx] = (a, number[idx][2] + 1)
    insert!(number, idx + 1, (b, number[idx][2]))
    return number
end

function reduce!(number)
    while true
        to_explode = findfirst(n -> n[2] >= 5, number)

        if !isnothing(to_explode)
            explode!(number, to_explode)
            continue
        end

        to_split = findfirst(n -> n[1] >= 10, number)

        if !isnothing(to_split)
            split!(number, to_split)
            continue
        end

        break
    end
    return number
end

function magnitude(number)
    for d = 4:-1:1
        idx = findfirst(n -> n[2] == d, number)

        while !isnothing(idx)
            number[idx] = (3 * number[idx][1] + 2 * number[idx+1][1], d - 1)
            deleteat!(number, idx + 1)
            idx = findfirst(n -> n[2] == d, number)
        end
    end

    return number[1][1]
end

function dump(number)
    curr_d = 0

    for n in number
        while curr_d < n[2]
            curr_d += 1
            print('[')
        end

        while curr_d > n[2]
            curr_d -= 1
            print("] ")
        end

        print(n[1])
        print(' ')
    end
end

function part_one(input)
    number = reduce(input_to_number.(split(input, "\n"))) do l, r
        return reduce!(add(l, r))
    end
    return magnitude(number)
end

function part_two(input)
    numbers = input_to_number.(split(input, "\n"))

    adds = map(n -> reduce!(add(n...)), permutations(numbers, 2))

    return maximum(magnitude, adds)
end

function test()
    example2 = """[[[0,[4,5]],[0,0]],[[[4,5],[2,6]],[9,5]]]
[7,[[[3,7],[4,3]],[[6,3],[8,8]]]]
[[2,[[0,8],[3,4]]],[[[6,7],1],[7,[1,6]]]]
[[[[2,4],7],[6,[0,5]]],[[[6,8],[2,8]],[[2,1],[4,5]]]]
[7,[5,[[3,8],[1,4]]]]
[[2,[2,2]],[8,[8,1]]]
[2,9]
[1,[[[9,3],9],[[9,0],[0,7]]]]
[[[5,[7,4]],7],1]
[[[[4,2],2],6],[8,7]]"""


    example = """[[[0,[5,8]],[[1,7],[9,6]]],[[4,[1,2]],[[1,4],2]]]
[[[5,[2,8]],4],[5,[[9,9],0]]]
[6,[[[6,2],[5,6]],[[7,6],[4,7]]]]
[[[6,[0,7]],[0,9]],[4,[9,[9,0]]]]
[[[7,[6,4]],[3,[1,3]]],[[[5,5],1],9]]
[[6,[[7,3],[3,2]]],[[[3,8],[5,7]],4]]
[[[[5,4],[7,7]],8],[[8,3],8]]
[[9,3],[[9,9],[6,[4,9]]]]
[[2,[[7,7],7]],[[5,8],[[9,3],[0,2]]]]
[[[[5,2],5],[8,[3,7]]],[[5,[7,5]],[4,4]]]"""

    @test part_one(example) == 4140
    @test part_two(example) == 3993
end
