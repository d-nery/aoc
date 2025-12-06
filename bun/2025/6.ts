import { expect } from "bun:test";
import { numberMatrix, lines } from "../utils/input";

const op = (op: string, a: number, b: number) => {
  return op === "*" ? (a == 0 ? 1 : a) * b : a + b;
};

export const partOne = (input: string) => {
  const _lines = lines(input);
  const numbers = _lines
    .slice(0, _lines.length - 1)
    .map((l) => l.trim().split(/\s+/).map(Number));
  const operations = _lines[_lines.length - 1]!.trim().split(/\s+/);

  let total = 0;
  for (let i = 0; i < operations.length; i++) {
    let acc = 0;
    for (let j = 0; j < numbers.length; j++) {
      acc = op(operations[i], acc, numbers[j][i]);
    }
    total += acc;
  }

  return total;
};

// Actual input has 4 lines with numbers, I'll just use that information
export const partTwo = (input: string, nLength = 4) => {
  const _lines = input.split("\n");

  let idx = Math.max(..._lines.map((l) => l.length));
  let total = 0;

  let numbers: number[] = [];
  while (idx-- > 0) {
    let nString = "";
    for (let row = 0; row < nLength; row++) {
      nString += _lines[row][idx] ?? "";
    }

    numbers.push(parseInt(nString));

    const op = _lines[nLength][idx] ?? " ";
    if (op != " ") {
      total +=
        op === "*"
          ? numbers.reduce((a, b) => a * b, 1)
          : numbers.reduce((a, b) => a + b, 0);

      numbers = [];
      idx--;
    }
  }

  return total;
};

export const test = () => {
  const example = `123 328  51 64
 45 64  387 23
  6 98  215 314
*   +   *   +`;

  //   expect(partOne(example)).toBe(4277556);
  expect(partTwo(example, 3)).toBe(3263827);
};
