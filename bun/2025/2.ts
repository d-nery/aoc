import { expect } from "bun:test";

const isInvalid = (n: number) => {
  const len = n.toString().length;
  const mask = 10 ** (len / 2);
  return n % mask === Math.trunc(n / mask);
};

const isInvalid2 = (n: number) => {
  const id = n.toString();

  for (let i = 1; i <= id.length / 2; i++) {
    if (id.length % i != 0) {
      continue;
    }

    const re = new RegExp(`.{1,${i}}`, "g");
    const parts = id.match(re)!;
    if (parts.every((p) => p === parts[0])) {
      return true;
    }
  }

  return false;
};

export const partOne = (input: string, validator = isInvalid) => {
  const ids = input.split(",").map((id) => id.split("-").map(Number)) as [
    number,
    number,
  ][];

  let idSum = 0;
  for (const [first, second] of ids) {
    for (let id = first; id <= second; id++) {
      if (validator(id)) {
        idSum += id;
      }
    }
  }

  return idSum;
};

export const partTwo = (input: string) => {
  return partOne(input, isInvalid2);
};

export const test = () => {
  const example = `11-22,95-115,998-1012,1188511880-1188511890,222220-222224,1698522-1698528,446443-446449,38593856-38593862,565653-565659,824824821-824824827,2121212118-2121212124`;

  expect(partOne(example)).toBe(1227775554);
  expect(partTwo(example)).toBe(4174379265);
};
