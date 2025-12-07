import { expect } from "bun:test";
import { grid, lines } from "../utils/input";

export const partOne = (input: string) => {
  const diagram = lines(input);
  const start = diagram[0].indexOf("S");

  let beams = new Set([start]);
  let splits = 0;
  for (let l = 0; l < diagram.length - 1; l++) {
    let nextBeams = new Set<number>();
    for (const beam of beams) {
      if (diagram[l + 1][beam] === "^") {
        splits++;
        nextBeams.add(beam - 1);
        nextBeams.add(beam + 1);
      } else {
        nextBeams.add(beam);
      }
    }
    beams = nextBeams;
  }

  return splits;
};

export const partTwo = (input: string) => {
  const diagram = grid(input) as (number | string)[][];

  // Each splitter possibilities is the sum of the possibilites of the splliter directly below-left/right them, 1 if none
  // So we go bottom-up summing those.
  // We can skip a line since there's always an empty line between each line of splitters
  for (let line = diagram.length - 2; line > 1; line -= 2) {
    for (let col = 1; col < diagram[line].length - 1; col++) {
      if (diagram[line][col] === "^") {
        let left = 1;
        let right = 1;
        for (let k = line + 1; k < diagram.length; k++) {
          if (typeof diagram[k][col - 1] === "number" && left === 1) {
            left = diagram[k][col - 1] as number;
          }

          if (typeof diagram[k][col + 1] === "number" && right === 1) {
            right = diagram[k][col + 1] as number;
          }
        }

        diagram[line][col] = left + right;
      }
    }
  }

  const start = diagram[0].indexOf("S");

  return diagram[2][start];
};

export const test = () => {
  const example = `.......S.......
...............
.......^.......
...............
......^.^......
...............
.....^.^.^.....
...............
....^.^...^....
...............
...^.^...^.^...
...............
..^...^.....^..
...............
.^.^.^.^.^...^.
...............`;

  expect(partOne(example)).toBe(21);
  expect(partTwo(example)).toBe(40);
};
