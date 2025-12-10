import { lines } from "../utils/input.ts";
import { combinations } from "../utils/combinatorics.ts";
import { init, type Context } from "z3-solver";

// Bun cant run part 2 because of z3, so it must be ran manually with node => npm i -> node 2025/10.ts

type Machine = {
  target: number;
  buttons: string[];
  joltages: number[];
};

const parseMachine = (input: string): Machine => {
  const data = input.match(/\[(.*)\] (.*) \{(.*)\}/);

  const lightAmt = data![1].length;
  const target = parseInt(data![1].replaceAll(".", "0").replaceAll("#", "1"), 2);

  const buttons = data![2].split(" ").map((d) => {
    let b = Array(lightAmt).fill("0") as string[];
    for (const n of d
      .slice(1, d.length - 1)
      .split(",")
      .map(Number)) {
      b[n] = "1";
    }
    return b.join("");
  });
  const joltages = data![3].split(",").map(Number);

  return { target, buttons, joltages };
};

const calculateLightPresses = (m: Machine) => {
  // try each amount until one combination is found
  for (let amt = 1; amt <= m.buttons.length; amt++) {
    // use buttons as binary for XOR
    const combs = combinations(
      m.buttons.map((b) => parseInt(b, 2)),
      amt,
    );
    if (combs.some((c) => c.reduce((a, b) => a ^ b) === m.target)) {
      return amt;
    }
  }

  return m.buttons.length;
};

export const partOne = (input: string) => {
  const machines = lines(input).map((l) => parseMachine(l));
  return machines.reduce((a, b) => a + calculateLightPresses(b), 0);
};

const calculateJoltagePresses = async (m: Machine) => {
  // Ex1: (3) (1,3) (2) (2,3) (0,2) (0,1) {3,5,4,7}
  // Buttons are:
  //  A: 0 0 0 1
  //  B: 0 1 0 1
  //  C: 0 0 1 0
  //  D: 0 0 1 1
  //  E: 1 0 1 0
  //  F: 1 1 0 0
  // And the target:
  //     3 5 4 7
  // Which gives:
  //  E + F = 3
  //  C + D + E = 4
  //  B + F = 5
  //  A + B + D = 7
  // With A, B, C, D, E, F >= 0
  // We find the solution that gives the smallest A + B + C + D + E + F

  const { Context } = await init();
  //@ts-ignore
  const Z3: Context = new Context("main");

  const solver = new Z3.Solver();
  const buttons = m.buttons.map((b, i) => Z3.Int.const(`b_${i}`));
  for (const b of buttons) {
    solver.add(b.ge(0));
  }

  for (let i = 0; i < m.joltages.length; i++) {
    const indexes = m.buttons
      .map((b, i) => [b, i] as [string, number])
      .filter((b) => b[0][i] === "1")
      .map((b) => b[1]);
    const bs = buttons.filter((v, idx) => indexes.includes(idx));
    solver.add(Z3.Sum(Z3.Int.val(0), ...bs).eq(m.joltages[i]));
  }

  let sm = 99999;
  while ((await solver.check()) === "sat") {
    const model = solver.model();
    const v = buttons.reduce((a, b) => a + +model.eval(b).toString(), 0);
    sm = Math.min(sm, v);

    solver.add(Z3.Or(...buttons.map((b) => b.neq(model.eval(b)))));
  }

  return sm;
};

export const partTwo = async (input: string) => {
  const machines = lines(input).map((l) => parseMachine(l));
  let total = 0;
  let i = 0;
  for (const m of machines) {
    const joltage = await calculateJoltagePresses(m);
    console.log(`Procesed machine ${i++} = ${joltage}`);
    total += joltage;
  }
  return total;
};

export const test = async () => {
  const { expect } = await import("bun:test");

  const example = `[.##.] (3) (1,3) (2) (2,3) (0,2) (0,1) {3,5,4,7}
  [...#.] (0,2,3,4) (2,3) (0,4) (0,1,2) (1,2,3,4) {7,5,12,7,2}
  [.###.#] (0,1,2,3,4) (0,3,4) (0,1,2,4,5) (1,2) {10,11,11,5,10,5}`;
  expect(partOne(example)).toBe(7);
  // expect(await partTwo(example)).toBe(33);
};

// Run this as RUN_NODE=1 npx ts-node 2025/10.ts
if (process.env.RUN_NODE) {
  const example = `[.##.] (3) (1,3) (2) (2,3) (0,2) (0,1) {3,5,4,7}
[...#.] (0,2,3,4) (2,3) (0,4) (0,1,2) (1,2,3,4) {7,5,12,7,2}
[.###.#] (0,1,2,3,4) (0,3,4) (0,1,2,4,5) (1,2) {10,11,11,5,10,5}`;
  const fs = await import("node:fs/promises");

  (async () => {
    // console.log(await partTwo(example));
    // return;

    const input = await fs.readFile("./data/2025/10.txt", { encoding: "utf-8" });
    const res = await partTwo(input.trim());
    console.log(res);
  })();
}
