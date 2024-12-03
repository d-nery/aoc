#include <bits/stdc++.h>

#include "../utils/utils.h"

using namespace std;

int part1(Input input) {
    regex pattern("mul\\(\\d+,\\d+\\)");
    regex pattern_digits("(\\d+),(\\d+)");

    int sum = 0;
    for (auto& line : input.lines()) {
        smatch matches;

        for (auto i = sregex_iterator(line.begin(), line.end(), pattern); i != sregex_iterator(); i++) {
            auto value = i->str();
            smatch match;
            regex_search(value, match, pattern_digits);

            int a = stoi(match.str(1));
            int b = stoi(match.str(2));

            sum += a * b;
        }
    }

    return sum;
}

int part2(Input input) {
    regex pattern("(mul\\(\\d+,\\d+\\)|do\\(\\)|don't\\(\\))");
    regex pattern_digits("(\\d+),(\\d+)");

    bool enabled = true;
    int sum = 0;
    for (auto& line : input.lines()) {
        smatch matches;

        for (auto i = sregex_iterator(line.begin(), line.end(), pattern); i != sregex_iterator(); i++) {
            auto value = i->str();

            if (value == "do()") {
                enabled = true;
                continue;
            }

            if (value == "don't()") {
                enabled = false;
                continue;
            }

            if (!enabled) {
                continue;
            }

            smatch match;
            regex_search(value, match, pattern_digits);

            int a = stoi(match.str(1));
            int b = stoi(match.str(2));

            sum += a * b;
        }
    }

    return sum;
}

void test() {
    string example = R"(xmul(2,4)%&mul[3,7]!@^do_not_mul(5,5)+mul(32,64]then(mul(11,8)mul(8,5)))";
    string example2 = "xmul(2,4)&mul[3,7]!^don't()_mul(5,5)+mul(32,64](mul(11,8)undo()?mul(8,5))";

    assert(part1(Input::from_raw(example)) == 161);
    assert(part2(Input::from_raw(example2)) == 48);
}
