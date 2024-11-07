'use client';

import { useEffect } from 'react';
import { useCurrentAddress } from '@roochnetwork/rooch-sdk-kit';

import { useRouter } from 'src/routes/hooks';

export default function TransactionOverviewView() {
  const address = useCurrentAddress();
  const router = useRouter();
  useEffect(() => {
    if (address) {
      router.push(`/transactions/${address.toStr()}`);
    }
  }, [address, router]);
  if (!address) {
    return null;
  }
  return null;
}