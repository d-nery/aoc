#include <bits/stdc++.h>

#include "../utils/utils.h"

using namespace std;

vector<Point> shortest_path(Grid<char> const& grid, Point const& from, Point const& to) {
    vector<Point> path{from};

    Point current = from;
    Point prev = {-1, -1};

    while (current != to) {
        for (auto& dir : directions) {
            auto next = current + dir;

            if (prev == next) {
                continue;
            }

            if (grid[next] != '#') {
                path.push_back(next);
                prev = current;
                current = next;
                break;
            }
        }
    }

    return path;
}

uint64_t solve(Input input, int max_shortcut_len, int min_shortcut_ps) {
    auto grid = input.grid();

    Point S = grid.find('S');
    Point E = grid.find('E');

    auto main_path = shortest_path(grid, S, E);

    int better = 0;
    for (size_t i = 0; i < main_path.size(); i++) {
        for (size_t j = i + 1; j < main_path.size(); j++) {
            auto dist = main_path[i].manhattan(main_path[j]);
            if (dist <= max_shortcut_len) {
                int shortcut = j - (i + dist);
                better += shortcut >= min_shortcut_ps;
            }
        }
    }

    return better;
}

uint64_t part1(Input input) {
    return solve(input, 2, 100);
}

uint64_t part2(Input input) {
    return solve(input, 20, 100);
}

void test() {
    string example = R"(###############
#...#...#.....#
#.#.#.#.#.###.#
#S#...#.#.#...#
#######.#.#.###
#######.#.#...#
#######.#.###.#
###..E#...#...#
###.#######.###
#...###...#...#
#.#####.#.###.#
#.#...#.#.#...#
#.#.#.#.#.#.###
#...#...#...###
###############)";

    assert(solve(Input::from_raw(example), 2, 10) == 10);
    assert(solve(Input::from_raw(example), 20, 50) == 285);
}
