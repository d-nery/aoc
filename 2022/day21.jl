using Test
using Polynomials

function calculate(monkeys, key)
    v = monkeys[key]
    if contains(v, " ")
        (m1, op, m2) = split(v, " ")
        op = eval(Meta.parse(op))
        return Int(op(calculate(monkeys, m1), calculate(monkeys, m2)))
    end
    return parse(Int, v)
end

function build_expression(monkeys, key)
    v = monkeys[key]
    if contains(v, " ")
        (m1, op, m2) = split(v, " ")
        return "($(build_expression(monkeys, m1)) $op $(build_expression(monkeys, m2)))"
    end
    return v
end

function part_one(input)
    monkeys = Dict(split.(split(input, "\n"), ": "))
    return calculate(monkeys, "root")
end

function part_two(input)
    monkeys = Dict(split.(split(input, "\n"), ": "))
    monkeys["humn"] = "x"
    monkeys["root"] = replace(monkeys["root"], "+" => "-")

    eval(Meta.parse("x = variable(); p = " * build_expression(monkeys, "root")))

    return Int(round(roots(p)[1]))
end

function test()
    example = """root: pppw + sjmn
dbpl: 5
cczh: sllz + lgvd
zczc: 2
ptdq: humn - dvpt
dvpt: 3
lfqf: 4
humn: 5
ljgn: 2
sjmn: drzm * dbpl
sllz: 4
pppw: cczh / lfqf
lgvd: ljgn * ptdq
drzm: hmdt - zczc
hmdt: 32"""

    @test part_one(example) == 152
    @test part_two(example) == 301
end
