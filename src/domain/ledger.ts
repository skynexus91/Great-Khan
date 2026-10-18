import { transferKhan } from "./transfers";
import { totalWalletBalance, validateWallet, type Wallet } from "./wallets";

/** In-memory simulation ledger. Callers must persist the returned state atomically. */
export type TransferCommand = Readonly<{
  operationId: string;
  from: string;
  to: string;
  amount: number;
  feeBps: number;
}>;
export type TransferEvent = Readonly<TransferCommand & { fee: number; kind: "KHAN_TRANSFER" }>;
export type LedgerState = Readonly<{
  wallets: readonly Wallet[];
  treasury: number;
  events: readonly TransferEvent[];
}>;

export function applyTransfer(state: LedgerState, command: TransferCommand): LedgerState {
  if (!/^[a-zA-Z0-9_-]{1,128}$/.test(command.operationId)) throw new RangeError("Invalid operation ID");
  if (!Number.isSafeInteger(state.treasury) || state.treasury < 0) throw new RangeError("Invalid treasury");
  totalWalletBalance(state.wallets); // validate wallets and unique IDs
  const existing = state.events.find(event => event.operationId === command.operationId);
  if (existing) {
    if (
      existing.kind === "KHAN_TRANSFER" &&
      existing.from === command.from &&
      existing.to === command.to &&
      existing.amount === command.amount &&
      existing.feeBps === command.feeBps
    ) return state; // safe retry of the same command
    throw new RangeError("Operation ID reused for a different transfer");
  }
  const sender = state.wallets.find(wallet => wallet.id === command.from);
  const receiver = state.wallets.find(wallet => wallet.id === command.to);
  if (!sender || !receiver) throw new RangeError("Unknown sender or receiver");
  const result = transferKhan(sender, receiver, state.treasury, command.amount, command.feeBps);
  const wallets = state.wallets.map(wallet =>
    wallet.id === sender.id ? validateWallet({ ...wallet, balance: result.sender.balance }) :
    wallet.id === receiver.id ? validateWallet({ ...wallet, balance: result.receiver.balance }) : wallet
  );
  return {
    wallets,
    treasury: result.treasury,
    events: [...state.events, { ...command, fee: result.fee, kind: "KHAN_TRANSFER" }],
  };
}
