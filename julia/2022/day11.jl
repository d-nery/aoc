using Test

mutable struct Monkey
    items::Array{Int}
    op::Function
    dividend::Int
    ifTrue::Int
    ifFalse::Int
    inspected::Int
end

function parse_monkey(input)
    input = strip.(split(input, "\n"))
    items = parse.(Int, split(input[2][17:end], ", "))

    operation = split(input[3][22:end], " ")
    op = eval(Meta.parse(operation[1]))
    v = operation[2] == "old" ? -1 : parse(Int, operation[2])

    dividend = parse(Int, split(input[4], " ")[end])
    ifTrue = parse(Int, split(input[5], " ")[end])
    ifFalse = parse(Int, split(input[6], " ")[end])

    return Monkey(items, (old) -> op(old, v == -1 ? old : v), dividend, ifTrue, ifFalse, 0)
end

function part_one(input, rounds=20, worry_checker=(w) -> w ÷ 3)
    raw = split(input, "\n\n")
    monkeys = map(parse_monkey, raw)

    for round in 1:rounds
        for monkey in monkeys
            while length(monkey.items) > 0
                worry = popfirst!(monkey.items)
                worry = monkey.op(worry)
                worry = worry_checker(worry)
                idx = worry % monkey.dividend == 0 ? monkey.ifTrue : monkey.ifFalse

                push!(monkeys[idx+1].items, worry)
                monkey.inspected += 1
            end
        end
    end

    return *(sort!(map((m) -> m.inspected, monkeys))[end-1:end]...)
end

function part_two(input)
    raw = split(input, "\n\n")
    monkeys = map(parse_monkey, raw)

    mmc = *(map((m) -> m.dividend, monkeys)...)

    return part_one(input, 10000, (w) -> w % mmc)
end

function test()
    example = """Monkey 0:
Starting items: 79, 98
Operation: new = old * 19
Test: divisible by 23
    If true: throw to monkey 2
    If false: throw to monkey 3

Monkey 1:
Starting items: 54, 65, 75, 74
Operation: new = old + 6
Test: divisible by 19
    If true: throw to monkey 2
    If false: throw to monkey 0

Monkey 2:
Starting items: 79, 60, 97
Operation: new = old * old
Test: divisible by 13
    If true: throw to monkey 1
    If false: throw to monkey 3

Monkey 3:
Starting items: 74
Operation: new = old + 3
Test: divisible by 17
    If true: throw to monkey 0
    If false: throw to monkey 1"""

    @test part_one(example) == 10605
    @test part_two(example) == 2713310158
end
