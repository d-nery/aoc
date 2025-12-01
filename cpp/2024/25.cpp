#include <bits/stdc++.h>
#include <ranges>

#include "../utils/utils.h"

using namespace std;

uint64_t part1(Input input) {
    auto lines = input.lines();

    vector<array<int, 5>> keys;
    vector<array<int, 5>> locks;

    for (int i = 0; i < (int)lines.size(); i += 8) {
        array<int, 5> lock_or_key{0, 0, 0, 0, 0};

        for (int j = 1; j <= 5; j++) {
            for (int k = 0; k < 5; k++) {
                lock_or_key[k] += lines[i + j][k] == '#';
            }
        }

        if (lines[i][0] == '.') {
            keys.push_back(lock_or_key);
        } else {
            locks.push_back(lock_or_key);
        }
    }

    uint64_t count = 0;
    for (auto& key : keys) {
        for (auto& lock : locks) {
            count++;
            for (int i = 0; i < 5; i++) {
                if (key[i] + lock[i] >= 6) {
                    count--;
                    break;
                }
            }
        }
    }

    return count;
}

uint64_t part2(Input input) {
    return 0;
}

void test() {
    string example = R"(#####
.####
.####
.####
.#.#.
.#...
.....

#####
##.##
.#.##
...##
...#.
...#.
.....

.....
#....
#....
#...#
#.#.#
#.###
#####

.....
.....
#.#..
###..
###.#
###.#
#####

.....
.....
.....
#....
#.#..
#.#.#
#####)";

    assert(part1(Input::from_raw(example)) == 3);
    assert(part2(Input::from_raw(example)) == 0);
}

/**

 */
