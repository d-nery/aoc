#include <bits/stdc++.h>

#include "../utils/grid.h"
#include "../utils/utils.h"

using namespace std;

static bool consider_visited = true;
int points(Grid<char>& grid, Point const& from, set<Point>& visited) {
    if (consider_visited) {
        visited.emplace(from);
    }

    if (grid[from] == '9') {
        return 1;
    }

    vector<Point> to_visit;
    for (auto& dir : directions) {
        auto next = from + dir;

        if (!grid.is_inside(next)) {
            continue;
        }

        if (grid[next] - grid[from] != 1) {
            continue;
        }

        if (consider_visited && visited.contains(next)) {
            continue;
        }

        to_visit.push_back(next);
    }

    int sum = 0;

    for (auto& p : to_visit) {
        sum += points(grid, p, visited);
    }

    return sum;
}

uint64_t part1(Input input) {
    auto grid = input.grid();

    int sum = 0;

    for (auto const& [v, point] : grid) {
        if (v == '0') {
            set<Point> visited;
            sum += points(grid, point, visited);
        }
    }

    return sum;
}

uint64_t part2(Input input) {
    consider_visited = false;
    return part1(input);
}

void test() {
    string example = R"(89010123
78121874
87430965
96549874
45678903
32019012
01329801
10456732)";

    assert(part1(Input::from_raw(example)) == 36);
    assert(part2(Input::from_raw(example)) == 81);
}
