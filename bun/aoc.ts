#! /usr/bin/env bun

const problem = Bun.argv[2] ?? "test";
const day = Bun.argv[3] ?? new Date().getDate();
const year = Bun.argv[4] ?? new Date().getFullYear();

const fetch_input = async () => {
  const dataPath = `data/${year}/${day}.txt`;
  const file = Bun.file(dataPath);
  if (await file.exists()) {
    return (await file.text()).trim();
  }

  console.log("Fetching input...");
  const cookie = await Bun.file(".cookie").text();
  const request = new Request(
    `https://adventofcode.com/${year}/day/${day}/input`,
    {
      headers: {
        Cookie: `session=${cookie.trim()}`,
        "User-Agent": "https://github.com/d-nery/aoc <danielnso97@gmail.com>",
      },
    }
  );

  const raw = await fetch(request);
  const input = await raw.text();

  file.write(input).catch(console.error);

  return input.trim();
};

console.log("== AoC Problem Runner ==");
console.log(`Day ${day}`);
console.log(`Year ${year}`);
console.log(`Problem ${problem}`);
console.log("------------------------");
console.log();

const { partOne, partTwo, test } = await import(`./${year}/${day}.ts`);

const input = await fetch_input();

console.log("Running...");
console.log("------------------------");
console.log();
const start = performance.now();
let answer: any = 0;
if (problem === "1") {
  answer = partOne(input);
} else if (problem === "2") {
  answer = partTwo(input);
} else {
  test();
  process.exit(0);
}

const end = performance.now();

console.log(`Finished in ${(end - start).toFixed(3)} ms`);
console.log(`Answer: ${answer}`);
