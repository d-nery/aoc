using Test
using CircularArrays

function dump(mixed)
    m = sort(mixed, by=m -> m[1])
    s = join(map(i -> i[2], m), " ")
    println(s)
end

function mix(numbers, n=1)
    t = length(numbers)
    mixed = collect(enumerate(numbers))

    # println("Mixing $t numbers")

    for _ in 1:n
        for idx in 1:t
            (i, v) = mixed[idx]

            if v == 0
                continue
            end

            ni = (i + v) % (t - 1)

            if (ni <= 0)
                ni = ni + t - 1
            end

            if (ni > t)
                ni = ni - t + 1
            end

            # println("Moving $v from $i to $ni")

            for idx2 in 1:t
                if idx == idx2
                    continue
                end

                (i2, v2) = mixed[idx2]
                if ni > i
                    if i < i2 <= ni
                        mixed[idx2] = (i2 - 1, v2)
                    end
                else
                    if ni <= i2 < i
                        mixed[idx2] = (i2 + 1, v2)
                    end
                end
            end

            mixed[idx] = (ni, v)

            if t == 7 # Just dump the test case
                dump(mixed)
            end
        end
    end

    sort!(mixed, by=m -> m[1])
    return CircularArray(map(i -> i[2], mixed))
end

function part_one(input)
    original = parse.(Int, split(input, "\n"))

    mixed = mix(original)
    idx0 = findfirst(i -> i == 0, mixed)

    return mixed[idx0+1000] + mixed[idx0+2000] + mixed[idx0+3000]
end

function part_two(input)
    original = parse.(Int, split(input, "\n")) .* 811589153
    mixed = mix(original, 10)
    idx0 = findfirst(i -> i == 0, mixed)

    return mixed[idx0+1000] + mixed[idx0+2000] + mixed[idx0+3000]
end

function test()
    example = """1
2
-3
3
-2
0
4"""

    @test part_one(example) == 3
    @test part_two(example) == 1623178306
end
