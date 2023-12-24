#include <iostream>
#include <z3++.h>

using namespace z3;

int main() {
    context c;

    expr x = c.bv_const("x", 64);
    expr y = c.bv_const("y", 64);
    expr z = c.bv_const("z", 64);

    expr vx = c.bv_const("vx", 64);
    expr vy = c.bv_const("vy", 64);
    expr vz = c.bv_const("vz", 64);

    expr t1 = c.bv_const("t_1", 64);
    expr t2 = c.bv_const("t_2", 64);
    expr t3 = c.bv_const("t_3", 64);


    solver s(c);

    // Example
    // s.add(t1 > 0);
    // s.add(x + vx * t1 == 19 - 2 * t1);
    // s.add(y + vy * t1 == 13 + t1);
    // s.add(z + vz * t1 == 30 - 2 * t1);

    // s.add(t2 > 0);
    // s.add(x + vx * t2 == 18 - t2);
    // s.add(y + vy * t2 == 19 - t2);
    // s.add(z + vz * t2 == 22 - 2 * t2);

    // s.add(t3 > 0);
    // s.add(x + vx * t3 == 20 - 2 * t3);
    // s.add(y + vy * t3 == 25 - 2 * t3);
    // s.add(z + vz * t3 == 34 - 4 * t3);

    s.add(t1 > 0);
    s.add(x + vx * t1 == c.bv_val(251454256616722, 64) + 43 * t1);
    s.add(y + vy * t1 == c.bv_val(382438634889004, 64) - 207 * t1);
    s.add(z + vz * t1 == c.bv_val(18645302082228, 64) + 371 * t1);

    s.add(t2 > 0);
    s.add(x + vx * t2 == c.bv_val(289124150762025, 64) - 73 * t2);
    s.add(y + vy * t2 == c.bv_val(364325878532733, 64) - 158 * t2);
    s.add(z + vz * t2 == c.bv_val(278169080781801, 64) - 13 * t2);

    s.add(t3 > 0);
    s.add(x + vx * t3 == c.bv_val(268852221227649, 64) + 41 * t3);
    s.add(y + vy * t3 == c.bv_val(10710819924145, 64) + 192 * t3);
    s.add(z + vz * t3 == c.bv_val(258969710792682, 64) + 62 * t3);

    std::cout << s.check() << std::endl;
    std::cout << s.get_model().eval(x + y + z).get_numeral_int64() << std::endl;
}
