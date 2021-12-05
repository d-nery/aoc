using Test

function build_lines(infos)
    size = [0, 0]
    pat = r"(\d+),(\d+) -> (\d+),(\d+)"

    lines = map(infos) do info
        (x1, y1, x2, y2) = parse.(Int, match(pat, info).captures) .+ 1

        size[1] = max(size[1], x1, x2)
        size[2] = max(size[2], y1, y2)

        return (x1, y1, x2, y2)
    end

    return (lines, size)
end

function is_vertical(line)
    (x1, _, x2, _) = line
    return x1 == x2
end

function is_horizontal(line)
    (_, y1, _, y2) = line
    return y1 == y2
end

function calculate_result(board)
    return (Iterators.flatten(board)
            |> collect
            |> (b -> filter(>=(2), b))
            |> length)
end

function build_board!(board, lines, diags = true)
    for line in lines
        (x1, y1, x2, y2) = line
        xs = x1 == x2 ? 1 : sign(x2 - x1)
        ys = y1 == y2 ? 1 : sign(y2 - y1)
        if is_vertical(line) || is_horizontal(line)
            board[x1:xs:x2, y1:ys:y2] .+= 1
        elseif diags
            coords = [(x1 + xs * i, y1 + ys * i) for i = 0:abs(x2 - x1)]
            for (x, y) in coords
                board[x, y] += 1
            end
        end
    end
end

function part_one(input)
    (lines, size) = build_lines(split(input, "\n"))
    board = zeros(size...)
    build_board!(board, lines, false)
    return calculate_result(board)
end

function part_two(input)
    (lines, size) = build_lines(split(input, "\n"))
    board = zeros(size...)
    build_board!(board, lines, true)
    return calculate_result(board)
end

function test()
    example = """0,9 -> 5,9
8,0 -> 0,8
9,4 -> 3,4
2,2 -> 2,1
7,0 -> 7,4
6,4 -> 2,0
0,9 -> 2,9
3,4 -> 1,4
0,0 -> 8,8
5,5 -> 8,2"""

    @test part_one(example) == 5
    @test part_two(example) == 12
end
