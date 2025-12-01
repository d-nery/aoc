#include <bits/stdc++.h>
#include <ranges>

#include "../utils/grid.h"
#include "../utils/utils.h"

using namespace std;

static std::map<char, Point> dir_map = {
    {'^', Point(-1, 0)}, {'>', Point(0, 1)}, {'v', Point(1, 0)}, {'<', Point(0, -1)}, {'[', Point(0, 1)}, {']', Point(0, -1)},
};

bool move(Grid<char>& grid, char& direction, Point at) {
    auto c = grid[at];
    auto next = at + dir_map[direction];

    if (c == '#') {
        return false;
    }

    if (c == '.') {
        return true;
    }

    if (move(grid, direction, next)) {
        grid[at] = '.';
        grid[next] = c;
        return true;
    }

    return false;
}

uint64_t part1(Input input) {
    auto split = ranges::split_view(input.raw(), "\n\n"sv) | ranges::to<vector<string>>();
    auto grid = Input::from_raw(split[0]).grid();
    auto instructions = regex_replace(split[1], regex("\\n"), "");

    Point init;

    for (auto const& [c, p] : grid) {
        if (c == '@') {
            init = p;
            break;
        }
    }

    for (auto& i : instructions) {
        if (move(grid, i, init)) {
            init = init + dir_map[i];
        }
    }

    int sum = 0;
    for (auto const& [c, p] : grid) {
        if (c == 'O') {
            sum += 100 * p.x + p.y;
        }
    }

    return sum;
}

bool can_move(Grid<char>& grid, char& direction, Point at) {
    auto next = at + dir_map[direction];

    switch (grid[at]) {
    case '.':
        return true;
    case '#':
        return false;
    case '@':
        return can_move(grid, direction, at + dir_map[direction]);
    default:
        return can_move(grid, direction, next) && can_move(grid, direction, next + dir_map[grid[at]]);
    }
}

bool move_scaled(Grid<char>& grid, char& direction, Point at) {
    if (direction == '<' || direction == '>') {
        return move(grid, direction, at);
    }

    auto c = grid[at];
    auto next = at + dir_map[direction];

    if (c == '.') {
        return true;
    }

    if (c == '#') {
        return false;
    }

    if (c == '@') {
        if (can_move(grid, direction, next)) {
            move_scaled(grid, direction, next);
            grid[at] = '.';
            grid[next] = c;
            return true;
        }

        return false;
    }

    // c either [ or ]

    auto other_side = next + dir_map[c];
    if (can_move(grid, direction, next) && can_move(grid, direction, other_side)) {
        move_scaled(grid, direction, next);
        move_scaled(grid, direction, other_side);

        grid[at] = '.';
        grid[at + dir_map[c]] = '.';

        grid[next] = c;
        grid[other_side] = c == '[' ? ']' : '[';
        return true;
    }

    return false;
}

uint64_t part2(Input input) {
    auto raw = regex_replace(input.raw(), regex("#"), "##");
    raw = regex_replace(raw, regex("\\."), "..");
    raw = regex_replace(raw, regex("O"), "[]");
    raw = regex_replace(raw, regex("@"), "@.");

    auto split = ranges::split_view(raw, "\n\n"sv) | ranges::to<vector<string>>();
    auto grid = Input::from_raw(split[0]).grid();
    auto instructions = regex_replace(split[1], regex("\\n"), "");

    Point init;

    for (auto const& [c, p] : grid) {
        if (c == '@') {
            init = p;
            break;
        }
    }

    for (auto& i : instructions) {
        if (move_scaled(grid, i, init)) {
            init = init + dir_map[i];
        }
    }

    int sum = 0;
    for (auto const& [c, p] : grid) {
        if (c == '[') {
            sum += 100 * p.x + p.y;
        }
    }

    return sum;
}

void test() {
    string example = R"(##########
#..O..O.O#
#......O.#
#.OO..O.O#
#..O@..O.#
#O#..O...#
#O..O..O.#
#.OO.O.OO#
#....O...#
##########

<vv>^<v^>v>^vv^v>v<>v^v<v<^vv<<<^><<><>>v<vvv<>^v^>^<<<><<v<<<v^vv^v>^
vvv<<^>^v^^><<>>><>^<<><^vv^^<>vvv<>><^^v>^>vv<>v<<<<v<^v>^<^^>>>^<v<v
><>vv>v^v^<>><>>>><^^>vv>v<^^^>>v^v^<^^>v^^>v^<^v>v<>>v^v^<v>v^^<^^vv<
<<v<^>>^^^^>>>v^<>vvv^><v<<<>^^^vv^<vvv>^>v<^^^^v<>^>vvvv><>>v^<<^^^^^
^><^><>>><>^^<<^^v>>><^<v>^<vv>>v>>>^v><>^v><<<<v>>v<v<v>vvv>^<><<>^><
^>><>^v<><^vvv<^^<><v<<<<<><^v<<<><<<^^<v<^^^><^>>^<v^><<<^>>^v<v^v<v^
>^>>^v>vv>^<<^v<>><<><<v<<v><>v<^vv<<<>^^v^>^^>>><<^v>>v^v><^^>>^<>vv^
<><^^>^^^<><vvvvv^v<v<<>^v<v>v<<^><<><<><<<^^<<<^<<>><<><^^^>^^<>^>v<>
^^>vv<^v^v<vv>^<><v<^v>^^^>>>^^vvv^>vvv<>>>^<^>>>>>^<<^v>^vvv<>^<><<v>
v^^>>><<^^<>>^v^<v^vv<>v^<<>^<^v^v><^<<<><<^<v><v<>vv>>v><v^<vv<>v^<<^)";

    string example2 = R"(########
#..O.O.#
##@.O..#
#...O..#
#.#.O..#
#...O..#
#......#
########

<^^>>>vv<v>>v<<)";

    assert(part1(Input::from_raw(example)) == 10092);
    assert(part1(Input::from_raw(example2)) == 2028);
    assert(part2(Input::from_raw(example)) == 9021);
}
