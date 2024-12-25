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

static vector<vector<string>> numpad_moves = {
    {"", "^<", "^", "^>", "^^<", "^^", "^^>", "^^^<", "^^^", "^^^>", ">"},    // 0
    {">v", "", ">", ">>", "^", "^>", "^>>", "^^", "^^>", "^^>>", ">>v"},      // 1
    {"v", "<", "", ">", "<^", "^", "^>", "<^^", "^^", "^^>", ">v"},           // 2
    {"<v", "<<", "<", "", "<<^", "<^", "^", "<<^^", "<^^", "^^", "v"},        // 3
    {">vv", "v", ">v", ">>v", "", ">", ">>", "^", "^>", "^>>", ">>vv"},       // 4
    {"vv", "<v", "v", ">v", "<", "", ">", "<^", "^", "^>", ">vv"},            // 5
    {"<vv", "<<v", "<v", "v", "<<", "<", "", "<<^", "<^", "^", "vv"},         // 6
    {">vvv", "vv", ">vv", ">>vv", "v", ">v", ">>v", "", ">", ">>", ">>vvv"},  // 7
    {"vvv", "<vv", "vv", ">vv", "<v", "v", ">v", "<", "", ">", ">vvv"},       // 8
    {"<vvv", "<<vv", "<vv", "vv", "<<v", "<v", "v", "<<", "<", "", "vvv"},    // 9
    {"<", "^<<", "<^", "^", "^^<<", "<^^", "^^", "^^^<<", "<^^^", "^^^", ""}, // A
};

static vector<vector<string>> arrow_moves = {
    {"", ">v", "v", "v<", ">"},   // ^
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

    int sum = 0;
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

        println("{}", r2);
        println("{}", r1);
        println("{}", moves);
        println("{}: {} * {} = {}", code, v, r2.length(), v * r2.length());
        println();
    }

    // <AAv<A>>^A
    // ^^<A^>AvvAvA
    // 593A

    // 283A
    // 670A
    // 459A
    // 279A
    return sum;
}

uint64_t part2(Input input) {
    return 0;
}

void aaa() {
    string x = "<v<A>>^AvA^A<vA<AA>>^AAvA<^A>AAvA^A<vA>^AA<A>A<v<A>A>^AAAvA<^A>A";
    vector<char> v{'I', '^', 'A', '<', 'v', '>'};

    int at = 2;

    string next;
    for (auto c : x) {
        if (c == 'A')
            next += v[at];
        if (c == '^')
            at -= 3;
        if (c == '>')
            at += 1;
        if (c == '<')
            at -= 1;
        if (c == 'v')
            at += 3;
    }

    at = 2;
    string next2;
    for (auto c : next) {
        if (c == 'A')
            next2 += v[at];
        if (c == '^')
            at -= 3;
        if (c == '>')
            at += 1;
        if (c == '<')
            at -= 1;
        if (c == 'v')
            at += 3;
    }

    cout << x << endl;
    cout << next << endl;
    cout << next2 << endl;
}

void test() {
    string example = R"(029A
980A
179A
456A
379A)";
    println();

    // aaa();
    // return;

    assert(part1(Input::from_raw(example)) == 126384);
    assert(part2(Input::from_raw(example)) == 0);
}

// <v<A>>^AvA^A<vA<AA>>^AAvA<^A>AAvA^A<vA>^AA<A>A<v<A>A>^AAAvA<^A>A
// v<<A>>^AvA^Av<<A>>^AAv<A<A>>^AAvAA<^A>Av<A>^AA<A>Av<A<A>>^AAAvA<^A>A

// <A>Av<<AA>^AA>AvAA^A<vAAA>^A
// <A>A<AAv<AA>>^AvAA^Av<AAA>^A

// ^A<<^^A>>AvvvA
// ^A^^<<A>>AvvvA

//
// 379A