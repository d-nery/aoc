import { expect } from "bun:test";
import { lines } from "../utils/input";

type Point = [number, number];

const area = (p1: Point, p2: Point) => {
  return (Math.abs(p1[0] - p2[0]) + 1) * (Math.abs(p1[1] - p2[1]) + 1);
};

export const partOne = (input: string) => {
  const points = lines(input).map((l) => l.split(",").map(Number)) as Point[];
  points.push(points[0]);

  let largest = 0;
  for (let i = 0; i < points.length - 1; i++) {
    for (let j = i + 1; j < points.length; j++) {
      largest = Math.max(area(points[i], points[j]), largest);
    }
  }

  return largest;
};

export const partTwo = (input: string) => {
  const points = lines(input).map((l) => l.split(",").map(Number)) as Point[];
  points.push(points[0]);

  const isInside = (p1: Point, p2: Point) => {
    // min and max rectangle coords. Yes, I'm using lowercase for min and uppercase for max
    const [rx, rX] = p1[0] <= p2[0] ? [p1[0], p2[0]] : [p2[0], p1[0]];
    const [ry, rY] = p1[1] <= p2[1] ? [p1[1], p2[1]] : [p2[1], p1[1]];

    // Check if no line of the perimeter crosses the rectangle
    for (let i = 0; i < points.length - 1; i++) {
      const [x1, y1] = points[i];
      const [x2, y2] = points[i + 1];

      if (y1 === y2) {
        const x = Math.min(x1, x2);
        const X = Math.max(x1, x2);

        if (
          ry < y1 &&
          y1 < rY &&
          ((x <= rx && rx < X) || (x < rX && rX <= X))
        ) {
          return false;
        }
      } else if (x1 === x2) {
        const y = Math.min(y1, y2);
        const Y = Math.max(y1, y2);

        if (
          rx < x1 &&
          x1 < rX &&
          ((y <= ry && ry < Y) || (y < rY && rY <= Y))
        ) {
          return false;
        }
      }
    }

    return true;
  };

  let largest = 0;
  for (let i = 0; i < points.length - 1; i++) {
    for (let j = i + 1; j < points.length; j++) {
      const [p1, p2] = [points[i], points[j]];
      if (isInside(p1, p2)) {
        largest = Math.max(area(p1, p2), largest);
      }
    }
  }

  return largest;
};

export const test = () => {
  const example = `7,1
11,1
11,7
9,7
9,5
2,5
2,3
7,3`;

  expect(partOne(example)).toBe(50);
  expect(partTwo(example)).toBe(24);
};
