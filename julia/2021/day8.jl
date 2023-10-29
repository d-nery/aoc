using Test
# using DataStructures

function part_one(input)
    return (split(input, "\n")
            .|> (s -> split(s, " | "))
            |> (s -> map(o -> split(o[2], " "), s))
            |> Iterators.flatten
            |> collect
            |> (c -> filter(o -> 2 <= length(o) <= 4 || length(o) == 7, c))
            |> length)
end

function part_two(input)
    inputs = split.(split(input, "\n"), " | ")

    sum = 0
    for input in inputs
        set_input = Set.(split(join(input, " "), " "))
        mapping = Dict(map(n -> (n, Set()), 0:9))

        for known in set_input
            if length(known) == 2
                push!(mapping[1], known...)
            elseif length(known) == 3
                push!(mapping[7], known...)
            elseif length(known) == 4
                push!(mapping[4], known...)
            elseif length(known) == 7
                push!(mapping[8], known...)
            end
        end

        for six in set_input
            if (length(six) != 6)
                continue
            end
            if length(six ∩ mapping[1]) == 1
                push!(mapping[6], six...)
            elseif length(six ∩ mapping[4]) == 3
                push!(mapping[0], six...)
            else
                push!(mapping[9], six...)
            end
        end

        e = pop!(setdiff(mapping[8], mapping[9]))
        for five in set_input
            if (length(five) != 5)
                continue
            end
            if length(five ∩ mapping[1]) == 2
                push!(mapping[3], five...)
            elseif e in five
                push!(mapping[2], five...)
            else
                push!(mapping[5], five...)
            end
        end

        output = Set.(split(input[2], " "))
        for (i, o) in enumerate(output)
            n = first(filter(kv -> kv.second == o, mapping)).first
            sum += n * (10^(4 - i))
        end
    end

    return sum
end



function test()
    example = """be cfbegad cbdgef fgaecd cgeb fdcge agebfd fecdb fabcd edb | fdgacbe cefdb cefbgd gcbe
edbfga begcd cbg gc gcadebf fbgde acbgfd abcde gfcbed gfec | fcgedb cgb dgebacf gc
fgaebd cg bdaec gdafb agbcfd gdcbef bgcad gfac gcb cdgabef | cg cg fdcagb cbg
fbegcd cbd adcefb dageb afcb bc aefdc ecdab fgdeca fcdbega | efabcd cedba gadfec cb
aecbfdg fbg gf bafeg dbefa fcge gcbea fcaegb dgceab fcbdga | gecf egdcabf bgf bfgea
fgeab ca afcebg bdacfeg cfaedg gcfdb baec bfadeg bafgc acf | gebdcfa ecba ca fadegcb
dbcfg fgd bdegcaf fgec aegbdf ecdfab fbedc dacgb gdcebf gf | cefg dcbef fcge gbcadfe
bdfegc cbegaf gecbf dfcage bdacg ed bedf ced adcbefg gebcd | ed bcgafe cdgba cbgef
egadfb cdbfeg cegd fecab cgb gbdefca cg fgcdab egfdb bfceg | gbdfcae bgc cg cgb
gcafb gcf dcaebfg ecagb gf abcdeg gaef cafbge fdbac fegbdc | fgae cfgab fg bagce"""

    @test part_one(example) == 26
    @test part_two(example) == 61229
end
