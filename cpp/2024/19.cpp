#include <bits/stdc++.h>
#include <ranges>

#include "../utils/utils.h"

using namespace std;

bool can_be_designed(set<string> const& patterns, string design) {
    static map<string, bool> values;

    if (design.empty()) {
        return true;
    }

    if (!values.contains(design)) {
        values[design] = false;
        for (auto& pat : patterns) {
            if (design.starts_with(pat) && can_be_designed(patterns, design.substr(pat.size()))) {
                values[design] = true;
                return true;
            }
        }
    }

    return values[design];
}

uint64_t part1(Input input) {
    auto lines = input.lines();
    auto patterns = ranges::split_view(lines[0], ", "sv) | ranges::to<set<string>>();

    int possible = 0;
    for (auto it = lines.begin() + 2; it != lines.end(); it++) {
        possible += can_be_designed(patterns, *it);
    }

    return possible;
}

uint64_t design_possibilities(set<string> const& patterns, string design) {
    static map<string, uint64_t> values;

    if (design.empty()) {
        return 1;
    }

    if (!values.contains(design)) {
        uint64_t sum = 0;
        for (auto& pat : patterns) {
            if (design.starts_with(pat)) {
                sum += design_possibilities(patterns, design.substr(pat.size()));
            }
        }
        values[design] = sum;
    }

    return values[design];
}

uint64_t part2(Input input) {
    auto lines = input.lines();
    auto patterns = ranges::split_view(lines[0], ", "sv) | ranges::to<set<string>>();

    uint64_t possible = 0;
    for (auto it = lines.begin() + 2; it != lines.end(); it++) {
        possible += design_possibilities(patterns, *it);
    }

    return possible;
}

void test() {
    string example = R"(r, wr, b, g, bwu, rb, gb, br

brwrr
bggr
gbbr
rrbgbr
ubwu
bwurrg
brgr
bbrgwb)";

    assert(part1(Input::from_raw(example)) == 6);
    assert(part2(Input::from_raw(example)) == 16);
}
