#include <bits/stdc++.h>
#include <ranges>

#include "../utils/utils.h"

using namespace std;

using sset = set<string>;
using graph = unordered_map<string, sset>;

uint64_t part1(Input input) {
    graph connections;

    for (auto& line : input.lines()) {
        string pc1 = line.substr(0, 2);
        string pc2 = line.substr(3);

        connections[pc1].emplace(pc2);
        connections[pc2].emplace(pc1);
    }

    set<tuple<string, string, string>> trios;
    for (auto const& [pc, conns] : connections) {
        if (!pc.starts_with('t')) {
            continue;
        }

        for (auto& c : conns) {
            for (auto& c2 : connections[c]) {
                if (connections[c2].contains(pc)) {
                    // println("{},{},{}", pc, c, c2);
                    vector<string> trio{pc, c, c2};
                    ranges::sort(trio);
                    trios.emplace(tuple{trio[0], trio[1], trio[2]});
                }
            }
        }
    }

    return trios.size();
}

void bron_kerbosch(graph& connections, sset& R, sset& P, sset& X, sset& out) {
    if (P.empty() && X.empty()) {
        if (R.size() > out.size()) {
            out = R;
        }
        return;
    }

    sset PuX;
    set_union(P.begin(), P.end(), X.begin(), X.end(), inserter(PuX, PuX.end()));
    auto pivot = *PuX.begin();

    auto& Nu = connections[pivot];
    sset PNu;

    set_difference(P.begin(), P.end(), Nu.begin(), Nu.end(), inserter(PNu, PNu.end()));

    for (auto& v : PNu) {
        // BronKerbosch2(R ⋃ {v}, P ⋂ N(v), X ⋂ N(v))
        R.insert(v);

        auto& Nv = connections[v];
        sset _P, _X;
        set_intersection(P.begin(), P.end(), Nv.begin(), Nv.end(), inserter(_P, _P.end()));
        set_intersection(X.begin(), X.end(), Nv.begin(), Nv.end(), inserter(_X, _X.end()));
        bron_kerbosch(connections, R, _P, _X, out);

        R.erase(v);
        P.erase(v);
        X.insert(v);
    }
}

uint64_t part2(Input input) {
    graph connections;

    for (auto& line : input.lines()) {
        string pc1 = line.substr(0, 2);
        string pc2 = line.substr(3);

        connections[pc1].emplace(pc2);
        connections[pc2].emplace(pc1);
    }

    auto all_pcs = views::keys(connections) | ranges::to<sset>();

    sset X, R, out;

    bron_kerbosch(connections, R, all_pcs, X, out);

    auto ans = out | views::join_with(',') | ranges::to<string>();
    cout << ans << endl;

    return 0;
}

void test() {
    string example = R"(kh-tc
qp-kh
de-cg
ka-co
yn-aq
qp-ub
cg-tb
vc-aq
tb-ka
wh-tc
yn-cg
kh-ub
ta-co
de-co
tc-td
tb-wq
wh-td
ta-ka
td-qp
aq-cg
wq-ub
ub-vc
de-ta
wq-aq
wq-vc
wh-yn
ka-de
kh-ta
co-tc
wh-qp
tb-vc
td-yn)";

    assert(part1(Input::from_raw(example)) == 7);
    assert(part2(Input::from_raw(example)) == 0);
}
