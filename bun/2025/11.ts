import { expect } from "bun:test";
import { lines } from "../utils/input";

const countPaths = (connections: Record<string, string[]>, from: string, to: string, allowList?: Set<string>) => {
  let paths = 0;
  let toVisit = [from];

  while (toVisit.length > 0) {
    const next = toVisit.shift()!;

    if (allowList?.has(next) === false) {
      continue;
    }

    if (next === to) {
      paths++;
      continue;
    }

    const neighbours = connections[next] ?? [];
    toVisit.push(...neighbours);
  }

  return paths;
};

const reacheableFrom = (connections: Record<string, string[]>, to: string) => {
  let set = new Set([to]);
  let prevLength = 0;
  while (true) {
    for (const label of [...set]) {
      set = set.union(new Set(connections[label]));
    }

    if (prevLength === set.size) {
      break;
    }

    prevLength = set.size;
  }

  return set;
};

export const partOne = (input: string) => {
  const connections = lines(input).reduce((a, b) => {
    const [from, outputs] = b.split(": ");
    const to = outputs.split(" ");
    return { ...a, [from]: to };
  }, {});

  return countPaths(connections, "you", "out");
};

export const partTwo = (input: string) => {
  const connections = lines(input).reduce((a, b) => {
    const [from, outputs] = b.split(": ");
    const to = outputs.split(" ");
    return { ...a, [from]: to };
  }, {}) as Record<string, string[]>;

  // We need
  //  svr->fft * fft->dac * dac->out + svr->dac * dac->fft * fft->out
  // Running each step manually I got
  // countPaths(connections, "dac", "fft") = 0
  // So we can eliminate the second multiplication
  // On the first part I got (I believe it to be) infinite loops for svr->fft and fft->dac
  // So precomputing backwards we can prune unreacheable nodes and avoid loops, which can't exist on the answer paths

  const reverseConnections: Record<string, string[]> = {};
  for (const [k, v] of Object.entries(connections)) {
    for (const label of v) {
      reverseConnections[label] ??= [];
      reverseConnections[label].push(k);
    }
  }

  return (
    countPaths(connections, "svr", "fft", reacheableFrom(reverseConnections, "fft")) *
    countPaths(connections, "fft", "dac", reacheableFrom(reverseConnections, "dac")) *
    countPaths(connections, "dac", "out", reacheableFrom(reverseConnections, "out"))
  );
};

export const test = () => {
  const example = `aaa: you hhh
you: bbb ccc
bbb: ddd eee
ccc: ddd eee fff
ddd: ggg
eee: out
fff: out
ggg: out
hhh: ccc fff iii
iii: out`;

  const example2 = `svr: aaa bbb
aaa: fft
fft: ccc
bbb: tty
tty: ccc
ccc: ddd eee
ddd: hub
hub: fff
eee: dac
dac: fff
fff: ggg hhh
ggg: out
hhh: out`;

  expect(partOne(example)).toBe(5);
  expect(partTwo(example2)).toBe(2);
};
