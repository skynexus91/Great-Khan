import { describe, expect, it } from "vitest";
import { createWallet, totalWalletBalance, validateWallet } from "./wallets";

describe("KHAN demo wallets", () => {
  it("creates unique empty wallets without mutating the registry", () => {
    const original = [{ id: "alice", balance: 12, verified: true }];
    const next = createWallet(original, "bob");
    expect(next).toHaveLength(2);
    expect(next[1]).toEqual({ id: "bob", balance: 0, verified: false });
    expect(original).toHaveLength(1);
    expect(() => createWallet(next, "alice")).toThrow();
  });
  it("rejects invalid wallet identifiers and balances", () => {
    for (const id of ["", " ", "a/b", "x".repeat(65)]) {
      expect(() => validateWallet({ id, balance: 0, verified: false })).toThrow();
    }
    for (const balance of [-1, 0.5, NaN, Infinity, Number.MAX_SAFE_INTEGER + 1]) {
      expect(() => validateWallet({ id: "a", balance, verified: false })).toThrow();
    }
  });
  it("counts large balances exactly without number overflow", () => {
    const max = Number.MAX_SAFE_INTEGER;
    expect(totalWalletBalance([{ id: "a", balance: max, verified: false }, { id: "b", balance: max, verified: true }])).toBe(2n * BigInt(max));
    expect(() => totalWalletBalance([{ id: "a", balance: 1, verified: false }, { id: "a", balance: 2, verified: false }])).toThrow();
  });
});
