using Test

function board_to_matrix(board)
    b = split.(strip.(split(board, "\n")), r"\s+")
    intb = map(c -> parse.(Int, c), b)

    return reduce(hcat, intb)
end

function input_to_numbers_and_boards(input)
    (numbers, boards...) = split(input, "\n\n")
    numbers = parse.(Int, split(numbers, ","))
    boards = map(board_to_matrix, boards)

    return (numbers, boards)
end

function is_winning_board(board, numbers)
    matches = in(numbers).(board)
    rows = sum(matches, dims = 1)
    columns = sum(matches, dims = 2)

    return any(rows .== 5) || any(columns .== 5)
end

function is_game_over(boards, numbers)
    return any(b -> is_winning_board(b, numbers), boards)
end

function calculate_result(board, called_numbers)
    return (Iterators.flatten(board)
            |> collect
            |> (b -> filter(n -> !(n in called_numbers), b))
            |> sum
    ) * called_numbers[end]
end

function part_one(input)
    numbers, boards = input_to_numbers_and_boards(input)

    called_numbers = numbers[1:5]
    numbers = numbers[6:end]

    while !is_game_over(boards, called_numbers)
        push!(called_numbers, popfirst!(numbers))
    end

    board = first(filter(b -> is_winning_board(b, called_numbers), boards))

    return calculate_result(board, called_numbers)
end

function part_two(input)
    numbers, boards = input_to_numbers_and_boards(input)

    called_numbers = numbers[1:5]
    numbers = numbers[6:end]

    while length(boards) > 1
        push!(called_numbers, popfirst!(numbers))
        boards = filter(b -> !is_winning_board(b, called_numbers), boards)
    end

    while !is_winning_board(boards[1], called_numbers)
        push!(called_numbers, popfirst!(numbers))
    end

    return calculate_result(boards[1], called_numbers)
end

function test()
    example = """7,4,9,5,11,17,23,2,0,14,21,24,10,16,13,6,15,25,12,22,18,20,8,19,3,26,1

22 13 17 11  0
8  2 23  4 24
21  9 14 16  7
6 10  3 18  5
1 12 20 15 19

3 15  0  2 22
9 18 13 17  5
19  8  7 25 23
20 11 10 24  4
14 21 16 12  6

14 21 17 24  4
10 16 15  9 19
18  8 23 26 20
22 11 13  6  5
2  0 12  3  7"""

    @test part_one(example) == 4512
    @test part_two(example) == 1924
end
