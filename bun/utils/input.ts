export const numberArray = (input: string): number[] => {
  return input.trim().split(" ").map(Number);
};

export const numberMatrix = (input: string): number[][] => {
  return input
    .trim()
    .split("\n")
    .map((line) => numberArray(line));
};

export const lines = (input: string): string[] => {
  return input
    .trim()
    .split("\n")
    .filter((line) => line.trim() !== "");
};

export const sections = (input: string): string[] => {
  return input.trim().split("\n\n");
};
