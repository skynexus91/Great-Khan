import { type LedgerState, type TransferEvent } from "./ledger";
import { totalWalletBalance, validateWallet } from "./wallets";

const VERSION = 1;
const MAX_EVENTS = 100_000;
export type PersistedLedger = Readonly<{ version: 1; state: LedgerState; checksum: string }>;

/** Deterministic integrity checksum for accidental corruption, NOT a signature or secure hash. */
function checksum(input: string): string {
  let h = 2166136261;
  for (let i = 0; i < input.length; i++) {
    h ^= input.charCodeAt(i);
    h = Math.imul(h, 16777619);
  }
  return (h >>> 0).toString(16).padStart(8, "0");
}

function validateState(state: LedgerState): LedgerState {
  if (!state || !Array.isArray(state.wallets) || !Array.isArray(state.events)) throw new RangeError("Invalid ledger state");
  if (!Number.isSafeInteger(state.treasury) || state.treasury < 0) throw new RangeError("Invalid treasury");
  if (state.events.length > MAX_EVENTS) throw new RangeError("Ledger history exceeds demo limit");
  totalWalletBalance(state.wallets);
  const ids = new Set<string>();
  const events: TransferEvent[] = state.events.map(event => {
    if (!event || event.kind !== "KHAN_TRANSFER" || !/^[a-zA-Z0-9_-]{1,128}$/.test(event.operationId)) throw new RangeError("Invalid event");
    if (ids.has(event.operationId)) throw new RangeError("Duplicate operation ID in history");
    ids.add(event.operationId);
    if (!state.wallets.some(wallet => wallet.id === event.from) || !state.wallets.some(wallet => wallet.id === event.to) || event.from === event.to) throw new RangeError("Invalid event participants");
    if (!Number.isSafeInteger(event.amount) || event.amount <= 0 || !Number.isSafeInteger(event.fee) || event.fee < 0 || !Number.isSafeInteger(event.feeBps) || event.feeBps < 0 || event.feeBps > 10000) throw new RangeError("Invalid event amounts");
    const fee = Number((BigInt(event.amount) * BigInt(event.feeBps) + 9999n) / 10000n);
    if (fee !== event.fee) throw new RangeError("Invalid recorded fee");
    return { kind: "KHAN_TRANSFER", operationId: event.operationId, from: event.from, to: event.to, amount: event.amount, feeBps: event.feeBps, fee: event.fee };
  });
  return { wallets: state.wallets.map(validateWallet), treasury: state.treasury, events };
}

export function serializeLedger(state: LedgerState): string {
  const validated = validateState(state);
  const body = JSON.stringify({ version: VERSION, state: validated });
  return JSON.stringify({ version: VERSION, state: validated, checksum: checksum(body) });
}

export function deserializeLedger(raw: string): LedgerState {
  if (raw.length > 15_000_000) throw new RangeError("Saved ledger too large");
  const parsed: unknown = JSON.parse(raw);
  if (!parsed || typeof parsed !== "object") throw new RangeError("Invalid saved ledger");
  const record = parsed as Partial<PersistedLedger>;
  if (record.version !== VERSION || !record.state || typeof record.checksum !== "string") throw new RangeError("Unsupported ledger format");
  const body = JSON.stringify({ version: VERSION, state: record.state });
  if (checksum(body) !== record.checksum) throw new RangeError("Ledger checksum mismatch");
  return validateState(record.state);
}

/** Storage adapter permits browser localStorage or a test in-memory implementation. */
export type StorageAdapter = Pick<Storage, "getItem" | "setItem">;
export function saveLedger(storage: StorageAdapter, key: string, state: LedgerState): void {
  storage.setItem(key, serializeLedger(state));
}
export function loadLedger(storage: StorageAdapter, key: string): LedgerState | null {
  const raw = storage.getItem(key);
  return raw === null ? null : deserializeLedger(raw);
}
