using Test

function part_one(input)
    rules = split(input, "\n")
    rule_pattern = r"^(?<min>\d+)-(?<max>\d+) (?<letter>.): (?<password>.+)$"

    return reduce((r, e) -> begin
            m = match(rule_pattern, e)
            letters = count(l -> l == m["letter"][1], m["password"])
            return r + (parse(Int, m["min"]) <= letters <= parse(Int, m["max"]) ? 1 : 0)
        end, rules; init = 0)
end

function part_two(input)
    rules = split(input, "\n")
    rule_pattern = r"^(?<min>\d+)-(?<max>\d+) (?<letter>.): (?<password>.+)$"

    return reduce((r, e) -> begin
            m = match(rule_pattern, e)
            pos1 = parse(Int, m["min"])
            pos2 = parse(Int, m["max"])

            return r + (
                (m["password"][pos1] == m["letter"][1] != m["password"][pos2]) ||
                m["password"][pos2] == m["letter"][1] != m["password"][pos1] ? 1 : 0)
        end, rules; init = 0)
end

function test()
    example = """1-3 a: abcde
1-3 b: cdefg
2-9 c: ccccccccc"""

    @test part_one(example) == 2
    @test part_two(example) == 1
end
