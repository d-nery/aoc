#include <bits/stdc++.h>
#include <ranges>

#include "../utils/utils.h"

using namespace std;

static bool sum_unordered = false;

uint64_t part1(Input input) {
    map<int, set<int>> rules;

    int sum = 0;

    bool reading_rules = true;
    for (auto& line : input.lines()) {
        if (reading_rules) {
            if (line == "") {
                reading_rules = false;
                continue;
            }

            int n1, n2;
            sscanf(line.c_str(), "%d|%d", &n1, &n2);

            if (!rules.contains(n1)) {
                rules[n1] = set<int>();
            }

            rules[n1].emplace(n2);
            continue;
        }

        auto reading = line | ranges::views::split(',') | ranges::views::transform([](auto x) { return stoi(ranges::to<string>(x)); }) |
                       ranges::to<vector<int>>();

        auto original(reading);

        sort(reading.begin(), reading.end(), [&](int& n1, int& n2) { return rules.contains(n1) && rules[n1].contains(n2); });

        if (sum_unordered) {
            if (original != reading) {
                sum += reading[reading.size() / 2];
            }
        } else {
            if (original == reading) {
                sum += original[original.size() / 2];
            }
        }
    }

    return sum;
}

uint64_t part2(Input input) {
    sum_unordered = true;
    return part1(input);
}

void test() {
    string example = R"(47|53
97|13
97|61
97|47
75|29
61|13
75|53
29|13
97|29
53|29
61|53
97|53
61|29
47|13
75|47
97|75
47|61
75|61
47|29
75|13
53|13

75,47,61,53,29
97,61,53,29,13
75,29,13
75,97,47,61,53
61,13,29
97,13,75,29,47)";

    assert(part1(Input::from_raw(example)) == 143);
    assert(part2(Input::from_raw(example)) == 123);
}
