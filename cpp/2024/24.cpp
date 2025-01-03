#include <bits/stdc++.h>
#include <ranges>

#include "../utils/utils.h"

using namespace std;

struct Op {
    string op1, op2;
    string op;
    string out;

    bool stable;
};

uint64_t part1(Input input) {
    bool reading_ops = false;
    map<string, bool> registers;

    vector<Op> operations;
    for (auto& line : input.lines()) {
        if (line.empty()) {
            reading_ops = true;
            continue;
        }

        if (reading_ops) {
            auto d = ranges::split_view(line, " "sv) | ranges::to<vector<string>>();
            operations.push_back(Op{d[0], d[2], d[1], d[4], false});
            continue;
        }

        auto d = ranges::split_view(line, ": "sv) | ranges::to<vector<string>>();
        registers[d[0]] = d[1] == "1";
    }

    while (!all_of(operations.begin(), operations.end(), [](auto&& op) { return op.stable; })) {
        for (auto& op : operations) {
            if (op.stable) {
                continue;
            }

            if (!registers.contains(op.op1) || !registers.contains(op.op2)) {
                continue;
            }

            bool v1 = registers[op.op1];
            bool v2 = registers[op.op2];
            registers[op.out] = op.op == "AND" ? v1 & v2 : op.op == "OR" ? v1 | v2 : v1 ^ v2;

            // For p2
            println("{}({}) {} {}({}) -> {}({})", op.op1, int(v1), op.op, op.op2, int(v2), op.out, registers[op.out]);

            op.stable = true;
        }
    }

    uint64_t val = 0;
    for (auto const& [r, v] : registers) {
        if (!r.starts_with("z")) {
            continue;
        }

        uint64_t i;
        sscanf(r.c_str(), "z%ld", &i);
        val |= uint64_t(v) << i;
    }

    return val;
}

uint64_t part2(Input input) {
    // X =  101101010111101101000111000000010110000000011
    // Y =  100011100111110100010111100110001110000011011
    // S = 1010000111111100001011110100110100100000011110
    // Z = 1001111111011100001011110101010100010000011110
    //           ^                    ^^     ^^

    // All operations from input in adder order:
    // x00 XOR y00 -> z00
    // y00 AND x00 -> kvj  => carry

    // y01 XOR x01 -> bhq
    // bhq XOR kvj -> z01
    // y01 AND x01 -> rtg
    // kvj AND bhq -> wkc
    // rtg OR  wkc -> htw

    // y02 XOR x02 -> mpj
    // mpj XOR htw -> z02
    // htw AND mpj -> sdk
    // x02 AND y02 -> dmq
    // dmq OR  sdk -> gwf

    // y03 XOR x03 -> nbw
    // nbw XOR gwf -> z03
    // nbw AND gwf -> btm
    // x03 AND y03 -> psr
    // psr OR  btm -> hct

    // x04 XOR y04 -> cnr
    // cnr XOR hct -> z04
    // y04 AND x04 -> ggt
    // cnr AND hct -> nbp
    // ggt OR  nbp -> ffv

    // y05 XOR x05 -> pmh
    // pmh XOR ffv -> z05
    // ffv AND pmh -> brb
    // y05 AND x05 -> wnc
    // brb OR  wnc -> sfm

    // x06 XOR y06 -> wsn
    // sfm XOR wsn -> z06
    // wsn AND sfm -> kjs
    // x06 AND y06 -> kbv
    // kbv OR  kjs -> jqv
    // etc

    bool reading_ops = false;
    map<string, bool> registers;

    vector<Op> operations;
    for (auto& line : input.lines()) {
        if (line.empty()) {
            reading_ops = true;
            continue;
        }

        if (reading_ops) {
            auto d = ranges::split_view(line, " "sv) | ranges::to<vector<string>>();
            operations.push_back(Op{d[0], d[2], d[1], d[4], false});
            continue;
        }

        auto d = ranges::split_view(line, ": "sv) | ranges::to<vector<string>>();
        registers[d[0]] = d[1] == "1";
    }

    auto find_op = [&](string reg, string bin) {
        auto op = find_if(operations.begin(), operations.end(), [&](Op op) { return (op.op1 == reg || op.op2 == reg) && op.op == bin; });
        return *op;
    };

    for (int i = 1; i < 45; i++) {
        string reg = format("x{:02d}", i);
        auto i1 = find_op(reg, "XOR");
        auto z = find_op(i1.out, "XOR");
        if (!z.out.starts_with("z")) {
            println("Error on bit {}", i);
        }
    }

    // From above, steps with errors are 10, 17, 35, 39:
    // From input:
    // x10 XOR y10 -> kck
    // x10 AND y10 -> z10  !!!
    // kck XOR skm -> vcf  !!!
    // skm AND kck -> sst
    // sst OR  vcf -> fgb

    // x17 XOR y17 -> qjg
    // jjf XOR qjg -> fhg  !!!
    // qjg AND jjf -> z17  !!!
    // x17 AND y17 -> qjn
    // qjn OR  fhg -> jfb

    // y35 XOR x35 -> fsq  !!!
    // dvb XOR jsn -> z35
    // y35 AND x35 -> dvb  !!!
    // jsn AND dvb -> ftc
    // ftc OR  fsq -> bwc

    // y39 XOR x39 -> kmh
    // y39 AND x39 -> rvd
    // kmh AND mnd -> wrj
    // kmh XOR mnd -> tnc  !!!
    // rvd OR wrj  -> z39  !!!

    // In order: dvb,fhg,fsq,tnc,vcf,z10,z17,z39

    return 0;
}

void test() {
    string example = R"(x00: 1
x01: 1
x02: 1
y00: 0
y01: 1
y02: 0

x00 AND y00 -> z00
x01 XOR y01 -> z01
x02 OR y02 -> z02)";

    string example2 = R"(x00: 1
x01: 0
x02: 1
x03: 1
x04: 0
y00: 1
y01: 1
y02: 1
y03: 1
y04: 1

ntg XOR fgs -> mjb
y02 OR x01 -> tnw
kwq OR kpj -> z05
x00 OR x03 -> fst
tgd XOR rvg -> z01
vdt OR tnw -> bfw
bfw AND frj -> z10
ffh OR nrd -> bqk
y00 AND y03 -> djm
y03 OR y00 -> psh
bqk OR frj -> z08
tnw OR fst -> frj
gnj AND tgd -> z11
bfw XOR mjb -> z00
x03 OR x00 -> vdt
gnj AND wpb -> z02
x04 AND y00 -> kjc
djm OR pbm -> qhw
nrd AND vdt -> hwm
kjc AND fst -> rvg
y04 OR y02 -> fgs
y01 AND x02 -> pbm
ntg OR kjc -> kwq
psh XOR fgs -> tgd
qhw XOR tgd -> z09
pbm OR djm -> kpj
x03 XOR y03 -> ffh
x00 XOR y04 -> ntg
bfw OR bqk -> z06
nrd XOR fgs -> wpb
frj XOR qhw -> z04
bqk OR frj -> z07
y03 OR x01 -> nrd
hwm AND bqk -> z03
tgd XOR rvg -> z12
tnw OR pbm -> gnj)";

    assert(part1(Input::from_raw(example)) == 4);
    assert(part1(Input::from_raw(example2)) == 2024);
    assert(part2(Input::from_raw(example)) == 0);
}
