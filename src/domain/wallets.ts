/** Demo wallet registry. No private keys or real custody. */
export type Wallet = Readonly<{ id: string; balance: number; verified: boolean }>;
export function validateWallet(wallet: Wallet): Wallet {
  if (!/^[a-zA-Z0-9_-]{1,64}$/.test(wallet.id)) throw new RangeError("Invalid wallet ID");
  if (!Number.isSafeInteger(wallet.balance) || wallet.balance < 0) throw new RangeError("Invalid wallet balance");
  if (typeof wallet.verified !== "boolean") throw new TypeError("Invalid verification flag");
  return { ...wallet };
}
export function createWallet(registry: readonly Wallet[], id: string): Wallet[] {
  const wallet = validateWallet({ id, balance: 0, verified: false });
  if (registry.some(existing => existing.id === id)) throw new RangeError("Duplicate wallet ID");
  return [...registry.map(validateWallet), wallet];
}
export function totalWalletBalance(registry: readonly Wallet[]): bigint {
  const seen = new Set<string>();
  return registry.reduce((total, wallet) => {
    validateWallet(wallet);
    if (seen.has(wallet.id)) throw new RangeError("Duplicate wallet ID");
    seen.add(wallet.id);
    return total + BigInt(wallet.balance);
  }, 0n);
}
