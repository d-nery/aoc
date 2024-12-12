#include <bits/stdc++.h>
#include <ranges>

#include "../utils/grid.h"
#include "../utils/utils.h"

using namespace std;

int solve(Grid<char>& grid, function<void(set<Point>&, Point&, Point&)> antinode_handler) {
    map<char, vector<Point>> antennas;
    set<Point> antinodes;

    for (auto const& [c, point] : grid) {
        if (c == '.') {
            continue;
        }

        if (!antennas.contains(c)) {
            antennas[c] = {};
        }

        antennas[c].push_back(point);
    }

    for (auto& [_, locs] : antennas) {
        for (int l = 0; l < (int)locs.size() - 1; l++) {
            for (int other = l + 1; other < (int)locs.size(); other++) {
                auto p1 = locs[l];
                auto p2 = locs[other];

                antinode_handler(antinodes, p1, p2);
            }
        }
    }

    return antinodes.size();
}

uint64_t part1(Input input) {
    auto grid = input.grid();

    return solve(grid, [&](set<Point>& antinodes, Point& p1, Point& p2) {
        auto diff = p2 - p1;
        auto a1 = p1 - diff;
        auto a2 = p2 + diff;

        if (grid.is_inside(a1)) {
            antinodes.emplace(a1);
        }

        if (grid.is_inside(a2)) {
            antinodes.emplace(a2);
        }
    });
}

uint64_t part2(Input input) {
    auto grid = input.grid();

    return solve(grid, [&](set<Point>& antinodes, Point& p1, Point& p2) {
        auto diff = p2 - p1;

        auto a1 = p1 - diff;
        auto a2 = p2 + diff;

        antinodes.emplace(p1);
        antinodes.emplace(p2);

        while (grid.is_inside(a1)) {
            antinodes.emplace(a1);
            a1 = a1 - diff;
        }

        while (grid.is_inside(a2)) {
            antinodes.emplace(a2);
            a2 = a2 + diff;
        }
    });
}

void test() {
    string example = R"(............
........0...
.....0......
.......0....
....0.......
......A.....
............
............
........A...
.........A..
............
............)";

    assert(part1(Input::from_raw(example)) == 14);
    assert(part2(Input::from_raw(example)) == 34);
}
