#include <bits/stdc++.h>
#include <ranges>

#include "../utils/utils.h"

using namespace std;

string process(int64_t A, int64_t B, int64_t C, string program) {
    auto combo = [&](int operand) {
        if (operand <= 3)
            return (int64_t)operand;
        if (operand == 4)
            return A;
        if (operand == 5)
            return B;
        if (operand == 6)
            return C;
        throw "Invalid operand";
    };

    vector<int> outputs;

    for (size_t i = 0; i < program.size(); i += 2) {
        int opcode = program[i] - '0';
        int operand = program[i + 1] - '0';

        switch (opcode) {
        case 0:
            A >>= combo(operand);
            break;
        case 1:
            B ^= operand;
            break;
        case 2:
            B = combo(operand) & 0b111;
            break;
        case 3:
            if (A == 0)
                break;
            i = operand - 2;
            break;
        case 4:
            B ^= C;
            break;
        case 5:
            outputs.push_back(combo(operand) & 0b111);
            break;
        case 6:
            B = A >> combo(operand);
            break;
        case 7:
            C = A >> combo(operand);
            break;
        }
    }

    stringstream ss;
    for (auto& i : outputs) {
        ss << to_string(i);
    }

    return ss.str();
}

uint64_t part1(Input input) {
    auto lines = input.lines();
    int64_t A, B, C;
    char buffer[256];

    sscanf(lines[0].c_str(), "Register A: %ld", &A);
    sscanf(lines[1].c_str(), "Register B: %ld", &B);
    sscanf(lines[2].c_str(), "Register C: %ld", &C);
    sscanf(lines[4].c_str(), "Program: %s", buffer);
    string program(buffer);
    erase(program, ',');

    cout << process(A, B, C, program) << endl;

    return 0;
}

uint64_t part2(Input input) {
    // My input:
    // Program: 2,4,1,1,7,5,0,3,1,4,4,0,5,5,3,0
    //                                  ^  unico out
    // Instr 1 -> (2, 4) = B = A & 0b111                 -> várias possibilidades de ultimos 3 bits de A, output depende só disso
    //    [A] = A B C D E F G H I J K L M N O P
    //    [B] = 0 0 0 0 0 0 0 0 0 0 0 0 0 N O P
    //    [C] = _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
    // Instr 2 -> (1, 1) = B = B ^ 0b001
    //    [A] = A B C D E F G H I J K L M N O P
    //    [B] = 0 0 0 0 0 0 0 0 0 0 0 0 0 N O ~P
    //    [C] = _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
    // Instr 3 -> (7, 5) = C = A >> B [0 ~ 7]
    //    [A] = A B C D E F G H I J K L M N O P
    //    [B] = 0 0 0 0 0 0 0 0 0 0 0 0 0 N O ~P
    //    [C] = 0 0 0 0 0 0 0 A B C D E F G H I    a   A B C D E F G H I J K L M N O P
    // Instr 4 -> (0, 3) = A = A >> 3                  -> Número com 3*16 bits, para zerar no final
    //    [A] = 0 0 0 A B C D E F G H I J K L M
    //    [B] = 0 0 0 0 0 0 0 0 0 0 0 0 0 N O ~P
    //    [C] = ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ?
    // Instr 5 -> (1, 4) = B = B ^ 0b100
    //    [A] = 0 0 0 A B C D E F G H I J K L M                                                  0b100 (4)
    //    [B] = 0 0 0 0 0 0 0 0 0 0 0 0 0 ~N O ~P              0 0 0 0 0 0 0 0 0 0 0 0 0 ~K L ~M -> ~K^F L^0 ~PH
    //    [C] = ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ?
    // Instr 6 -> (4, 0) = B = B ^ C
    //    [A] = 0 0 0 A B C D E F G H I J K L M
    //    [B] = 0 0 0 0 0 A B C D E F G H ~N^I O^J ~P^K
    //    [C] = ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ?
    // Instr 7 -> (5, 5) = OUT B & 0b111 -> Precisa ser 2 (0b010)
    //    [A] = _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
    //    [A] = _ _ _ _ _ _ _ _ _ _ _ _ _ ~N^I O^J ~P^k => ~N^I = 0, O^J = 1, ~P^K = 0
    //    [C] = 0 0 0 0 0 A B C D E F G H I J K
    // Instr 8 -> (3, 0) = A deve ser 0 na 16a vez apenas
    //    [A] = _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
    //    [A] = _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
    //    [A] = _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _

    // para menor numero Program = 2,4,1,1,7,5,0,3,1,4,4,0,5,5,3,0 = 010 100 001 001 111 101 000 011 001 100 100 000 101 101 011 000
    // string s;
    // for (auto& i : {2, 4, 1, 1, 7, 5, 0, 3, 1, 4, 4, 0, 5, 5, 3, 0}) {
    //     s += format("{:03b}", i);
    // }

    string program("2411750314405530");

    int64_t A = 0;
    for (int i = program.size() - 1; i >= 0; i--) {
        A <<= 3;

        for (int j = 0b000; j <= 0x111; j++) {
            int64_t _a = A | j;
            auto s = process(_a, 0, 0, program);

            if (s == program.substr(i)) {
                A = _a;
                break;
            }
        }
    }

    assert(process(A, 0, 0, program) == program);

    return A;
}

void test() {
    string example = R"(Register A: 729
Register B: 0
Register C: 0

Program: 0,1,5,4,3,0)";

    // assert(part1(Input::from_raw(example)) == 0);
    // assert(part2(Input::from_raw(example)) == 0);
}
