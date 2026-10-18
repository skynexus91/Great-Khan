/** Simulated net protocol revenue allocation. Amounts are integer minor units. */
export type RevenueAllocation = Readonly<{ commons: number; people: number; businesses: number }>;
export const DEFAULT_SHARES = [40, 30, 30] as const;
export function distributeRevenue(amount: number, weights: readonly number[] = DEFAULT_SHARES): RevenueAllocation {
  if (!Number.isSafeInteger(amount) || amount < 0) throw new RangeError("Amount must be a nonnegative safe integer");
  if (weights.length !== 3 || weights.some(w => !Number.isSafeInteger(w) || w < 0) || weights.reduce((a,b) => a+b,0) !== 100) throw new RangeError("Shares must be nonnegative integers totaling 100");
  const bases = weights.map(w => Math.floor(amount * w / 100));
  let remainder = amount - bases.reduce((a,b) => a+b,0);
  const ranked = weights.map((w,i) => ({i, fraction: amount * w % 100})).sort((a,b) => b.fraction-a.fraction || a.i-b.i);
  for (let j=0;j<remainder;j++) bases[ranked[j].i]++;
  return {commons:bases[0],people:bases[1],businesses:bases[2]};
}
