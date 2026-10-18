import { describe, expect, it } from "vitest";
import { applyTransfer, type LedgerState } from "./ledger";
import { deserializeLedger, loadLedger, saveLedger, serializeLedger } from "./persistence";

const genesis = (): LedgerState => ({
  wallets: [{ id: "alice", balance: 1000, verified: true }, { id: "bob", balance: 0, verified: false }],
  treasury: 50,
  events: [],
});

describe("KHAN versioned ledger persistence", () => {
  it("round-trips balances, history and idempotency after reload", () => {
    const state = applyTransfer(genesis(), { operationId: "t1", from: "alice", to: "bob", amount: 100, feeBps: 100 });
    const data = new Map<string, string>();
    const storage = { getItem: (key: string) => data.get(key) ?? null, setItem: (key: string, value: string) => { data.set(key, value); } };
    saveLedger(storage, "khan-ledger", state);
    const restored = loadLedger(storage, "khan-ledger")!;
    expect(restored).toEqual(state);
    expect(applyTransfer(restored, { operationId: "t1", from: "alice", to: "bob", amount: 100, feeBps: 100 })).toBe(restored);
    expect(loadLedger(storage, "missing")).toBeNull();
  });
  it("rejects tampered content, invalid JSON, unknown versions and duplicate history", () => {
    const raw = serializeLedger(genesis());
    expect(() => deserializeLedger(raw.replace('"balance":1000', '"balance":9000'))).toThrow();
    expect(() => deserializeLedger("{broken")).toThrow();
    expect(() => deserializeLedger(raw.replace('"version":1', '"version":2'))).toThrow();
    const state = applyTransfer(genesis(), { operationId: "t1", from: "alice", to: "bob", amount: 1, feeBps: 0 });
    expect(() => serializeLedger({ ...state, events: [...state.events, state.events[0]] })).toThrow();
    expect(() => serializeLedger({ ...state, treasury: -1 })).toThrow();
  });
  it("survives 100 sequential save/load cycles", () => {
    let state = genesis();
    for (let i = 0; i < 100; i++) {
      state = applyTransfer(state, { operationId: "round-" + i, from: "alice", to: "bob", amount: 1, feeBps: 0 });
      state = deserializeLedger(serializeLedger(state));
    }
    expect(state.events).toHaveLength(100);
    expect(state.wallets[0].balance).toBe(900);
    expect(state.wallets[1].balance).toBe(100);
  });
});
