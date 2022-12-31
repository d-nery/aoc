using Test

function snafu_to_decimal(input)
    input = reverse(input)
    n = 0
    for (idx, digit) in enumerate(input)
        if digit == '2'
            n += 2 * 5^(idx - 1)
        elseif digit == '1'
            n += 1 * 5^(idx - 1)
        elseif digit == '-'
            n += -1 * 5^(idx - 1)
        elseif digit == '='
            n += -2 * 5^(idx - 1)
        end
    end

    return n
end

function decimal_to_snafu(n)
    r = ""
    while n > 0
        n, rem = divrem(n, 5)
        if rem == 3
            n += 1
            r = "=" * r
        elseif rem == 4
            n += 1
            r = "-" * r
        else
            r = "$rem" * r
        end
    end

    return r
end

function part_one(input)
    return split(input, "\n") .|> snafu_to_decimal |> sum |> decimal_to_snafu
end

function part_two(input)
    return 0
end

function test()
    example = """1=-0-2
12111
2=0=
21
2=01
111
20012
112
1=-1=
1-12
12
1=
122"""

    @test part_one(example) == "2=-1=0"
    @test part_two(example) == 0
end
