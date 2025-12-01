import { expect } from "bun:test";
import { lines } from "../utils/input";

export const partOne = (input: string) => {
  const values = lines(input);
  let value = 50;
  let count = 0;

  for (const line of values) {
    const dir = line[0];
    const val = Number(line.slice(1));

    if (dir === "L") {
      value -= val;
      while (value < 0) {
        value += 100;
      }
    } else {
      value += val;
      if (value > 99) {
        value %= 100;
      }
    }

    if (value == 0) {
      count++;
    }
  }

  return count;
};

export const partTwo = (input: string) => {
  const values = lines(input);
  let value = 50;
  let count = 0;

  for (const line of values) {
    const dir = line[0];
    let val = Number(line.slice(1));

    if (dir === "L") {
      while (val--) {
        value -= 1;
        if (value == 0) {
          count++;
        }

        if (value == -1) {
          value = 99;
        }
      }
    } else {
      while (val--) {
        value += 1;
        if (value == 100) {
          value = 0;
          count++;
        }
      }
    }
  }

  return count;
};

export const test = () => {
  const example = `L68
L30
R48
L5
R60
L55
L1
L99
R14
L82`;

  expect(partOne(example)).toBe(3);
  expect(partTwo(example)).toBe(6);
};
