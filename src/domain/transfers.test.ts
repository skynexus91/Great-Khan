import { describe, expect, it } from "vitest";
import { transferKhan } from "./transfers";

describe("KHAN transfer invariants", () => {
  it("transfers amount and fee without creating or losing KHAN", () => {
    let seed = 20261019;
    const rand = () => ((seed = (Math.imul(seed, 1664525) + 1013904223) >>> 0) / 4294967296);
    for (let i = 0; i < 20_000; i++) {
      const balance = 1 + Math.floor(rand() * 1_000_000);
      const amount = 1 + Math.floor(rand() * balance);
      const feeBps = Math.floor(rand() * 1001);
      const fee = Number((BigInt(amount) * BigInt(feeBps) + 9999n) / 10000n);
      const sender = { id: "alice", balance: balance + fee };
      const receiver = { id: "bob", balance: Math.floor(rand() * 1_000_000) };
      const treasury = Math.floor(rand() * 1_000_000);
      const result = transferKhan(sender, receiver, treasury, amount, feeBps);
      expect(result.fee).toBe(fee);
      expect(result.sender.balance).toBe(balance - amount);
      expect(result.receiver.balance).toBe(receiver.balance + amount);
      expect(result.treasury).toBe(treasury + fee);
      expect(result.sender.balance + result.receiver.balance + result.treasury).toBe(sender.balance + receiver.balance + treasury);
      expect(sender.balance).toBe(balance + fee); // inputs are unchanged
    }
  });
  it("rejects invalid transfers and overdrafts", () => {
    const a = { id: "a", balance: 100 };
    const b = { id: "b", balance: 0 };
    expect(() => transferKhan(a, b, 0, 100, 100)).toThrow();
    expect(() => transferKhan(a, a, 0, 1, 0)).toThrow();
    for (const amount of [0, -1, 1.2, NaN, Infinity, Number.MAX_SAFE_INTEGER + 1]) {
      expect(() => transferKhan(a, b, 0, amount, 0)).toThrow();
    }
    for (const bps of [-1, 0.1, NaN, 10001]) {
      expect(() => transferKhan(a, b, 0, 1, bps)).toThrow();
    }
    expect(() => transferKhan({ id: "a", balance: Number.MAX_SAFE_INTEGER }, { id: "b", balance: Number.MAX_SAFE_INTEGER }, 0, 1, 0)).toThrow();
  });
  it("handles exact-balance transfers and maximum safe values", () => {
    const r = transferKhan({ id: "a", balance: 101 }, { id: "b", balance: 0 }, 0, 100, 100);
    expect(r).toEqual({ sender: { id: "a", balance: 0 }, receiver: { id: "b", balance: 100 }, treasury: 1, fee: 1 });
    const max = transferKhan({ id: "a", balance: Number.MAX_SAFE_INTEGER }, { id: "b", balance: 0 }, 0, Number.MAX_SAFE_INTEGER, 0);
    expect(max.sender.balance).toBe(0);
    expect(max.receiver.balance).toBe(Number.MAX_SAFE_INTEGER);
  });
});
