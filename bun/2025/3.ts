import { expect } from "bun:test";
import { lines } from "../utils/input";

const getMaxJoltage = (bank: number[], digits: number) => {
  let joltage = 0;
  let lastIdx = -1;
  for (let d = digits - 1; d >= 0; d--) {
    let n = 0;

    for (let i = lastIdx + 1; i < bank.length - d; i++) {
      if (bank[i]! > n) {
        n = bank[i]!;
        lastIdx = i;
      }
    }

    joltage += n * 10 ** d;
  }

  return joltage;
};

export const partOne = (input: string, d = 2) => {
  const banks = lines(input).map((s) => s.split("").map(Number));

  let output = 0;
  for (const bank of banks) {
    output += getMaxJoltage(bank, d);
  }

  return output;
};

export const partTwo = (input: string) => {
  return partOne(input, 12);
};

export const test = () => {
  const example = `987654321111111
811111111111119
234234234234278
818181911112111`;

  expect(partOne(example)).toBe(357);
  expect(partTwo(example)).toBe(3121910778619);
};
