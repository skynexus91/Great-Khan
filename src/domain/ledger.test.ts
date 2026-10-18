import { describe, expect, it } from "vitest";
import { applyTransfer, type LedgerState } from "./ledger";

const initial = (): LedgerState => ({
  wallets: [
    { id: "alice", balance: 1000, verified: true },
    { id: "bob", balance: 50, verified: false },
    { id: "carol", balance: 70, verified: false },
  ],
  treasury: 25,
  events: [],
});
const cmd = (operationId: string, amount = 100) =>
  ({ operationId, from: "alice", to: "bob", amount, feeBps: 100 });

describe("KHAN integrated ledger", () => {
  it("applies once, preserves total supply, and keeps history", () => {
    const state = initial();
    const after = applyTransfer(state, cmd("tx-1"));
    expect(after.wallets.map(w => w.balance)).toEqual([899, 150, 70]);
    expect(after.treasury).toBe(26);
    expect(after.events).toEqual([{ ...cmd("tx-1"), fee: 1, kind: "KHAN_TRANSFER" }]);
    expect(state.events).toHaveLength(0);
    expect(applyTransfer(after, cmd("tx-1"))).toBe(after);
    expect(() => applyTransfer(after, cmd("tx-1", 200))).toThrow();
    const sum = (s: LedgerState) => s.wallets.reduce((v, w) => v + BigInt(w.balance), BigInt(s.treasury));
    expect(sum(after)).toBe(sum(state));
  });
  it("rejects missing wallets, malformed IDs, duplicate wallets and overdrafts", () => {
    expect(() => applyTransfer(initial(), { ...cmd("tx"), to: "missing" })).toThrow();
    expect(() => applyTransfer(initial(), cmd("bad id"))).toThrow();
    expect(() => applyTransfer(initial(), cmd("tx", 1000))).toThrow();
    const s = initial();
    expect(() => applyTransfer({ ...s, wallets: [...s.wallets, s.wallets[0]] }, cmd("tx"))).toThrow();
  });
  it("conserves KHAN through 2,000 chained transfers and exact retries", () => {
    let state = initial();
    let seed = 991;
    const rand = () => ((seed = (Math.imul(seed, 1664525) + 1013904223) >>> 0) / 4294967296);
    for (let i = 0; i < 2000; i++) {
      const eligible = state.wallets.filter(w => w.balance > 1);
      const sender = eligible[Math.floor(rand() * eligible.length)];
      const receiver = state.wallets.find(w => w.id !== sender.id)!;
      const amount = 1 + Math.floor(rand() * (sender.balance - 1));
      const command = { operationId: "op-" + i, from: sender.id, to: receiver.id, amount, feeBps: 0 };
      const before = state.wallets.reduce((sum, w) => sum + w.balance, state.treasury);
      state = applyTransfer(state, command);
      expect(applyTransfer(state, command)).toBe(state);
      expect(state.wallets.reduce((sum, w) => sum + w.balance, state.treasury)).toBe(before);
    }
    expect(state.events).toHaveLength(2000);
  });
});
