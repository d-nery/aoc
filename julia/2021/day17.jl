using Test

function sim(x, y, target)
    pos = [0, 0]
    max_y = 0

    while true
        pos[1] += x
        pos[2] += y

        x = x < 0 ? x + 1 : x > 0 ? x - 1 : 0
        y -= 1

        max_y = max(max_y, pos[2])

        if target[1] <= pos[1] <= target[2] && target[3] <= pos[2] <= target[4]
            break
        end

        if pos[1] > target[2] || pos[2] < target[3]
            return false, max_y
        end
    end

    return true, max_y
end

function part_one(input)
    pat = r"^.+ x=(-?\d+)..(-?\d+), y=(-?\d+)..(-?\d+)$"
    target = parse.(Int, match(pat, input).captures)

    max_y = 0

    for x = 1:1000
        for y = -1000:1000
            ok, y = sim(x, y, target)
            if ok
                max_y = max(max_y, y)
            end
        end
    end

    return max_y
end

function part_two(input)
    pat = r"^.+ x=(-?\d+)..(-?\d+), y=(-?\d+)..(-?\d+)$"
    target = parse.(Int, match(pat, input).captures)

    oks = 0

    for x = 1:1000
        for y = -1000:1000
            ok, y = sim(x, y, target)
            if ok
                oks += 1
            end
        end
    end

    return oks
end

function test()
    example = """target area: x=20..30, y=-10..-5"""

    @test part_one(example) == 45
    @test part_two(example) == 112
end
