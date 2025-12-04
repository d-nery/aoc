import { expect } from "bun:test";
import { grid } from "../utils/input";

const canAccess = (grid: string[][], i: number, j: number) => {
  return (
    [-1, 0, 1]
      .flatMap((di) =>
        [-1, 0, 1].map((dj) =>
          di === 0 && dj === 0 ? undefined : grid[i + di]?.[j + dj]
        )
      )
      .filter((x) => x === "@").length < 4
  );
};

export const partOne = (input: string) => {
  const map = grid(input);

  let removable = 0;
  for (let i = 0; i < map.length; i++) {
    for (let j = 0; j < map[i]!.length; j++) {
      if (map[i]![j] === "@" && canAccess(map, i, j)) {
        removable += 1;
      }
    }
  }

  return removable;
};

export const partTwo = (input: string) => {
  const map = grid(input);

  let total = 0;
  while (true) {
    let removable = 0;
    for (let i = 0; i < map.length; i++) {
      for (let j = 0; j < map[i]!.length; j++) {
        if (map[i]![j] === "@" && canAccess(map, i, j)) {
          removable += 1;
          map[i]![j] = "x";
        }
      }
    }

    if (removable === 0) {
      break;
    }

    total += removable;
  }

  return total;
};

export const test = () => {
  const example = `..@@.@@@@.
@@@.@.@.@@
@@@@@.@.@@
@.@@@@..@.
@@.@@@@.@@
.@@@@@@@.@
.@.@.@.@@@
@.@@@.@@@@
.@@@@@@@@.
@.@.@@@.@.`;

  expect(partOne(example)).toBe(13);
  expect(partTwo(example)).toBe(43);
};
