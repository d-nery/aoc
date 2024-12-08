#include <bits/stdc++.h>
#include <ranges>

#include "../utils/utils.h"

using namespace std;
using Grid = vector<string>;

struct Point {
    int x, y;

    Point operator+(const Point& other) { return Point{x + other.x, y + other.y}; }
    Point operator-(const Point& other) { return Point{x - other.x, y - other.y}; }
    string to_string() { return format("{},{}", x, y); }
};

int solve(Grid& grid, function<void(set<string>&, Point&, Point&)> antinode_handler) {
    int max_i = grid.size();
    int max_j = grid[0].size();

    map<char, vector<Point>> antennas;
    set<string> antinodes;

    for (int i = 0; i < max_i; i++) {
        for (int j = 0; j < max_j; j++) {
            char c = grid[i][j];

            if (c == '.') {
                continue;
            }

            if (!antennas.contains(c)) {
                antennas[c] = {};
            }

            antennas[c].push_back(Point{i, j});
        }
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

int part1(Input input) {
    auto grid = input.lines();

    int max_i = grid.size();
    int max_j = grid[0].size();

    return solve(grid, [&](set<string>& antinodes, Point& p1, Point& p2) {
        auto diff = p2 - p1;
        auto a1 = p1 - diff;
        auto a2 = p2 + diff;

        if (a1.x >= 0 && a1.x < max_i && a1.y >= 0 && a1.y < max_j) {
            antinodes.emplace(a1.to_string());
        }

        if (a2.x >= 0 && a2.x < max_i && a2.y >= 0 && a2.y < max_j) {
            antinodes.emplace(a2.to_string());
        }
    });
}

int part2(Input input) {
    auto grid = input.lines();

    int max_i = grid.size();
    int max_j = grid[0].size();

    return solve(grid, [&](set<string>& antinodes, Point& p1, Point& p2) {
        auto diff = p2 - p1;

        auto a1 = p1 - diff;
        auto a2 = p2 + diff;

        antinodes.emplace(p1.to_string());
        antinodes.emplace(p2.to_string());

        while (a1.x >= 0 && a1.x < max_i && a1.y >= 0 && a1.y < max_j) {
            antinodes.emplace(a1.to_string());
            a1 = a1 - diff;
        }

        while (a2.x >= 0 && a2.x < max_i && a2.y >= 0 && a2.y < max_j) {
            antinodes.emplace(a2.to_string());
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
