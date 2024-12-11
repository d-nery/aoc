#include <bits/stdc++.h>
#include <ranges>

#include "../utils/utils.h"

using namespace std;

static bool include_concat = false;

bool check_result(uint64_t target, uint64_t acc, size_t idx, vector<int> const& numbers) {
    if (idx == numbers.size()) {
        return acc == target;
    }

    // All operations increase the number
    if (acc > target) {
        return false;
    }

    int next = numbers[idx];

    bool sum = check_result(target, acc + next, idx + 1, numbers);
    bool mul = check_result(target, acc * next, idx + 1, numbers);
    bool concat = (include_concat && check_result(target, stoll(to_string(acc) + to_string(next)), idx + 1, numbers));

    return sum || mul || concat;
}

uint64_t part1(Input input) {
    uint64_t sum = 0;

    for (auto& line : input.lines()) {
        auto idx = line.find(':');
        uint64_t result = stoll(line.substr(0, idx));

        auto values = line.substr(idx + 2) | ranges::views::split(' ') |
                      ranges::views::transform([](auto x) { return stoi(ranges::to<string>(x)); }) | ranges::to<vector<int>>();

        if (check_result(result, values[0], 1, values)) {
            sum += result;
        }
    }

    // int return limitation, print here
    cout << sum << endl;

    return sum;
}

uint64_t part2(Input input) {
    include_concat = true;
    return part1(input);
}

void test() {
    string example = R"(190: 10 19
3267: 81 40 27
83: 17 5
156: 15 6
7290: 6 8 6 15
161011: 16 10 13
192: 17 8 14
21037: 9 7 18 13
292: 11 6 16 20)";

    assert(part1(Input::from_raw(example)) == 3749);
    assert(part2(Input::from_raw(example)) == 11387);
}
