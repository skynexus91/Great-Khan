/** Pure KHAN transfers. All balances and fees use safe integer minor units. */
export type KhanWallet = Readonly<{ id: string; balance: number }>;
export type TransferResult = Readonly<{ sender: KhanWallet; receiver: KhanWallet; treasury: number; fee: number }>;

function units(value: number, label: string): void {
  if (!Number.isSafeInteger(value) || value < 0) throw new RangeError(label + " must be a nonnegative safe integer");
}
function checkedAdd(a: number, b: number): number {
  const sum = BigInt(a) + BigInt(b);
  if (sum > BigInt(Number.MAX_SAFE_INTEGER)) throw new RangeError("Balance overflow");
  return Number(sum);
}
/** Fee is rounded up in minor units; bps ranges from 0 to 10000. */
export function transferKhan(
  sender: KhanWallet,
  receiver: KhanWallet,
  treasury: number,
  amount: number,
  feeBps: number,
): TransferResult {
  if (!sender.id || !receiver.id || sender.id === receiver.id) throw new RangeError("Distinct wallet IDs required");
  for (const [label, value] of [["sender balance", sender.balance], ["receiver balance", receiver.balance], ["treasury", treasury], ["amount", amount], ["fee basis points", feeBps]] as const) units(value, label);
  if (amount === 0) throw new RangeError("Transfer amount must be positive");
  if (feeBps > 10000) throw new RangeError("Fee exceeds 100%");
  const fee = Number((BigInt(amount) * BigInt(feeBps) + 9999n) / 10000n);
  const debit = BigInt(amount) + BigInt(fee);
  if (debit > BigInt(sender.balance)) throw new RangeError("Insufficient KHAN balance including fee");
  const nextReceiver = checkedAdd(receiver.balance, amount);
  const nextTreasury = checkedAdd(treasury, fee);
  return {
    sender: { ...sender, balance: Number(BigInt(sender.balance) - debit) },
    receiver: { ...receiver, balance: nextReceiver },
    treasury: nextTreasury,
    fee,
  };
}
