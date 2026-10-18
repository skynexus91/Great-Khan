import { describe, expect, it } from "vitest";
import { distributeRevenue } from "./revenue";

function rng(seed: number) {
  let s = seed >>> 0;
  return () => ((s = (Math.imul(s, 1664525) + 1013904223) >>> 0) / 0x100000000);
}
describe("KHAN three-pillar randomized allocation", () => {
  it("conserves 100,000 distinct randomly shuffled amounts and variable shares", () => {
    const random = rng(20261019); // reproducible seed; failures can be replayed
    const seen = new Set<number>();
    for (let i = 0; i < 100_000; i++) {
      // Unique by construction, while randomizing values inside each disjoint bucket.
      const amount = i * 100_000 + Math.floor(random() * 100_000);
      expect(seen.has(amount)).toBe(false);
      seen.add(amount);
      const commons = Math.floor(random() * 101);
      const people = Math.floor(random() * (101 - commons));
      const businesses = 100 - commons - people;
      const shares = [commons, people, businesses];
      const a = distributeRevenue(amount, shares);
      const allocations = [a.commons, a.people, a.businesses];
      expect(allocations.reduce((x, y) => x + y, 0)).toBe(amount);
      for (let j = 0; j < 3; j++) {
        expect(allocations[j]).toBeGreaterThanOrEqual(0);
        expect(Math.abs(allocations[j] * 100 - amount * shares[j])).toBeLessThanOrEqual(100);
      }
      expect(distributeRevenue(amount, shares)).toEqual(a);
    }
    expect(seen.size).toBe(100_000);
  });
  it("rejects invalid values and weights", () => {
    for (const amount of [-1, NaN, Infinity, 1.5, Number.MAX_SAFE_INTEGER + 1]) {
      expect(() => distributeRevenue(amount)).toThrow();
    }
    for (const weights of [[40,30,20], [101,0,-1], [50,50], [40,30,29.5]]) {
      expect(() => distributeRevenue(100, weights)).toThrow();
    }
  });
});
