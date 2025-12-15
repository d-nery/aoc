import { expect } from "bun:test";
import { lines, sections } from "../utils/input";

// All shapes are 3x3

class Shape {
  private inner: [[number, number, number], [number, number, number], [number, number, number]];
  public ones: number;

  constructor(data: string[]) {
    this.inner = [
      [0, 0, 0],
      [0, 0, 0],
      [0, 0, 0],
    ];

    for (let i = 0; i < 3; i++) {
      for (let j = 0; j < 3; j++) {
        this.inner[i][j] = data[i][j] === "#" ? 1 : 0;
      }
    }

    this.ones = this.inner.flat().reduce((a, b) => a + b);
  }
}

// and there's 6 shapes
type Region = {
  size: [number, number];
  goal: [number, number, number, number, number, number];
};

export const parse = (input: string): [Shape[], Region[]] => {
  const _sections = sections(input);
  const rawPresents = _sections.slice(0, _sections.length - 1);
  const rawRegions = _sections[_sections.length - 1];

  const presents = rawPresents.map((p) => {
    const [idx, ...shape] = p.split("\n");
    return new Shape(shape);
  });

  const regions = rawRegions.split("\n").map((l) => {
    const [s, a] = l.split(": ");
    return {
      size: s.split("x").map(Number),
      goal: a.split(" ").map(Number),
    } as Region;
  });

  return [presents, regions];
};

export const partOne = (input: string) => {
  const [presents, regions] = parse(input);

  let total = 0;
  for (const region of regions) {
    const availableSpace = region.size[0] * region.size[1];
    let occupied = 0;
    for (let i = 0; i < 6; i++) {
      occupied += region.goal[i] * presents[i].ones;
    }

    if (occupied <= availableSpace) {
      total++;
    }
  }

  return total;
};

export const partTwo = (input: string) => {
  return 0;
};

export const test = () => {
  const example = `0:
###
##.
##.

1:
###
##.
.##

2:
.##
###
##.

3:
##.
###
##.

4:
###
#..
###

5:
###
.#.
###

4x4: 0 0 0 0 2 0
12x5: 1 0 1 0 2 2
12x5: 1 0 1 0 3 2`;

  expect(partOne(example)).toBe(2);
  expect(partTwo(example)).toBe(0);
};
