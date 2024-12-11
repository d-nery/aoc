#include <bits/stdc++.h>
#include <ranges>

#include "../utils/utils.h"

using namespace std;

static int blinks = 25;

vector<uint64_t> blink(vector<uint64_t> const& stones) {
    vector<uint64_t> new_stones;

    for (auto& s : stones) {
        if (s == 0) {
            new_stones.push_back(1);
            continue;
        }

        if (size_t length = to_string(s).length(); !(length & 1)) {
            int digits = pow(10, length / 2);
            new_stones.push_back(s / digits);
            new_stones.push_back(s % digits);
            continue;
        }

        new_stones.push_back(s * 2024);
    }

    return new_stones;
}

uint64_t part1(Input input) {
    auto stones = input.lines()[0] | ranges::views::split(' ') | ranges::views::transform([](auto x) { return stoll(ranges::to<string>(x)); }) |
                  ranges::to<vector<uint64_t>>();

    for (int i{}; i < blinks; i++) {
        stones = blink(stones);
    }

    return stones.size();
}

static map<pair<uint64_t, int>, uint64_t> depth_map;

uint64_t blink_memo(uint64_t stone, int depth) {
    if (depth_map.contains({stone, depth})) {
        return depth_map[{stone, depth}];
    }

    if (depth == blinks) {
        return 1;
    }

    uint64_t value;
    if (stone == 0) {
        value = blink_memo(1, depth + 1);
    } else if (size_t length = to_string(stone).length(); !(length & 1)) {
        int digits = pow(10, length / 2);
        value = blink_memo(stone / digits, depth + 1) + blink_memo(stone % digits, depth + 1);
    } else {
        value = blink_memo(stone * 2024, depth + 1);
    }

    depth_map[{stone, depth}] = value;
    return value;
}

uint64_t part2(Input input) {
    blinks = 75;

    auto stones = input.lines()[0] | ranges::views::split(' ') | ranges::views::transform([](auto x) { return stoll(ranges::to<string>(x)); }) |
                  ranges::to<vector<uint64_t>>();

    uint64_t total = 0;
    for (auto& stone : stones) {
        total += blink_memo(stone, 0);
    }

    return total;
}

void test() {
    string example = R"(125 17)";

    assert(part1(Input::from_raw(example)) == 55312);
    assert(part2(Input::from_raw(example)) == 65601038650482);
}
