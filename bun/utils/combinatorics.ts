export const combinations = <T>(arr: T[], k: number): T[][] => {
  let head,
    tail,
    result = [];
  if (k > arr.length || k < 1) {
    return [];
  }
  if (k === arr.length) {
    return [arr];
  }
  if (k === 1) {
    return arr.map((element) => [element]);
  }
  for (let i = 0; i < arr.length - k + 1; i++) {
    head = arr.slice(i, i + 1);
    tail = combinations(arr.slice(i + 1), k - 1);
    for (let j = 0; j < tail.length; j++) {
      result.push(head.concat(tail[j]));
    }
  }
  return result;
};
