#include <bits/stdc++.h>

#include "../utils/utils.h"

using namespace std;

// from / to  0     1     2     3     4     5     6     7     8     9     A
//        0         ^<    ^     ^>    ^^<   ^^    ^^>   ^^^<  ^^^   ^^^>  >
//        1   >v          >     >>    ^     ^>    ^>>   ^^    ^^>   ^^>>  >>v
//        2   v     <           >     ^<    ^     ^>    ^^<   ^^    ^^>   >v
//        3   <v    <<    <           ^<<   ^<    ^     ^^<<  ^^<   ^^    v
//        4   >vv   v     >v    >>v         >     >>    ^     ^>    ^>>   >>vv
//        5   vv    v<    v     v>    <           >     ^<    ^     ^>    >vv
//        6   <vv   <<v   <v    v     <<    <           ^<<   ^<    ^     vv
//        7   >vvv  vv    >vv   >>vv  v     >v    >>v         >     >>    >>vvv
//        8   vvv   <vv   vv    >vv   <v    v     >v    <           >     >vvv
//        9   <vvv  <<vv  <vv   vv    <<v   <v    v     <<    <           vvv
//        A   <     ^<<   ^<    ^     ^^<<  ^^<   ^^    ^^^<< ^^^<  ^^^

// +---+---+---+        +---+---+
// | 7 | 8 | 9 |        | ^ | A |
// +---+---+---+    +---+---+---+
// | 4 | 5 | 6 |    | < | v | > |
// +---+---+---+    +---+---+---+
// | 1 | 2 | 3 |
// +---+---+---+
//     | 0 | A |
//     +---+---+

static vector<vector<string>> numpad_moves = {
    {"", "^<", "^", "^>", "^^<", "^^", "^^>", "^^^<", "^^^", "^^^>", ">"},    // 0
    {">v", "", ">", ">>", "^", "^>", "^>>", "^^", "^^>", "^^>>", ">>v"},      // 1
    {"v", "<", "", ">", "<^", "^", "^>", "<^^", "^^", "^^>", "v>"},           // 2
    {"<v", "<<", "<", "", "<<^", "<^", "^", "<<^^", "<^^", "^^", "v"},        // 3
    {">vv", "v", ">v", ">>v", "", ">", ">>", "^", "^>", "^>>", ">>vv"},       // 4
    {"vv", "<v", "v", "v>", "<", "", ">", "<^", "^", "^>", "vv>"},            // 5
    {"<vv", "<<v", "<v", "v", "<<", "<", "", "<<^", "<^", "^", "vv"},         // 6
    {">vvv", "vv", "vv>", ">>vv", "v", "v>", "v>>", "", ">", ">>", ">>vvv"},  // 7
    {"vvv", "<vv", "vv", "vv>", "<v", "v", "v>", "<", "", ">", "vvv>"},       // 8
    {"<vvv", "<<vv", "<vv", "vv", "<<v", "<v", "v", "<<", "<", "", "vvv"},    // 9
    {"<", "^<<", "<^", "^", "^^<<", "<^^", "^^", "^^^<<", "<^^^", "^^^", ""}, // A
};

static vector<vector<string>> arrow_moves = {
    {"", "v>", "v", "v<", ">"},   // ^
    {"<^", "", "<", "<<", "^"},   // >
    {"^", ">", "", "<", "^>"},    // v
    {">^", ">>", ">", "", ">>^"}, // <
    {"<", "v", "<v", "v<<", ""},  // A
};

constexpr int to_idx(char c) {
    return min(c - '0', 10);
}

constexpr int to_idx_arr(char c) {
    return c == '^' ? 0 : c == '>' ? 1 : c == 'v' ? 2 : c == '<' ? 3 : 4;
}

uint64_t part1(Input input) {
    auto lines = input.lines();

    uint64_t sum = 0;
    for (auto& code : lines) {
        char at = 'A';
        string moves;
        for (auto& c : code) {
            moves += numpad_moves[to_idx(at)][to_idx(c)] + "A";
            at = c;
        }

        string r1;
        at = 'A';
        for (auto& c : moves) {
            r1 += arrow_moves[to_idx_arr(at)][to_idx_arr(c)] + "A";
            at = c;
        }

        string r2;
        at = 'A';
        for (auto& c : r1) {
            r2 += arrow_moves[to_idx_arr(at)][to_idx_arr(c)] + "A";
            at = c;
        }

        int v;
        sscanf(code.c_str(), "%dA", &v);
        sum += v * r2.length();
    }

    return sum;
}

constexpr auto robot_amount = 25;
uint64_t getCount(string input, int robot) {
    // input -> count for robot in each depth (idx = depth)
    static unordered_map<string, vector<uint64_t>> count_cache;

    if (count_cache.contains(input) && count_cache[input][robot - 1] != 0) {
        return count_cache[input][robot - 1];
    } else if (!count_cache.contains(input)) {
        count_cache[input] = vector<uint64_t>(robot_amount);
    }

    string sequence;       // complete sequence
    vector<string> steps;  // each step back to A
    char at = 'A';
    for (auto& c : input) {
        string move = arrow_moves[to_idx_arr(at)][to_idx_arr(c)] + "A";
        steps.push_back(move);
        sequence += move;
        at = c;
    }

    count_cache[input][0] = sequence.size();

    if (robot == robot_amount) {
        return sequence.size();
    }

    uint64_t count = 0;
    for (auto& step : steps) {
        auto c = getCount(step, robot + 1);
        count += c;
    }

    count_cache[input][robot - 1] = count;
    return count;
}

uint64_t part2(Input input) {
    auto lines = input.lines();

    uint64_t sum = 0;
    for (auto& code : lines) {
        char at = 'A';
        string moves;
        for (auto& c : code) {
            moves += numpad_moves[to_idx(at)][to_idx(c)] + "A";
            at = c;
        }

        auto count = getCount(moves, 1);

        int v;
        sscanf(code.c_str(), "%dA", &v);
        sum += uint64_t(v) * count;
    }

    return sum;
}

void test() {
    string example = R"(029A
980A
179A
456A
379A)";

    assert(part1(Input::from_raw(example)) == 126384);
    assert(part2(Input::from_raw(example)) == 154115708116294);
}
