import { expect, setDefaultTimeout } from "bun:test";
import { lines } from "../utils/input";
import { isConstructSignatureDeclaration } from "typescript";

type XYZ = [number, number, number];

const qdist = (a: XYZ, b: XYZ) => {
  return (a[0] - b[0]) ** 2 + (a[1] - b[1]) ** 2 + (a[2] - b[2]) ** 2;
};

export const partOne = (input: string, connections = 1000) => {
  const boxes = lines(input).map((l) => l.split(",").map(Number)) as XYZ[];

  const dists: [number, number, number][] = [];

  for (let i = 0; i < boxes.length - 1; i++) {
    for (let j = i + 1; j < boxes.length; j++) {
      dists.push([qdist(boxes[i], boxes[j]), i, j]);
    }
  }

  dists.sort((a, b) => a[0] - b[0]);

  const conns = dists.slice(0, connections).map((d) => [d[1], d[2]]);
  const sets: Set<number>[] = [new Set(conns.shift())];

  let prevSize = 1;
  let set = sets[0];

  while (conns.length > 0) {
    for (let i = 0; i < conns.length; i++) {
      const next = conns.shift()!;
      if (set.has(next[0]) || set.has(next[1])) {
        set.add(next[0]);
        set.add(next[1]);
      } else {
        conns.push(next);
      }
    }

    // Finished this set
    if (set.size == prevSize) {
      set = new Set(conns.shift());
      sets.push(set);
    }

    prevSize = set.size;
  }

  sets.sort((a, b) => b.size - a.size);

  return sets.slice(0, 3).reduce((a, b) => a * b.size, 1);
};

export const partTwo = (input: string) => {
  const boxes = lines(input).map((l) => l.split(",").map(Number)) as XYZ[];

  const dists: [number, number, number][] = [];

  for (let i = 0; i < boxes.length - 1; i++) {
    for (let j = i + 1; j < boxes.length; j++) {
      dists.push([qdist(boxes[i], boxes[j]), i, j]);
    }
  }

  dists.sort((a, b) => a[0] - b[0]);
  const conns = dists.map((d) => [d[1], d[2]]);

  const set = new Set(conns.shift());

  while (true) {
    const c = conns.shift()!;
    set.add(c[0]);
    set.add(c[1]);

    if (set.size == boxes.length) {
      return boxes[c[0]][0] * boxes[c[1]][0];
    }
  }
};

export const test = () => {
  const example = `162,817,812
57,618,57
906,360,560
592,479,940
352,342,300
466,668,158
542,29,236
431,825,988
739,650,466
52,470,668
216,146,977
819,987,18
117,168,530
805,96,715
346,949,466
970,615,88
941,993,340
862,61,35
984,92,344
425,690,689`;

  expect(partOne(example, 10)).toBe(40);
  expect(partTwo(example)).toBe(25272);
};
