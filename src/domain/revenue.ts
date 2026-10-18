/** Exact allocation of simulated net protocol revenue in integer minor units. */
export type RevenueAllocation = Readonly<{ commons: number; people: number; businesses: number }>;
export const DEFAULT_SHARES = [40, 30, 30] as const;

export function distributeRevenue(
  amount: number,
  weights: readonly number[] = DEFAULT_SHARES,
): RevenueAllocation {
  if (!Number.isSafeInteger(amount) || amount < 0) {
    throw new RangeError("Amount must be a nonnegative safe integer");
  }
  if (
    weights.length !== 3 ||
    weights.some(w => !Number.isSafeInteger(w) || w < 0 || w > 100) ||
    weights.reduce((a, b) => a + b, 0) !== 100
  ) {
    throw new RangeError("Shares must be nonnegative integers totaling 100");
  }

  // BigInt prevents precision loss in amount * percentage at MAX_SAFE_INTEGER.
  const total = BigInt(amount);
  const parts = weights.map((weight, index) => {
    const numerator = total * BigInt(weight);
    return { index, base: numerator / 100n, fraction: numerator % 100n };
  });
  const allocated = parts.reduce((sum, part) => sum + part.base, 0n);
  const ranked = [...parts].sort((a, b) =>
    a.fraction === b.fraction ? a.index - b.index : a.fraction > b.fraction ? -1 : 1
  );
  const result = parts.map(part => part.base);
  for (let i = 0; i < Number(total - allocated); i++) {
    result[ranked[i].index] += 1n;
  }
  return {
    commons: Number(result[0]),
    people: Number(result[1]),
    businesses: Number(result[2]),
  };
}
