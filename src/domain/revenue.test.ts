import { describe, expect, it } from "vitest";
import { distributeRevenue } from "./revenue";
describe("KHAN 40/30/30 allocation", () => {
  it("conserves 100,000 distinct amounts", () => {
    let seed = 20261019;
    const seen = new Set<number>();
    for (let i = 0; i < 100_000; i++) {
      seed = (Math.imul(seed, 1664525) + 1013904223) >>> 0;
      const amount = i < 10_000 ? i : 10_000 + i * 10_000 + seed;
      expect(seen.has(amount)).toBe(false);
      seen.add(amount);
      const a = distributeRevenue(amount);
      expect(a.commons + a.people + a.businesses).toBe(amount);
      expect(Math.min(a.commons, a.people, a.businesses)).toBeGreaterThanOrEqual(0);
      expect(Math.abs(a.commons * 100 - amount * 40)).toBeLessThanOrEqual(100);
      expect(Math.abs(a.people * 100 - amount * 30)).toBeLessThanOrEqual(100);
      expect(Math.abs(a.businesses * 100 - amount * 30)).toBeLessThanOrEqual(100);
      expect(distributeRevenue(amount)).toEqual(a);
    }
  });
  it("rejects invalid amounts and weights", () => {
    for (const n of [-1, NaN, Infinity, 1.5, Number.MAX_SAFE_INTEGER + 1]) expect(() => distributeRevenue(n)).toThrow();
    for (const w of [[40,30,20], [101,0,-1], [50,50], [40,30,29.5]]) expect(() => distributeRevenue(100,w)).toThrow();
  });
});
