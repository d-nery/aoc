import { expect } from "bun:test";
import { lines, sections } from "../utils/input";

export const partOne = (input: string) => {
  const [fresh, available] = sections(input);

  const freshRanges = lines(fresh!).map((f) => f.split("-").map(Number)) as [
    number,
    number,
  ][];
  const toTest = lines(available!).map(Number);

  let count = 0;
  for (const n of toTest) {
    for (const range of freshRanges) {
      if (n >= range[0] && n <= range[1]) {
        count += 1;
        break;
      }
    }
  }

  return count;
};

export const partTwo = (input: string) => {
  const [fresh, _] = sections(input);
  let freshRanges = lines(fresh!).map((f) => f.split("-").map(Number)) as [
    number,
    number,
  ][];
  let previousLength = freshRanges.length;

  while (true) {
    let effectiveRanges = [freshRanges.shift()!.map((n) => n)] as [
      number,
      number,
    ][];

    for (const range of freshRanges) {
      let overlap = false;
      for (const eff of effectiveRanges) {
        // no overlap
        if (range[1] < eff[0] || range[0] > eff[1]) {
          continue;
        }

        overlap = true;
        eff[0] = Math.min(range[0], eff[0]);
        eff[1] = Math.max(eff[1], range[1]);

        break;
      }

      if (!overlap) {
        effectiveRanges.push([...range]);
      }
    }

    freshRanges = effectiveRanges.map((r) => r.map((n) => n)) as [
      number,
      number,
    ][];

    if (freshRanges.length === previousLength) {
      break;
    }

    previousLength = freshRanges.length;
  }

  return freshRanges.reduce((a, b) => a + (b[1] - b[0] + 1), 0);
};

export const test = () => {
  const example = `3-5
10-14
16-20
12-18

1
5
8
11
17
32`;

  expect(partOne(example)).toBe(3);
  expect(partTwo(example)).toBe(14);
};
